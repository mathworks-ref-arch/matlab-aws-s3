classdef Client < aws.Object
    % CLIENT Amazon S3 Client
    %
    % Amazon Simple Storage Service (Amazon S3) is storage for the Internet.
    % Amazon S3 can be used to store and retrieve any amount of data at any
    % time, from anywhere on the web: https://aws.amazon.com/documentation/s3/
    %
    %  Encryption Schemes:
    %
    % The encryption scheme to be used is defined as a property. The supported
    % encryption scheme are as follows:
    %   'NOENCRYPTION'  : do not use encryption (default)
    %   'CSESMK'        : client side with a symmetric master key
    %   'CSEAMK'        : client side with an asymmetric master key
    %   'SSEC'          : server side encryption with a customer supplied key
    %   'KMSCMK'        : Key Management Service managed customer master key
    %   'SSEKMS'        : server side encryption using the Key Management Service
    %   'SSES3'         : server side encryption using S3 managed encryption keys
    % A scheme is selected as follows:
    %       s3 = aws.s3.Client();
    %       s3.encryptionScheme = 'SSES3';
    %       s3.intialize();
    %
    % If using 'NOENCRYPTIION' data will NOT be encrypted at rest on S3.
    %
    % If using 'CSEAMK' then a Client-side Asymmetric Master Key argument of
    % type java.security.KeyPair is also required e.g.
    %       s3 = aws.s3.Client();
    %       s3.encryptionScheme = 'CSEAMK';
    %       s3.CSEAMKKeyPair = s3.generateCSEAsymmetricMasterKey(1024);
    %       s3.intialize();
    %
    % If using 'CSESMK' then a Client-side Symmetric Master Key argument of type
    % javax.crypto.spec.SecretKeySpec is also required, e.g:
    %       s3 = aws.s3.Client();
    %       s3.encryptionScheme = 'CSESMK';
    %       s3.CSESMKKey = s3.generateCSESymmetricMasterKey('AES', 256);
    %       s3.intialize();
    %
    % If using 'SSEC' a key of type com.amazonaws.services.s3.model.SSECustomerKey
    % is required as an argument to put and get calls but is not used at client
    % initialization.
    %
    % If using 'KMSCMK' a KMS managed Customer Master Key ID is required as an
    % additional client property, e.g:
    %       s3 = aws.s3.Client();
    %       s3.KMSCMKKeyID = 'c6123457-cea5-476a-abb9-a0a4f678e8e';
    %       s3.intialize();
    %
    % If using 'SSEKMS' an argument of type
    % com.amazonaws.services.s3.model.SSEAwsKeyManagementParams is required for
    % put calls but not gets as the key is known and the decryption is
    % performed on the server side.
    %
    % If using 'SSES3' S3 will manage the encryption keys, this is used as the
    % AWS default server side encryption scheme.
    %
    %
    %  Authentication Credentials
    %
    % By default the AWS Credentials Provider Chain will be used, this means
    % the client will attempt to Authenticate using credentials in the following
    % order:
    %  * Environment variables: AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY.
    %  * Java system properties: aws.accessKeyId and aws.secretKey.
    %  * The default credential profiles file: typically located at
    %    ~/.aws/credentials (location can vary per platform), and shared by many
    %    of the AWS SDKs and by the AWS CLI. A credentials file can be created
    %    by using the aws configure command provided by the AWS CLI, or
    %    create it by editing the file with a text editor. For information about
    %    the credentials file format, see:
    %    https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/credentials.html#credentials-file-format
    %  * Amazon ECS container credentials: loaded from the Amazon ECS if the
    %    environment variable AWS_CONTAINER_CREDENTIALS_RELATIVE_URI is set.
    %  * Instance profile credentials: used on EC2 instances, and delivered
    %    through the Amazon EC2 metadata service. Instance profile credentials
    %    are used only if AWS_CONTAINER_CREDENTIALS_RELATIVE_URI is not set.
    %  * For more information see:
    %    https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/credentials.html
    %
    % Set the client property useCredentialsProviderChain to false to skip the use
    % of the provider chain. In this case, the client will then expect to
    % find a file called "credentials.json" on the MATLAB path. A template for
    % this file can be found in the config folder.
    %
    % An alternative filename and path can be used if specified as follows:
    %
    %       s3 = aws.s3.Client();
    %       s3.useCredentialsProviderChain = false;
    %       % using a Unix style path in this case
    %       s3.credentialsFilePath= '/home/myusername/creddir/mycredentials.file'
    %       s3.intialize();
    %
    % The contents of this file contains a JSON formatted snippet that contains
    % the access and secret keys. An alternate filename can be provided as an
    % argument.
    %
    % Example:
    % {
    %     "aws_access_key_id" : "YOUR_ACCESS_KEY_GOES_HERE",
    %     "secret_access_key" : "YOUR_SECRET_ACCESS_KEY_GOES_HERE",
    %     "region" : "us-west-1"
    % }
    %
    % Use this configuration to specify the region as shown above.
    %
    % Short term session tokens are also supported using an additional entry
    % like:
    %     "session_token" : "FQoDYX<REDACTED>KL7kw88F"
    %
    % Please see the authentication section of the documentation for more details.
    %
    %  Proxy Support:
    %
    % If a proxy is required to reach the S3 service this is configured using a
    % ClientConfiguration, a simple example of which is as follows:
    %       s3 = aws.s3.Client();
    %       s3.clientConfig.setProxyHost('proxyHost','myproxy.example.com');
    %       s3.clientConfig.setProxyPort(8080);
    %       s3.initialize();
    % If the proxy details are configured in the MATLAB preferences they
    % will be used automatically.
    %
    %  Alternate endpointURI:
    %
    % If an alternative endpoint is required, e.g. if using an non-AWS S3
    % service one can specified it as follows:
    %       s3 = aws.s3.Client();
    %       s3.endpointURI = 'https//mylocals3.example.com';
    %       s3.initialize();
    %

    % Copyright 2018-2019 The MathWorks, Inc.

    properties
        % default to no encryption
        encryptionScheme = aws.s3.EncryptionScheme.NOENCRYPTION;
        % default to using the AWS provider chain
        credentialsFilePath = 'credentials.json';
        useCredentialsProviderChain = true;
        % supplemental encryption details
        CSEAMKKeyPair;
        CSESMKKey;
        KMSCMKKeyID;
        % clientConfiguration object is used for certain client properties,
        % e.g. proxy handling
        clientConfiguration = aws.ClientConfiguration();
        % endpoint for the service, this is changed for example if connecting to
        % a non AWS S3 implementation
        endpointURI = matlab.net.URI();
        pathStyleAccessEnabled = false;
    end

    methods
        %% Constructor
        function obj = Client(~, varargin)
            logObj = Logger.getLogger();
            logObj.MsgPrefix = 'AWS:S3';
            % In normal operation use default level: debug
            % logObj.DisplayLevel = 'verbose';

            write(logObj,'verbose','Creating Client');
            if ~usejava('jvm')
                write(logObj,'error','MATLAB must be used with the JVM enabled to access AWS S3');
            end
            if verLessThan('matlab','9.2') % R2017a
                write(logObj,'error','MATLAB Release 2017a or newer is required');
            end

            obj.encryptionScheme = aws.s3.EncryptionScheme.NOENCRYPTION;
            obj.credentialsFilePath = 'credentials.json';
            obj.useCredentialsProviderChain = true;
            obj.CSEAMKKeyPair;
            obj.CSESMKKey;
            obj.KMSCMKKeyID;
            obj.clientConfiguration = aws.ClientConfiguration();
            obj.endpointURI = matlab.net.URI();
        end


        %% Setter functions
        function set.useCredentialsProviderChain(obj, tf)
            if islogical(tf)
                obj.useCredentialsProviderChain = tf;
            else
                write(logObj,'error','Expected useCredentialsProviderChain of type logical');
            end
        end


        % set a custom path to a json credentials file
        function set.credentialsFilePath(obj, credFile)
            % Create a logger object
            logObj = Logger.getLogger();

            if ischar(credFile)
                obj.credentialsFilePath = credFile;
            else
                write(logObj,'error','Expected credentialsFilePath of type character vector');
            end
        end


        % set clientConfiguration used for proxy settings
        function set.clientConfiguration(obj, config)
            % Create a logger object
            logObj = Logger.getLogger();

            if isa(config,'aws.ClientConfiguration')
                obj.clientConfiguration = config;
            else
                write(logObj,'error','Expected clientConfiguration of type aws.ClientConfiguration');
            end
        end


        function set.endpointURI(obj, endpointStr)
            % Create a logger object
            logObj = Logger.getLogger();

            epURI = matlab.net.URI(endpointStr);
            if isa(epURI,'matlab.net.URI')
                obj.endpointURI = epURI;
            else
                write(logObj,'error','Expected endpointURI of type matlab.net.URI');
            end
        end


        function set.CSESMKKey(obj, key)
            % Create a logger object
            logObj = Logger.getLogger();

            if isa(key, 'javax.crypto.spec.SecretKeySpec')
                obj.CSESMKKey = key;
            else
                write(logObj,'error','Expected Client-side Symmetric Master Key argument of type javax.crypto.spec.SecretKeySpec');
            end
        end


        function set.CSEAMKKeyPair(obj, keyPair)
            % Create a logger object
            logObj = Logger.getLogger();

            if isa(keyPair, 'java.security.KeyPair')
                obj.CSEAMKKeyPair = keyPair;
            else
                write(logObj,'error','Expected Client-side Asymmetric Master Key pair argument of type java.security.KeyPair');
            end
        end


        function set.KMSCMKKeyID(obj, keyID)
            % Create a logger object
            logObj = Logger.getLogger();

            % check the format of the string to see that it is key-like
            % sample pattern: 'd6262571-def3-234a-caa3-a0b1f24c3e8f'
            expression = '[\dabcdef]{8}-[\dabcdef]{4}-[\dabcdef]{4}-[\dabcdef]{4}-[\dabcdef]{12}';
            if ischar(keyID) && ~isempty(regexpi(keyID,expression))
                % valid key set the property
                obj.KMSCMKKeyID = keyID;
            else
                write(logObj,'error','Expected KMS Customer Master Key ID argument of type char of form: d6262571-def3-234a-caa3-a0b1f24c3e8f');
            end
        end


        function set.encryptionScheme(obj, encryptionScheme)
            % Create a logger object
            logObj = Logger.getLogger();

            % set the encryption scheme on the client object and check for encryption
            % keys based on the scheme
            switch upper(encryptionScheme)
                case {'','NOENCRYPTION'}
                    % NOENCRYPTION, data not encrypted at rest
                    write(logObj,'verbose','Not using encryption');
                    obj.encryptionScheme = aws.s3.EncryptionScheme.NOENCRYPTION;
                case 'KMSCMK'
                    % KMSCMK, KMS managed customer master key
                    write(logObj,'verbose','Using KMS managed customer key');
                    obj.encryptionScheme = aws.s3.EncryptionScheme.KMSCMK;
                case 'SSEC'
                    % SSEC, server side encryption with customer provided key additional key is required
                    write(logObj,'verbose','Using server-side encryption with customer provided key');
                    obj.encryptionScheme = aws.s3.EncryptionScheme.SSEC;
                case 'SSEKMS'
                    % SSEKMS, server-side encryption using a KMS managed key additional parameter is required
                    write(logObj,'verbose','Using server-side encryption using a KMS managed key');
                    obj.encryptionScheme = aws.s3.EncryptionScheme.SSEKMS;
                case 'SSES3'
                    % SSES3, server-side encryption using S3 managed encryption keys
                    write(logObj,'verbose','Using server-side encryption using S3 managed encryption');
                    obj.encryptionScheme = aws.s3.EncryptionScheme.SSES3;
                case 'CSESMK'
                    % CSESMK, client side symmetric master key
                    write(logObj,'verbose','Using client side encryption symmetric master key');
                    obj.encryptionScheme = aws.s3.EncryptionScheme.CSESMK;
                    if ~unlimitedCryptography
                        write(logObj,'warning','Using client side encryption but unlimited strength cryptography policy files are not installed');
                    end
                case 'CSEAMK'
                    % CSEAMK, client side asymmetric master key
                    write(logObj,'verbose','Using client side encryption asymmetric master key');
                    obj.encryptionScheme = aws.s3.EncryptionScheme.CSEAMK;
                    if ~unlimitedCryptography
                        write(logObj,'warning','Using client side encryption but unlimited strength cryptography policy files are not installed');
                    end
                otherwise
                    obj.encryptionScheme = aws.s3.EncryptionScheme.NOENCRYPTION;
                    write(logObj,'error',['Unknown encryption scheme: ', encryptionScheme, ' - Encryption NOT enabled']);
            end
        end %function
    end %methods

end %class
