function [varargout] = listObjects(obj, objectKey, prefix)
% LISTOBJECTS Method to list the objects in an S3 bucket
% Objects in a particular bucket can be listed using:
%
%   s3.listObjects(bucketName);
%
% For example:
%   s3.listObjects('com-mathworks-mybucket');
%
% The results of the query are returned in as a MATLAB table.
% If the bucket is empty an empty table is returned.
%
% To retrieve only objects below a certain level,
%  e.g. from s3://com-mathworks-mybucket/my/path, use the path as an input.
%
%   s3.listObjects('com-mathworks-mybucket', 'my/path');
%
%
% When listing and fetching data in other account owned buckets, depending
% on the ACL configuration, the user may not be able to retrieve the owner
% information. In such cases the owner for the object will be set to an
% empty string.

% Copyright 2017 The MathWorks, Inc.

%% Imports
import com.amazonaws.services.s3.model.ListObjectsRequest;
import com.amazonaws.services.s3.model.ObjectListing;

logObj = Logger.getLogger();
write(logObj,'verbose',['Listing objects in ',objectKey]);

% Create a request
listRequest = ListObjectsRequest();

% get the first batch of object listings
if nargin > 2
    objectListing = obj.Handle.listObjects(listRequest.withBucketName(objectKey).withPrefix(prefix));
else
    objectListing = obj.Handle.listObjects(listRequest.withBucketName(objectKey));
end
objectSummaries = objectListing.getObjectSummaries();

% if the number of objects exceeds 1000 then the listing will be flagged as
% turncated and we get the next batch and so on
while objectListing.isTruncated()
    objectListing = obj.Handle.listNextBatchOfObjects(objectListing);
    objectSummaries.addAll(objectListing.getObjectSummaries());
end

bCount = 0;
while (objectSummaries.iterator.hasNext())
    % We have a bucket to process
    objItem = objectSummaries.iterator.next();
    bCount = bCount+1;
    % Get the table entries for this iteration
    objectKeyName(bCount) = {char(objItem.getKey())}; %#ok<AGROW>
    objectSize(bCount) = {objItem.getSize()}; %#ok<AGROW>
    lastModified(bCount) = {char(objItem.getLastModified())}; %#ok<AGROW>
    storageClass(bCount) = {char(objItem.getStorageClass())}; %#ok<AGROW>

    % Depending on ACL configuration, the object may or may not show an
    % owner
    if ~isempty(objItem.getOwner())
        ownerName(bCount) = {char(objItem.getOwner().getDisplayName())}; %#ok<AGROW>
    else
        ownerName(bCount) = {''}; %#ok<AGROW>
    end

    % Pop the owner from the array
    objectSummaries.remove(0); % Java uses 0 based indexing
end

% Create a MATLAB table from the results, if bucket is empty return an
% empty table
if bCount > 0
    bucketTable = table(objectKeyName', objectSize', lastModified', storageClass',ownerName','VariableNames',{'ObjectKey','ObjectSize','LastModified','StorageClass','Owner'});
else
    bucketTable = table;
end

% Return table as an output or display the table
if nargout == 1
    varargout{1} = bucketTable;
else
    disp(bucketTable);
end

end % function
