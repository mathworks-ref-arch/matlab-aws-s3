function params = setSSEAwsKeyManagementParams(~, varargin)
% SETSSEAWSKEYMANAGMENTPARAMS Method to set property to request KMS
% This method is used to setup a parameter property that is used with the
% putObject() method to server side encrypt the data at rest.
% If the key ID value is not provided then s3 uses the master default
% key, otherwise a user created key can be requested and used by giving
% the desired key ID.
%
% Example:
%   params = s3.setSSEAwsKeyManagementParams();
%
%   params = s3.setSSEAwsKeyManagementParams('c1234567-cba2-456a-ade9-a1a3f84c9a8a');
%

% Copyright 2017 The MathWorks, Inc.

%% Imports
import com.amazonaws.services.s3.model.SSEAwsKeyManagementParams;

logObj = Logger.getLogger();

% if not set to use the default key ID us the one that is provided
if isempty(varargin)
    write(logObj,'verbose','Using default SSEAwsKeyManagementParam');
    params = SSEAwsKeyManagementParams();
elseif length(varargin) == 1
    % check the type, expecting a char
    if ischar(varargin{1})
        % an argument has been provided first check if it is empty or white
        % space
        if strcmp('',strtrim(varargin{1}))
            % allow for the likely error case that a user calls:
            % params = s3.setSSEAwsKeyManagementParams(''); or similar
            % rather than
            % params = s3.setSSEAwsKeyManagementParams();
            % to use default parameters
            write(logObj,'warning','Using default SSEAwsKeyManagementParam');
            write(logObj,'warning','SSEAwsKeyManagementParam() should be called without white space or an empty argument to use the default master key');
            params = SSEAwsKeyManagementParams();
        else
            % if it looks like a valid argument use it
            write(logObj,'verbose','Using non-default SSEAwsKeyManagementParam');
            params = SSEAwsKeyManagementParams(varargin{1});
        end
    else
        write(logObj,'error','Expected Key ID argument of type char');
    end
else
    write(logObj,'error','Invalid number of arguments');
end

end %function
