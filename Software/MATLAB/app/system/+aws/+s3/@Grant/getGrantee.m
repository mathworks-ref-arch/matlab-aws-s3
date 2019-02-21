function grantee = getGrantee(obj)
% GRANTEE Gets the grantee being granted a permission by this grant
% An object of type CanonicalGrantee, EmailAddressGrantee or GroupGrantee is
% returned.
%
% Example:
%   grants = myAcl.getGrantsAsList();
%    grantee = grants{1}.getGrantee();
%    % show the identifier of the first grantee
%    grantee.Identifier
%

% Copyright 2019 The MathWorks, Inc.

    granteeJ = obj.Handle.getGrantee();

    if isa(granteeJ, 'com.amazonaws.services.s3.model.CanonicalGrantee')
        grantee = aws.s3.CanonicalGrantee(char(granteeJ.getIdentifier));
    elseif (isa(granteeJ, 'com.amazonaws.services.s3.model.EmailAddressGrantee'))
        grantee = aws.s3.EmailAddressGrantee(char(granteeJ.getIdentifier));
    elseif (isa(granteeJ, 'com.amazonaws.services.s3.model.GroupGrantee'))
        % in thsi case the identifer is the URI http://acs.amazonaws.com/groups/global/AllUsers
        % to construct the grantee use the nam which is Allusers as per the
        % enum
        grantee = aws.s3.GroupGrantee(char(granteeJ.name));
    else
        logObj = Logger.getLogger();
        write(logObj,'error',['Invalid grantee class: ',class(granteeJ)]);
    end
end
