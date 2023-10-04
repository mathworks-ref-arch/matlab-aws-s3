function getObject(obj, varargin)
% GETOBJECT Method to retrieve a file object from Amazon S3
% Download an object from a given bucket with a given key name. If
% downloading a file it will be saved using keyName as the filename
% or optionally a specified filename.
%
% When an object is downloaded, all of the object's metadata and
% a stream from which to read the contents, become available.
% It is important to read the contents of the stream as quickly as
% possibly since the data is streamed directly from Amazon S3 and the
% network connection will remain open until all the data has been read or
% the input stream is closed.
%
% Example:
% In the simplest case one simply specifies a bucket name and key name as
% character arrays.
%
%   s3 = aws.s3.Client();
%   s3.initialize();
%   s3.getObject('com-mathworks-testbucket','MyData.mat');
%
% Optionally a filename can be provided, in which case if the object is a
% file it will be written to the filename otherwise the key value will be
% used as the filename.
%
%   s3.getObject(bucketName, keyName, fileName);
%
% If the method will result in a file being overwritten a
% warning is produced and the operation proceeds. If a directory is to be
% overwritten an error is produced.
%
% If using SSEC encryption then a customer provided and managed key must
% also be provided. An optional filename can still be provided as the
% final argument in the argument list.
%
%   s3.getObject(bucketName, keyName, SSECustomerKey);
%
% For files of 100MB and greater a aws.s3.transfer.TransferManager based
% download will be used this can call be used with smaller files by using
% TransferManager directly.
%
% See also: aws.s3.transfer.TransferManager

% Copyright 2017-2023 The MathWorks, Inc.

%% Imports
% import java.io.File;
% import java.io.FileInputStream;
% import java.io.FileOutputStream;
% import org.apache.commons.io.IOUtils;
% import javax.crypto.SecretKey;
% import com.amazonaws.services.s3.model.SSECustomerKey;
% import com.amazonaws.services.s3.model.S3ObjectInputStream;

logObj = Logger.getLogger();

% validate input
p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'getObject';

addRequired(p,'bucketName',@ischar);
addRequired(p,'keyName',@ischar);
if  obj.encryptionScheme == aws.s3.EncryptionScheme.SSEC
    checkSSECClass = @(x) isa(x,'com.amazonaws.services.s3.model.SSECustomerKey');
    addRequired(p,'ssecKey',checkSSECClass);
end
addOptional(p,'fileName','',@ischar);

parse(p,varargin{:});

if obj.encryptionScheme == aws.s3.EncryptionScheme.SSEC
    ssecKey = p.Results.ssecKey;
end
bucketName = p.Results.bucketName;
keyName = p.Results.keyName;
fileName = p.Results.fileName;

% Begin getting the object
write(logObj,'verbose',['Getting an object ',bucketName,'/',keyName]);

% Get object's meta data to determine size
if  obj.encryptionScheme == aws.s3.EncryptionScheme.SSEC
    metadata = obj.getObjectMetadata(bucketName, keyName, ssecKey);
else
    metadata = obj.getObjectMetadata(bucketName, keyName);
end
objectLength = metadata.getContentLength();


% For files less that 100MB use conventional putObject for larger files adopt the
% newer multipart support introduced in v0.6.0
% See: https://docs.aws.amazon.com/AmazonS3/latest/userguide/mpuoverview.html

if objectLength < 104857600 %100MB
    % Create a get request with the key if provided
    if  obj.encryptionScheme == aws.s3.EncryptionScheme.SSEC
        getReqJ = com.amazonaws.services.s3.model.GetObjectRequest(bucketName,keyName).withSSECustomerKey(ssecKey);
    else
        getReqJ = com.amazonaws.services.s3.model.GetObjectRequest(bucketName,keyName);
    end
    s3Object = obj.Handle.getObject(getReqJ);


    % Get the custom matlab_object field
    % write(logObj,'verbose','Getting object metadata');
    type = s3Object.getObjectMetadata().getUserMetaDataOf(string('com-mathworks-matlabobject')); %#ok<STRQUOT>
    % if the custom metadata field is not set assume it is a regular file
    if isempty(type)
        type = 'file';
    end

    if strcmpi(type,'file')
        % write(logObj,'verbose','Getting object');
        if isempty(fileName)
            fileName = keyName;
        end

        % Check for the implications of using this filename
        if exist(fullfile(cd,fileName),'file') == 2
            write(logObj,'warning',['Overwriting existing file: ',fileName]);
        end
        if exist(fullfile(cd,fileName),'dir') == 7
            % error out here as will not be able to overwrite the directory
            write(logObj,'error',['A directory exists named: ',fileName]);
            error('A directory exists named: %s',fileName);
        end
        % Get the input stream for the s3 object
        % fileStream is a com.amazonaws.services.s3.model.S3ObjectInputStream
        fileStream = s3Object.getObjectContent();
        % Create an output to disk, outputStream is a java.io.FileOutputStream
        outputStream = java.io.FileOutputStream(fileName);
        % Copy one stream to another and cleanup
        org.apache.commons.io.IOUtils.copy(fileStream,outputStream);
        outputStream.close();
        fileStream.close();
    else
        % Shouldn't get here, but could in the case of a variable uploaded with a
        % release prior to 0.4.1
        write(logObj,'error',['Unexpected matlabObject value: ',type]);
    end
else
    % Do not support com-mathworks-matlabobject metadata, not supported on upload & deprecated
    type = metadata.getUserMetaDataOf('com-mathworks-matlabobject');
    if ~isempty(type) && ~strcmp(type, 'file')
        write(logObj,'warning',['com-mathworks-matlabobject metadata not supported when using transfer manager, type: ', char(type)]);
    end

    getObjectRequest = aws.s3.model.GetObjectRequest(bucketName,keyName);
    if  obj.encryptionScheme == aws.s3.EncryptionScheme.SSEC
        getObjectRequest = getObjectRequest.withSSECustomerKey(ssecKey);
    end
    tmb = aws.s3.transfer.TransferManagerBuilder();
    tmb = tmb.withS3Client(obj.Handle);
    tm = tmb.build();
    if isempty(fileName) || strlength(fileName) == 0
        fileName = keyName;
    end
    download = tm.download(getObjectRequest, fileName);
    download.waitForCompletion();
    state = download.getState();
    tm.shutdownNow(false);
    if state ~= aws.s3.transfer.TransferState.Completed
        write(logObj,'error',['Download finished with state other than ''Completed'': ', char(state)]);
    end
end
end %function
