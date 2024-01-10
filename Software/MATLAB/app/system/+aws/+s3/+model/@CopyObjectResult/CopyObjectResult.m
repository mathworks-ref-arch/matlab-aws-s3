classdef CopyObjectResult < aws.Object
    % COPYOBJECTRESULT Contains data returned by copyObject call
    % This result may be ignored if not needed; otherwise, use this result
    % to access information about the new object created from the copyObject
    % call.
    %
    % Example;
    %    s3 = aws.s3.Client();
    %    s3.initialize();
    %    copyObjectResult = s3.copyObject('mysourcebucket','mysourcekey','mydestinationbucket', 'mydestinationkey');

    % Copyright 2022 The MathWorks, Inc.

    methods
        function obj = CopyObjectResult(varargin)

            logObj = Logger.getLogger();

            if nargin == 1
                if ~isa(varargin{1}, 'com.amazonaws.services.s3.model.CopyObjectResult')
                    write(logObj,'error', 'Expected CopyObjectResult of type com.amazonaws.services.s3.model.CopyObjectResult');
                else
                    obj.Handle = varargin{1};
                end
            else
                write(logObj,'error','Invalid number of arguments');
            end
        end %function
    end %methods

end %class