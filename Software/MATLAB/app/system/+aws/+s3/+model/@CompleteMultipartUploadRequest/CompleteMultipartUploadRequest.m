classdef CompleteMultipartUploadRequest < aws.Object
    % COMPLETEMULTIPARTUPLOADREQUEST Results of initiating a multipart upload
    %
    %  Contains the results of initiating a multipart upload, particularly
    %  the unique ID of the new multipart upload
    %
    % See: aws.s3.transfer.TransferManager for a high-level alternative.

    % Copyright 2023 The MathWorks, Inc.

    methods
        function obj = CompleteMultipartUploadRequest(varargin)

            logObj = Logger.getLogger();
            
            if nargin == 1
                if ~isa(varargin{1}, 'com.amazonaws.services.s3.model.CompleteMultipartUploadRequest')
                    write(logObj,'error', 'Expected an argument of type com.amazonaws.services.s3.model.CompleteMultipartUploadRequest');
                else
                    obj.Handle = varargin{1};
                end
            else
                write(logObj,'error','Invalid number of arguments');
            end
        end
    end
end