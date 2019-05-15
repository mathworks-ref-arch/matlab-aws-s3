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
% get the size of the array so the fields can be preallocated
size = bucketData.size();

bCount = 0;
bucketName = cell(1, size);
bucketCreationDate = cell(1, size);
bucketOwner = cell(1, size);
bucketOwnerId = cell(1, size);

while (bucketData.iterator.hasNext())
    % We have a bucket to process
    bucketItem = bucketData.iterator.next();
    bCount = bCount+1;

    % Get the name
    bucketName(bCount) = {char(bucketItem.getName())}; 
    bucketCreationDate(bCount) = {char(bucketItem.getCreationDate)}; 

    % TODO: Support multiple owners
    ownerJ = bucketItem.getOwner();
    % if using the Google Cloud Storage interop service then owner can be
    % empty
    if isempty(ownerJ)
        bucketOwner(bCount) = {char.empty};
        bucketOwnerId(bCount) = {char.empty};
    else
        bucketOwner(bCount) = {char(bucketItem.getOwner().getDisplayName())}; 
        bucketOwnerId(bCount) = {char(bucketItem.getOwner().getId())}; 
    end
    
    bucketData.remove(0); % Java uses 0 based indexing
end

% Create a MATLAB table from the results
bucketTable = table(bucketCreationDate', bucketName', bucketOwner', bucketOwnerId','VariableNames',{'CreationDate','Name','Owner','OwnerId'});

% Return an output
if nargout == 1
    varargout{1} = bucketTable;
else
    str = evalc('disp(bucketTable)');
    write(logObj,'debug',str);
end

end %function
