classdef CanonicalGrantee < aws.Object
    % CANONICALGRANTEE defines a Canonical identifier address based grantee
    % Returns a Java CanonicalGrantee object for S3 ACLs.
    % It creates a canonical identifier string based object that can be used
    % when creating Access Control Lists.
    %
    % Here it is used to grant a permission to an ACL along with a permission
    % assuming an existing aws.s3 object
    %
    % Example:
    %   canonicalgrantee = aws.s3.CanonicalGrantee('d25639fbe9c19cd30a4c0f43fbf00e2d3f96400a9aa8dabfbbebe1906Example');
    %   my_perm = aws.s3.Permission('read');
    %   my_acl = aws.s3.AccessControlList();
    %	my_acl.grantPermission(canonicalgrantee, my_perm);
    %

    % Copyright 2017 The MathWorks, Inc.

    properties (SetAccess = immutable)
        Identifier;
    end

    methods
        function obj = CanonicalGrantee(Id)
            import com.amazonaws.services.s3.model.CanonicalGrantee;

            logObj = Logger.getLogger();
            write(logObj,'verbose','Creating CanonicalGrantee');
            obj.Handle = CanonicalGrantee(string(Id));
            obj.Identifier = char(obj.Handle.getIdentifier());
        end % function
    end

end % class
