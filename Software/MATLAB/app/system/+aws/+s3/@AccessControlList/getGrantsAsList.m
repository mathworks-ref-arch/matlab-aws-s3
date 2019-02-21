function grantsList = getGrantsAsList(obj)
% GETGRANTSASLIST Method to return a list of grants associated with an ACL
% The list is returned as a MATLAB cell array.
% Each grant consists of a grantee and a permission.
% An empty cell array is returned if there are no grants.
%
% Example:
%  s3 = aws.s3.Client();
%  s3.initialize();
%  acl = s3.getObjectAcl(bucketname,keyname);
%  grantlist = acl.getGrantsAsList();
%

% Copyright 2017 The MathWorks, Inc.

%% Imports
import com.amazonaws.services.s3.model.AccessControlList;

logObj = Logger.getLogger();
write(logObj,'verbose','Getting a list of ACL Grants');

linkedListJ = obj.Handle.getGrantsAsList();
listSize = linkedListJ.size();

% convert the list of com.amazonaws.services.s3.model.Grants to a cell array of
% aws.s3.Grants
grantsList = cell(1,listSize);
for n = 1:listSize
    grantsList{1,n} = aws.s3.Grant(linkedListJ.get(n-1));
end

end % function
