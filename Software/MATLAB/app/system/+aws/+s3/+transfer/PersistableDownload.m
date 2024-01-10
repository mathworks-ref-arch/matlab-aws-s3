classdef PersistableDownload < aws.s3.transfer.PersistableTransfer
    % PERSISTABLEDOWNLOAD An opaque token that holds some private state and can be used to resume a paused download operation

    % Copyright 2023 The MathWorks, Inc.

    methods
        function obj = PersistableDownload(varargin)
            if nargin == 1
                if isa(varargin{1}, 'com.amazonaws.services.s3.transfer.PersistableDownload')
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
    end
end
