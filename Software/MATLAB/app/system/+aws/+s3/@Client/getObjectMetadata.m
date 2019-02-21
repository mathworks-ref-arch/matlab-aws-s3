function objectMetadata = getObjectMetadata(obj, varargin)
% GETOBJECTMETADATA Method to retrieve an AWS S3 object's metadata
% Download an object's metadata without downloading the object itself
%
% Examples:

% If using SSEC encryption then the SSEC key should also be provided
%   myMD = s3.getObjectMetadata(bucketName, keyName);
%   myMD = s3.getObjectMetadata(bucketName, keyName, sseKey);
%

% Copyright 2017 The MathWorks, Inc.

%% Imports
import com.amazonaws.services.s3.model.GetObjectMetadataRequest
import com.amazonaws.services.s3.model.SSECustomerKey

logObj = Logger.getLogger();

% validate input
p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'getObjectMetadata';

addRequired(p,'bucketName',@ischar);
addRequired(p,'keyName',@ischar);
if  obj.encryptionScheme == aws.s3.EncryptionScheme.SSEC
    checkSSECClass = @(x) isa(x,'com.amazonaws.services.s3.model.SSECustomerKey');
    addRequired(p,'ssecKey',checkSSECClass);
end

parse(p,varargin{:});

bucketName = p.Results.bucketName;
keyName = p.Results.keyName;
if  obj.encryptionScheme == aws.s3.EncryptionScheme.SSEC
    ssecKey = p.Results.ssecKey;
end

% setup the request
if  obj.encryptionScheme == aws.s3.EncryptionScheme.SSEC
    getReq = GetObjectMetadataRequest(bucketName, keyName).withSSECustomerKey(ssecKey);
else
    getReq = GetObjectMetadataRequest(bucketName, keyName);
end

% download the metadata and return the metadata object for the object
objectMetadata = aws.s3.ObjectMetadata();
objectMetadata.Handle = obj.Handle.getObjectMetadata(getReq);

% dump output as debug info
%write(logObj,'verbose','Object Metadata Debug info:');
%write(logObj,'verbose','===========================');
%disp('Content-Length HTTP header indicating the size of the associated object in bytes.');
%fprintf('ContentLength: %d\n', objectMetadata.getContentLength());
%write(logObj,'verbose','The server-side encryption algorithm when encrypting the object using AWS-managed keys.');
%write(logObj,'verbose',['SSEAlgorithm : ', objectMetadata.getSSEAlgorithm()]);
%write(logObj,'verbose','The AWS Key Management System key id used for Server Side Encryption of the Amazon S3 object.');
%write(logObj,'verbose',['SSEAwsKmsKeyId : ', objectMetadata.getSSEAwsKmsKeyId()]);
%write(logObj,'verbose','The server-side encryption algorithm if the object is encrypted using customer-provided keys.');
%write(logObj,'verbose',['SSECustomerAlgorithm : ', objectMetadata.getSSECustomerAlgorithm()]);
%disp('The optional Content-Disposition HTTP header, which specifies presentation information for the object such as the recommended filename for the object to be saved as.');
%fprintf('ContentDisposition: %s\n\n', objectMetadata.getContentDisposition());
%disp('The value of x-amz-mp-parts-count header.');
%fprintf('PartCount: %s\n',objectMetadata.getPartCount());
%write(logObj,'verbose','The base64-encoded MD5 digest of the encryption key for server-side encryption, if the object is encrypted using customer-provided keys.');
%write(logObj,'verbose',['SSECustomerKeyMd5 : ',objectMetadata.getSSECustomerKeyMd5()]);

end %function
