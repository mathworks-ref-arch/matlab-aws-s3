function containerMapResult = getUserMetadata(obj)
% GETUSERMETADATA Gets the custom user-metadata for the associated object
% A containers.Map of the metadata keys and values is returned. If there is
% no metadata an empty containers.Map is returned.
%
% Example:
%   myDownloadedMetadata = s3.getObjectMetadata(myBucket, myObjectKey);
%   myMap = myDownloadedMetadata.getUserMetaData();
%   myMetadataValue = myMap(lower('myMetadataKey'));
%

% Copyright 2018 The MathWorks, Inc.

% returns a java.util.TreeMap
resultJ = obj.Handle.getUserMetadata();

% the following conversion process is not optimal for performance or scale
% but is straightforward and sufficient for object metadata

% return and entrySet to get an iterator
entrySetJ = resultJ.entrySet();
% get the iterator
iteratorJ = entrySetJ.iterator();

% declare empty cell arrays for values and keys
metadataKeys = {};
metadataValues = {};

while iteratorJ.hasNext()
    % pick metadata from the entry set one at a time
    entryJ = iteratorJ.next();
    % get the key and the value
    metadataKey = entryJ.getKey();
    metadataValue = entryJ.getValue();
    % build the cell arrays of keys and values
    metadataKeys{end+1} = metadataKey; %#ok<AGROW>
    metadataValues{end+1} = metadataValue; %#ok<AGROW>
end

% if the cell arrays are still empty then create an empty containers.Map and
% return that else build it from the arrays of values and keys
if isempty(metadataKeys)
    containerMapResult = containers.Map;
else
    containerMapResult = containers.Map(metadataKeys,metadataValues);
end

end
