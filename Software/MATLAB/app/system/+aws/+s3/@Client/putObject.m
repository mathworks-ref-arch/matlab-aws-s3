function putObject(obj, varargin)
% PUTOBJECT uploads an object to an Amazon S3 bucket
% Uploads a file as an object to the specified Amazon S3 bucket.
%
% Examples:
%   s3 = aws.s3.Client();
%   s3.initialize();
%   % Create a sample dataset
%   x = rand(1000,1000); % Approx 7MB
%   save myData x;
%   s3.putObject('com-mathworks-mytestbucket', 'myData.mat');
%
% Optionally, a key name for the object can be specified, the object will then
% be referenced using the key name rather than the filename value.
%
%   s3.putObject('com-mathworks-mytestbucket', 'myFile.mat', 'myFileObjectName');
%
% If an absolute path is not provided, the MATLAB path will be searched for the
% names file.
%
% If using SSEC or SSEKMS encryption a key or parameter argument respectively
% must be provided. An optional object name can still be provided as the
% final entry in the argument list:
%
%   s3.putObject('myBucketName', 'myObject.mat', 'mySSECKey');
%   s3.putObject('myBucketName', 'myObject.csv', 'mySSEKeyManagementParams');
%
% When uploading a file the client automatically computes a checksum of the
% file. Amazon S3 uses checksums to validate the data in each file.
% Using the file extension, Amazon S3 attempts to determine the correct
% content type and content disposition to use for the object.
%
% The specified bucket must already exist and the caller must have
% "Permission.Write" permission to the bucket to upload an object.
%
% Amazon S3 is a distributed system. If Amazon S3 receives multiple write
% requests for the same object nearly simultaneously, all of the objects
% might be stored. However, only one object will obtain the key.
%
% Amazon S3 never stores partial objects; if during this call an exception
% wasn't thrown, the entire object was stored.
%
% An ObjectMetadata object can be uploaded along with and object, it can be used
% to specify custom metadata for that object. This metadata can later be
% downloaded without downloading the entire object.
% .mat file objects are uploaded with a user metadata key and value pair of
% 'com-mathworks-matlabobject' and 'file' respectively.
%
%  s3.putObject('myBucket', 'myObject.mat', 'myObjectName.mat',myObjectMetadata);
%

% Copyright 2017-2021 The MathWorks, Inc.

%% Imports
import java.io.File
import com.amazonaws.services.s3.model.PutObjectRequest
import javax.crypto.SecretKey
import com.amazonaws.services.s3.model.SSECustomerKey
import com.amazonaws.services.s3.model.ObjectMetadata
import com.amazonaws.services.s3.model.S3Object

% Logging object
logObj = Logger.getLogger();

% Validate input - needs to move to parameters at some point
p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'putObject';

addRequired(p,'bucketName',@ischar);
addRequired(p,'object', @ischar);
optArgCtr = 3;
if  obj.encryptionScheme == aws.s3.EncryptionScheme.SSEC
    checkSSECClass = @(x) isa(x,'com.amazonaws.services.s3.model.SSECustomerKey');
    addRequired(p,'ssecKey',checkSSECClass);
    optArgCtr = optArgCtr + 1;
end
if  obj.encryptionScheme == aws.s3.EncryptionScheme.SSEKMS
    checkSSEKMSClass = @(x) isa(x,'com.amazonaws.services.s3.model.SSEAwsKeyManagementParams');
    addRequired(p,'sseKmsParam',checkSSEKMSClass);
    optArgCtr = optArgCtr + 1;
end

% if the arg following the optional encryptionScheme arg is a char it is the keyname
if optArgCtr > numel(varargin)
    % don't have enough args to have a keyname
    parsedKeyName = false;
else
    if ischar(varargin{optArgCtr})
        addRequired(p,'keyName');
        parsedKeyName = true;
        optArgCtr = optArgCtr + 1;
    else
        parsedKeyName = false;
    end
end

if optArgCtr > numel(varargin)
    % we don't have a metadat arg
    parsedMetaData = false;
else
    % we may have metadata
    if isa(varargin{optArgCtr},'aws.s3.ObjectMetadata')
        addRequired(p,'metadata');
        parsedMetaData = true;
    else
        parsedMetaData = false;
    end
end

parse(p,varargin{:});
bucketName = p.Results.bucketName;
object = p.Results.object;
if  obj.encryptionScheme == aws.s3.EncryptionScheme.SSEC
    ssecKey = p.Results.ssecKey;
end
if  obj.encryptionScheme == aws.s3.EncryptionScheme.SSEKMS
    sseKmsParam = p.Results.sseKmsParam;
end
if parsedKeyName
    keyName = p.Results.keyName;
else
    keyName = '';
end
if parsedMetaData
    metadata = p.Results.metadata;
else
    metadata = aws.s3.ObjectMetadata();
end

% check if we are dealing with a relative or absolute path
% file does not have to exist for fileparts to work
[pathstr,~,extstr] = fileparts(object);
% if path is empty then relative path
if isempty(pathstr)
    % use which to return MATLAB's view of what the absolute path is
    absFileName = which(object);
    % In case we're using MATLAB in a compiled application, this may be
    % necessary to find the corresponding file.
    if isempty(absFileName)
        absFileName = fullfile('.', object);
    end
else
    % in this case we've an absolute path so just use that
    absFileName = object;
end
% object for upload is a file, object is the file path and name
% uploading a file first check it exists
% does not check if it is a MAT file
if exist(absFileName,'file') ~= 2
    % Escape any back slashes in paths
    absFileName = strrep(absFileName, '\', '\\');
    write(logObj,'error', ['File not found: ', absFileName]);
end

% Create a java file handle for the file
fObj = File(absFileName);

% if keyName is set then use that as the name otherwise reuse the
% object i.e. the file path when creating the request
if isempty(keyName)
    write(logObj, 'debug', ['Specific key name not set, using: ', object]);
    keyName = object;
end

% configure the PutObjectRequest
% configure EncryptionScheme metadata as required
if strcmpi(extstr,'.mat') || obj.encryptionScheme == aws.s3.EncryptionScheme.SSES3
    % set the custom metadata field for the type
    if strcmpi(extstr,'.mat')
        metadata.addUserMetadata('com-mathworks-matlabobject','file');
    end
    if obj.encryptionScheme == aws.s3.EncryptionScheme.SSES3
        % this set method is not implemented so use handle method
        metadata.Handle.setSSEAlgorithm(ObjectMetadata.AES_256_SERVER_SIDE_ENCRYPTION);
    end
end

% Create a request to put the specified file along with the metadata
% The metadata may have been configured above, passed as an argument or a default 'empty' ObjectMetadata object
pReq = PutObjectRequest(bucketName, keyName, fObj).withMetadata(metadata.Handle);


% upload the object with or without at SSEC key or SSE KMS parameter
if obj.encryptionScheme == aws.s3.EncryptionScheme.SSEC
    write(logObj,'verbose',['Uploading a file to S3 using SSEC, bucket: ', bucketName,' object: ',keyName]);
    % return value is a PutObjectResult response (unused for now)
    response = obj.Handle.putObject(pReq.withSSECustomerKey(ssecKey));
elseif obj.encryptionScheme == aws.s3.EncryptionScheme.SSEKMS
    write(logObj,'verbose',['Uploading a file to S3 using SSEKMS, bucket: ', bucketName,' object: ',keyName]);
    response = obj.Handle.putObject(pReq.withSSEAwsKeyManagementParams(sseKmsParam));
else
    write(logObj,'verbose',['Uploading a file to S3, bucket: ', bucketName,' object: ',keyName]);
    response = obj.Handle.putObject(pReq);
end

% check the response to see that an encryption scheme has been applied where
% expected and where possible
switch obj.encryptionScheme
    case {aws.s3.EncryptionScheme.NOENCRYPTION, aws.s3.EncryptionScheme.CSEAMK, aws.s3.EncryptionScheme.CSESMK, aws.s3.EncryptionScheme.KMSCMK}
        % NOENCRYPTION, data not encrypted at rest don't test
        % CSEAMK, CSESMK, KMSCMK no response values to test against
    case aws.s3.EncryptionScheme.SSEC
        % SSEC, server side encryption with customer provided key additional key is required
        algval = char(response.getSSECustomerAlgorithm());
        if ~strcmp(algval, 'AES256')
            write(logObj,'error',['SSEC SSEAlgorithm set to: ', algval,' expected: AES256, CAUTION data may not be encrypted at rest']);
        end
        keyMd5 = char(response.getSSECustomerKeyMd5());
        if isempty(keyMd5)
            write(logObj,'error','SSEC KeyMd5 unexpected value');
        end
    case aws.s3.EncryptionScheme.SSEKMS
        % SSEKMS, server-side encryption using a KMS managed key additional parameter is required
        algval = char(response.getSSEAlgorithm());
        if ~strcmp(algval, 'aws:kms')
            write(logObj,'error',['SSEKMS SSEAlgorithm set to: ', algval,' expected: aws:kms, CAUTION data may not be encrypted at rest']);
        end
    case aws.s3.EncryptionScheme.SSES3
        % SSES3, server-side encryption using S3 managed encryption keys
        algval = char(response.getSSEAlgorithm());
        if ~strcmp(algval, 'AES256')
            write(logObj,'error',['SSES3 SSEAlgorithm set to: ', algval,' expected: AES256, CAUTION data may not be encrypted at rest']);
        end
    otherwise
        write(logObj,'error','Unknown encryption scheme, WARNING data may not be encrypted at rest');
end % switch

end % function
