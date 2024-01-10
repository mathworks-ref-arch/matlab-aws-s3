classdef CompleteMultipartUploadResult < aws.Object
    % CompleteMultipartUploadResult The CompleteMultipartUploadResult contains all the information about the CompleteMultipartUpload method
    %
    % See: aws.s3.transfer.TransferManager for a high-level alternative.

    % Copyright 2023 The MathWorks, Inc.

    methods
        function obj = CompleteMultipartUploadResult(varargin)

            logObj = Logger.getLogger();
            
            if nargin == 1
                if ~isa(varargin{1}, 'com.amazonaws.services.s3.model.CompleteMultipartUploadResult')
                    write(logObj,'error', 'Expected an argument of type com.amazonaws.services.s3.model.CompleteMultipartUploadResult');
                else
                    obj.Handle = varargin{1};
                end
            else
                write(logObj,'error','Invalid number of arguments');
            end
        end
    end
end