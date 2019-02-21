classdef testProviderChainEC2 < matlab.unittest.TestCase
    % TESTCLIENTSTS Unit Test for the Amazon S3 Client using Provider Chain Authentication
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
            % Create the object
            s3 = aws.s3.Client();
            
            testCase.verifyClass(s3,'aws.s3.Client');
        end
        
        % Test to check if the execution is happening on AWS EC2
        function testInitializationIAMRole(testCase)
            if ~isEC2
                
                warning('testCase must be run in an EC2 environment');
                
            else
                
                % Create the client and initialize using IAM Role
                testCase.verifyTrue(isEC2);
                
                s3 = aws.s3.Client();
                
                % Check AWS_REGION not set
                regionVal = char(java.lang.System.getenv('AWS_REGION'));
                write(testCase.logObj,'debug',['Region env var should be empty: ', regionVal]);
                testCase.verifyEmpty(regionVal);
                
                s3.initialize();
                testCase.verifyNotEmpty(s3.Handle);
                
                s3.shutdown();
            end
        end
        
    end
end

