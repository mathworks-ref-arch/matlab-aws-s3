function userMetadata = getUserMetaDataOf(obj, key)
    % GETUSERMETADATAOF Returns the value of the specified user meta datum

    % Copyright 2023 The MathWorks, Inc.

    if ischar(key) || isStringScalar(key)
        userMetadata = char(obj.Handle.getUserMetaDataOf(key));
    else
        logObj = Logger.getLogger();
        write(logObj,'error','Invalid input');
    end
end