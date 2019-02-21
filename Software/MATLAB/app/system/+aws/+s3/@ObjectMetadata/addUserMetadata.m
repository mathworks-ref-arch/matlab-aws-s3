function addUserMetadata(obj, key, value)
% ADDUSERMETADATA Adds key value pair of custom metadata for an object
% Note that user-metadata for an object is limited by the HTTP request
% header limit. All HTTP headers included in a request (including user
% metadata headers and other standard HTTP headers) must be less than 8KB.
% User-metadata keys are case insensitive and will be returned as lowercase
% strings, even if they were originally specified with uppercase strings.
%
% Example:
%   save myData x;
%   myMetadata = aws.s3.ObjectMetadata();
%   myMetadata.addUserMetadata('myKey', 'myValue');
%   s3.putObject('com-mathworks-mytestbucket', 'myData.mat', myMetadata);
%

% Copyright 2018 The MathWorks, Inc.

% Logging object
logObj = Logger.getLogger();

% Validate input
if ~ischar(key)
    write(logObj,'error','Invalid key argument');
end

if ~ischar(value)
    write(logObj,'error','Invalid value argument');
end

obj.Handle.addUserMetadata(key,value);

end %function
