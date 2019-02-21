classdef AccessControlList < aws.Object
    % ACCESSCONTROLLIST class to define a S3 ACL object
    % The AccessControlList method calls the constructor for the AWS Java SDK
    % ACL object
    %
    % Example:
    %   s3 = aws.s3.Client();
    %   s3.initialize();
    %   my_acl = aws.s3.AccessControlList();
    %   my_perm = aws.s3.Permission('read');
    %   email_addr_grantee = aws.s3.EmailAddressGrantee('joe.blog@example.com');
    %   my_acl.grantPermission(email_addr_grantee, my_perm);
    %

    % Copyright 2017 The MathWorks, Inc.

    methods
        %% Constructor
        function obj =  AccessControlList(varargin)
            import com.amazonaws.services.s3.model.AccessControlList;

            logObj = Logger.getLogger();
            write(logObj,'verbose','Creating AccessControlList');
            obj.Handle = com.amazonaws.services.s3.model.AccessControlList();
        end

    end %methods
end %class
