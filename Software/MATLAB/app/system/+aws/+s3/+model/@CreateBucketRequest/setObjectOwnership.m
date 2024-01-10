function setObjectOwnership(obj, objectOwnership)
    % SETOBJECTOWNERSHIP Sets the optional object ownership for the new bucket
    %
    % Valid string values are:
    %
    % BucketOwnerPreferred - Objects uploaded to the bucket change ownership to
    %                        the bucket owner if the objects are uploaded with
    %                        the bucket-owner-full-control canned ACL.
    %
    %         ObjectWriter - The uploading account will own the object if the
    %                        object is uploaded with the bucket-owner-full-control
    %                        canned ACL.
    %
    %  BucketOwnerEnforced - ACLs are disabled, and the bucket owner owns all the
    %                        objects in the bucket. Objects can only be uploaded
    %                        to the bucket if they have no ACL or the
    %                        bucket-owner-full-control canned ACL. 

    % Copyright 2023 The MathWorks, Inc.

    if ischar(objectOwnership)
        obj.Handle.setObjectOwnership(objectOwnership);
    else
        logObj = Logger.getLogger();
        write(logObj,'error', 'Expected argument of type character vector');
    end

end
