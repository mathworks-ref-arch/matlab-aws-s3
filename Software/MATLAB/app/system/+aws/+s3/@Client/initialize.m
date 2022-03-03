function initStat = initialize(obj, varargin)
% INITIALIZE Configure the MATLAB session to connect to S3
% Once a client has been configured, initialize is used to validate the
% client configuration and initiate the connection to S3
%
% Example:
%       s3 = aws.s3.Client();
%       s3.encryptionScheme = 'SSES3';
%       s3.initialize();
%

% Copyright 2017-2019 The MathWorks, Inc.

%% Imports
% Exceptions
import com.amazonaws.AmazonClientException
import com.amazonaws.AmazonServiceException

% Credentials
import com.amazonaws.auth.AWSCredentials
import com.amazonaws.auth.BasicAWSCredentials
import com.amazonaws.auth.AWSStaticCredentialsProvider
import com.amazonaws.auth.BasicSessionCredentials
import com.amazonaws.auth.STSSessionCredentialsProvider
import com.amazonaws.auth.InstanceProfileCredentialsProvider
import com.amazonaws.auth.profile.ProfileCredentialsProvider
import com.amazonaws.auth.DefaultAWSCredentialsProviderChain

% Builders
import com.amazonaws.services.s3.AmazonS3ClientBuilder

% Regions
import com.amazonaws.regions.Region
import com.amazonaws.regions.Regions
import com.amazonaws.regions.DefaultAwsRegionProviderChain

% S3 Client and models
import com.amazonaws.services.s3.AmazonS3
import com.amazonaws.services.s3.AmazonS3Client
import com.amazonaws.services.s3.model.Bucket
import com.amazonaws.services.s3.model.GetObjectRequest
import com.amazonaws.services.s3.model.ListObjectsRequest
import com.amazonaws.services.s3.model.ObjectListing
import com.amazonaws.services.s3.model.PutObjectRequest
import com.amazonaws.services.s3.model.S3Object
import com.amazonaws.services.s3.model.S3ObjectSummary

% ACL and security
import com.amazonaws.services.s3.model.AccessControlList
import com.amazonaws.services.s3.model.CannedAccessControlList
import com.amazonaws.services.s3.model.CanonicalGrantee
import com.amazonaws.services.s3.model.CreateBucketRequest
import com.amazonaws.services.s3.model.Grant
import com.amazonaws.services.s3.model.GroupGrantee
import com.amazonaws.services.s3.model.Permission
import com.amazonaws.services.s3.model.Region

% Encryption support
import com.amazonaws.services.s3.AmazonS3EncryptionClient
import com.amazonaws.services.s3.model.EncryptionMaterials
import com.amazonaws.services.s3.AmazonS3EncryptionClientBuilder
import com.amazonaws.services.s3.model.StaticEncryptionMaterialsProvider

% KMS Support
import com.amazonaws.services.s3.model.KMSEncryptionMaterialsProvider
import com.amazonaws.services.s3.model.CryptoConfiguration
import com.amazonaws.services.kms.AWSKMSClient
import com.amazonaws.services.kms.AWSKMSClientBuilder


%% Create a logger object
logObj = Logger.getLogger();
write(logObj,'verbose','Initializing S3 client');

% assume we're returning a fail
initStat = false;

% check that KMSCMKKeyID, CSESMKKey & CSEAMKKeyPair are set if required
checkKeyRelatedProps(obj);

% ensure that proxy settings are configured if required
initClientConfiguration(obj);


%% if NOT using the provider chain then setup a credentials file
if obj.useCredentialsProviderChain == false
    % if using the default name with no path establish the full path using which
    % else use the full path as should have been provided and set
    if strcmpi(obj.credentialsFilePath,'credentials.json')
        credFile = which(obj.credentialsFilePath);
    else
        credFile = obj.credentialsFilePath;
    end
    if exist(credFile,'file') == 2
        % Read in configuration and credentials from static sources
        write(logObj,'verbose','Using credential file based authentication');
        % Create a client handle using basic static credentials
        credentials = jsondecode(fileread(credFile));
        % if there is no session token use static credentials otherwise use
        % STS credentials
        if ~isfield(credentials, 'session_token')
            awsCreds = BasicAWSCredentials(credentials.aws_access_key_id, credentials.secret_access_key);
        elseif strcmp(strtrim(credentials.session_token),'')
            % In this case we are allowing for a template that has the session_token field but
            % it has no value so it is probably conventional static
            % credentials file with a stray session token field
            awsCreds = BasicAWSCredentials(credentials.aws_access_key_id, credentials.secret_access_key);
        else
            % we have a potentially valid session token
            write(logObj,'verbose','Using credentials file with session token based authentication');
            awsCreds = BasicSessionCredentials(credentials.aws_access_key_id, credentials.secret_access_key, credentials.session_token);
        end
        awsCredentials = AWSStaticCredentialsProvider(awsCreds);
        % takes a string of the form "us-west-1" from the file and returns the
        % ENUM of the form US_WEST_1, NB there are format exceptions e.g.
        % GovCloud
        awsRegion = Regions.fromName(credentials.region);
    else
        write(logObj,'error',['Credentials file not found: ',credFile]);
        return;
    end
else
    write(logObj,'verbose','Using Provider Chain based authentication');

    % setup credentials and region provider using provider chain if useCredentialsProviderChain
    % is true
    awsCredentials = DefaultAWSCredentialsProviderChain();
    regionProvider = DefaultAwsRegionProviderChain();

    % this should return null if not set but this is a bug in the AWS SDK
    % that will not be fixed until version 2 so now an exception is thrown
    % if the default provider chain does not provide a region
    awsRegionName = char(regionProvider.getRegion());
    write (logObj,'verbose',['Provider Chain set Region to: ', awsRegionName]);

    % pass the Java ENUM object of the form US_WEST_1, this is used later
    % by the builder and to set the KMS region
    awsRegion = Regions.fromName(regionProvider.getRegion());

end

% S3 is universally available so no need to check it exists in the given AWS region

%% Initialize a handle to the S3 client
switch obj.encryptionScheme
case {aws.s3.EncryptionScheme.NOENCRYPTION, aws.s3.EncryptionScheme.SSEC, aws.s3.EncryptionScheme.SSEKMS, aws.s3.EncryptionScheme.SSES3}
        if obj.pathStyleAccessEnabled
            builderH = AmazonS3ClientBuilder.standard().withCredentials(awsCredentials).withClientConfiguration(obj.clientConfiguration.Handle).withPathStyleAccessEnabled(java.lang.Boolean(true));
        else
            builderH = AmazonS3ClientBuilder.standard().withCredentials(awsCredentials).withClientConfiguration(obj.clientConfiguration.Handle);
        end

    case aws.s3.EncryptionScheme.CSEAMK
        encryptionMaterials = EncryptionMaterials(obj.CSEAMKKeyPair);
        encryptionMaterialsP = StaticEncryptionMaterialsProvider(encryptionMaterials);
        if obj.pathStyleAccessEnabled
            builderH = AmazonS3EncryptionClientBuilder.standard().withCredentials(awsCredentials).withEncryptionMaterials(encryptionMaterialsP).withClientConfiguration(obj.clientConfiguration.Handle).withPathStyleAccessEnabled(java.lang.Boolean(true));
        else
            builderH = AmazonS3EncryptionClientBuilder.standard().withCredentials(awsCredentials).withEncryptionMaterials(encryptionMaterialsP).withClientConfiguration(obj.clientConfiguration.Handle);
        end

    case aws.s3.EncryptionScheme.CSESMK
        encryptionMaterials = EncryptionMaterials(obj.CSESMKKey);
        encryptionMaterialsP = StaticEncryptionMaterialsProvider(encryptionMaterials);
        if obj.pathStyleAccessEnabled
            builderH = AmazonS3EncryptionClientBuilder.standard().withCredentials(awsCredentials).withEncryptionMaterials(encryptionMaterialsP).withClientConfiguration(obj.clientConfiguration.Handle).withPathStyleAccessEnabled(java.lang.Boolean(true));
        else
            builderH = AmazonS3EncryptionClientBuilder.standard().withCredentials(awsCredentials).withEncryptionMaterials(encryptionMaterialsP).withClientConfiguration(obj.clientConfiguration.Handle);
        end

    case aws.s3.EncryptionScheme.KMSCMK
        encryptionMaterialsP = KMSEncryptionMaterialsProvider(obj.KMSCMKKeyID);
        awsKmsRegion = Region.getRegion(awsRegion);
        cryptoconfig = CryptoConfiguration().withAwsKmsRegion(awsKmsRegion);
        if obj.pathStyleAccessEnabled
            builderH = AmazonS3EncryptionClientBuilder.standard().withCredentials(awsCredentials).withEncryptionMaterials(encryptionMaterialsP).withCryptoConfiguration(cryptoconfig).withClientConfiguration(obj.clientConfiguration.Handle).withPathStyleAccessEnabled(java.lang.Boolean(true));
        else
            builderH = AmazonS3EncryptionClientBuilder.standard().withCredentials(awsCredentials).withEncryptionMaterials(encryptionMaterialsP).withClientConfiguration(obj.clientConfiguration.Handle);
        end

    otherwise
        write(logObj,'error',['Unknown encryption scheme: ',obj.encryptionScheme]);
        return;
end


%% configure the endpoint if set else just set the region
if isempty(obj.endpointURI.Host)
    % set the region directly if not using a custom endpoint otherwise the region
    % is configured as part of the endpoint configuration
    builderH.setRegion(awsRegion.getName);
else
    % if the URI has a path we don't include it in the endpoint as this is likely bucket name
    endpointHostPort = [char(obj.endpointURI.Scheme) '://' char(obj.endpointURI.EncodedAuthority)];
    endpointRegion = char(awsRegion.getName);
    write(logObj,'verbose',['Setting Endpoint URI & Region to: ',endpointHostPort,' ',endpointRegion]);
    endPointConfig = javaObject('com.amazonaws.client.builder.AwsClientBuilder$EndpointConfiguration',endpointHostPort, endpointRegion);
    builderH.setEndpointConfiguration(endPointConfig);
end


%% Build the S3 client handle
% We are ready to build() as we have a fully configured builder
obj.Handle = builderH.build();

%% Return true if the client handle exists
if ~isempty(obj.Handle)
    write(logObj,'verbose','Client initialized');
    initStat = true;
else
    write(logObj,'error','Client initialization failed');
end

end % main function


%% check key related client properties
function checkKeyRelatedProps(obj)
    if obj.encryptionScheme == aws.s3.EncryptionScheme.KMSCMK
        if isempty(obj.KMSCMKKeyID)
            write(logObj,'error','Client.KMSCMKKey not set. Expected KMS Customer Master Key ID argument of type char of form: d6262571-def3-234a-caa3-a0b1f24c3e8f');
            return;
        end
    end
    if obj.encryptionScheme == aws.s3.EncryptionScheme.CSESMK
        if isempty(obj.CSESMKKey)
            write(logObj,'error','Client.CSESMKKey not set. Expected Client-side Symmetric Master Key argument of type javax.crypto.spec.SecretKeySpec');
            return;
        end
    end
    if obj.encryptionScheme == aws.s3.EncryptionScheme.CSEAMK
        if isempty(obj.CSEAMKKeyPair)
            write(logObj,'error','Client.CSEAMKKeyPair not set. Expected Client-side Asymmetric Master Key argument of type java.security.KeyPair');
            return;
        end
    end
end


function initClientConfiguration(obj)
    % if the property has not been set the call the set function to initialize
    % it from preferences panel / OS settings, if it is set then we know the
    % set function has previously been called
    if isempty(obj.clientConfiguration.proxyHost)
        obj.clientConfiguration.setProxyHost();
    end
    if isempty(obj.clientConfiguration.proxyPort)
        obj.clientConfiguration.setProxyPort();
    end
    if isempty(obj.clientConfiguration.proxyUsername)
        obj.clientConfiguration.setProxyUsername();
    end
    if isempty(obj.clientConfiguration.proxyPassword)
        obj.clientConfiguration.setProxyPassword();
    end
end
