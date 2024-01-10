classdef UploadPartResult < aws.Object
    % UploadPartResult Contains the parameters used for the UploadPart operation
    %
    % See: aws.s3.transfer.TransferManager for a high-level alternative.

    % Copyright 2023 The MathWorks, Inc.

    methods
        function obj = UploadPartResult(varargin)
            if nargin == 1
                if isa(varargin{1}, 'com.amazonaws.services.s3.model.UploadPartResult')
                    obj.Handle = varargin{1};
                else
                    logObj = Logger.getLogger();
                    write(logObj,'error','Invalid argument type');
                end
            elseif nargin == 0
                obj.Handle = com.amazonaws.services.s3.model.UploadPartResult();
            else
                logObj = Logger.getLogger();
                write(logObj,'error','Invalid number of arguments');
            end
        end
    end
end
