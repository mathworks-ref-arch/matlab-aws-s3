classdef Owner < aws.Object
    % CREATEOWNER Creates an owner object for an ACL
    %
    % Example:
    %   s3 = aws.s3.Client();
    %   s3.initialize();
    %   acl = aws.s3.AccessControlList();
    %   owner = aws.s3.Owner();
    %   owner.setDisplayName('my_disp_name');
    %   owner.setId('1234567890abcdef');
    %

    % Copyright 2017 The MathWorks, Inc.

    properties (SetAccess = protected)
        displayName;
        id;
    end

    methods
        function obj = Owner()
            %% Imports
            import com.amazonaws.services.s3.model.Owner

            logObj = Logger.getLogger();
            write(logObj,'verbose','Creating owner');
            obj.Handle = com.amazonaws.services.s3.model.Owner();
            % initialise these values, in practice they may be set later with
            % set methods
            obj.displayName = char(obj.Handle.getDisplayName());
            obj.id = char(obj.Handle.getId());
        end %function

    end %methods
end %class
