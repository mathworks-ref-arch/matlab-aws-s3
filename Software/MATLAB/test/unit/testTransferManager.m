classdef testTransferManager < matlab.unittest.TestCase
    % TESTTRANSFERMANAGER Unit Test for the Amazon S3 Client using STS Authentication
    %
    % The test suite exercises the basic operations on the S3 Client using
    % the token service (STS). Please note that these tests will succeed if
    % a credential file is provided so if you are not using the STS token
    % then the tests will still pass. The objective of this suite is to
    % ensure that they will work when using STS. Please consult the
    % documentation for more details.

    % Copyright 2023 The MathWorks, Inc.

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Please add test cases below
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties
        logObj
        bucketName
        dstBucketName
        s3
    end

    methods (TestMethodSetup)
        function testSetup(testCase)
            testCase.logObj = Logger.getLogger();

            % Create the client and initialize
            testCase.s3 = aws.s3.Client();
            if strcmpi(getenv('GITLAB_CI'), 'true')
                testCase.s3.useCredentialsProviderChain = false;
            else
                testCase.s3.useCredentialsProviderChain = true;
            end
            testCase.s3.initialize();

            % bucketName = lower(matlab.lang.makeValidName(['com.example.awss3.unittest',datestr(now)],'ReplacementStyle','delete'));
            testCase.bucketName = lower(matlab.lang.makeValidName(['com.example.awss3.unittest','transfermanager'],'ReplacementStyle','delete'));
            if ~testCase.s3.doesBucketExist(testCase.bucketName)
                testCase.s3.createBucket(testCase.bucketName);
            end

            testCase.dstBucketName = lower(matlab.lang.makeValidName(['com.example.awss3.unittest','transfermanager-destination'],'ReplacementStyle','delete'));
            if ~testCase.s3.doesBucketExist(testCase.dstBucketName)
                testCase.s3.createBucket(testCase.dstBucketName);
            end
        end
    end

    methods (TestMethodTeardown)
        function testTearDown(testCase)
            testCase.s3.shutdown();
            % force a short wait so next call to now will always return a
            % new number
            pause(1.1);
        end
    end

    methods (Test)
        function testTransferMangerBuilder(testCase)

            tmb = aws.s3.transfer.TransferManagerBuilder();
            testCase.verifyClass(tmb, 'aws.s3.transfer.TransferManagerBuilder');
            testCase.verifyClass(tmb.Handle, 'com.amazonaws.services.s3.transfer.TransferManagerBuilder');
            tmb = tmb.withS3Client(testCase.s3);

            testCase.verifyClass(tmb.getMultipartCopyThreshold, 'int64');
            testCase.verifyClass(tmb.getMultipartUploadThreshold, 'int64');

            tmb.setAlwaysCalculateMultipartMd5(false);
            testCase.verifyFalse(tmb.getAlwaysCalculateMultipartMd5);
            tmb.setAlwaysCalculateMultipartMd5(true);
            testCase.verifyTrue(tmb.getAlwaysCalculateMultipartMd5);

            tmb.setDisableParallelDownloads(false);
            testCase.verifyFalse(tmb.isDisableParallelDownloads());
            tmb.setDisableParallelDownloads(true);
            testCase.verifyTrue(tmb.isDisableParallelDownloads());

            tm = tmb.build();

            testCase.verifyClass(tm, 'aws.s3.transfer.TransferManager')
            testCase.verifyClass(tm.Handle, 'com.amazonaws.services.s3.transfer.TransferManager')

            localPath = [tempname,'.mat'];
            [~,n,e] = fileparts(localPath);
            x = rand(1000,1000);
            save(localPath, 'x');
            testCase.verifyTrue(isfile(localPath));
            cleanup = onCleanup(@()delete(localPath));
            keyName = [n,e];
            upload = tm.upload(testCase.bucketName, keyName, localPath);
            testCase.verifyClass(upload, 'aws.s3.transfer.Upload');
            testCase.verifyTrue(isa(upload.Handle, 'com.amazonaws.services.s3.transfer.Upload') || ...
                isa(upload.Handle, 'com.amazonaws.services.s3.transfer.internal.UploadImpl'));
            testCase.verifyClass(upload.isDone, 'logical');
            testCase.verifyClass(upload.getDescription, 'char');
            testCase.verifyTrue(startsWith(upload.getDescription, ['Uploading to ', testCase.bucketName, '/', keyName]));

            tp = upload.getProgress();
            testCase.verifyClass(tp, 'aws.s3.transfer.TransferProgress');
            testCase.verifyClass(tp.Handle, 'com.amazonaws.services.s3.transfer.TransferProgress');
            testCase.verifyClass(tp.getBytesTransferred, 'int64');
            testCase.verifyClass(tp.getPercentTransferred, 'double');
            testCase.verifyClass(tp.getTotalBytesToTransfer, 'int64');

            result = upload.waitForUploadResult();
            testCase.verifyClass(result, 'aws.s3.transfer.model.UploadResult');
            testCase.verifyClass(result.Handle, 'com.amazonaws.services.s3.transfer.model.UploadResult');
            testCase.verifyEqual(result.getKey, keyName);
            testCase.verifyEqual(result.getBucketName, testCase.bucketName);
            testCase.verifyClass(result.getETag, 'char');
            testCase.verifyGreaterThan(strlength(result.getETag), 0);
            testCase.verifyClass(result.getVersionId, 'char');

            state = upload.getState();
            testCase.verifyClass(state, 'aws.s3.transfer.TransferState');
            testCase.verifyTrue(isenum(state));
            [~, strs] = enumeration('aws.s3.transfer.TransferState');
            testCase.verifyTrue(contains(char(state), strs))

            testCase.verifyTrue(upload.isDone);
            testCase.verifyEqual(tp.getPercentTransferred, 100);

            % cleanup
            testCase.s3.deleteObject(testCase.bucketName, keyName);
            %s3.deleteBucket(bucketName);
            shutDownS3Client = true;
            tm.shutdownNow(shutDownS3Client);
        end


        function testDownload(testCase)
            tmb = aws.s3.transfer.TransferManagerBuilder();
            tmb.setS3Client(testCase.s3);
            tm = tmb.build();

            localPath = [tempname,'.mat'];
            [~,n,e] = fileparts(localPath);
            x = rand(1000,1000);
            save(localPath, 'x');
            testCase.verifyTrue(isfile(localPath));
            cleanup = onCleanup(@()delete(localPath));
            keyName = [n,e];
            upload = tm.upload(testCase.bucketName, keyName, localPath);
            result = upload.waitForUploadResult(); %#ok<NASGU>
            testCase.verifyTrue(upload.isDone);

            downloadLocalPath = [tempname,'.mat'];
            download = tm.download(testCase.bucketName, keyName, downloadLocalPath);
            cleanup = onCleanup(@()delete(downloadLocalPath));
            testCase.verifyClass(download, 'aws.s3.transfer.Download');
            testCase.verifyTrue(isa(download.Handle, 'com.amazonaws.services.s3.transfer.Download') || isa(download.Handle, 'com.amazonaws.services.s3.transfer.internal.DownloadImpl'));

            testCase.verifyClass(download.isDone, 'logical');
            testCase.verifyClass(download.getDescription, 'char');
            testCase.verifyTrue(startsWith(download.getDescription, ['Downloading from ', testCase.bucketName, '/', keyName]));

            tp = download.getProgress();
            testCase.verifyClass(tp, 'aws.s3.transfer.TransferProgress');
            testCase.verifyClass(tp.Handle, 'com.amazonaws.services.s3.transfer.TransferProgress');
            testCase.verifyClass(tp.getBytesTransferred, 'int64');
            testCase.verifyClass(tp.getPercentTransferred, 'double');
            testCase.verifyClass(tp.getTotalBytesToTransfer, 'int64');

            testCase.verifyEqual(download.getKey, keyName);
            testCase.verifyEqual(download.getBucketName, testCase.bucketName);

            md = download.getObjectMetadata();
            testCase.verifyClass(md.getContentLength, 'int64');
            testCase.verifyClass(md.getSSEAlgorithm, 'char');
            testCase.verifyEqual(md.getSSEAlgorithm, 'AES256');
            testCase.verifyClass(md.getSSEAwsKmsKeyId, 'char');
            testCase.verifyClass(md.getSSECustomerKeyMd5, 'char');
            testCase.verifyClass(md.getSSECustomerAlgorithm, 'char');
            md.addUserMetadata('myMetadataKey', 'myMetadataValue');
            userMd = md.getUserMetadata();
            userMdKeys = keys(userMd);
            userMdValues = values(userMd);
            testCase.verifyEqual(numel(userMdKeys), 1);
            testCase.verifyEqual(userMdKeys{1}, 'myMetadataKey');
            testCase.verifyEqual(userMdValues{1}, 'myMetadataValue');

            state = download.getState();
            testCase.verifyClass(state, 'aws.s3.transfer.TransferState');
            testCase.verifyTrue(isenum(state));
            [~, strs] = enumeration('aws.s3.transfer.TransferState');
            testCase.verifyTrue(contains(char(state), strs))

            download.waitForCompletion();
            testCase.verifyTrue(download.isDone);
            tp = download.getProgress();
            testCase.verifyEqual(tp.getPercentTransferred, 100);

            % cleanup
            testCase.s3.deleteObject(testCase.bucketName, keyName);
            %s3.deleteBucket(bucketName);
            shutDownS3Client = true;
            tm.shutdownNow(shutDownS3Client);
        end



        function testCopy(testCase)
            tmb = aws.s3.transfer.TransferManagerBuilder();
            tmb.setS3Client(testCase.s3);
            tm = tmb.build();

            localPath = [tempname,'.mat'];
            [~,n,e] = fileparts(localPath);
            x = rand(1000,1000);
            save(localPath, 'x');
            testCase.verifyTrue(isfile(localPath));
            cleanup = onCleanup(@()delete(localPath));

            keyName = [n,e];
            upload = tm.upload(testCase.bucketName, keyName, localPath);
            result = upload.waitForUploadResult(); %#ok<NASGU>
            testCase.verifyTrue(upload.isDone);

            keyNameCopy = [n,'_copy',e];
            copy = tm.copy(testCase.bucketName, keyName, testCase.dstBucketName, keyNameCopy);
            testCase.verifyClass(copy, 'aws.s3.transfer.Copy');
            testCase.verifyTrue(isa(copy.Handle, 'com.amazonaws.services.s3.transfer.Copy') || isa(copy.Handle, 'com.amazonaws.services.s3.transfer.internal.CopyImpl'));

            testCase.verifyClass(copy.isDone, 'logical');
            testCase.verifyClass(copy.getDescription, 'char');
            testCase.verifyTrue(startsWith(copy.getDescription, ['Copying object from ', testCase.bucketName, '/', keyName, ' to ' testCase.dstBucketName, '/', keyNameCopy]));

            tp = copy.getProgress();
            testCase.verifyClass(tp, 'aws.s3.transfer.TransferProgress');
            testCase.verifyClass(tp.Handle, 'com.amazonaws.services.s3.transfer.TransferProgress');
            testCase.verifyClass(tp.getBytesTransferred, 'int64');
            testCase.verifyClass(tp.getPercentTransferred, 'double');
            testCase.verifyClass(tp.getTotalBytesToTransfer, 'int64');

            state = copy.getState();
            testCase.verifyClass(state, 'aws.s3.transfer.TransferState');
            testCase.verifyTrue(isenum(state));
            [~, strs] = enumeration('aws.s3.transfer.TransferState');
            testCase.verifyTrue(contains(char(state), strs))

            copyResult = copy.waitForCopyResult();
            testCase.verifyTrue(copy.isDone);
            copy.waitForCompletion();
            testCase.verifyTrue(copy.isDone);
            tp = copy.getProgress();
            testCase.verifyEqual(tp.getPercentTransferred, 100);

            testCase.verifyClass(copyResult, 'aws.s3.transfer.model.CopyResult');
            testCase.verifyClass(copyResult.Handle, 'com.amazonaws.services.s3.transfer.model.CopyResult');
            testCase.verifyEqual(copyResult.getDestinationBucketName, testCase.dstBucketName);
            testCase.verifyEqual(copyResult.getDestinationKey, keyNameCopy);
            testCase.verifyClass(copyResult.getETag, 'char');
            testCase.verifyEqual(copyResult.getSourceKey, keyName);
            testCase.verifyClass(copyResult.getVersionId, 'char');

            % cleanup
            testCase.s3.deleteObject(testCase.bucketName, keyName);
            testCase.s3.deleteObject(testCase.dstBucketName, keyNameCopy);
            %s3.deleteBucket(bucketName);
            %s3.deleteBucket(dstBucketName);
            shutDownS3Client = true;
            tm.shutdownNow(shutDownS3Client);
        end


        function testUploadDownloadDirectory(testCase)
            tmb = aws.s3.transfer.TransferManagerBuilder();
            tmb.setS3Client(testCase.s3);
            tm = tmb.build();

            tDir = fullfile(tempname);
            mkdir(tDir);
            f1 = fullfile(tDir, 'file1.mat');
            f2 = fullfile(tDir, 'file2.mat');
            x1 = rand(10,10);
            x2 = rand(10,10);
            save(f1, 'x1');
            save(f2, 'x2');
            testCase.verifyTrue(isfile(f1));
            testCase.verifyTrue(isfile(f2));
            cleanup = onCleanup(@()rmdir(tDir, 's'));

            includeSubdirectories = true;
            virtualDirectoryKeyPrefix = 'testUploadDownloadDirectory';
            keyName1 = [virtualDirectoryKeyPrefix, '/', 'file1.mat'];
            keyName2 = [virtualDirectoryKeyPrefix, '/', 'file2.mat'];

            multipleFileUpload = tm.uploadDirectory(testCase.bucketName, virtualDirectoryKeyPrefix, tDir, includeSubdirectories);
            testCase.verifyClass(multipleFileUpload, 'aws.s3.transfer.MultipleFileUpload');
            testCase.verifyTrue(isa(multipleFileUpload.Handle, 'com.amazonaws.services.s3.transfer.MultipleFileUpload') || isa(copy.Handle, 'com.amazonaws.services.s3.transfer.internal.MultipleFileUploadImpl'));
            testCase.verifyEqual(multipleFileUpload.getBucketName, testCase.bucketName);
            testCase.verifyEqual(multipleFileUpload.getKeyPrefix, [virtualDirectoryKeyPrefix, '/']);

            testCase.verifyClass(multipleFileUpload.isDone, 'logical');
            testCase.verifyClass(multipleFileUpload.getDescription, 'char');
            testCase.verifyTrue(startsWith(multipleFileUpload.getDescription, 'Uploading'));

            tp = multipleFileUpload.getProgress();
            testCase.verifyClass(tp, 'aws.s3.transfer.TransferProgress');
            testCase.verifyClass(tp.Handle, 'com.amazonaws.services.s3.transfer.TransferProgress');
            testCase.verifyClass(tp.getBytesTransferred, 'int64');
            testCase.verifyClass(tp.getPercentTransferred, 'double');
            testCase.verifyClass(tp.getTotalBytesToTransfer, 'int64');

            state = multipleFileUpload.getState();
            testCase.verifyClass(state, 'aws.s3.transfer.TransferState');
            testCase.verifyTrue(isenum(state));
            [~, strs] = enumeration('aws.s3.transfer.TransferState');
            testCase.verifyTrue(contains(char(state), strs));

            multipleFileUpload.waitForCompletion();
            testCase.verifyTrue(multipleFileUpload.isDone);
            tp = multipleFileUpload.getProgress();
            testCase.verifyEqual(tp.getPercentTransferred, 100);

            testCase.verifyTrue(testCase.s3.doesObjectExist(testCase.bucketName, keyName1));
            testCase.verifyTrue(testCase.s3.doesObjectExist(testCase.bucketName, keyName2));

            % Download testing
            tDownloadDir = fullfile(tempname);
            mkdir(tDownloadDir);
            multipleFileDownload = tm.downloadDirectory(testCase.bucketName, virtualDirectoryKeyPrefix, tDownloadDir);
            f1 = fullfile(tDownloadDir, virtualDirectoryKeyPrefix, 'file1.mat');
            f2 = fullfile(tDownloadDir, virtualDirectoryKeyPrefix, 'file2.mat');
            cleanup = onCleanup(@()rmdir(tDownloadDir, 's'));

            testCase.verifyClass(multipleFileDownload, 'aws.s3.transfer.MultipleFileDownload');
            testCase.verifyTrue(isa(multipleFileDownload.Handle, 'com.amazonaws.services.s3.transfer.MultipleFileDownload') || isa(copy.Handle, 'com.amazonaws.services.s3.transfer.internal.MultipleFileDownloadImpl'));
            testCase.verifyEqual(multipleFileDownload.getBucketName, testCase.bucketName);
            testCase.verifyEqual(multipleFileDownload.getKeyPrefix, virtualDirectoryKeyPrefix);

            testCase.verifyClass(multipleFileDownload.isDone, 'logical');
            testCase.verifyClass(multipleFileDownload.getDescription, 'char');
            testCase.verifyTrue(startsWith(multipleFileDownload.getDescription, ['Downloading from ', testCase.bucketName, '/', virtualDirectoryKeyPrefix]));

            tp = multipleFileDownload.getProgress();
            testCase.verifyClass(tp, 'aws.s3.transfer.TransferProgress');
            testCase.verifyClass(tp.Handle, 'com.amazonaws.services.s3.transfer.TransferProgress');
            testCase.verifyClass(tp.getBytesTransferred, 'int64');
            testCase.verifyClass(tp.getPercentTransferred, 'double');
            testCase.verifyClass(tp.getTotalBytesToTransfer, 'int64');

            state = multipleFileDownload.getState();
            testCase.verifyClass(state, 'aws.s3.transfer.TransferState');
            testCase.verifyTrue(isenum(state));
            [~, strs] = enumeration('aws.s3.transfer.TransferState');
            testCase.verifyTrue(contains(char(state), strs));

            multipleFileDownload.waitForCompletion();
            testCase.verifyTrue(multipleFileDownload.isDone);
            tp = multipleFileDownload.getProgress();
            testCase.verifyEqual(tp.getPercentTransferred, 100);

            testCase.verifyTrue(isfile(f1));
            testCase.verifyTrue(isfile(f2));

            % cleanup
            testCase.s3.deleteObject(testCase.bucketName, keyName1);
            testCase.s3.deleteObject(testCase.bucketName, keyName2);

            shutDownS3Client = true;
            tm.shutdownNow(shutDownS3Client);
        end

        function testUploadFileList(testCase)
            tmb = aws.s3.transfer.TransferManagerBuilder();
            tmb.setS3Client(testCase.s3);
            tm = tmb.build();

            tDir = fullfile(tempname);
            mkdir(tDir);
            f1 = fullfile(tDir, 'file1.mat');
            f2 = fullfile(tDir, 'file2.mat');
            x1 = rand(10,10);
            x2 = rand(10,10);
            save(f1, 'x1');
            save(f2, 'x2');
            testCase.verifyTrue(isfile(f1));
            testCase.verifyTrue(isfile(f2));
            cleanup = onCleanup(@()rmdir(tDir, 's'));

            virtualDirectoryKeyPrefix = 'testFileListDirectory';
            keyName1 = [virtualDirectoryKeyPrefix, '/', 'file1.mat'];
            keyName2 = [virtualDirectoryKeyPrefix, '/', 'file2.mat'];

            files = ["file1.mat", "file2.mat"];
            directory = tDir;
            multipleFileUpload = tm.uploadFileList(testCase.bucketName, virtualDirectoryKeyPrefix, directory, files);
            testCase.verifyClass(multipleFileUpload, 'aws.s3.transfer.MultipleFileUpload');
            testCase.verifyTrue(isa(multipleFileUpload.Handle, 'com.amazonaws.services.s3.transfer.MultipleFileUpload') || isa(copy.Handle, 'com.amazonaws.services.s3.transfer.internal.MultipleFileUploadImpl'));
            testCase.verifyEqual(multipleFileUpload.getBucketName, testCase.bucketName);
            testCase.verifyEqual(multipleFileUpload.getKeyPrefix, [virtualDirectoryKeyPrefix, '/']);

            testCase.verifyClass(multipleFileUpload.isDone, 'logical');
            testCase.verifyClass(multipleFileUpload.getDescription, 'char');
            testCase.verifyTrue(startsWith(multipleFileUpload.getDescription, 'Uploading'));

            % Underlying AWS function does not seem to function, needs further
            % investigation
            subs = multipleFileUpload.Handle.getSubTransfers();
            if ~subs.isEmpty()
                tp = multipleFileUpload.getProgress();
                testCase.verifyClass(tp, 'aws.s3.transfer.TransferProgress');
                testCase.verifyClass(tp.Handle, 'com.amazonaws.services.s3.transfer.TransferProgress');
                testCase.verifyClass(tp.getBytesTransferred, 'int64');
                testCase.verifyClass(tp.getPercentTransferred, 'double');
                testCase.verifyClass(tp.getTotalBytesToTransfer, 'int64');

                state = multipleFileUpload.getState();
                testCase.verifyClass(state, 'aws.s3.transfer.TransferState');
                testCase.verifyTrue(isenum(state));
                [~, strs] = enumeration('aws.s3.transfer.TransferState');
                testCase.verifyTrue(contains(char(state), strs));

                multipleFileUpload.waitForCompletion();
                testCase.verifyTrue(multipleFileUpload.isDone);
                tp = multipleFileUpload.getProgress();
                testCase.verifyEqual(tp.getPercentTransferred, 100);

                testCase.verifyTrue(testCase.s3.doesObjectExist(testCase.bucketName, keyName1));
                testCase.verifyTrue(testCase.s3.doesObjectExist(testCase.bucketName, keyName2));
            else
                multipleFileUpload.waitForCompletion();
            end
            % cleanup
            testCase.s3.deleteObject(testCase.bucketName, keyName1);
            testCase.s3.deleteObject(testCase.bucketName, keyName2);

            shutDownS3Client = true;
            tm.shutdownNow(shutDownS3Client);
        end

        %% Disabled pending further pause exception related functionality
        % function testResume(testCase)
        %     tmb = aws.s3.transfer.TransferManagerBuilder();
        %     tmb.setS3Client(testCase.s3);
        %     tm = tmb.build();
        % 
        %     localPath = [tempname,'.mat'];
        %     [~,n,e] = fileparts(localPath);
        %     x = rand(1000,1000);
        %     nbytes = int64(1000*1000*8);
        %     save(localPath, 'x');
        %     testCase.verifyTrue(isfile(localPath));
        %     cleanup = onCleanup(@()delete(localPath));
        %     keyName = [n,e];
        % 
        %     cfg = tm.Handle.getConfiguration;
        %     cfg.setMultipartUploadThreshold(int64(nbytes/2));
        %     upload = tm.upload(testCase.bucketName, keyName, localPath);
        %     uploadPersist = upload.pause();
        % 
        %     resumedUpload = upload.resumeUpload(uploadPersist);
        % 
        %     result = resumedUpload.waitForUploadResult(); %#ok<NASGU>
        %     testCase.verifyTrue(upload.isDone);
        % 
        %     % cleanup
        %     testCase.s3.deleteObject(testCase.bucketName, keyName);
        % 
        %     shutDownS3Client = true;
        %     tm.shutdownNow(shutDownS3Client);
        % end


        function testMonitor(testCase)
            tmb = aws.s3.transfer.TransferManagerBuilder();
            tmb.setS3Client(testCase.s3);
            tm = tmb.build();

            localPath = [tempname,'.mat'];
            [~,n,e] = fileparts(localPath);
            x = rand(1000,1000);
            save(localPath, 'x');
            testCase.verifyTrue(isfile(localPath));
            cleanup = onCleanup(@()delete(localPath));
            keyName = [n,e];
            disp('Monitor: default');
            upload = tm.upload(testCase.bucketName, keyName, localPath);
            aws.s3.mathworks.s3.transferMonitor(upload);
            upload = tm.upload(testCase.bucketName, keyName, localPath);
            disp('Monitor: delay 1');
            aws.s3.mathworks.s3.transferMonitor(upload, 'delay', 1);
            upload = tm.upload(testCase.bucketName, keyName, localPath);
            disp('Monitor: delay 1, static');
            aws.s3.mathworks.s3.transferMonitor(upload, 'display', 'static', 'delay', 1);
            upload = tm.upload(testCase.bucketName, keyName, localPath);
            disp('Monitor: delay 1, static, bytes');
            aws.s3.mathworks.s3.transferMonitor(upload, 'mode', 'bytes', 'display', 'static', 'delay', 1);
            
            result = upload.waitForUploadResult(); %#ok<NASGU>
            testCase.verifyTrue(upload.isDone);

            downloadLocalPath = [tempname,'.mat'];
            cleanup = onCleanup(@()delete(downloadLocalPath));
            disp('Monitor: delay 1, static, bytes (download)');
            download = tm.download(testCase.bucketName, keyName, downloadLocalPath);
            aws.s3.mathworks.s3.transferMonitor(download, 'mode', 'bytes', 'display', 'static', 'delay', 1);
            disp('Monitor: delay 1, scroll, bytes (download)');
            download = tm.download(testCase.bucketName, keyName, downloadLocalPath);
            aws.s3.mathworks.s3.transferMonitor(download, 'mode', 'bytes', 'display', 'scroll', 'delay', 1);
            
            download.waitForCompletion();
            testCase.verifyTrue(download.isDone);
            
            % cleanup
            testCase.s3.deleteObject(testCase.bucketName, keyName);
            %s3.deleteBucket(bucketName);
            shutDownS3Client = true;
            tm.shutdownNow(shutDownS3Client);
        end


        function testAbortMultipartUploads(testCase)
            tmb = aws.s3.transfer.TransferManagerBuilder();
            tmb.setS3Client(testCase.s3);
            tm = tmb.build();
            tm.abortMultipartUploads(testCase.bucketName, datetime('now'));
        end

    end
end
