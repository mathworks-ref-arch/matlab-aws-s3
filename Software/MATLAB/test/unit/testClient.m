classdef testClient < matlab.unittest.TestCase
    % TESTCLIENT Unit Test for the Amazon S3 Client
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
        function testTearDown(testCase)

        end
    end

    methods (Test)
        function testConstructor(testCase)
            write(testCase.logObj,'debug','Testing testConstructor');
            % Create the object
            s3 = aws.s3.Client();

            testCase.verifyClass(s3,'aws.s3.Client');
        end

        function testInitialization(testCase)
            write(testCase.logObj,'debug','Testing testInitialization');
            % Create the client and initialize
            s3 = aws.s3.Client();
            s3.useCredentialsProviderChain = false;
            s3.initialize();

            testCase.verifyNotEmpty(s3.Handle);
            s3.shutdown();
        end

        function testInitializationOtherCredentials(testCase)
            write(testCase.logObj,'debug','Testing testInitializationOtherCredentials');
            % Create the client and initialize using a temp copy of the
            % credentials file in the same directory
            currentCreds = which('credentials.json');
            [pathstr,~,~] = fileparts(currentCreds);

            newCreds = fullfile(pathstr, 'testInitializationOtherCredentials.json');
            copyfile(currentCreds,newCreds);

            s3 = aws.s3.Client();
            s3.useCredentialsProviderChain = false;
            s3.credentialsFilePath = newCreds;
            s3.initialize();

            testCase.verifyNotEmpty(s3.Handle);
            delete(newCreds);
            s3.shutdown();
        end

        function testlistBucketsBasic(testCase)
            write(testCase.logObj,'debug','Testing testlistBucketsBasic');
            % Create the client and initialize
            s3 = aws.s3.Client();
            s3.useCredentialsProviderChain = false;
            s3.initialize();

            myTable = s3.listBuckets();
            testCase.verifyEqual(class(myTable),'table');

            s3.shutdown();
        end

        function testclientConfigFail(testCase)
            write(testCase.logObj,'debug','Testing testclientConfigFail');
            % Create the client and initialize with a proxy that should
            % fail
            s3 = aws.s3.Client();
            s3.useCredentialsProviderChain = false;
            s3.clientConfiguration.setProxyHost('proxyHost','myproxy.example.com');
            s3.clientConfiguration.setProxyPort(8080);
            s3.initialize();
            testCase.verifyNotEmpty(s3.clientConfiguration.Handle);
            testCase.verifyError(@()s3.listBuckets(),'MATLAB:Java:GenericException');
            testCase.verifyNotEmpty(s3.Handle);
            s3.shutdown();
        end

        % Note: Uncomment this test with a valid proxy server to ensure that the
        % test passes
        %
        % function testclientConfigOkay(testCase)
            % proxyServer = 'validproxyserver.example.com';
            %
            % write(testCase.logObj,'debug','Testing testclientConfigOkay');
            % % Create the client and initialize with a proxy that should
            % % NOT fail
            % s3 = aws.s3.Client();
            % s3.clientConfiguration.setProxyHost('proxyHost',proxyServer);
            % s3.clientConfiguration.setProxyPort(3128);
            % s3.useCredentialsProviderChain = false;
            % s3.initialize();
            %
            % % create a bucket in order to have something to list
            % uniqName = lower(matlab.lang.makeValidName(['com.example.awss3.unittest',datestr(now)],'ReplacementStyle','delete'));
            % s3.createBucket(uniqName);
            %
            % % verify that dim 2 is equal to 4, dim 1 will vary with the number of buckets
            % mylist = s3.listBuckets();
            % testCase.verifyEqual(size(mylist,2),4);
            %
            % % verify that the bucket name is on the list
            % names = mylist.Name;
            % matches = strcmp(uniqName, names);
            %
            % testCase.verifyEqual(nnz(matches),1);
            % testCase.verifyNotEmpty(s3.clientConfiguration.Handle);
            % testCase.verifyNotEmpty(s3.Handle);
            % s3.shutdown();
        % end

        function testcreateBucket(testCase)
            write(testCase.logObj,'debug','Testing testcreateBucket');
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

        function testdoesBucketExist(testCase)
            write(testCase.logObj,'debug','Testing testdoesBucketExist');
            % Create the client and initialize
            s3 = aws.s3.Client();
            s3.useCredentialsProviderChain = false;
            s3.initialize();

            % Create a bucket
            uniqName = lower(matlab.lang.makeValidName(['com.example.awss3.unittest',datestr(now)],'ReplacementStyle','delete'));
            s3.createBucket(uniqName);

            myresult = s3.doesBucketExist(uniqName);

            % verify that there is one and only one match with the bucket
            testCase.verifyTrue(myresult);

            % cleanup
            s3.deleteBucket(uniqName);
            s3.shutdown();
            % force a short wait so next call to now sill always return a
            % new number
            pause(1.1);
        end

        function testdeleteBucket(testCase)
            write(testCase.logObj,'debug','Testing testdeleteBucket');
            % Create the client and initialize
            s3 = aws.s3.Client();
            s3.useCredentialsProviderChain = false;
            s3.initialize();

            % Create a bucket
            uniqName = lower(matlab.lang.makeValidName(['com.example.awss3.unittest',datestr(now)],'ReplacementStyle','delete'));
            s3.createBucket(uniqName);

            % verify it was created
            bucket_table = s3.listBuckets();
            names = bucket_table.Name;
            matches = strcmp(uniqName, names);
            testCase.verifyEqual(nnz(matches),1);

            % delete the bucket
            s3.deleteBucket(uniqName);

            % verify it is no longer listed
            bucket_table = s3.listBuckets();
            names = bucket_table.Name;
            matches = strcmp(uniqName, names);
            testCase.verifyEqual(nnz(matches),0);
            s3.shutdown();
            % allow now to increment
            pause(1.1);
        end

        function testlistBuckets(testCase)
            write(testCase.logObj,'debug','Testing testlistBuckets');
            % Create the client and initialize
            s3 = aws.s3.Client();
            s3.useCredentialsProviderChain = false;

            s3.initialize();

            % create a bucket in order to have something to list
            uniqName = lower(matlab.lang.makeValidName(['com.example.awss3.unittest',datestr(now)],'ReplacementStyle','delete'));
            s3.createBucket(uniqName);

            % verify that dim 2 is equal to 4, dim 1 will vary with the number of buckets
            mylist = s3.listBuckets();
            testCase.verifyEqual(size(mylist,2),4);

            % verify that the bucket name is on the list
            names = mylist.Name;
            matches = strcmp(uniqName, names);
            testCase.verifyEqual(nnz(matches),1);

            % cleanup the bucket and wait for a little time to elapse
            s3.deleteBucket(uniqName);
            s3.shutdown();
            pause(1.1);
        end

        function testputgetObject(testCase)
            write(testCase.logObj,'debug','Testing testputgetObject');
            % Create the client and initialize
            s3 = aws.s3.Client();
            s3.useCredentialsProviderChain = false;
            s3.initialize();

            % create a small block of data and save it to a file
            x = rand(100,100);
            uploadfile = [tempname,'.mat'];
            save(uploadfile, 'x');

            % create a bucket to hold the object
            bucketname = lower(matlab.lang.makeValidName(['com.example.awss3.unittest',datestr(now)],'ReplacementStyle','delete'));
            s3.createBucket(bucketname);

            % upload the file as an object
            s3.putObject(bucketname,uploadfile);

            % when downloaded the file will have the same name as the previously
            % uploaded file so delete that first, change over the variable
            % name for clarity
            downloadfile = uploadfile;
            delete(uploadfile);
            s3.getObject(bucketname,downloadfile);

            %compare the downloaded file to the original generate random values
            y = load(downloadfile,'x');

            testCase.verifyTrue(isequal(x,y.x));
            % remove the bucket and the contained object afterwards
            s3.deleteObject(bucketname,downloadfile);
            s3.deleteBucket(bucketname);
            s3.shutdown();
            % delete the temporary file
            delete(downloadfile);
            pause(1.1);
        end

        function testputgetObjectRelative(testCase)
            write(testCase.logObj,'debug','Testing testputgetObjectRelative');
            % Create the client and initialize
            s3 = aws.s3.Client();
            s3.useCredentialsProviderChain = false;

            s3.initialize();

            % create a small block of data and save it to a file
            x = rand(100,100);
            uploadfile = ['testputgetObjectRelative','.mat'];
            save(uploadfile, 'x');

            % create a bucket to hold the object
            bucketname = lower(matlab.lang.makeValidName(['com.example.awss3.unittest',datestr(now)],'ReplacementStyle','delete'));
            s3.createBucket(bucketname);

            % upload the file as an object
            s3.putObject(bucketname,uploadfile);

            % when downloaded the file will have the same name as the previously
            % uploaded file so delete that first, change over the variable
            % name for clarity
            downloadfile = uploadfile;
            delete(uploadfile);
            s3.getObject(bucketname,downloadfile);

            %compare the downloaded file to the original generate random values
            y = load(downloadfile,'x');

            testCase.verifyTrue(isequal(x,y.x));
            % remove the bucket and the contained object afterwards
            s3.deleteObject(bucketname,downloadfile);
            s3.deleteBucket(bucketname);
            s3.shutdown();
            % delete the temporary file
            delete(downloadfile);
            pause(1.1);
        end

        function testdoesObjectExist(testCase)
            write(testCase.logObj,'debug','Testing testdoesObjectExist');
            % Create the client and initialize
            s3 = aws.s3.Client();
            s3.useCredentialsProviderChain = false;

            s3.initialize();

            % create a small block of data and save it to a file
            x = rand(100,100);
            uploadfile = [tempname,'.mat'];
            save(uploadfile, 'x');

            % create a bucket to hold the object
            bucketname = lower(matlab.lang.makeValidName(['com.example.awss3.unittest',datestr(now)],'ReplacementStyle','delete'));
            s3.createBucket(bucketname);

            % upload the file as an object
            s3.putObject(bucketname,uploadfile);

            % check it exists
            myresult = s3.doesObjectExist(bucketname,uploadfile);

            testCase.verifyTrue(myresult);

            % remove the bucket and the contained object afterwards
            s3.deleteObject(bucketname,uploadfile);
            s3.deleteBucket(bucketname);
            s3.shutdown();
            % delete the temporary file
            delete(uploadfile);
            pause(1.1);
        end

        function testgetObjectAcl(testCase)
            write(testCase.logObj,'debug','Testing testgetObjectAcl');
            % Create the client and initialize
            s3 = aws.s3.Client();
            s3.useCredentialsProviderChain = false;
            s3.initialize();

            % create a small block of data and save it to a file
            x = rand(100,100);
            tmpName = [tempname,'.mat'];
            save(tmpName,'x');

            % create a bucket and object from which to get the ACL
            uniqName = lower(matlab.lang.makeValidName(['com.example.awss3.unittest',datestr(now)],'ReplacementStyle','delete'));
            s3.createBucket(uniqName);
            s3.putObject(uniqName,tmpName);

            % get the object and check the return type is correct
            % <should also check it is not empty> TODO
            acl = s3.getObjectAcl(uniqName,tmpName);
            testCase.verifyEqual(class(acl),'aws.s3.AccessControlList');
            testCase.verifyEqual(class(acl.Handle),'com.amazonaws.services.s3.model.AccessControlList');
            % test it is not empty by searching for a string it should
            % contain
            str = char(acl.Handle.toString);
            testCase.verifySubstring(str,'permission=');

            % remove the bucket and the contained object afterwards
            s3.deleteObject(uniqName,tmpName);
            s3.deleteBucket(uniqName);
            s3.shutdown();
            % delete the temporary file
            delete(tmpName);
            pause(1.1);
        end

        function testEmailAddressGrantee(testCase)
            write(testCase.logObj,'debug','Testing testEmailAddressGrantee');
            % Create the client and initialize
            s3 = aws.s3.Client();
            s3.useCredentialsProviderChain = false;
            s3.initialize();

            % Create a CanonicalGrantee object and test its type (RFC2606)
            email_addr_obj = aws.s3.EmailAddressGrantee('joe.blog@example.com');
            testCase.verifyEqual(class(email_addr_obj.Handle),'com.amazonaws.services.s3.model.EmailAddressGrantee');
            s3.shutdown();
        end

        function testGroupGrantee(testCase)
            write(testCase.logObj,'debug','Testing testGroupGrantee');
            % Create the client and initialize
            s3 = aws.s3.Client();
            s3.useCredentialsProviderChain = false;
            s3.initialize();

            % Create a GroupGrantee object and test its type
            group_grantee_obj = aws.s3.GroupGrantee('AllUsers');
            testCase.verifyEqual(class(group_grantee_obj.Handle),'com.amazonaws.services.s3.model.GroupGrantee');
            s3.shutdown();
        end

        %NOTE: Please uncomment this test with a canonical form of the
        %grantee to test this functionality.
        %
        % function testCanonicalGrantee(testCase)
        %     write(testCase.logObj,'debug','Testing testCanonicalGrantee');
        % 
        %     % Configure the canonical form of the grantee
        %     canonicalGrantee = 'aa64f60[ R E D A C T E D ]f0331199e0';
        % 
        %     % Create the client and initialize
        %     s3 = aws.s3.Client();
        %     s3.useCredentialsProviderChain = false;
        %     s3.initialize();
        % 
        %     % Create a CanonicalGrantee object and test its type
        %     canonical_obj = aws.s3.CanonicalGrantee(canonicalGrantee);
        %     testCase.verifyEqual(class(canonical_obj.Handle),'com.amazonaws.services.s3.model.CanonicalGrantee');
        %     s3.shutdown();
        % end

        function testdeleteObject(testCase)
            write(testCase.logObj,'debug','Testing testdeleteObject');
            % Create the client and initialize
            s3 = aws.s3.Client();
            s3.useCredentialsProviderChain = false;
            s3.initialize();

            % create a small block of data and save it to a file
            x = rand(100,100);
            tmpName = [tempname,'.mat'];
            save(tmpName,'x');

            % create a bucket and object from which to get the ACL
            uniqName = lower(matlab.lang.makeValidName(['com.example.awss3.unittest',datestr(now)],'ReplacementStyle','delete'));
            s3.createBucket(uniqName);
            s3.putObject(uniqName,tmpName,tmpName);

            % verify a table of the right size is returned and that it
            % contains the object name
            my_list = s3.listObjects(uniqName);
            testCase.verifyEqual(class(my_list),'table');
            testCase.verifyEqual(size(my_list,1),1);
            testCase.verifyEqual(size(my_list,2),5);
            name = char(my_list{1,1});
            testCase.verifySubstring(name,tmpName);

            % remove the bucket and the contained object afterwards
            s3.deleteObject(uniqName,tmpName);

            % verify an empty table is returned
            my_list = s3.listObjects(uniqName);
            testCase.verifyEqual(class(my_list),'table');
            testCase.verifyEqual(size(my_list,1),0);
            testCase.verifyEqual(size(my_list,2),0);

            s3.deleteBucket(uniqName);
            s3.shutdown();
            % delete the temporary file
            delete(tmpName);
            pause(1.1);
        end

        function testPermissions(testCase)
            write(testCase.logObj,'debug','Testing testPermissions');
            % Create a Permission object and test its type
            perm_enum = aws.s3.Permission('read');
            testCase.verifyEqual(class(perm_enum.Handle),'com.amazonaws.services.s3.model.Permission');
            testCase.verifyEqual(perm_enum.stringValue,'READ');

            perm_enum = aws.s3.Permission('write');
            testCase.verifyEqual(class(perm_enum.Handle),'com.amazonaws.services.s3.model.Permission');
            testCase.verifyEqual(perm_enum.stringValue,'WRITE');

            perm_enum = aws.s3.Permission('readacp');
            testCase.verifyEqual(class(perm_enum.Handle),'com.amazonaws.services.s3.model.Permission');
            testCase.verifyEqual(perm_enum.stringValue,'READ_ACP');

            perm_enum = aws.s3.Permission('writeacp');
            testCase.verifyEqual(class(perm_enum.Handle),'com.amazonaws.services.s3.model.Permission');
            testCase.verifyEqual(perm_enum.stringValue,'WRITE_ACP');

            perm_enum = aws.s3.Permission('fullcontrol');
            testCase.verifyEqual(class(perm_enum.Handle),'com.amazonaws.services.s3.model.Permission');
            testCase.verifyEqual(perm_enum.stringValue,'FULL_CONTROL');
        end

        function testlistObjects(testCase)
            write(testCase.logObj,'debug','Testing testlistObjects');
            % Create the client and initialize
            s3 = aws.s3.Client();
            s3.useCredentialsProviderChain = false;
            s3.initialize();

            % create a small block of data and save it to a file
            x = rand(100,100);
            tmpName = [tempname,'.mat'];
            save(tmpName,'x');

            % create a bucket and object from which to get the ACL
            uniqName = lower(matlab.lang.makeValidName(['com.example.awss3.unittest',datestr(now)],'ReplacementStyle','delete'));
            s3.createBucket(uniqName);
            s3.putObject(uniqName,tmpName);

            % verify a table of the right size is returned and that it
            % contains the object name
            my_list = s3.listObjects(uniqName);
            testCase.verifyEqual(class(my_list),'table');
            testCase.verifyEqual(size(my_list,1),1);
            testCase.verifyEqual(size(my_list,2),5);
            name = char(my_list{1,1});
            testCase.verifySubstring(name,tmpName);

            % remove the bucket and the contained object afterwards
            s3.deleteObject(uniqName,tmpName);
            s3.deleteBucket(uniqName);
            s3.shutdown();
            % delete the temporary file
            delete(tmpName);
            pause(1.1);
        end

        function testsetObjectAcl(testCase)
            write(testCase.logObj,'debug','Testing testsetObjectAcl');
            % Create the client and initialize
            s3 = aws.s3.Client();
            s3.useCredentialsProviderChain = false;
            s3.initialize();

            % create a small block of data and save it to a file
            x = rand(100,100);
            tmpName = [tempname,'.mat'];
            save(tmpName,'x');

            % get the owner of the account so we can use its canonical Id
            owner = s3.getS3AccountOwner();

            % create a bucket and object from which to get the ACL
            uniqName = lower(matlab.lang.makeValidName(['com.example.awss3.unittest',datestr(now)],'ReplacementStyle','delete'));
            s3.createBucket(uniqName);
            s3.putObject(uniqName,tmpName);

            initacl = s3.getObjectAcl(uniqName,tmpName);

            canonical_obj = aws.s3.CanonicalGrantee(owner.id);
            perm_enum = aws.s3.Permission('read');
            myacl = aws.s3.AccessControlList();
            myacl.grantPermission(canonical_obj, perm_enum);

            % build a new owner object to demonstrate process, could have reused
            % existing owner object
            newOwner  = aws.s3.Owner();
            newOwner.setDisplayName(owner.displayName);
            newOwner.setId(owner.id);
            myacl.setOwner(newOwner);

            s3.setObjectAcl(uniqName, tmpName, myacl);
            newacl = s3.getObjectAcl(uniqName,tmpName);
            % validate
            grants = newacl.getGrantsAsList();
            testCase.verifyEqual(numel(grants),1);
            grantee = grants{1}.getGrantee();
            permission = grants{1}.getPermission();
            testCase.verifyClass(grantee, 'aws.s3.CanonicalGrantee');
            testCase.verifyEqual(grantee.Identifier,owner.id);
            testCase.verifyClass(permission, 'aws.s3.Permission');
            testCase.verifyEqual(permission.stringValue,'READ');

            % remove the bucket and the contained object afterwards
            s3.deleteObject(uniqName,tmpName);
            s3.deleteBucket(uniqName);
            s3.shutdown();
            % delete the temporary file
            delete(tmpName);
            pause(1.1);
        end

        function testMetadata(testCase)
            write(testCase.logObj,'debug','Testing testMetadata');
            % Create the client and initialize
            s3 = aws.s3.Client();
            s3.useCredentialsProviderChain = false;
            s3.initialize();

            % create a small block of data and save it to a file
            x = rand(100,100);
            tmpName = [tempname,'.mat'];
            save(tmpName,'x');
            myKey = 'myobjectkey';

            % create a bucket and object from which to get the metadata
            uniqName = lower(matlab.lang.makeValidName(['com.example.awss3.unittest',datestr(now)],'ReplacementStyle','delete'));
            s3.createBucket(uniqName);

            % configure some metadata
            myMetadata = aws.s3.ObjectMetadata();
            myMetadata.addUserMetadata('myMDKey1', 'myMDValue1');
            myMetadata.addUserMetadata('myMDKey2', 'myMDValue2');
            myMetadata.addUserMetadata('myMDKey3', 'myMDValue3');

            % upload to s3
            s3.putObject(uniqName, tmpName, myKey, myMetadata);
            % get the metadata for the object from s3
            myDownloadedMetadata = s3.getObjectMetadata(uniqName, myKey);
            % get a containers.Map containing the metAdata
            myMap = myDownloadedMetadata.getUserMetadata();
            testCase.verifyEqual(myMap('mymdkey1'), 'myMDValue1');
            testCase.verifyEqual(myMap('mymdkey2'), 'myMDValue2');
            testCase.verifyEqual(myMap('mymdkey3'), 'myMDValue3');

            % remove the bucket and the contained object afterwards
            s3.deleteObject(uniqName,myKey);
            s3.deleteBucket(uniqName);
            s3.shutdown();
            % delete the temporary file
            delete(tmpName);
            pause(1.1);
        end
    end
end
