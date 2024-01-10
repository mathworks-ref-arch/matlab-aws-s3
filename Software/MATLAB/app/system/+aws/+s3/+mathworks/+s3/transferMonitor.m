function transferMonitor(transfer, varargin)
    % TRANSFERMONITOR Provides visual feedback for the progression of a transfer
    %
    % The following named parameters are accepted:
    %    delay : delay in seconds between updates, (default 10)
    %     mode : display a "percentage" value or a number of "bytes", (default percentage) 
    %  display : "scroll" provide updates on progressive console lines (default)
    %            "static" provide updates on a single console line
    %
    % Examples:
    %   upload = tm.upload(testCase.bucketName, keyName, localPath);
    %   aws.s3.mathworks.s3.transferMonitor(upload);
    %
    %   aws.s3.mathworks.s3.transferMonitor(download, 'mode', 'bytes', 'display', 'static', 'delay', 1);

    % Copyright 2023 The MathWorks, Inc.

    validString = @(x) ischar(x) || isStringScalar(x);
    validFreq = @(x) (isa(x,'double') || isa(x,'int32') || isa(x,'int64')) && gt(x,0);

    p = inputParser;
    p.CaseSensitive = false;
    p.FunctionName = mfilename;
    addOptional(p,'delay', 10, validFreq);
    addOptional(p,'mode', 'percent', validString);
    addOptional(p,'display', 'scroll', validString);
    parse(p,varargin{:})

    if isa(transfer, 'aws.s3.transfer.Download') || ...
       isa(transfer, 'aws.s3.transfer.Upload')
        if strcmpi(p.Results.mode, 'percent')
            percentReport(transfer, p.Results.delay, p.Results.display);
        elseif strcmpi(p.Results.mode, 'bytes')
            bytesReport(transfer, p.Results.delay, p.Results.display);
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Only percentage base reporting is current supported');
        end
    else
        logObj = Logger.getLogger();
        write(logObj,'error','Expected transfer to be of type aws.s3.transfer.Download or aws.s3.transfer.Upload');
    end

end


function bytesReport(tx, delay, display)
    tp = tx.getProgress();
    total = tp.getTotalBytesToTransfer;
    fieldWidth = 0;
    while ~tx.isDone
        tp = tx.getProgress();
        done = tp.getBytesTransferred;
        fieldWidth = displayBytes(total, done, fieldWidth, display);
        pause(delay);
    end
    done = total;
    displayBytes(total, done, fieldWidth, display);
    if strcmp(display, 'static')
        fprintf(1,"\n");
    end
    tx.waitForCompletion();
end


function fieldWidth = displayBytes(total, done, fieldWidth, display)
    if strcmp(display, 'scroll')
        fprintf(1,"%ld/%ld bytes\n", done, total);
    elseif strcmp(display, 'static')
        bytesStr = sprintf("%ld/%ld bytes", done, total);
        specials = "";
        for n = 1:fieldWidth
            specials = specials + sprintf("\b");
        end
        fprintf(1,"%s%s", specials, bytesStr);
        fieldWidth = strlength(bytesStr);
    else
        logObj = Logger.getLogger();
        write(logObj,'error',"Supported display modes are 'static' and 'scroll'");
    end
end


function percentReport(tx, delay, display)
    fieldWidth = 0;
    while ~tx.isDone
        tp = tx.getProgress();
        percentage = tp.getPercentTransferred;
        fieldWidth = displayPercentage(percentage, fieldWidth, display);
        pause(delay);
    end
    percentage = 100;
    displayPercentage(percentage, fieldWidth, display);
    if strcmp(display, 'static')
        fprintf(1,"\n");
    end
    tx.waitForCompletion();
end


function fieldWidth = displayPercentage(pc, fieldWidth, display)
    if strcmp(display, 'scroll')
        percentStr = sprintf('%3.0f%%\n', pc);
        percentStr = pad(percentStr, 4, 'left');
        fprintf(1,"%s", percentStr);
    elseif strcmp(display, 'static')
        percentStr = sprintf('%3.0f%%', pc);
        percentStr = pad(percentStr, 4, 'left');
        specials = "";
        for n = 1:fieldWidth
            specials = specials + sprintf("\b");
        end
        fprintf(1,"%s%s", specials, percentStr);
        fieldWidth = strlength(percentStr);
    else
        logObj = Logger.getLogger();
        write(logObj,'error',"Supported display modes are 'static' and 'scroll'");
    end
end