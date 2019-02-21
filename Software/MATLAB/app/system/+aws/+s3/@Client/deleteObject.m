function deleteObject(obj, bucketName, key)
% DELETEOBJECTS Method to delete an object
% Removes the specified object from the specified S3 bucket.
% Unless versioning has been turned on for the bucket.
% There is no way to undelete an object, so use caution when deleting objects.
%
%   s3.deleteObject(bucketName, key);
%

% Copyright 2017 The MathWorks, Inc.


logObj = Logger.getLogger();
write(logObj,'verbose',['Deleting object: ',key ,' from bucket: ',bucketName]);

% Call the API to delete an object
obj.Handle.deleteObject(bucketName, key);

end %function
