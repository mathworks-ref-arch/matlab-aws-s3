classdef Transfer  < aws.Object
    %TRANSFER Represents an asynchronous upload to or download from Amazon S3
    % Use this class to check a transfer's progress,
    % add listeners for progress events, check the state of a transfer,
    % or wait for the transfer to complete.

    % Copyright 2023 The MathWorks, Inc.
    
    properties
    end
    
    methods

        function description = getDescription(obj)
            % GETDESCRIPTION Returns a human-readable description of this transfer
            description = char(obj.Handle.getDescription());
        end


        function transferProgress = getProgress(obj)
            % GETPROGRESS Returns progress information about this transfer
            transferProgress = aws.s3.transfer.TransferProgress(obj.Handle.getProgress());
        end


        function transferState = getState(obj)
            % GETSTATE Returns the current state of this transfer
            state = char(obj.Handle.getState.toString());
            transferState = aws.s3.transfer.TransferState(state);
        end


        function tf = isDone(obj)
            % ISDONE Returns whether or not the transfer is finished
            % (i.e. completed successfully, failed, or was canceled)
            % A logical is returned.
            tf = obj.Handle.isDone();
        end


        function waitForCompletion(obj)
            % WAITFORCOMPLETION Waits for this transfer to complete
            obj.Handle.waitForCompletion();
        end
    end
end

