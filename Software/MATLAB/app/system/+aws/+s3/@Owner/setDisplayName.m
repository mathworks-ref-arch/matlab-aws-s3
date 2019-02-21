function  setDisplayName(obj, displayname)
% SETOWNERDISPLAYNAME Method to set the DisplayName of an owner of an ACL
%
% Example:
%   s3 = aws.s3.Client();
%   s3.initialize();
%   acl = aws.s3.AccessControllist();
%   owner = aws.s3.Owner();
%   owner.setDisplayName('my_display_name');
%   owner.setId('aba123456a64f60b91c7736971a81116fb2a07fff2331499c04a967c243b7576');
%   acl.setOwner(owner);
%

% Copyright 2017 The MathWorks, Inc.

%% Imports
import com.amazonaws.services.s3.model.Owner;

logObj = Logger.getLogger();
write(logObj,'verbose',['Setting owner DisplayName: ',displayname]);

obj.Handle.setDisplayName(string(displayname));
% get the displayName back for the the local MATLAB object from the Java
% object to ensure direct correspondence
obj.displayName = char(obj.Handle.getDisplayName());

end %function
