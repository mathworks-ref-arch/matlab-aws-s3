classdef Grant < aws.Object
    % GRANT Specifies a grant, consisting of one grantee and one permission
    % A Grant object can be created using either a grantee and a permission or
    % using a Java Grant object. If using a grantee and permission they may be
    % either Java com.amazonaws.services.s3.model.<Grantee Type> or MATLAB
    % aws.s3.<Grantee Type>. CanonicalGrantee, EmailAddressGrantee and
    % GroupGrantee types are supported.
    %
    % Examples:
    %    myGrant = aws.s3.Grant(myGrantee, myPermission);
    %    % or
    %    myGrant = aws.s3.Grant(myJavaGranteeObject);
    %

    % Copyright 2019 The MathWorks, Inc.

methods
    function obj = Grant(varargin)
        import com.amazonaws.services.s3.model.Grant;
        import com.amazonaws.services.s3.model.Grantee;
        import com.amazonaws.services.s3.model.Permission;

        logObj = Logger.getLogger();

        if nargin == 2
            grantee = varargin{1};
            permission = varargin{2};

            if     isa(grantee, com.amazonaws.services.s3.model.CanonicalGrantee) ...
                || isa(grantee, com.amazonaws.services.s3.model.EmailAddressGrantee) ...
                || isa(grantee, com.amazonaws.services.s3.model.GroupGrantee)
                granteeJ = grantee;
            elseif isa(grantee, aws.s3.CanonicalGrantee) ...
                || isa(grantee, aws.s3.EmailAddressGrantee) ...
                || isa(grantee, aws.s3.GroupGrantee)
                granteeJ = grantee.Handle;
            else
                write(logObj,'error',['Invalid grantee class: ',class(grantee)]);
            end

            if isa(permission, com.amazonaws.services.s3.model.Permission)
                permissionJ = permission;
            elseif isa(permission, aws.s3.Permission)
                permissionJ = permission.Handle;
            else
                write(logObj,'error',['Invalid permission class: ',class(permission)]);
            end

            obj.Handle = Grant(granteeJ, permissionJ);

        elseif nargin == 1
            grantJ = varargin{1};

            if isa(grantJ, 'com.amazonaws.services.s3.model.Grant')
                obj.Handle = grantJ;
            else
                write(logObj,'error',['Invalid grant class: ',class(grantJ)]);
            end
        else
            write(logObj,'error','Invalid number of arguments');
        end


    end %function
end %methods
end %class
