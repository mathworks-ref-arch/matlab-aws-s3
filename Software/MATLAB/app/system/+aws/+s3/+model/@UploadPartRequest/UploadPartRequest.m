classdef UploadPartRequest < aws.Object
    % UPLOADPARTREQUEST Contains the parameters used for the UploadPart operation
    %
    % See: aws.s3.transfer.TransferManager for a high-level alternative.

    % Copyright 2023 The MathWorks, Inc.

    methods
        function obj = UploadPartRequest()
            obj.Handle = com.amazonaws.services.s3.model.UploadPartRequest();
        end
    end
end
