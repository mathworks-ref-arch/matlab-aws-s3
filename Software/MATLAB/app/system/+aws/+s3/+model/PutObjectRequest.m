classdef PutObjectRequest < aws.Object
    % PUTOBJECTREQUEST Uploads a new object to the specified Amazon S3 bucket
    %
    % Example
    %   putObjectRequest = aws.s3.model.PutObjectRequest(bucketName, keyName, filePath);

   
    % Copyright 2023 The MathWorks, Inc.

    methods
        function obj = PutObjectRequest(varargin)
            if nargin == 1 && isa(varargin{1}, 'com.amazonaws.services.s3.model.PutObjectRequest')
                obj.Handle = varargin{1};
            elseif nargin == 3 && ischar(varargin{1}) && ischar(varargin{2}) && ischar(varargin{3})
                bucketName = varargin{1};
                key = varargin{2};
                file = varargin{3};
                fileJ = java.io.File(file);
                obj.Handle = com.amazonaws.services.s3.model.PutObjectRequest(bucketName, key, fileJ);
            else
                logObj = Logger.getLogger();
                write(logObj,'error', 'Invalid arguments');
            end
        end


        function putObjectRequest = withMetadata(obj, metadata)
            % PUTOBJECTREQUEST Sets the optional metadata instructing Amazon S3 how to handle the uploaded data
            % (e.g. custom user metadata, hooks for specifying content type, etc.).
            % An updated PutObjectRequest is returned.

            if isa(metadata, 'aws.s3.ObjectMetadata')
                putObjectRequest = aws.s3.model.PutObjectRequest(obj.Handle.withMetadata(metadata.Handle));
            else
                logObj = Logger.getLogger();
                write(logObj,'error', 'Invalid arguments');
            end
        end


        function putObjectRequest = withSSECustomerKey(obj, key)
            % WITHSSECUSTOMERKEY Sets the optional customer-provided server-side encryption key to encrypt the object
            % An updated PutObjectRequest is returned.

            if isa(key, 'com.amazonaws.services.s3.model.SSECustomerKey')
                putObjectRequest = aws.s3.model.PutObjectRequest(obj.Handle.withSSECustomerKey(key));
            else
                logObj = Logger.getLogger();
                write(logObj,'error', 'Invalid arguments');
            end
        end


        function putObjectRequest = withSSEAwsKeyManagementParams(obj, params)
            % WITHSSEAWSKEYMANAGEMENTPARAMS Sets the Key Management System parameters used to encrypt the object on server side
            % An updated PutObjectRequest is returned.

            if isa(params, 'com.amazonaws.services.s3.model.SSEAwsKeyManagementParams')
                putObjectRequest = aws.s3.model.PutObjectRequest(obj.Handle.withSSEAwsKeyManagementParams(params));
            else
                logObj = Logger.getLogger();
                write(logObj,'error', 'Invalid arguments');
            end
        end
    end
end