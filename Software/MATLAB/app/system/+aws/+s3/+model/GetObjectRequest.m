classdef GetObjectRequest < aws.Object
    % GETOBJECTREQUEST Retrieves objects from Amazon S3
    % To use GET, you must have READ access to the object.
    %
    % Example:
    %   getObjectRequest = aws.s3.model.GetObjectRequest(bucketName,keyName);


    % Copyright 2023 The MathWorks, Inc.

    methods
        function obj = GetObjectRequest(varargin)
            if nargin == 1 && isa(varargin{1}, 'com.amazonaws.services.s3.model.GetObjectRequest')
                obj.Handle = varargin{1};
            elseif nargin == 2  && ischar(varargin{1}) && ischar(varargin{2})
                bucketName = varargin{1};
                key = varargin{2};
                obj.Handle = com.amazonaws.services.s3.model.GetObjectRequest(bucketName, key);
            else
                logObj = Logger.getLogger();
                write(logObj,'error', 'Invalid arguments');
            end
        end

        function getObjectRequest = withSSECustomerKey(obj, sseKey)
            % WITHSSECUSTOMERKEY Sets the optional customer-provided server-side encryption key to use to decrypt this object
            % Returns the updated GetObjectRequest.

            if isa(sseKey, 'com.amazonaws.services.s3.model.SSECustomerKey')
                getObjectRequest = aws.s3.model.GetObjectRequest(obj.Handle.withSSECustomerKey(sseKey));
            else
                logObj = Logger.getLogger();
                write(logObj,'error', 'Invalid arguments');
            end
        end
    end
end

