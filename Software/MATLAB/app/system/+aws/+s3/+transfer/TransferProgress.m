classdef TransferProgress < aws.Object
    % TRANSFERPROGRESS Describes the progress of a transfer
    %
    % Example:
    %   tmb = aws.s3.transfer.TransferManagerBuilder();
    %   tmb.setS3Client(testCase.s3);
    %   tm = tmb.build();
    %   multipleFileUpload = tm.uploadDirectory(bucketName, virtualDirectoryKeyPrefix, directory, includeSubdirectories);
    %   tp = multipleFileUpload.getProgress();
    %   a = tp.getBytesTransferred;
    %   b = tp.getPercentTransferred;
    %   c = tp.getTotalBytesToTransfer;
    %
    % See: https://docs.aws.amazon.com/AWSJavaSDK/latest/javadoc/index.html?com/amazonaws/services/s3/AmazonS3.html
    
    % Copyright 2023 The MathWorks, Inc.
    
    properties
    end
    
    methods
        function obj = TransferProgress(varargin)
            if nargin == 1
                if isa(varargin{1}, 'com.amazonaws.services.s3.transfer.TransferProgress')
                    obj.Handle = varargin{1};
                else
                    logObj = Logger.getLogger();
                    write(logObj,'error','Invalid argument type');
                end
            elseif nargin == 0
                obj.Handle = com.amazonaws.services.s3.transfer.TransferProgress();
            else
                logObj = Logger.getLogger();
                write(logObj,'error','Invalid number of arguments');
            end
        end
        

        function bytesTransferred = getBytesTransferred(obj)
            % GETDESCRIPTION Returns the number of bytes completed in the associated transfer
            % An int64 is returned
            bytesTransferred = aws.s3.mathworks.internal.int64FnHandler(obj);
        end


        function percentTransferred = getPercentTransferred(obj)
            % GETPERCENTTRANSFERRED Returns a percentage of the number of bytes transferred out of the total number of bytes to transfer
            % A double is returned
            percentTransferred = obj.Handle.getPercentTransferred();
        end


        function totalBytesToTransfer = getTotalBytesToTransfer(obj)
            % GETTOTALBYTESTOTRANSFER Returns the total size in bytes of the associated transfer, or -1 if the total size isn't known
            % An int64 is returned
            totalBytesToTransfer = aws.s3.mathworks.internal.int64FnHandler(obj);
        end


        % TODO check if the AWS implementation changed
        % function updateProgress(obj, bytes)
        %     % UPDATEPROGRESS Note appears to be partially implemented at the AWS level
        %     if isa(bytes, 'int64')
        %         obj.Handle.updateProgress(bytes);
        %     else
        %         logObj = Logger.getLogger();
        %         write(logObj,'error','Expected bytes to be of type int64');
        %     end
        % end


        function setTotalBytesToTransfer(obj, totalBytesToTransfer)
            % SETTOTALBYTESTOTRANSFER
            if isa(totalBytesToTransfer, 'int64')
                obj.Handle.setTotalBytesToTransfer(totalBytesToTransfer);
            else
                logObj = Logger.getLogger();
                write(logObj,'error','Expected totalBytesToTransfer to be of type int64');
            end
        end
    end
end

