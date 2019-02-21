function  setOwner(obj, owner)
% SETOWNER Method to set the owner of an ACL
%
% Example:
%   acl = aws.s3.AccessControlList();
%   owner = aws.s3.createOwner();
%   owner.setDisplayName('my_display_name');
%   owner.setId('aba123456a64f60b91c7736971a81116fb2a07fff2331499c04a967c243b7576');
%   acl.setOwner(owner);
%

% Copyright 2017 The MathWorks, Inc.

%% Imports
import com.amazonaws.services.s3.model.Owner
import com.amazonaws.services.s3.model.AccessControlList;
import com.amazonaws.services.s3.model.CannedAccessControlList;

logObj = Logger.getLogger();
write(logObj,'verbose','Setting ACL Owner');
obj.Handle.setOwner(owner.Handle);

end %function
