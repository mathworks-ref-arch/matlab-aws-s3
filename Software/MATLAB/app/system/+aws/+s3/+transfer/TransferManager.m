classdef TransferManager < aws.Object
    % TransferManager High level utility for managing transfers to Amazon S3
    %
    % Examples:
    %   % Create a TransferManager object
    %   tmb = aws.s3.transfer.TransferManagerBuilder();
    %   tmb.setS3Client(s3);
    %   tm = tmb.build();
    %
    %   % Download an object to a local file
    %   download = tm.download(bucketName, keyName, localPath);
    %   download.waitForCompletion();
    %
    %   % Abort previous in-flight uploads to a given bucket
    %   tm.abortMultipartUploads(bucketName, datetime('now'));
    %
    %   % Copy an object to another object
    %   copy = tm.copy(sourceBucketName, sourceKeyName, destinationBucketName, destinationKeyName);
    %   copyResult = copy.waitForCopyResult();
    %
    %   % Aborts any multipart uploads that were initiated before the specified date
    %   tm.abortMultipartUploads(bucketName, datetime('now'));
    %
    %   % Downloads all objects in the virtual directory designated by the given keyPrefix to the destination directory
    %   multipleFileDownload = tm.downloadDirectory(testCase.bucketName, virtualDirectoryKeyPrefix, tDownloadDir);
    %   multipleFileDownload.waitForCompletion();
    %
    %   % Uploads all files in the directory to a named bucket
    %   multipleFileUpload = tm.uploadDirectory(bucketName, virtualDirectoryKeyPrefix, directory, includeSubdirectories);
    %   multipleFileUpload.waitForCompletion();
    %
    %   % Upload a file to a local S3 object
    %   upload = tm.upload(bucketName, keyName, localPath);
    %   result = upload.waitForUploadResult();
    %
    %   % Shut down a TransferManger when transfers have completed
    %   % shutDownS3Client, a logical whether to shut down the underlying Amazon S3 client.
    %   tm.shutdownNow(shutDownS3Client)

    % Copyright 2023 The MathWorks, Inc.

    methods
        function obj = TransferManager(varargin)
            if nargin == 1
                if isa(varargin{1}, 'com.amazonaws.services.s3.transfer.TransferManager')
                    obj.Handle = varargin{1};
                else
                    logObj = Logger.getLogger();
                    write(logObj,'error','Invalid argument type');
                end
            elseif nargin == 0
                obj.Handle = com.amazonaws.services.s3.transfer.TransferManagerBuilder.defaultTransferManager();
            else
                logObj = Logger.getLogger();
                write(logObj,'error','Invalid number of arguments');
            end
        end


        function delete(obj)
            % Call shutdownNow on the TransferManager without shutting down the S3 client
            obj.shutdownNow(false);
        end


        function abortMultipartUploads(obj, bucketName, date)
            % ABORTMULTIPARTUPLOADS Aborts any multipart uploads that were initiated before the specified date
            % Uploaded parts from an interrupted upload may not always be automatically cleaned up
            % abortMultipartUploads(datetime) can be used to clean up any upload parts.
            %
            % Example:
            %   tmb = aws.s3.transfer.TransferManagerBuilder();
            %   tmb.setS3Client(testCase.s3);
            %   tm = tmb.build();
            %   tm.abortMultipartUploads(testCase.bucketName, datetime('now'));
            
            dateJ = java.util.Date(int64(posixtime(date)));
            obj.Handle.abortMultipartUploads(bucketName, dateJ);
        end


        function copy = copy(obj, sourceBucketName, sourceKey, destinationBucketName, destinationKey)
            % COPY Schedules a new transfer to copy data from one Amazon S3 location to another Amazon S3 location
            %
            % Example:
            %   copy = tm.copy(sourceBucketName, sourceKeyName, destinationBucketName, destinationKeyName);
            %   copyResult = copy.waitForCopyResult();

            copyJ = obj.Handle.copy(sourceBucketName, sourceKey, destinationBucketName, destinationKey);
            copy = aws.s3.transfer.Copy(copyJ);
        end


        function download = download(obj, varargin)
            % DOWNLOAD Schedules a new transfer to download data from Amazon S3 and save it to the specified file
            %
            % Example:
            %   download = tm.download(bucketName, keyName, localPath);
            %   download.waitForCompletion();
            %
            %   % Download can also be called using a aws.s3.model.GetObjectRequest
            %   download = tm.download(getObjectRequest, localPath);
            %   download.waitForCompletion();

            if nargin == 4 && ischar(varargin{1}) && ischar(varargin{2}) && ischar(varargin{3})
                bucket = varargin{1};
                key = varargin{2};
                file = varargin{3};
                fileJ = java.io.File(file);
                downloadJ = obj.Handle.download(bucket, key, fileJ);
            elseif nargin == 3 && isa(varargin{1}, 'aws.s3.model.GetObjectRequest') && ischar(varargin{2})
                getObjectRequest = varargin{1};
                file = varargin{2};
                fileJ = java.io.File(file);
                downloadJ = obj.Handle.download(getObjectRequest.Handle, fileJ);
            else
                logObj = Logger.getLogger();
                write(logObj,'error','Invalid arguments');
            end
            download = aws.s3.transfer.Download(downloadJ);
        end


        function multipleFileDownload = downloadDirectory(obj, bucketName, keyPrefix, destinationDirectory)
            % DOWNLOADDIRECTORY Downloads all objects in the virtual directory designated by the given keyPrefix to the destination directory
            % All virtual subdirectories will be downloaded recursively.
            % An aws.s3.transfer.MultipleFileDownload is returned.
            %
            % Example:
            %   multipleFileDownload = tm.downloadDirectory(testCase.bucketName, virtualDirectoryKeyPrefix, tDownloadDir);
            %   multipleFileDownload.waitForCompletion();

            fileJ = java.io.File(destinationDirectory);
            multipleFileDownloadJ = obj.Handle.downloadDirectory(bucketName, keyPrefix, fileJ);
            multipleFileDownload = aws.s3.transfer.MultipleFileDownload(multipleFileDownloadJ);
        end


        function multipleFileUpload = uploadDirectory(obj, bucketName, virtualDirectoryKeyPrefix, directory, includeSubdirectories)
            % UPLOADDIRECTORY Uploads all files in the directory to a named bucket
            % Optionally recursing for all subdirectories
            % S3 will overwrite any existing objects that happen to have the same key,
            % just as when uploading individual files.
            %
            % bucketName should be of type char or a scalar string.
            % virtualDirectoryKeyPrefix should be of type char or a scalar string.
            % directory should be of type char or a scalar string.
            % includeSubdirectories should be of type logical.
            % An aws.s3.transfer.MultipleFileUpload is returned.
            %
            % Example:
            %    multipleFileUpload = tm.uploadDirectory(bucketName, virtualDirectoryKeyPrefix, directory, includeSubdirectories);
            %    multipleFileUpload.waitForCompletion();
            
            if ~(ischar(directory) || isStringScalar(directory))
                logObj = Logger.getLogger();
                write(logObj,'error','Expected directory to be of type char or a scalar string');
            end

            if ~(ischar(virtualDirectoryKeyPrefix) || isStringScalar(virtualDirectoryKeyPrefix))
                logObj = Logger.getLogger();
                write(logObj,'error','Expected virtualDirectoryKeyPrefix to be of type char or a scalar string');
            end

            if ~(ischar(bucketName) || isStringScalar(bucketName))
                logObj = Logger.getLogger();
                write(logObj,'error','Expected bucketName to be of type char or a scalar string');
            end

            if ~(islogical(includeSubdirectories))
                logObj = Logger.getLogger();
                write(logObj,'error','Expected includeSubdirectories to be of type logical');
            end

            fileJ = java.io.File(directory);
            multipleFileUploadJ = obj.Handle.uploadDirectory(bucketName, virtualDirectoryKeyPrefix, fileJ, includeSubdirectories);
            multipleFileUpload = aws.s3.transfer.MultipleFileUpload(multipleFileUploadJ);
        end


        function multipleFileUpload = uploadFileList(obj, bucketName, virtualDirectoryKeyPrefix, directory, files)
            % UPLOADFILELIST Uploads all specified files to the named bucket named
            % constructing relative keys depending on the commonParentDirectory given
            % S3 will overwrite any existing objects that happen to have the same key,
            % just as when uploading individual files, so use with caution.
            %
            % Note:
            %   There appears to be an issue with the underlying AWS function
            %   pending further investigation see the alternative upload methods.
            %
            % bucketName - The name of the bucket to upload objects to.
            % bucketName should be of type char or a scalar string.
            %
            % virtualDirectoryKeyPrefix - The key prefix of the virtual directory to
            % upload to. Use an empty string to upload files to the root of the bucket.
            % virtualDirectoryKeyPrefix should be of type char or a scalar string.
            %
            % directory - The common parent directory of files to upload.
            % The keys of the files in the list of files are constructed relative to
            % this directory and the virtualDirectoryKeyPrefix.
            % directory should be of type char or a scalar string.
            %
            % files - A list of files to upload. The keys of the files are calculated
            % relative to the common parent directory and the virtualDirectoryKeyPrefix.
            % Files should be of type string or string array.
            %
            % An aws.s3.transfer.MultipleFileUpload is returned.

            if ~(ischar(directory) || isStringScalar(directory))
                logObj = Logger.getLogger();
                write(logObj,'error','Expected directory to be of type char or a scalar string');
            end

            if ~(ischar(virtualDirectoryKeyPrefix) || isStringScalar(virtualDirectoryKeyPrefix))
                logObj = Logger.getLogger();
                write(logObj,'error','Expected virtualDirectoryKeyPrefix to be of type char or a scalar string');
            end

            if ~(ischar(bucketName) || isStringScalar(bucketName))
                logObj = Logger.getLogger();
                write(logObj,'error','Expected bucketName to be of type char or a scalar string');
            end

            if ~(isstring(files))
                logObj = Logger.getLogger();
                write(logObj,'error','Expected files to be of type string');
            end

            directoryJ = java.io.File(directory);
            % Assume 1D list
            fileArrayJ = javaArray('java.io.File',numel(files));
            for n = 1:numel(files)
                fileArrayJ(n) = java.io.File(files(n));
            end
            filesListJ = java.util.Arrays.asList(fileArrayJ);
            multipleFileUploadJ = obj.Handle.uploadFileList(bucketName, virtualDirectoryKeyPrefix, directoryJ, filesListJ);
            multipleFileUpload = aws.s3.transfer.MultipleFileUpload(multipleFileUploadJ);
        end


        function upload = upload(obj, varargin)
            % UPLOAD Initiates and upload and returns an aws.s3.transfer.Upload object
            %
            % Example:
            %   upload = tm.upload(bucketName, keyName, localPath);
            %   result = upload.waitForUploadResult();

            if nargin == 4 && ischar(varargin{1}) && ischar(varargin{2}) && ischar(varargin{3})
                bucket = varargin{1};
                key = varargin{2};
                file = varargin{3};
                if exist(file, 'file') == 2
                    uploadJ = obj.Handle.upload(bucket, key, java.io.File(file));
                    upload = aws.s3.transfer.Upload(uploadJ);
                else
                    logObj = Logger.getLogger();
                    write(logObj,'error',['File not found: ', char(file)]);
                end
            elseif nargin == 2 && isa(varargin{1}, 'aws.s3.model.PutObjectRequest')
                putObjectRequest = varargin{1};
                uploadJ = obj.Handle.upload(putObjectRequest.Handle);
                upload = aws.s3.transfer.Upload(uploadJ);
            else
                logObj = Logger.getLogger();
                write(logObj,'error','Invalid arguments');
            end
        end


        function shutdownNow(obj, shutDownS3Client)
            % SHUTDOWNNOW Forcefully shuts down this TransferManager instance
            % Currently executing transfers will not be allowed to finish.
            % Callers should use this method when they either:
            % * have already verified that their transfers have completed by checking each transfer's state
            % * need to exit quickly and don't mind stopping transfers before they complete. 
            % Callers should also remember that uploaded parts from an interrupted upload
            % may not always be automatically cleaned up, but callers can use
            % abortMultipartUploads(datetime) to clean up any upload parts.
            % shutDownS3Client, Logical whether to shut down the underlying Amazon S3 client.

            obj.Handle.shutdownNow(shutDownS3Client);
        end


        %% Disabled pending further pause exception related functionality
        % function upload = resumeUpload(obj, persistableUpload)
        %     % RESUMEUPLOAD Resumes an upload operation
        %     % This upload operation uses the same configuration TransferManagerConfiguration
        %     % as the original upload. Any data already uploaded will be skipped, and only
        %     % the remaining will be uploaded to Amazon S3.
        %
        %     upload = aws.s3.Transfer.PersistableUpload(obj.Handle.resumeUpload(persistableUpload.Handle));
        % end


        % function download = resumeDownload(obj, persistableDownload)
        %     % RESUMEDOWNLOAD Resumes an download operation
        %     % This download operation uses the same configuration as the original download.
        %     % Any data already fetched will be skipped, and only the remaining
        %     % data is retrieved from Amazon S3.
        %
        %     download = aws.s3.Transfer.PersistableDownload(obj.Handle.resumeDownload(persistableDownload.Handle));
        % end
    end
end
