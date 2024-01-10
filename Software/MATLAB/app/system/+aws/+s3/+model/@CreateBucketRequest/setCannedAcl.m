function setCannedAcl(obj, cannedAcl)
    % SETCANNEDACL Sets the optional Canned ACL to set for the new bucket

    % Copyright 2023 The MathWorks, Inc.

    if isa(cannedAcl, 'aws.s3.CannedAccessControlList')
        obj.Handle.setCannedAcl(cannedAcl.Handle);
    else
        logObj = Logger.getLogger();
        write(logObj,'error', 'Expected argument of type aws.s3.CannedAccessControlList');
    end

end