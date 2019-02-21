classdef testCrypto < matlab.unittest.TestCase
    % TESTCRYPTO Unit Test for the Amazon S3 Client
    %
    % The assertions that you can use in test cases:
    %
    %    assertTrue
    %    assertFalse
    %    assertEqual
    %    assertFilesEqual
    %    assertElementsAlmostEqual
    %    assertVectorsAlmostEqual
    %    assertExceptionThrown
    %
    % The test suite exercises the basic operations on the S3 Client.

    % Copyright 2017 The MathWorks, Inc.

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Please add test cases below
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties
        logObj
    end

    methods (TestMethodSetup)
        function testSetup(testCase)
            testCase.logObj = Logger.getLogger();
            testCase.logObj.DisplayLevel = 'verbose';
        end
    end

    methods (TestMethodTeardown)
        function testTearDown(testCase) %#ok<MANU>

        end
    end

    methods (Test)
        function testputObjectSSES3(testCase)
            write(testCase.logObj,'debug','Testing SSES3');
            s3 = aws.s3.Client();
            s3.encryptionScheme = 'SSES3';
            s3.useCredentialsProviderChain = false;
            s3.initialize();

            % create a small block of data
            x = rand(100,100);
            plainfile = [tempname,'.mat'];
            save(plainfile, 'x');
            y=x;
            clear 'x';

            % create a bucket to hold the objects
            bucketname = lower(matlab.lang.makeValidName(['com.example.awss3.unittest',datestr(now)],'ReplacementStyle','delete'));
            s3.createBucket(bucketname);

            write(testCase.logObj,'debug','Uploading data to be encrypted by S3');
            s3.putObject(bucketname,plainfile);

            write(testCase.logObj,'debug','Verifying algoithm metadata');
            metadata = s3.getObjectMetadata(bucketname,plainfile);
            testCase.verifyEqual(metadata.getSSEAlgorithm(), 'AES256');

            write(testCase.logObj,'debug','Retrieving data from S3');
            s3.getObject(bucketname,plainfile);
            load(plainfile,'x');

            write(testCase.logObj,'debug','Verifying matched uploaded data');
            % compare it to the uploaded data
            testCase.verifyTrue(isequal(x,y));

            % redownload with the same credentials but not with an encryption client
            % should be decrypted by default as default key was used to store it
            write(testCase.logObj,'debug','Redownload with no decryption');
            s3b = aws.s3.Client();
            s3b.useCredentialsProviderChain = false;
            s3b.initialize();
            delete(plainfile);
            clear 'x';
            s3b.getObject(bucketname,plainfile);
            load(plainfile,'x');
            vars = whos('-file',plainfile);
            testCase.verifyTrue(ismember('x', {vars.name}));
            write(testCase.logObj,'debug','Verifying non-garbled data');
            testCase.verifyTrue(isequal(x,y));

            write(testCase.logObj,'debug','Cleaning up');
            s3.deleteObject(bucketname,plainfile);
            s3.deleteBucket(bucketname);
            delete(plainfile);
            s3.shutdown();
            s3b.shutdown();
            pause(1.1);
        end


        function testputObjectSSEC(testCase)

            write(testCase.logObj,'debug','Testing ssec');

            s3 = aws.s3.Client();
            s3.useCredentialsProviderChain = false;
            s3.encryptionScheme = 'ssec';
            s3.initialize();

            % create a small block of data
            x = rand(100,100);
            plainfile = [tempname,'.mat'];
            save(plainfile, 'x');

            % create a bucket to hold the objects
            bucketname = lower(matlab.lang.makeValidName(['com.example.awss3.unittest',datestr(now)],'ReplacementStyle','delete'));
            s3.createBucket(bucketname);

            % generate a customer key
            my_SecretKey = s3.generateSSECKey();

            % upload the object using the key
            s3.putObject(bucketname,plainfile,my_SecretKey);

            % dump the metadata
            metadata = s3.getObjectMetadata(bucketname,plainfile,my_SecretKey);

            % check the fields that indicate crypto enabled
            algval = metadata.getSSECustomerAlgorithm();
            testCase.verifyTrue(strcmp(char(algval),'AES256'));
            md5val = metadata.getSSECustomerKeyMd5();
            testCase.verifyFalse(isempty(md5val));

            % copy x data to y and clear x so we know the reloaded value is
            % from the download
            y=x;
            clear 'x';

            % download the object using the key
            s3.getObject(bucketname,plainfile,my_SecretKey);

            % load the downloaded file into the workspace
            load(plainfile,'x');

            % compare it to the uploaded data
            testCase.verifyTrue(isequal(x,y));

            % try to redownload using a different key
            disp('redownloading with the wrong key');
            my_SecretKey2 = s3.generateSSECKey();
            testCase.verifyError(@()s3.getObject(bucketname,plainfile,my_SecretKey2),'MATLAB:Java:GenericException');

            % clean up by deleting the bucket and tmp file
            s3.deleteObject(bucketname,plainfile);
            s3.deleteBucket(bucketname);
            delete(plainfile);
            s3.shutdown();
            pause(1.1);
        end

        % NOTE: This test requires access to valid keys on the KMS system
        % and a JRE capable of unlimited word strength. Please refer to the
        % documentation for more details. Please uncomment this with valid
        % key ids
        %
        % function testputObjectkmscmk(testCase)
        %     if unlimitedCryptography
        %         % requires unlimited strength encryption policy files
        %         write(testCase.logObj,'debug','Testing kmscmk');
        %         % using KMS (Key Management Service) with a Customer Managed Key
        %         % id for a key created in the region in question (keys are
        %         % region specific) the key below is tied to us-west-1
        %        
        %         key_id = 'c6662517-[ R E D A C T E D]-a0a4f84c9e8e';
        %         s3 = aws.s3.Client();
        %         s3.useCredentialsProviderChain = false;
        %         s3.encryptionScheme = 'kmscmk';
        %         s3.KMSCMKKeyID = key_id;
        %         s3.initialize();
        %
        %         % create a small block of data
        %         x = rand(100,100);
        %         plainfile = [tempname,'.mat'];
        %         save(plainfile, 'x');
        %         y=x;
        %         clear 'x';
        %
        %         % create a bucket to hold the objects
        %         bucketname = lower(matlab.lang.makeValidName(['com.example.awss3.unittest',datestr(now)],'ReplacementStyle','delete'));
        %         s3.createBucket(bucketname);
        %
        %         % upload the object with client side encryption
        %         s3.putObject(bucketname,plainfile,plainfile)
        %
        %         % do a dump of metadata
        %         % client side method no metadata to test
        %         metadata = s3.getObjectMetadata(bucketname,plainfile); %#ok<NASGU>
        %
        %         s3.getObject(bucketname,plainfile);
        %         load(plainfile,'x');
        %
        %         % compare it to the uploaded data
        %         testCase.verifyTrue(isequal(x,y));
        %
        %         % start a new client redownload the file and prove that it is
        %         % not readable
        %         write(testCase.logObj,'debug','Try to download with the wrong key ID');
        %         key_idb = 'a1234567-[R E D A C T E D]-c6d7e89f0a1b';
        %         s3b = aws.s3.Client();
        %         s3b.useCredentialsProviderChain = false;
        %         s3b.encryptionScheme = 'kmscmk';
        %         s3b.KMSCMKKeyID = key_idb;
        %         s3b.initialize();
        %         delete(plainfile);
        %         % redownload the file, whos should fail...
        %         % for now flag the fail by being able to read the variable
        %         s3b.getObject(bucketname,plainfile);
        %         vars = whos('-file',plainfile);
        %         % KMS will automatically use the correct master key for
        %         % decryption so even though an invalid key id is supplied the
        %         % correct data should still be returned
        %         testCase.verifyTrue(ismember('x', {vars.name}));
        %         %testCase.verifyError(@()load(plainfile),'MATLAB:load:notBinaryFile');
        %
        %         s3.deleteObject(bucketname,plainfile);
        %         s3.deleteBucket(bucketname);
        %         delete(plainfile);
        %         s3.shutdown();
        %         s3b.shutdown();
        %         pause(1.1);
        %     else
        %         write(testCase.logObj,'warning','NOT Testing kmscmk unlimited strength cryptography required');
        %     end
        % end

        function testputObjectssekms_default(testCase)
            write(testCase.logObj,'debug','Testing ssekms - Server-Side encryption with Key Management Service using default master key');

            % use default key id
            write(testCase.logObj,'debug','using default master key');
            s3 = aws.s3.Client();
            s3.useCredentialsProviderChain = false;
            s3.encryptionScheme = 'ssekms';
            s3.initialize();
            write(testCase.logObj,'debug','Requesting that default master Key be used');
            sse_params = s3.setSSEAwsKeyManagementParams();
            write(testCase.logObj,'debug','Generating sample data');
            x = rand(100,100);
            plainfile = [tempname,'.mat'];
            save(plainfile, 'x');
            y=x;
            clear 'x';

            % create a bucket to hold the objects
            bucketname = lower(matlab.lang.makeValidName(['com.example.awss3.unittest',datestr(now)],'ReplacementStyle','delete'));
            s3.createBucket(bucketname);

            write(testCase.logObj,'debug','Uploading data to be encrypted by S3');
            s3.putObject(bucketname,plainfile,sse_params);

            metadata = s3.getObjectMetadata(bucketname,plainfile);
            testCase.verifyEqual(metadata.getSSEAlgorithm(), 'aws:kms');

            write(testCase.logObj,'debug','Retrieving data from S3');
            s3.getObject(bucketname,plainfile);
            load(plainfile,'x');

            write(testCase.logObj,'debug','Verifying matched uploaded data');
            % compare it to the uploaded data
            testCase.verifyTrue(isequal(x,y));

            % redownload with the same credentials but not with an encryption client
            % should be decrypted by default as default key was used to store it
            write(testCase.logObj,'debug','Redownload with no decryption');
            s3b = aws.s3.Client();
            s3b.useCredentialsProviderChain = false;
            s3b.initialize();

            delete(plainfile);
            clear 'x';
            s3b.getObject(bucketname,plainfile);
            load(plainfile,'x');
            vars = whos('-file',plainfile);
            testCase.verifyTrue(ismember('x', {vars.name}));

            write(testCase.logObj,'debug','Verifying non-garbled data');
            testCase.verifyTrue(isequal(x,y));

            write(testCase.logObj,'debug','Cleaning up');
            s3.deleteObject(bucketname,plainfile);
            s3.deleteBucket(bucketname);
            delete(plainfile);
            s3.shutdown();
            s3b.shutdown();
            pause(1.1);
        end

        function testputObjectssekms_default_bad_arg(testCase)
            write(testCase.logObj,'debug','Testing ssekms - Server-Side encryption with Key Management Service using default master key but with a bad argument');

            % use default key id but call setSSEAwsKeyManagementParams using a white space string
            % to replicate an observed user error
            write(testCase.logObj,'debug','using default master key');
            s3 = aws.s3.Client();
            s3.useCredentialsProviderChain = false;
            s3.encryptionScheme = 'ssekms';
            s3.initialize();
            write(testCase.logObj,'debug','Requesting that default master Key be used');
            sse_params = s3.setSSEAwsKeyManagementParams(' ');
            write(testCase.logObj,'debug','Generating sample data');
            x = rand(100,100);
            plainfile = [tempname,'.mat'];
            save(plainfile, 'x');
            y=x;
            clear 'x';

            % create a bucket to hold the objects
            bucketname = lower(matlab.lang.makeValidName(['com.example.awss3.unittest',datestr(now)],'ReplacementStyle','delete'));
            s3.createBucket(bucketname);

            write(testCase.logObj,'debug','Uploading data to be encrypted by S3');
            s3.putObject(bucketname,plainfile,sse_params);

            metadata = s3.getObjectMetadata(bucketname,plainfile);
            testCase.verifyEqual(metadata.getSSEAlgorithm(), 'aws:kms');

            write(testCase.logObj,'debug','Retrieving data from S3');
            s3.getObject(bucketname,plainfile);
            load(plainfile,'x');

            write(testCase.logObj,'debug','Verifying matched uploaded data')
            % compare it to the uploaded data
            testCase.verifyTrue(isequal(x,y));

            % redownload with the same credentials but not with an encryption client
            % should be decrypted by default as default key was used to store it
            write(testCase.logObj,'debug','Redownload with no decryption');
            s3b = aws.s3.Client();
            s3b.useCredentialsProviderChain = false;
            s3b.initialize();

            delete(plainfile);
            clear 'x';
            s3b.getObject(bucketname,plainfile);
            load(plainfile,'x');
            vars = whos('-file',plainfile);
            testCase.verifyTrue(ismember('x', {vars.name}));

            write(testCase.logObj,'debug','Verifying non-garbled data');
            testCase.verifyTrue(isequal(x,y));

            write(testCase.logObj,'debug','Cleaning up');
            s3.deleteObject(bucketname,plainfile);
            s3.deleteBucket(bucketname);
            delete(plainfile);
            s3.shutdown();
            s3b.shutdown();
            pause(1.1);
        end

        % NOTE: Uncomment this test to test put with SSEKMS. For this test
        % to succeed, a valid KMS ID is required. This has been redacted
        % below.
        %
        % function testputObjectssekms_nondefault(testCase)
        %     import matlab.unittest.TestCase;
        %     import matlab.unittest.constraints.IsTrue;
        %
        %     write(testCase.logObj,'debug','Testing ssekms - Server-Side encryption with Key Management Service nondefault');
        %
        %     % use non-default key id
        %     write(testCase.logObj,'debug','using non-default key');
        %     s3 = aws.s3.Client();
        %     s3.useCredentialsProviderChain = false;
        %     s3.encryptionScheme = 'ssekms';
        %     s3.initialize();
        %     write(testCase.logObj,'debug','Requesting that non default Key be used');
        %
        %     key_id = 'c6662517-[ R E D A C T E D ]-f84c9e8e';
        %
        %     sse_params = s3.setSSEAwsKeyManagementParams(key_id);
        %     write(testCase.logObj,'debug','Generating sample data');
        %     x = rand(100,100);
        %     plainfile = [tempname,'.mat'];
        %     save(plainfile, 'x');
        %     y=x;
        %     clear 'x';
        %
        %     % create a bucket to hold the objects
        %     bucketname = lower(matlab.lang.makeValidName(['com.example.awss3.unittest',datestr(now)],'ReplacementStyle','delete'));
        %     s3.createBucket(bucketname);
        %
        %     write(testCase.logObj,'debug','Uploading data to be encrypted by S3');
        %     s3.putObject(bucketname,plainfile,sse_params);
        %
        %     write(testCase.logObj,'debug','dumping metadata info');
        %     metadata = s3.getObjectMetadata(bucketname,plainfile);
        %     str = metadata.getSSEAwsKmsKeyId();
        %     testCase.verifySubstring(str,key_id);
        %
        %     str = metadata.getSSEAlgorithm();
        %     testCase.verifyTrue(strcmpi(str,'aws:kms'));
        %
        %     write(testCase.logObj,'debug','Retrieving data from S3');
        %     s3.getObject(bucketname,plainfile);
        %     load(plainfile,'x');
        %
        %     write(testCase.logObj,'debug','Verifying matched uploaded data')
        %     % compare it to the uploaded data
        %     testCase.verifyTrue(isequal(x,y));
        %
        %     % redownload with the same credentials but not with an encryption client
        %     % should be decrypted by the default master key
        %     write(testCase.logObj,'debug','Redownload with no decryption');
        %     s3b = aws.s3.Client();
        %     s3b.useCredentialsProviderChain = false;
        %     s3b.initialize();
        %
        %     delete(plainfile);
        %     clear 'x';
        %     s3b.getObject(bucketname,plainfile);
        %     load(plainfile,'x');
        %     metadata = s3b.getObjectMetadata(bucketname,plainfile);
        %     testCase.verifyEqual(metadata.getSSEAlgorithm(), 'aws:kms');
        %
        %     vars = whos('-file',plainfile);
        %     testCase.verifyTrue(ismember('x', {vars.name}));
        %
        %     write(testCase.logObj,'debug','Verifying non-garbled data');
        %     testCase.verifyTrue(isequal(x,y));
        %
        %     write(testCase.logObj,'debug','Cleaning up');
        %     s3.deleteObject(bucketname,plainfile);
        %     s3.deleteBucket(bucketname);
        %     delete(plainfile);
        %     s3.shutdown();
        %     s3b.shutdown();
        %     pause(1.1);
        % end

        function testputObjectssekms_InvalidKeyID(testCase)
            import matlab.unittest.TestCase;
            import matlab.unittest.constraints.IsTrue;

            write(testCase.logObj,'debug','Testing ssekms - Server-Side encryption with Key Management Service using an invalid key ID');

            % use non-default key id
            write(testCase.logObj,'debug','using Invalid key ID');
            s3 = aws.s3.Client();
            s3.useCredentialsProviderChain = false;
            s3.encryptionScheme = 'ssekms';
            s3.initialize();
            write(testCase.logObj,'debug','Requesting that an Invalid Key be used');
            key_id = 'a1234567-bcd1-234e-fab5-c6d7e89f0a1b';
            sse_params = s3.setSSEAwsKeyManagementParams(key_id);
            write(testCase.logObj,'debug','Generating sample data');
            x = rand(100,100);
            plainfile = [tempname,'.mat'];
            save(plainfile, 'x');
            clear 'x';

            % create a bucket to hold the objects
            bucketname = lower(matlab.lang.makeValidName(['com.example.awss3.unittest',datestr(now)],'ReplacementStyle','delete'));
            s3.createBucket(bucketname);

            write(testCase.logObj,'debug','Uploading data with invalid key, expecting failure');
            % should fail on the put
            testCase.verifyError(@()s3.putObject(bucketname,plainfile,sse_params),'MATLAB:Java:GenericException');

            write(testCase.logObj,'debug','Cleaning up');
            s3.deleteObject(bucketname,plainfile);
            s3.deleteBucket(bucketname);
            delete(plainfile);
            s3.shutdown();
            pause(1.1);
        end

        function testputObjectcsesmk(testCase)
            if unlimitedCryptography
                % requires unlimited strength encryption policy files
                write(testCase.logObj,'debug','Testing csesmk');

                s3 = aws.s3.Client();
                s3.useCredentialsProviderChain = false;
                s3.encryptionScheme = 'csesmk';
                % Generate a symmetric 256 bit AES key.
                s3.CSESMKKey = s3.generateCSESymmetricMasterKey('AES', 256);
                s3.initialize;

                x = rand(100,100);
                plainfile = [tempname,'.mat'];
                save(plainfile, 'x');
                y=x;
                clear 'x';

                % create a bucket to hold the objects
                bucketname = lower(matlab.lang.makeValidName(['com.example.awss3.unittest',datestr(now)],'ReplacementStyle','delete'));
                s3.createBucket(bucketname);

                s3.putObject(bucketname,plainfile);
                s3.getObject(bucketname,plainfile);
                load(plainfile,'x');

                % nothing to test for in the metadata
                metadata = s3.getObjectMetadata(bucketname,plainfile); %#ok<NASGU>

                % compare it to the uploaded data
                testCase.verifyTrue(isequal(x,y));

                % start a new client redownload the file and prove that it is
                % not readable
                write(testCase.logObj,'debug','Redownload with no decryption');
                s3b = aws.s3.Client();
                s3b.useCredentialsProviderChain = false;
                s3b.initialize();
                delete(plainfile);
                s3b.getObject(bucketname,plainfile);
                testCase.verifyError(@()load(plainfile,'x'),'MATLAB:load:notBinaryFile');

                % start a further client and download again this time using a
                % new and thus different key
                s3c = aws.s3.Client();
                s3c.useCredentialsProviderChain = false;
                s3c.encryptionScheme = 'csesmk';

                % Generate another symmetric 256 bit AES key.
                s3c.CSESMKKey = s3.generateCSESymmetricMasterKey('AES',256);
                s3c.initialize();
                delete(plainfile);
                % warns with: [WARN] S3AbortableInputStream - Not all bytes were read from the S3ObjectInputStream
                % aborting HTTP connection. This is likely an error and may result in sub-optimal behavior. Request
                % only the bytes you need via a ranged GET or drain the input stream after use.
                % errors with: com.amazonaws.AmazonClientException: Unable to decrypt symmetric key from object metadata
                testCase.verifyError(@()s3c.getObject(bucketname,plainfile),'MATLAB:Java:GenericException');


                s3.deleteObject(bucketname,plainfile);
                s3.deleteBucket(bucketname);
                % not required because previous download will fail
                % delete(plainfile);
                s3.shutdown();
                s3b.shutdown();
                s3c.shutdown();
                pause(1.1);
            else
                write(testCase.logObj,'warning','NOT Testing csesmk unlimited strength cryptography required');
            end
        end

        function testputObjectcseamk(testCase)
            if unlimitedCryptography
                % requires unlimited strength encryption policy files
                write(testCase.logObj,'debug','Testing cseamk');

                s3 = aws.s3.Client();
                s3.useCredentialsProviderChain = false;
                s3.encryptionScheme = 'cseamk';
                % Generate an asymmetric 1024 bit RSA key pair
                s3.CSEAMKKeyPair = s3.generateCSEAsymmetricMasterKey(1024);
                s3.initialize();

                x = rand(100,100);
                plainfile = [tempname,'.mat'];
                save(plainfile, 'x');
                y=x;
                clear 'x';

                % create a bucket to hold the objects
                bucketname = lower(matlab.lang.makeValidName(['com.example.awss3.unittest',datestr(now)],'ReplacementStyle','delete'));
                s3.createBucket(bucketname);

                s3.putObject(bucketname,plainfile,plainfile);
                s3.getObject(bucketname,plainfile);
                load(plainfile,'x');

                % nothing to test for in the metadata
                metadata = s3.getObjectMetadata(bucketname,plainfile); %#ok<NASGU>

                % compare it to the uploaded data
                testCase.verifyTrue(isequal(x,y));

                % start a new client redownload the file and prove that it is
                % not readable
                write(testCase.logObj,'debug','Redownload with no decryption');
                s3b = aws.s3.Client();
                s3b.useCredentialsProviderChain = false;
                s3b.initialize();
                delete(plainfile);
                s3b.getObject(bucketname,plainfile);
                testCase.verifyError(@()load(plainfile,'x'),'MATLAB:load:notBinaryFile');

                % start a further client and download again this time using a
                % new and thus different key
                s3c = aws.s3.Client();
                s3c.useCredentialsProviderChain = false;
                s3c.encryptionScheme = 'cseamk';

                % Generate another asymmetric 1024 bit RSA key.
                s3c.CSEAMKKeyPair = s3.generateCSEAsymmetricMasterKey();
                s3c.initialize();
                delete(plainfile);
                % warns with: [WARN] S3AbortableInputStream - Not all bytes were read from the S3ObjectInputStream
                % aborting HTTP connection. This is likely an error and may result in sub-optimal behavior. Request
                % only the bytes you need via a ranged GET or drain the input stream after use.
                % errors with: com.amazonaws.AmazonClientException: Unable to decrypt symmetric key from object metadata
                testCase.verifyError(@()s3c.getObject(bucketname,plainfile),'MATLAB:Java:GenericException');

                s3.deleteObject(bucketname,plainfile);
                s3.deleteBucket(bucketname);
                % not required because previous download will fail
                % delete(plainfile);
                s3.shutdown();
                s3b.shutdown();
                s3c.shutdown();
                pause(1.1);
            else
                write(testCase.logObj,'warning','NOT Testing cseamk unlimited strength cryptography required');
            end
        end

        function testCSEAMK(testCase)
            if unlimitedCryptography
                % requires unlimited strength encryption policy files
                write(testCase.logObj,'debug','Testing cseamk');

                % create some sample data, a temp file and a bucket name
                x = rand(3);
                y=x;
                mymatfile = [tempname,'.mat'];
                save(mymatfile, 'x');
                bucketName = lower(matlab.lang.makeValidName(['com.example.awss3.unittest',datestr(now)],'ReplacementStyle','delete'));

                % setup a client
                clientAlice = aws.s3.Client();
                clientAlice.useCredentialsProviderChain = false;
                clientAlice.encryptionScheme = 'CSEAMK';
                % Generate an asymmetric 1024 bit RSA key pair
                myKeyPair = clientAlice.generateCSEAsymmetricMasterKey(1024);
                saveKeyPair(myKeyPair,'mypublic.key','myprivate.key');

                % init client with both keys
                myKeyPair = loadKeyPair('mypublic.key','myprivate.key');
                clientAlice.CSEAMKKeyPair = myKeyPair;
                clientAlice.initialize;

                % init client with only the public key
                encryptOnlyPair = loadKeyPair('mypublic.key');
                clientBob = aws.s3.Client();
                clientBob.useCredentialsProviderChain = false;
                clientBob.CSEAMKKeyPair = encryptOnlyPair;
                clientBob.encryptionScheme = 'CSEAMK';
                clientBob.initialize();

                % create a bucket
                % client B uploads to it and A downloads
                clientAlice.createBucket(bucketName);
                clientBob.putObject(bucketName,mymatfile);
                clientAlice.getObject(bucketName,mymatfile);

                % check the result x should equal y
                clear x;
                load(mymatfile,'x');
                testCase.verifyTrue(isequal(x,y));

                % clear old results and redownload
                delete(mymatfile);
                clear x;
                % B's download - should fail
                testCase.verifyError(@()clientBob.getObject(bucketName,mymatfile),'MATLAB:Java:GenericException');

                % clear old result again and redownload using load semantics
                clear x;
                S = clientAlice.load(bucketName,mymatfile)
                testCase.verifyTrue(isequal(S.x,y)); %  x should equal y

                % cleanup
                if exist(mymatfile,'file') == 2
                    delete(mymatfile);
                end
                delete('mypublic.key');
                delete('myprivate.key');
                clientAlice.deleteObject(bucketName,mymatfile);
                clientAlice.deleteBucket(bucketName);
                clientAlice.shutdown();
                clientBob.shutdown();
                pause(1.1);
            else
                write(testCase.logObj,'warning','NOT Testing cseamk unlimited strength cryptography required');
            end
        end % function

    end % methods
end % class
