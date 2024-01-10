classdef PauseStatus < aws.Object
    % PAUSESTATUS The status of a pause operation initiated on a Upload/ Download

    % Copyright 2023 The MathWorks, Inc.

    enumeration
        % pause is not possible while transfer is already in progress AND cancel was requested; so we cancel it
        CANCELLED
        % pause is not yet applicable since transfer has not started AND cancel was requested; so we cancel it
        CANCELLED_BEFORE_START
        % pause is not possible while transfer is already in progress; so no action taken
        NO_EFFECT
        % pause is not yet applicable since transfer has not started; so no action taken
        NOT_STARTED
        % transfer successfully paused (and therefore the return information can be used to resume the transfer later on)
        SUCCESS
    end

    methods
        function obj = PauseStatus(varargin)
            if nargin == 1
                if isa(varargin{1}, 'com.amazonaws.services.s3.transfer.PauseStatus')
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


        function tf = isCancelled(obj)
            % ISCANCELLED Returns true if the transfer is cancelled else false
            tf = obj.Handle.isCancelled();
        end


        function tf = isPaused(obj)
            % ISPAUSED Returns true if the transfer is paused else false
            tf = obj.Handle.isPaused();
        end


        function tf = unchanged(obj)
            % UNCHANGED Returns true if the transfer is not started or the pause operation has no effect on the transfer
            tf = obj.Handle.unchanged();
        end
    end


    methods (Static)
        function value = valueOf(name)
            value = aws.s3.transfer.PauseStatus(com.amazonaws.services.s3.transfer.PauseStatus(name));
        end
    end
end