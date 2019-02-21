classdef Permission < aws.Object
    % Class to define a Permission object for S3 Access Control Lists
    % The permission can take one of five enumeration values reflecting various
    % rights.
    %
    % Grant permission permitted values are documented as:
    % 	READ, WRITE, READ_ACP, WRITE_ACP and FULL_CONTROL
    % However the Java SDK enum values are:
    %   Read, Write, ReadAcp, WriteAcp and FullControl
    % As this is can easily lead to errors this constructor will accept either
    % and is case insensitive
    %
    % Thus these mixed case names are used as the calling convention. Inputs
    % are converted to upper case prior to evaluation to reduce typo errors.
    % Underscores are not allowed for.
    %
    % The following sets my_perm to READ and uses it to create an ACL.
    % A grantee is also required, in this case based on an email address.
    %
    %   s3 = aws.s3.Client();
    %   s3.initialize();
    %   my_perm = aws.s3.Permission('READ');
    %   email_addr_grantee = aws.s3.EmailAddressGrantee('joe.blog@example.com');
    %   my_acl.grantPermission(email_addr_grantee, my_perm);
    %
    % When granted on a bucket ACL permissions correspond to the following
    % S3 Access Policy permissions apply as per S3 documentation:
    %
    %	READ : Allows grantee to list the objects in the bucket.
    %
    %	WRITE : Allows grantee to create, overwrite, and delete any object in
    %           the bucket.
    %
    %	READ_ACP : Allows grantee to read the bucket ACL.
    %
    %	WRITE_ACP : Allows grantee to write the ACL for the applicable bucket.
    %
    %	FULL_CONTROL : Allows grantee the READ, WRITE, READ_ACP, and WRITE_ACP
    %                  permissions on the bucket. It is equivalent to granting
    %                  READ, WRITE, READ_ACP, and WRITE_ACP ACL permissions.
    %
    %
    % When granted on an object ACL permissions correspond to the following
    % S3 Access Policy permissions apply as per s3 documentation:
    %
    %	READ : Allows grantee to read the object data and its metadata.
    %
    %	WRITE : Not applicable.
    %
    %	READ_ACP : Allows grantee to read the object ACL
    %
    %	WRITE_ACP : Allows grantee to write the ACL for the applicable object.
    %
    %	FULL_CONTROL : Is equivalent to granting READ, READ_ACP, and WRITE_ACP
    %                  ACL permissions. Allows grantee the READ, READ_ACP, and
    %                  WRITE_ACP permissions on the object.
    %

    % Copyright 2017 The MathWorks, Inc.

    properties (SetAccess = immutable)
        stringValue;
    end

    methods
        function obj = Permission(permval)
            import com.amazonaws.services.s3.model.Permission

            logObj = Logger.getLogger();
            % convert to upper to mask simple case errors
            permval = upper(permval);

            write(logObj,'debug',['Creating permission: ',permval]);
            switch (permval)
                case 'READ'
                    obj.Handle = Permission.Read;
                case 'WRITE'
                    obj.Handle = Permission.Write;
                case {'READACP', 'READ_ACP'}
                    obj.Handle = Permission.ReadAcp;
                case {'WRITEACP', 'WRITE_ACP'}
                    obj.Handle = Permission.WriteAcp;
                case {'FULLCONTROL', 'FULL_CONTROL'}
                    obj.Handle = Permission.FullControl;
                otherwise
                    errStr = sprintf('Invalid permission enumeration value: %s, Permitted values are: READ, WRITE, READACP/READ_ACP, WRITEACP/WRITE_ACP, FULLCONTROL/FULL_CONTROL (case insensitive)',permval);
                    write(logObj,'error',errStr);
            end
            % store the toString() value but as a char array
            obj.stringValue = char(obj.Handle.toString());
        end %function

    end %methods
end %class
