classdef Copy < aws.s3.transfer.Transfer
    % CopyRepresents an asynchronous copy request from one Amazon S3 location another
    % See TransferManager for more information about creating transfers.
    % Please note that when copying data between s3 buckets there is no progress
    % updates whilst data is in transit. This means that the 
    % TransferProgress.getBytesTransferred() will not be accurate until the copy
    % is complete.
    %
    % Example:
    %   tmb = aws.s3.transfer.TransferManagerBuilder();
    %   tmb.setS3Client(s3);
    %   tm = tmb.build();
    %   copy = tm.copy(sourceBucketName, sourceKeyName, destinationBucketName, destinationKeyName);
    %   copyResult = copy.waitForCopyResult();

    % Copyright 2023 The MathWorks, Inc.

    methods

        function obj = Copy(varargin)
            if nargin == 1
                if isa(varargin{1}, 'com.amazonaws.services.s3.transfer.Copy') || isa(varargin{1}, 'com.amazonaws.services.s3.transfer.internal.CopyImpl')
                    obj.Handle = varargin{1};
                else
                    logObj = Logger.getLogger();
                    write(logObj,'error','Invalid argument type');
                end
            else
                logObj = Logger.getLogger();
                write(logObj,'error','Invalid number of arguments');
            end
        end


        function copyResult = waitForCopyResult(obj)
            % WAITFORCOPYRESULT Waits for the copy request to complete and returns the result of this request
            copyResult = aws.s3.transfer.model.CopyResult(obj.Handle.waitForCopyResult());
        end
    end
end
