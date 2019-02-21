function  setId(obj, id)
% SETID Method to set the Id of an Owner of an ACL
%
% Example:
%   s3 = aws.s3.Client();
%   s3.initialize();
%   acl = aws.s3.AccessControlList();
%   owner = aws.s3.Owner();
%   owner.setDisplayName('my_display_name');
%   owner.setId('aba123456a64f60b91c7736971a81116fb2a07fff2331499c04a967c243b7576');
%   acl.setOwner(owner);
%

% Copyright 2017 The MathWorks, Inc.

%% Imports
import com.amazonaws.services.s3.model.Owner

logObj = Logger.getLogger();
write(logObj,'verbose',['Setting owner Id: ',id]);

% First set the underlying Java object Id based on the argument provided
obj.Handle.setId(string(id));
% Then using the Java object get method retrieve the Id and set the MATLAB
% object property based on this to ensure direct correspondence
obj.id = char(obj.Handle.getId());

end %function
