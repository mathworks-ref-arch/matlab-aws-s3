function acl = getBucketAcl(obj, bucketName)
% GETBUCKETACL Method to get the ACL of an existing Amazon S3 bucket
% Get the ACL for a bucket, the ACL can then be inspected or applied to
% another bucket. Depending on the permissions of the bucket it is possible
% that an empty ACL with no properties will be returned, e.g. if the bucket
% is owned by a 3rd party.
%
%   s3.getBucketAcl(bucketName);
%

% Copyright 2017-2021 The MathWorks, Inc.

%% Imports
import com.amazonaws.services.s3.model.AccessControlList

logObj = Logger.getLogger();
write(logObj,'verbose',['Getting ACL for: ',bucketName]);

% create an instance of the wrapped AccessControlList
acl = aws.s3.AccessControlList();

% assign the handle of the returned AWS ACL object to the handle in the
% wrapped object (??? review this e.g. resources leak etc.)
acl.Handle = obj.Handle.getBucketAcl(bucketName);
end %function
