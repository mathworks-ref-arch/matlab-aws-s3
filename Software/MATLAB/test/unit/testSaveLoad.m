classdef testSaveLoad < matlab.unittest.TestCase
    % TESTSAVELOAD Unit Test for the Amazon S3 Client for basic load/save
    %
    % The test suite exercises the basic operations on the S3 Client.

    % Copyright 2017-2021 The MathWorks, Inc.

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Please add test cases below
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
        function testLoad1File(testCase)
            write(testCase.logObj,'debug','Testing testLoad1File');
            s3 = aws.s3.Client();
            if strcmpi(getenv('GITLAB_CI'), 'true')
                s3.useCredentialsProviderChain = false;
            else
                s3.useCredentialsProviderChain = true;
            end
            s3.initialize();

            % create a small block of data
            x1 = rand(100,100);
            x2=3;
            x3=5;
            filename = [tempname,'.mat'];
            save(filename, 'x1','x2','x3');
            y1=x1;
            y2=x2;
            y3=x3;
            clear x1;
            clear x2;
            clear x3;

            % create a bucket to hold the object
            bucketname = lower(matlab.lang.makeValidName(['com.example.awss3.unittest',datestr(now)],'ReplacementStyle','delete'));  
            s3.createBucket(bucketname);
            % upload the file as an object
            s3.putObject(bucketname,filename);

            % load the object from s3 into the workspace as a variable by
            % the contents of objname
            S = s3.load(bucketname,filename);

            % verify values read back equal those written
            testCase.verifyTrue(isequal(S.x1,y1));
            testCase.verifyEqual(S.x2,y2);
            testCase.verifyEqual(S.x3,y3);

            s3.deleteObject(bucketname,filename);
            s3.deleteBucket(bucketname);
            s3.shutdown();
            delete(filename);
            pause(1.1);
        end

        function testLoad1VarNamed(testCase)
            write(testCase.logObj,'debug','Testing testLoad1VarNamed');
            s3 = aws.s3.Client();
            if strcmpi(getenv('GITLAB_CI'), 'true')
                s3.useCredentialsProviderChain = false;
            else
                s3.useCredentialsProviderChain = true;
            end
            s3.initialize();

            % create a small block of data
            x = rand(100,100);

            % create a bucket to hold the object
            bucketname = lower(matlab.lang.makeValidName(['com.example.awss3.unittest',datestr(now)],'ReplacementStyle','delete')); %#ok<*TNOW1,*DATST> 
            s3.createBucket(bucketname);
            objname = 'my_s3object_name.mat';
            filename = [tempname,'.mat'];
            save(filename,'x');
            % upload the variable x and a call it my_s3object_name
            s3.putObject(bucketname,filename,objname);

            % load the object from s3 into the workspace as a variable by
            % the contents of objname
            S = s3.load(bucketname,objname, 'x');

            testCase.verifyTrue(isequal(S.x,x));

            s3.deleteObject(bucketname,objname);
            s3.deleteBucket(bucketname);
            s3.shutdown();
            delete(filename);
            pause(1.1);
        end

        function testLoad1VarNoMatExt(testCase)
            write(testCase.logObj,'debug','Testing testLoad1VarUnnamed');
            s3 = aws.s3.Client();
            if strcmpi(getenv('GITLAB_CI'), 'true')
                s3.useCredentialsProviderChain = false;
            else
                s3.useCredentialsProviderChain = true;
            end
            s3.initialize();

            % create a small block of data
            x = rand(100,100);
            filename = [tempname,'.notmat'];
            save(filename, 'x');

            % create a bucket to hold the object
            bucketname = lower(matlab.lang.makeValidName(['com.example.awss3.unittest',datestr(now)],'ReplacementStyle','delete'));
            s3.createBucket(bucketname);
            % upload the variable x and a call it 'x'
            s3.putObject(bucketname,filename,'x');

            % clear x after saving it to y
            y=x;
            clear x;

            % load the object from s3 into the workspace as a variable
            % reloading x
            S = s3.load(bucketname,'x','-mat');

            testCase.verifyTrue(isequal(S.x,y));

            s3.deleteObject(bucketname,'x');
            s3.deleteBucket(bucketname);
            s3.shutdown();
            delete(filename);
            pause(1.1);
        end


        function testSaveVar(testCase)
            write(testCase.logObj,'debug','Testing testSave1File');
            % Create the client and initialize
            s3 = aws.s3.Client();
            if strcmpi(getenv('GITLAB_CI'), 'true')
                s3.useCredentialsProviderChain = false;
            else
                s3.useCredentialsProviderChain = true;
            end
            s3.initialize();

            % create a small block of data and save it to a file
            x = rand(100,100);

            % create a name for the bucket to hold the object
            bucketname = lower(matlab.lang.makeValidName(['com.example.awss3.unittest',datestr(now)],'ReplacementStyle','delete'));

            % call the save command to save the data to s3 as an object
            % named by filename
            filename = [tempname,'.mat'];
            s3.save(bucketname,filename,'x');

            % remove the local copy of the file and redownload it
            %delete(filename);
            s3.getObject(bucketname,filename);

            %compare the downloaded file to the original generate random values
            y = load(filename,'x');
            testCase.verifyTrue(isequal(x,y.x));

            % remove the bucket and the contained object afterwards
            s3.deleteObject(bucketname,filename);
            s3.deleteBucket(bucketname);
            s3.shutdown();
            % delete the temporary file
            delete(filename);
            pause(1.1);
        end


        function testSaveNonMat(testCase)
            write(testCase.logObj,'debug','Testing testSave1File');
            % Create the client and initialize
            s3 = aws.s3.Client();
            if strcmpi(getenv('GITLAB_CI'), 'true')
                s3.useCredentialsProviderChain = false;
            else
                s3.useCredentialsProviderChain = true;
            end
            s3.initialize();

            % create a small block of data and save it to a file
            x = rand(100,100);

            % create a name for the bucket to hold the object
            bucketname = lower(matlab.lang.makeValidName(['com.example.awss3.unittest',datestr(now)],'ReplacementStyle','delete'));

            % call the save command to save the data to s3 as an object
            % named by filename
            s3objname = [tempname,'.csv'];
            s3.save(bucketname, s3objname, 'x', '-ascii', '-double');

            % redownload it
            filename = [tempname,'.csv'];
            s3.getObject(bucketname,s3objname,filename);

            %compare the downloaded file to the originally generated random values
            y = load(filename,'x','-ascii');
            testCase.verifyTrue(isequal(x,y));

            % remove the bucket and the contained object afterwards
            s3.deleteObject(bucketname,s3objname);
            s3.deleteBucket(bucketname);
            s3.shutdown();
            % delete the temporary file
            delete(filename);
            pause(1.1);
        end

    end
end
