function setObjectAcl(obj, bucketName, keyName, acl)
% SETOBJECTACL Method to set an ACL on an existing object S3 object
% Sets an ACL on an object on the S3 service, the ACL is provided as
% an argument along with a bucket and keyname.
%
%   s3.setObjectAcl('com-mathworks-testbucket','mykeyname',myacl);
%
% This can be used along with getObjectAcl() to get and reuse an existing
% ACL. Alternately a preconfigured "canned" ACL can be used e.g.:
%
% myCannedACL = aws.s3.CannedAccessControlList('AuthenticatedRead')
% s3.setObjectAcl('com-mathworks-testbucket','MyData.mat',myCannedACL)
%
% See AWS S3 JDK SDK for a complete list of canned ACLs.

% Copyright 2017 The MathWorks, Inc.

%% Imports
import com.amazonaws.services.s3.model.AccessControlList
import com.amazonaws.services.s3.model.CannedAccessControlList

logObj = Logger.getLogger();
write(logObj,'verbose',['Setting ACL on bucket: ',bucketName,' object: ',keyName]);
obj.Handle.setObjectAcl(bucketName, keyName, acl.Handle);

end %function
