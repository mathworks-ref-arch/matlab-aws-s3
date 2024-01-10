classdef TransferManagerBuilder < aws.Object
    % TransferManagerBuilder Use of the builder is preferred over constructors for TransferManager
    %
    % Example:
    %   tmb = aws.s3.transfer.TransferManagerBuilder();
    %   tmb.setS3Client(testCase.s3);
    %   tm = tmb.build();
    
    % Copyright 2023 The MathWorks, Inc.

    methods
        function obj = TransferManagerBuilder(varargin)
            if nargin == 1
                if isa(varargin{1}, 'com.amazonaws.services.s3.transfer.TransferManagerBuilder')
                    obj.Handle = varargin{1};
                else
                    logObj = Logger.getLogger();
                    write(logObj,'error','Invalid argument type');
                end
            elseif nargin == 0
                obj.Handle = com.amazonaws.services.s3.transfer.TransferManagerBuilder.standard();
            else
                logObj = Logger.getLogger();
                write(logObj,'error','Invalid number of arguments');
            end
        end


        function transferManager = build(obj)
            % BUILD Construct a TransferManager with the default ExecutorService
            transferManager = aws.s3.transfer.TransferManager(obj.Handle.build());
        end


        function obj = disableParallelDownloads(obj)
            % disableParallelDownloads Disables parallel downloads
            % See setDisableParallelDownloads
            obj = obj.obj.Handle.disableParallelDownloads();
        end


        function tf = getAlwaysCalculateMultipartMd5(obj)
            % GETALWAYSCALCULATEMULTIPARTMD5 Returns true if Transfer Manager should calculate MD5 for multipart uploads
            tf = obj.Handle.getAlwaysCalculateMultipartMd5();
        end


        function threshold = getMultipartUploadThreshold(obj)
            % GETMULTIPARTUPLOADTHRESHOLD The multipart upload threshold currently configured in the builder
            threshold = aws.s3.mathworks.internal.int64FnHandler(obj);
        end


        function threshold = getMultipartCopyThreshold(obj)
            % GETMULTIPARTCOPYTHRESHOLD The multipart copy threshold currently configured in the builder
            threshold = aws.s3.mathworks.internal.int64FnHandler(obj);
        end


        function tf = isDisableParallelDownloads(obj)
            % ISDISABLEPARALLELDOWNLOADS Returns if the parallel downloads are disabled or not
            tf = obj.Handle.isDisableParallelDownloads().booleanValue;
        end


        function tf = isShutDownThreadPools(obj)
            % ISSHUTDOWNTHREADPOOLS Returns a logical
            tf = obj.Handle.isShutDownThreadPools().booleanValue;
        end


        function setAlwaysCalculateMultipartMd5(obj, alwaysCalculateMultipartMd5)
            % SETALWAYSCALCULATEMULTIPARTMD5 Set to true if Transfer Manager should calculate MD5 for multipart uploads
            if islogical(alwaysCalculateMultipartMd5)
                obj.Handle.setAlwaysCalculateMultipartMd5(alwaysCalculateMultipartMd5);
            else
                logObj = Logger.getLogger();
                write(logObj,'error','Expected alwaysCalculateMultipartMd5 to be of type logical');
            end
        end


        function setDisableParallelDownloads(obj, disableParallelDownloads)
            % setDisableParallelDownloads Sets the option to disable parallel downloads
            if islogical(disableParallelDownloads)
                obj.Handle.setDisableParallelDownloads(java.lang.Boolean(disableParallelDownloads));
            else
                logObj = Logger.getLogger();
                write(logObj,'error','Expected disableParallelDownloads to be of type logical');
            end
        end


        function setS3Client(obj, s3Client)
            % SETS3CLIENT Sets the low level client used to make the service calls to Amazon S3.

            if isa(s3Client, 'aws.s3.Client')
                obj.Handle.setS3Client(s3Client.Handle);
            elseif isa(s3Client, 'com.aws.s3.Client')
                obj.Handle.setS3Client(s3Client);
            else
                logObj = Logger.getLogger();
                write(logObj,'error','Expected s3Client to be of type aws.s3.Client or com.aws.s3.Client');
            end
        end


        function setShutDownThreadPools(shutDownThreadPools)
            % SETSHUTDOWNTHREADPOOLS By default, when the transfer manager is shut down, the underlying ExecutorService is also shut down
            if islogical(shutDownThreadPools)
                obj.Handle.shutDownThreadPools(java.lang.Boolean(shutDownThreadPools));
            else
                logObj = Logger.getLogger();
                write(logObj,'error','Expected disableParallelDownloads to be of type logical');
            end
        end


        function tmb = withS3Client(obj, s3Client)
            % WITHS3CLIENT Sets the low level client used to make the service calls to Amazon S3

            if isa(s3Client, 'aws.s3.Client')
                tmb = aws.s3.transfer.TransferManagerBuilder(obj.Handle.withS3Client(s3Client.Handle));
            elseif isa(s3Client, 'com.aws.s3.Client') || isa(s3Client, 'com.amazonaws.services.s3.AmazonS3Client')
                tmb = aws.s3.transfer.TransferManagerBuilder(obj.Handle.withS3Client(s3Client));
            else
                logObj = Logger.getLogger();
                write(logObj,'error','Expected s3Client to be of type aws.s3.Client or com.aws.s3.Client');
            end
        end

    end


    methods (Static)
        function transferManager = defaultTransferManager(obj)
            % defaultTransferManager Construct a default TransferManager
            transferManager = aws.s3.transfer.TransferManager(obj.Handle.defaultTransferManager());
        end

        function transferManager = standard(obj)
            % STANDARD Create new instance of builder with all defaults set
            transferManager = aws.s3.transfer.TransferManager(obj.Handle.standard());
        end
    end
end
