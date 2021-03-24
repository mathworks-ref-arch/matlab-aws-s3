function [altered, nameUsed] = createBucket(obj, bucketName)
% CREATEBUCKET Method to create a bucket on the Amazon S3 service
% Create a bucket on the S3 service
%
%   s3 = aws.s3.Client();
%   s3.initialize();
%   s3.createBucket('com-mathworks-testbucket-jblog');
%
% Amazon S3 bucket names are globally unique, so once a bucket name has
% been taken by any user, it cannot be used to create another bucket with the same
% name and it takes a while for the name to become available for reuse.
%
% Bucket names cannot contain UPPERCASE characters so all inputs are
% converted to lowercase.
%
% Amazon recommends that all bucket names comply with DNS naming conventions.
%
% Please see:
% http://docs.aws.amazon.com/AmazonS3/latest/dev/BucketRestrictions.html
%
% If an invalid name is passed createBucket will attempt to minimally alter it
% to comply with the rules. If the name has been altered the altered flag will
% be returned as true. The nameUsed return value returns the name that is passed
% to S3.


% Copyright 2018-2021 The MathWorks, Inc.

logObj = Logger.getLogger();

write(logObj,'verbose',['Creating bucket: ',bucketName]);

% if the name is changed to comply then altered is returned as true else
% false, the nameUsed is returned in either case
[altered, nameUsed] = mangleName(bucketName);

if altered
    write(logObj,'warning',['Bucket name altered from: ',bucketName,' to: ',nameUsed, 'due to S3 naming conventions']);
end

% Call the API to create a bucket
obj.Handle.createBucket(nameUsed);

end %function

function [altered, outName] = mangleName(inName)
% mangle the name to better comply with AWS restrictions on bucket names
% catches most common errors but 100% compliance or uniqueness is not
% guaranteed and should be tested using the createBucket return value

logObj = Logger.getLogger();

% copy the initial value for later comparison
originalName = inName;

% name must be 3 chars long at minimum, pad with 'x'
if length(inName) < 3
    for n = 1:3-length(inName)
        inName = [inName 'x']; %#ok<AGROW>
    end
end

% limit length to 63 characters, truncate
if length(inName) > 63
    inName = inName(1:63);
end

% remove uppercase characters
inName = lower(inName);

% remove underscores, replace with hyphens
inName = strrep(inName, '_', '-');

% if the first character is not a lowercase letter (conversion to lower)
% happened above or a number substitute an 'x'
if ~isLowerLetterOrNumber(inName(1))
    inName(1) = 'x';
end

% replace any repeated '.'
inName = strrep(inName, '..', '.x');

% labels between .'s should start and end with numbers or letters
labels = split(inName, '.');
for n = 1:numel(labels)
    if ~isLowerLetterOrNumber(labels{n}(1))
        labels{n}(1) = 'x';
    end
    if ~isLowerLetterOrNumber(labels{n}(end))
        labels{n}(end) = 'x';
    end
end
% reassemble the updated labels
inName = join(labels,'.');

% flag if the name has been changed in the log and return the flag
if ~strcmp(originalName, inName)
    % alteration flagged in calling function if appropriate unless verbose
    write(logObj,'verbose',['Bucket name: ', originalName, ' does not comply with naming restrictions, converting name to: ', inName]);
    altered = true;
    outName = inName;
else
    outName = originalName;
    altered = false;
end
end


% test if a character is a lowercase letter or number i.e. 0-9, returns true or
% false and only works with single character inputs
function tf = isLowerLetterOrNumber(val)
if ~isscalar(val)
    tf = false;
    return;
end

if ~ischar(val)
    tf = false;
    return;
end

if length(val) > 1
    tf = false;
    return;
end

if ~isletter(val)
    % not a letter so test if it is a number
    if isnan(str2double(val))
        tf = false;
        return;
    else
        tf = true;
        return;
    end
else
    % if the lower case value is the same as the value it is lowercase so
    % return true else false
    if strcmp(val,lower(val))
        tf = true;
        return;
    else
        tf = false;
        return;
    end
end
end
