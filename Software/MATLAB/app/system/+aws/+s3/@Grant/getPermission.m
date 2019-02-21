function permission = getPermission(obj)
% GETPERMISSION Gets the permission being granted to the grantee by this grant
% An aws.s3.Permission object is returned.

% Copyright 2019 The MathWorks, Inc.

permissionJ = obj.Handle.getPermission();

permission = aws.s3.Permission(char(permissionJ.toString));

end
