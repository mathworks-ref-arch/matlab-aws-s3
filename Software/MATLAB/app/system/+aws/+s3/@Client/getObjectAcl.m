function acl = getObjectAcl(obj, bucketName, keyName)
% GETOBJECTACL Method to get the ACL of an existing AWS S3 object
% Get the ACL for the object, the ACL can then be inspected or applied to
% another object
%
%   s3.getObjectAcl(bucketName, keyName);
%

% Copyright 2017 The MathWorks, Inc.
%% Imports
import com.amazonaws.services.s3.model.AccessControlList

logObj = Logger.getLogger();
write(logObj,'verbose',['Getting ACL for, bucket: ', bucketName,' object: ',keyName]);

% create an instance of the wrapped AccessControlList
acl = aws.s3.AccessControlList();

% assign the handle of the returned AWS ACL object to the handle in the
% wrapped object (TODO review this e.g. resources leak etc.)
acl.Handle = obj.Handle.getObjectAcl(bucketName, keyName);

end %function
