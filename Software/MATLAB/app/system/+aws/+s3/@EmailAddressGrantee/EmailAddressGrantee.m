classdef EmailAddressGrantee < aws.Object
    % Class to define an email address based grantee
    % EMAILADDRESSGRANTEE Method returns a Java EmailAddressGrantee object for S3 ACLs
    % It creates an EmailAddressGrantee object based on an email address
    % string that can be used when creating Access Control Lists.
    %
    % Here it is used to grant a permission to an ACL along with a permission
    % Example:
    %   emailaddrgrantee = aws.s3.EmailAddressGrantee('joe.blog@example.com');
    %   my_perm = s3.Permission('read');
    %   my_acl.grantPermission(emailaddrgrantee, my_perm);
    %

    % Copyright 2017 The MathWorks, Inc.

    properties (SetAccess = immutable)
        Identifier;
    end

    methods
        function obj = EmailAddressGrantee(emailaddr)
            import com.amazonaws.services.s3.model.EmailAddressGrantee

            logObj = Logger.getLogger();
            write(logObj,'verbose',['Setting EmailAddressGrantee ',emailaddr]);
            obj.Handle = EmailAddressGrantee(string(emailaddr));
            obj.Identifier = char(obj.Handle.getIdentifier);
        end %function

    end %methods
end %class
