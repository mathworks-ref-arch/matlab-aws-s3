classdef TransferState
    % TRANSFERSTATE Enumeration of the possible transfer states
    %
    % Possible values are:
    %   The transfer was canceled and did not complete successfully
    %   Canceled,
    %   The transfer completed successfully
    %   Completed
    %   The transfer failed
    %   Failed
    %   The transfer is actively uploading or downloading and hasn't finished yet
    %   InProgress
    %   The transfer is waiting for resources to execute and has not started yet
    %   Waiting
    
    % Copyright 2023 The MathWorks, Inc.

    enumeration
        % The transfer was canceled and did not complete successfully
        Canceled
        % The transfer completed successfully
        Completed
        % The transfer failed
        Failed
        % The transfer is actively uploading or downloading and hasn't finished yet
        InProgress
        % The transfer is waiting for resources to execute and has not started yet
        Waiting
    end
 end