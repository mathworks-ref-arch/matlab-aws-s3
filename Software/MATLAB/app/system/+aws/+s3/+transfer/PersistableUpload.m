classdef PersistableUpload < aws.s3.transfer.PersistableTransfer
    % PERSISTABLEUPLOAD An opaque token that holds some private state and can be used to resume a paused download operation

    % Copyright 2023 The MathWorks, Inc.

    methods
        function obj = PersistableUpload(varargin)
            if nargin == 1
                if isa(varargin{1}, 'com.amazonaws.services.s3.transfer.PersistableUpload')
                    obj.Handle = varargin{1};
                else
                    logObj = Logger.getLogger();
                    write(logObj,'error','Invalid argument type');
                end
            elseif (nargin == 6)
                % TODO add type checking
                bucketName = varargin(1); % string
                key = varargin(2); % string
                file = varargin(3); % string
                multipartUploadId = varargin(4) % int64
                partSize = varargin(5) % int64
                mutlipartUploadThreshold = varargin(6); % int64
                obj.Handle = com.amazonaws.services.s3.transfer.PersistableUpload(bucketName, key, file, multipartUploadId, partSize, mutlipartUploadThreshold);
            else
                logObj = Logger.getLogger();
                write(logObj,'error','Invalid number of arguments');
            end
        end
    end
end
