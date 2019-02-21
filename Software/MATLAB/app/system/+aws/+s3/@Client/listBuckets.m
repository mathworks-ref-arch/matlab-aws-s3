function [varargout] = listBuckets(obj, varargin)
% LISTBUCKETS Method to list the buckets available to the user
% The list of buckets names are returned as a table to the user.
%
%   s3 = aws.s3.Client()
%   s3.initialize();
%   s3.listBuckets();

% Copyright 2017 The MathWorks, Inc.

logObj = Logger.getLogger();
write(logObj,'verbose','Listing buckets');
bucketData = obj.Handle.listBuckets();

bCount = 0;
while (bucketData.iterator.hasNext())
    % We have a bucket to process
    bucketItem = bucketData.iterator.next();
    bCount = bCount+1;

    % Get the name
    bucketName(bCount) = {char(bucketItem.getName())}; %#ok<AGROW>
    bucketCreationDate(bCount) = {char(bucketItem.getCreationDate)}; %#ok<AGROW>

    % TODO: Support multiple owners
    bucketOwner(bCount) = {char(bucketItem.getOwner().getDisplayName())}; %#ok<AGROW>
    bucketOwnerId(bCount) = {char(bucketItem.getOwner().getId())}; %#ok<AGROW>

    bucketData.remove(0); % Java uses 0 based indexing
end

% Create a MATLAB table from the results
bucketTable = table(bucketCreationDate', bucketName', bucketOwner', bucketOwnerId','VariableNames',{'CreationDate','Name','Owner','OwnerId'});

% Return an output
if nargout == 1
    varargout{1} = bucketTable;
else
    str = evalc('disp(bucketTable)');
    write(logObj,'verbose',str);
end

end %function
