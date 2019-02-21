function grantPermission(obj, grantee, permission)
% GRANTPERMISSION Method to add a permission grant to an existing S3 ACL
%
% Example:
%   my_acl = aws.s3.AccessControlList();
%   my_perm = aws.s3.Permission('read');
%   email_addr_grantee = aws.s3.EmailAddressGrantee('joe.blog@example.com');
%   my_acl.grantPermission(email_addr_grantee, my_perm);
%

% Copyright 2017 The MathWorks, Inc.

%% Imports
import com.amazonaws.services.s3.model.AccessControlList;

logObj = Logger.getLogger();
write(logObj,'verbose','Granting permission to ACL');
obj.Handle.grantPermission(grantee.Handle, permission.Handle);

end %function
