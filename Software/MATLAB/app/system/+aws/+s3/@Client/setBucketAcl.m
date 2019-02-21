function setBucketAcl(obj, bucketName, acl)
% SETBUCKETACL Method to set an ACL on an existing object S3 Bucket
% Sets an ACL on a bucket on the S3 service.
%
%   s3.setBucketAcl('com-example-testbucket',myACL);
%
% This can be used along with getBucketAcl() to get and reuse an existing
% ACL. Alternately a preconfigured "canned" ACL can be used e.g.:
%
% myCannedACL = aws.s3.CannedAccessControlList('AuthenticatedRead')
% s3.setBucketAcl('com-example-testbucket',myCannedACL)
%
% See AWS S3 JDK SDK for a complete list of canned ACLs.

% Copyright 2017 The MathWorks, Inc.

%% Imports
import com.amazonaws.services.s3.model.AccessControlList
import com.amazonaws.services.s3.model.CannedAccessControlList

logObj = Logger.getLogger();
write(logObj,'verbose',['Setting ACL on: ',bucketName]);
obj.Handle.setBucketAcl(bucketName, acl.Handle);

end %functon
