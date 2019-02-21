classdef CannedAccessControlList < aws.Object
    % CANNEDACCESSCONTROLLIST class to define a canned ACL object
    % Canned access control lists are commonly used ACLs
    % that can be used as a shortcut when applying an ACL to Amazon S3
    % buckets or objects. A few commonly used configurations are available
    % as an alternative to manually creating a ACL.
    %
    % Example:
    %   myCannedACL = aws.s3.CannedAccessControlList('AuthenticatedRead')
    %
    % The following Canned ACLs are defined:
    % AuthenticatedRead
    % Specifies the owner is granted Permission.FullControl and the
    % GroupGrantee.AuthenticatedUsers group grantee is granted
    % Permission.Read access.
    %
    % AwsExecRead
    % Specifies the owner is granted Permission.FullControl.
    %
    % BucketOwnerFullControl
    % Specifies the owner of the bucket, but not necessarily the same as
    % the owner of the object, is granted Permission.FullControl.
    %
    % BucketOwnerRead
    % Specifies the owner of the bucket, but not necessarily the same as
    % the owner of the object, is granted Permission.Read.
    %
    % LogDeliveryWrite
    % Specifies the owner is granted Permission.FullControl and the
    % GroupGrantee.LogDelivery group grantee is granted Permission.Write
    % access so that access logs can be delivered.
    %
    % Private
    % Specifies the owner is granted Permission.FullControl.
    %
    % PublicRead
    % Specifies the owner is granted Permission.FullControl and the
    % GroupGrantee.AllUsers group grantee is granted Permission.Read access.
    %
    % PublicReadWrite
    % Specifies the owner is granted Permission.FullControl and the
    % GroupGrantee.AllUsers group grantee is granted Permission.Read and
    % Permission.Write access.
    %

    % Copyright 2017 The MathWorks, Inc.

    properties (SetAccess = immutable)
        stringValue;
    end

    methods
        function obj = CannedAccessControlList(cannedVal)
            import com.amazonaws.services.s3.model.CannedAccessControlList

            logObj = Logger.getLogger();

            cannedVal = upper(cannedVal);
            write(logObj,'verbose',['Creating CannedAccessControlList: ',cannedVal]);

            switch (cannedVal)
                case 'AUTHENTICATEDREAD'
                    obj.Handle = CannedAccessControlList.AuthenticatedRead;
                case 'AWSEXECREAD'
                    obj.Handle = CannedAccessControlList.AwsExecRead;
                case 'BUCKETOWNERFULLCONTROL'
                    obj.Handle = CannedAccessControlList.BucketOwnerFullControl;
                case 'BUCKETOWNERREAD'
                    obj.Handle = CannedAccessControlList.BucketOwnerRead;
                case 'LOGDELIEVERYWRITE'
                    obj.Handle = CannedAccessControlList.LogDeliveryWrite;
                case 'PRIVATE'
                    obj.Handle = CannedAccessControlList.Private;
                case 'PUBLICREAD'
                    obj.Handle = CannedAccessControlList.PublicRead;
                case 'PUBLICREADWRITE'
                    obj.Handle = CannedAccessControlList.PublicReadWrite;
                otherwise
                    write(logObj,'error',['Invalid CannedAccessControlList enumeration value: ',cannedVal,' Permitted values are: AuthenticatedRead, AwsExecRead, BucketOwnerFullControl, BucketOwnerRead, LogDeliveryWrite, Private, PublicRead and PublicReadWrite(case insensitive)']);
            end
            % store the toString() value but as a char array
            obj.stringValue = char(obj.Handle.toString());
        end %function
    end %methods

end %class
