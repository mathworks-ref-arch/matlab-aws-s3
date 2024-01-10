classdef PresignedUrlDownload < aws.s3.transfer.AbortableTransfer
    % PRESIGNEDURLDOWNLOAD Represent the output for the asynchronous download operation using presigned url

    % Copyright 2023 The MathWorks, Inc.

    methods
        function obj = PresignedUrlDownload(varargin)
        end

        function url = getPresignedUrl(obj)
            % GETPRESIGNEDURL The presigned url from which the object is being downloaded
            urlJ = char(obj.Handle.getBucketName());
            url = matlab.net.URL(char(urlJ.toString()));
        end
    end
end