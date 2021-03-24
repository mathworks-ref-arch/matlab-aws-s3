classdef testAcl < matlab.unittest.TestCase
    % TESTCLIENT Unit Test for the Amazon S3 Client
    %
    %
    % The test suite exercises the basic operations on the S3 Client ACLs,
    % Owners and Permissions.

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
            % Create the object
            write(testCase.logObj,'debug','Testing ACL constructor');
            acl = aws.s3.AccessControlList();

            testCase.verifyEqual(class(acl.Handle),'com.amazonaws.services.s3.model.AccessControlList');
            testCase.verifyEqual(class(acl),'aws.s3.AccessControlList');
        end

        function testcreateOwner(testCase)
            write(testCase.logObj,'debug','Testing Owner constructor');
            owner = aws.s3.Owner();

            testCase.verifyEqual(class(owner.Handle),'com.amazonaws.services.s3.model.Owner');
            testCase.verifyEqual(class(owner),'aws.s3.Owner');
        end

        function testgetGrantsAsList(testCase)
            % Create the client and initialize
            write(testCase.logObj,'debug','Testing getGrantsAsList');

            s3 = aws.s3.Client();
            if strcmpi(getenv('GITLAB_CI'), 'true')
                s3.useCredentialsProviderChain = false;
            else
                s3.useCredentialsProviderChain = true;
            end
            s3.initialize();

            % create a small block of data and save it to a file
            x = rand(100,100);
            tmpName = [tempname,'.mat'];
            save(tmpName,'x');
            % create a bucket to hold the object
            uniqName = lower(matlab.lang.makeValidName(['com.example.awss3.unittest',datestr(now)],'ReplacementStyle','delete'));
            s3.createBucket(uniqName);
            % upload the file as an object
            s3.putObject(uniqName,tmpName);
            % get the acl from the newly created object
            acl = s3.getObjectAcl(uniqName,tmpName);
            % getGrantsAsList() on a MATLAB aws.s3.acl object
            % returns a cell array that contains the MATLAB Grants
            grantlist = acl.getGrantsAsList();
            % check for a returned cell array
            testCase.verifyTrue(iscell(grantlist));

            % create a MATLAB wrapped Acl object
            myacl = aws.s3.AccessControlList();
            % Configure a Grantee and permission
            emailAddress = 'joe.blog@example.com';
            email_addr_obj = aws.s3.EmailAddressGrantee(emailAddress);
            permission = 'read';
            perm_enum = aws.s3.Permission(permission);
            % Grant the permission to the Acl
            myacl.grantPermission(email_addr_obj, perm_enum);
            % This getGrantsAsList() returns a cell array not a JAVA linked list
            mygrantlist = myacl.getGrantsAsList();
            % we assume that mygrantlist will contain only a single grant
            testCase.verifyEqual(numel(mygrantlist),1);
            % verify by looking inside it for the strings we expect
            granteeResult = mygrantlist{1,1}.getGrantee();
            testCase.verifyEqual(granteeResult.Identifier, emailAddress);
            permissionResult = mygrantlist{1}.getPermission();
            testCase.verifyEqual(permissionResult.stringValue, upper(permission));

            % remove the bucket and the contained object afterwards
            s3.deleteObject(uniqName,tmpName);
            s3.deleteBucket(uniqName);
            delete(tmpName);
            s3.shutdown();
            pause(1.1);
        end

        function testgetBucketAcl(testCase)
            % Create the client and initialize
            write(testCase.logObj,'debug','Testing getBucketAcl');
            s3 = aws.s3.Client();
            if strcmpi(getenv('GITLAB_CI'), 'true')
                s3.useCredentialsProviderChain = false;
            else
                s3.useCredentialsProviderChain = true;
            end
            s3.initialize();
            % create a bucket to hold the object
            uniqName = lower(matlab.lang.makeValidName(['com.example.awss3.unittest',datestr(now)],'ReplacementStyle','delete'));
            s3.createBucket(uniqName);

            myACL = s3.getBucketAcl(uniqName);
            grants = myACL.getGrantsAsList();
            testCase.verifyEqual(numel(grants),1);
            grantee = grants{1}.getGrantee();
            permission = grants{1}.getPermission();

            testCase.verifyClass(grantee, 'aws.s3.CanonicalGrantee');
            testCase.verifyEqual(permission.stringValue, 'FULL_CONTROL');

            s3.deleteBucket(uniqName);
            s3.shutdown();
            pause(1.1);
        end

        function testgrantPermissionHandle(testCase)
            write(testCase.logObj,'debug','Testing grantPermission');
            % Create the top level ACL object
            myacl = aws.s3.AccessControlList();

            % Configure a Grantee and permission
            email_addr_obj = aws.s3.EmailAddressGrantee('joe.blog@example.com');
            perm_enum = aws.s3.Permission('read');
            testCase.verifyEqual(perm_enum.stringValue,'READ');

            % Grant the permission to the ACL
            myacl.grantPermission(email_addr_obj, perm_enum);

            % extract the ACL as a string and verify an expected value in
            % the Handle
            str = char(myacl.Handle.toString());
            testCase.verifySubstring(str,'grantee=joe.blog@example.com, permission=READ');
            % test at the object level too
            grants = myacl.getGrantsAsList();
            testCase.verifyEqual(numel(grants),1);
            grantee = grants{1}.getGrantee();
            permission = grants{1}.getPermission();
            testCase.verifyClass(grantee, 'aws.s3.EmailAddressGrantee');
            testCase.verifyEqual(grantee.Identifier,'joe.blog@example.com');
            testCase.verifyClass(permission, 'aws.s3.Permission');
            testCase.verifyEqual(permission.stringValue,'READ');

        end

        function testgroupGrantee(testCase)
            write(testCase.logObj,'debug','Testing GroupGrantee');

            % test setting a groupGrantee
            my_group_grantee = aws.s3.GroupGrantee('AllUsers');
            testCase.verifyTrue(strcmp(my_group_grantee.Identifier,'http://acs.amazonaws.com/groups/global/AllUsers'));
            my_perm = aws.s3.Permission('read');
            my_acl = aws.s3.AccessControlList();
            my_acl.grantPermission(my_group_grantee, my_perm);

            % extract the ACL as a string and verify an expected value
            str = char(my_acl.Handle.toString());
            testCase.verifySubstring(str,'http://acs.amazonaws.com/groups/global/AllUsers], permission=READ');
        end

        function testcanonicalGrantee(testCase)
            write(testCase.logObj,'debug','Testing CanonicalGrantee');

            % test setting a Canonical grantee
            % note this is not a valid AWS canonical Id
            id = 'd25639fbe9c19cd30a4c0f43fbf00e2d3f96400a9aa8dabfbbebe1906Example';
            my_canonical_grantee = aws.s3.CanonicalGrantee(id);
            testCase.verifyTrue(strcmp(my_canonical_grantee.Identifier,id));
            my_perm = aws.s3.Permission('read');
            my_acl = aws.s3.AccessControlList();
            my_acl.grantPermission(my_canonical_grantee, my_perm);

            % extract the ACL as a string and verify an expected value in
            % the Handle
            str = char(my_acl.Handle.toString());
            testCase.verifySubstring(str,'[Grant [grantee=com.amazonaws.services.s3.model.CanonicalGrantee@');
            grants = my_acl.getGrantsAsList();
            testCase.verifyEqual(numel(grants),1);
            grantee = grants{1}.getGrantee();
            testCase.verifyEqual(grantee.Identifier,id);
        end

        function testsetOwnerDisplayName(testCase)
            write(testCase.logObj,'debug','Testing setDisplayName');
            % Create the owner object
            owner = aws.s3.Owner();
            % set the displayname property of the owner
            owner.setDisplayName('my_disp_name');

            % check the value returned is that set previously
            testCase.verifyEqual(char(owner.Handle.getDisplayName()),'my_disp_name');
            testCase.verifyEqual(owner.displayName,'my_disp_name');
        end

        function testsetOwnerId(testCase)
            write(testCase.logObj,'debug','Testing setId');
            % Create the Owner object
            owner = aws.s3.Owner();
            % set the displayname property of the owner
            owner.setId('1234567890abcdef');

            % check the value returned is that set previously
            testCase.verifyEqual(char(owner.Handle.getId()),'1234567890abcdef');
            testCase.verifyEqual(owner.id,'1234567890abcdef');
        end
    end
end
