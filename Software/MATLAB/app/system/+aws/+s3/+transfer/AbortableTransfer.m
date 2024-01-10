classdef AbortableTransfer < aws.s3.transfer.Transfer
    % ABORTABLETRANSFER Represents an asynchronous transfer that can be aborted

    % Copyright 2023 The MathWorks, Inc.

    methods
        function obj = AbortableTransfer()
        end

        function abort(obj)
            obj.Handle.abort();
        end
    end
end