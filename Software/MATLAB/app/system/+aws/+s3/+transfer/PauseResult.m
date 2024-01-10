classdef PauseResult < aws.Object
    % PAUSERESULT Information that can be used to resume the paused operation; can be null if the pause failed

    % Copyright 2023 The MathWorks, Inc.

    methods
        function obj = PauseResult(varargin)
            if nargin == 1
                if isa(varargin{1}, 'com.amazonaws.services.s3.transfer.PauseResult')
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

        function pauseStatus = getPauseStatus(obj)
            % PAUSESTATUS Returns information about whether the pause was successful or not; and if not why
            pauseStatus = aws.s3.transfer.PauseStatus(obj.Handle.getPauseStatus());
        end

    end
end