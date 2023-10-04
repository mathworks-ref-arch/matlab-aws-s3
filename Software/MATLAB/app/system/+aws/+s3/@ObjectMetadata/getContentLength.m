function ContentLength = getContentLength(obj)
    % GETCONTENTLENGTH Gets the length of the object in bytes
    % Gets the Content-Length HTTP header indicating the size of the associated
    % object in bytes.
    % An int64 is returned.

    % Copyright 2018-2023 The MathWorks, Inc.

    ContentLength = aws.s3.mathworks.internal.int64FnHandler(obj);
end
