function save(obj, varargin)
% SAVE Method to save files or variables to an Amazon S3 bucket
% A higher level method that uses the built in save syntax to save data to an
% S3 bucket. Save can be used very much like the functional form of the built-in
% save command with two exceptions:
%   1) The '-append' option is not supported.
%   2) An entire workspace cannot be saved e.g.
%   s3.save('my_work_space.mat');
% The workspace variables should be listed explicitly to overcome this or first
% save the workspace to a local file and then save the resulting file to S3.

% A bucket name must be provided, this bucket is created by the save
% call if it does not already exist. An object name must also be provided. This
% function will use the parameters following the server-side encryption
% parameter as though they were arguments to the conventional save command. A
% filename is not required as the bucket and object names are used in its place.
%
% Examples:
%    % save a variable x to S3
%    s3.save(mybucketname, myobjectname, 'x')
%
%    % save x but in ascii double format rather than .mat
%    s3.save(mybucketname, myobjectname, 'x', '-ascii', '-double');
%
% If required by the current encryption scheme a client-side managed encryption
% key for server-side encryption key must also be provided if required similarly
% KMS parameters must be provided. This is similar to when using putObject.
%
%   s3.save(bucketname, objectname, ssecKey, <save_arguments>)
%   s3.save(bucketname, objectname, sseKmsParam, <save_arguments>)
%
% The file extension type of the objectname is used as the file extension for
% the save. Save extension overrides can be used as shown above, -ascii.
%

% Copyright 2017 The MathWorks, Inc.

%% Imports
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.BufferedOutputStream;

% Create a logger object
logObj = Logger.getLogger();

% validate input
p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'save';

% a bucket name is required in all cases
addRequired(p,'bucketName',@ischar);
addRequired(p,'objectName',@ischar);
if (obj.encryptionScheme == aws.s3.EncryptionScheme.SSEC) || (obj.encryptionScheme == aws.s3.EncryptionScheme.SSEKMS)
    % Arguments: bucketName, ObjectName, [cryptKeyArg], firstOtherParam ....
    % Parameters from firstOtherParam onwards are passed to save so set the start
    % index to 3 or 4
    checkSSEClass = @(x) (isa(x,'com.amazonaws.services.s3.model.SSECustomerKey') || isa(x,'com.amazonaws.services.s3.model.SSEAwsKeyManagementParams'));
    addRequired(p,'cryptKeyArg','',checkSSEClass);
    parse(p,varargin{1:3});
    startIdx = 4;
else
    parse(p,varargin{1:2});
    startIdx = 3;
end

bucketName = p.Results.bucketName;
objectName = p.Results.objectName;

if (obj.encryptionScheme == aws.s3.EncryptionScheme.SSEC) || (obj.encryptionScheme == aws.s3.EncryptionScheme.SSEKMS)
    cryptKeyArg = p.Results.cryptKeyArg;
end

if (obj.encryptionScheme == aws.s3.EncryptionScheme.SSEC) && isempty(cryptKeyArg)
    write(logObj,'error','Expecting SSEC Key value');
elseif (obj.encryptionScheme == aws.s3.EncryptionScheme.SSEKMS) && isempty(cryptKeyArg)
    write(logObj,'error','Expecting SSE KMS parameter value');
end

% should have at least one load argument
if (numel(varargin) - startIdx) < 0
    write(logObj,'error','Insufficient input arguments');
end

% scan varargin for -append
% can't handle this as the file being appended to is not local it would
% have to be downloaded first
for n = startIdx:numel(varargin)
    if ischar(varargin{n})
        if strcmpi(varargin{n}, '-append')
            write(logObj,'error','-append is not support when saving to S3, consider downloading the target file and append locally and then upload');
            return;
        end
    end
end

% if the specified bucket does not exist create it
if ~obj.doesBucketExist(bucketName)
    write(logObj,'verbose',['Bucket does not exist, creating bucket: ',bucketName]);
    obj.createBucket(bucketName);
end


[~, ~, objExt] = fileparts(objectName);
% create a temp file to save the results to using built in save
tmpName = [tempname, objExt];
% call built in save to dump output to a file for later upload

% build an expression to pass to a built-in save in the calling workspace
% function ins the calling workspace will not be saved
expr = 'save(';
expr = [expr '''' tmpName ''''];
for n = startIdx:numel(varargin)
    expr = [expr ',' '''' varargin{n} '''']; %#ok<AGROW>
end
expr = [expr ')'];
evalin('caller', expr);

write(logObj,'verbose',['Saving data to S3, bucket: ', bucketName,' object: ',objectName]);
if obj.encryptionScheme == aws.s3.EncryptionScheme.SSEC
    % provide the key if required, the same key will be used for each
    % object being stored by a given save call
    obj.putObject(bucketName, tmpName, cryptKeyArg, objectName);
elseif obj.encryptionScheme == aws.s3.EncryptionScheme.SSEKMS
    % provide KMS parameters as required
    obj.putObject(bucketName, tmpName, cryptKeyArg, objectName);
else
    obj.putObject(bucketName, tmpName, objectName);
end

% delete the temp file
delete(tmpName);


end %function
