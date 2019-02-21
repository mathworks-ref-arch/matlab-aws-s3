classdef GroupGrantee < aws.Object
    % GROUPGRANTEE Defines group based grantee, returns Java GroupGrantee object
    % Permitted values are: AllUsers, AuthenticatedUsers, Logdelivery
    %
    % Here it is used to grant a permission to an ACL along with a permission:
    %
    % Example:
    %   my_group_grantee = aws.s3.GroupGrantee('AllUsers');
    %   my_perm = aws.s3.Permission('read');
    %   my_acl = aws.s3.AccessControlList();
    %   my_acl.grantPermission(my_group_grantee, my_perm);
    %
    % In practice values map to URLs that define them, e.g.
    % AllUsers maps to http://acs.amazonaws.com/groups/global/AllUsers

    % Copyright 2017 The MathWorks, Inc.

    properties (SetAccess = immutable)
        Identifier;
    end

    methods
        function obj = GroupGrantee(groupval)
            import com.amazonaws.services.s3.model.GroupGrantee;

            logObj = Logger.getLogger();
            % convert to upper to mask simple case errors
            groupval = upper(groupval);

            write(logObj,'verbose',['Setting GroupGrantee ',groupval]);
            switch (groupval)
                case 'ALLUSERS'
                    obj.Handle = GroupGrantee.AllUsers;
                case 'AUTHENTICATEDUSERS'
                    obj.Handle = GroupGrantee.AuthenticatedUsers;
                case 'LOGDELIVERY'
                    obj.Handle = GroupGrantee.LogDelivery;
                otherwise
                    write(logObj,'error',['Invalid GroupGrantee enumeration value: ',groupval,' Permitted values are: AllUsers, AuthenticatedUsers, Logdelivery (case insensitive)']);
            end
            obj.Identifier = char(obj.Handle.getIdentifier());
        end %function
    end %methods
end %class
