function S = load(obj, varargin)
% LOAD, Method to load data from AWS S3 into the workspace
% This method behaves similarly to the standard MATLAB load command in its
% functional form. It reads back from a specific object in a given bucket.It
% returns the results in a structure with the given variable names.
% Optionally a server side client provider and managed encryption key can
% be provided.
%
% Example:
%   % load a named variable from the file using an SSEC key
%   s3.load(bucketname, objectname, SSECustomerKey, 'my_variable_name');
%
%   % load regardless of file extension
%   s3.load(bucketname, NonMAT_objectname, 'my_variable_name', '-mat');
%
%   % load entire file
%   s3.load(bucketname, objectname, 'my_variable_name');
%
% Using load to load a subset of a file will not improve access time as the
% complete file is downloaded.

% Copyright 2017 The MathWorks, Inc.

%% Imports
import com.amazonaws.services.s3.model.GetObjectRequest;
import com.amazonaws.services.s3.model.S3ObjectInputStream;
import org.apache.commons.io.IOUtils;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.BufferedOutputStream;
import com.amazonaws.services.s3.model.SSECustomerKey;

logObj = Logger.getLogger();

% validate input
p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'load';

addRequired(p,'bucketName',@ischar);
addRequired(p,'objectName',@ischar);
% Arguments: bucketName, ObjectName, [cryptKeyArg], firstOtherParam ....
% Parameters from firstOtherParam onwards are passed to load so set the start
% index to 3 or 4
if (obj.encryptionScheme == aws.s3.EncryptionScheme.SSEC)
    checkSSEClass = @(x) isa(x,'com.amazonaws.services.s3.model.SSECustomerKey');
    addRequired(p,'cryptKeyArg',checkSSEClass);
    parse(p,varargin{1:3});
    startIdx = 4;
else
    parse(p,varargin{1:2});
    startIdx = 3;
end

bucketName = p.Results.bucketName;
objectName = p.Results.objectName;
if (obj.encryptionScheme == aws.s3.EncryptionScheme.SSEC)
    cryptKeyArg = p.Results.cryptKeyArg;
end

if (obj.encryptionScheme == aws.s3.EncryptionScheme.SSEC) && isempty(cryptKeyArg)
    write(logObj,'error','Expecting SSEC Key value');
end

% allow for no arguments other than the bucket and object, i.e load the
% entire file
if (numel(varargin) - startIdx) < -1
    write(logObj,'error','Insufficient input arguments');
end


% empty struct to return if there is an error
S = [];

[~, ~, objExt] = fileparts(objectName);
% create a temp file to save the results to using getObject
tmpName = [tempname, objExt];

if obj.encryptionScheme == aws.s3.EncryptionScheme.SSEC
    obj.getObject(bucketName, objectName, tmpName, cryptKeyArg);
else
    obj.getObject(bucketName, objectName, tmpName);
end

% check what has been downloaded
try
    output = whos('-file',tmpName); %#ok<NASGU>
catch
    warnType = true;
    for n = startIdx:numel(varargin)
        if ischar(varargin{n})
            if strcmpi(varargin{n}, '-ascii')
                warnType = false;
            end
        end
    end
    % if whos can read the file and it is not -ascii that is being passed warn
    % about the type as load is likely to fail
    if warnType
        write(logObj,'debug',['Warning ' tmpName ' does not have a .mat extension']);
    end
end

% return a struct containing the variables from the file
S = load(tmpName, varargin{startIdx:end});

% delete the local temp file
delete(tmpName);

end %function
