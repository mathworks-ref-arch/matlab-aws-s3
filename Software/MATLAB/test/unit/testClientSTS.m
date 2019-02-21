classdef testClientSTS < matlab.unittest.TestCase
    % TESTCLIENTSTS Unit Test for the Amazon S3 Client using STS Authentication
    % 
    % The test suite exercises the basic operations on the S3 Client using 
    % the token service (STS). Please note that these tests will succeed if
    % a credential file is provided so if you are not using the STS token
    % then the tests will still pass. The objective of this suite is to
    % ensure that they will work when using STS. Please consult the
    % documentation for more details.

    % Copyright 2017 The MathWorks, Inc.

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Please add test cases below
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties
        logObj
    end

    methods (TestMethodSetup)
        function testSetup(testCase)
            testCase.logObj = Logger.getLogger();
        end
    end

    methods (TestMethodTeardown)
        function testTearDown(testCase) %#ok<MANU>

        end
    end

    methods (Test)
        function testConstructor(testCase)
            % Create the object
            s3 = aws.s3.Client();

            testCase.verifyClass(s3,'aws.s3.Client');
        end

        function testInitialization(testCase)
            % Create the client and initialize
            s3 = aws.s3.Client();
            s3.useCredentialsProviderChain = false;
            s3.initialize();

            testCase.verifyNotEmpty(s3.Handle);
            s3.shutdown();
        end

        function testInitializationOtherCredendtials(testCase)
            % Create the client and initialize using a temp copy of the
            % credentials file in the same directory
            if isEC2
               write(testCase.logObj,'debug','Running in EC2 testInitializationOtherCredentials test will fail if relying on roles only ');
            end
            currentCreds = which('credentials.json');
            [pathstr,~,~] = fileparts(currentCreds);
            newCreds = [pathstr filesep 'testInitializationOtherCredentials.json'];
            copyfile(currentCreds,newCreds);

            s3 = aws.s3.Client();
            s3.credentialsFilePath = newCreds;
            s3.useCredentialsProviderChain = false;
            s3.initialize();

            testCase.verifyNotEmpty(s3.Handle);
            delete(newCreds);
            s3.shutdown();
        end

        function testcreateBucket(testCase)
            % Create the client and initialize
            s3 = aws.s3.Client();
            s3.useCredentialsProviderChain = false;
            s3.initialize();

            % Create a bucket
            uniqName = lower(matlab.lang.makeValidName(['com.example.awss3.unittest',datestr(now)],'ReplacementStyle','delete'));
            s3.createBucket(uniqName);

            % get a list of the buckets
            bucket_table = s3.listBuckets();
            % extract the bucket names to a cell array
            names = bucket_table.Name;
            % find matches vs. the bucket name just created
            matches = strcmp(uniqName, names);

            % verify that there is one and only one match with the bucket
            testCase.verifyEqual(nnz(matches),1);

            % cleanup
            s3.deleteBucket(uniqName);
            s3.shutdown();
            % force a short wait so next call to now sill always return a
            % new number
            pause(1.1);
        end
    end
end
