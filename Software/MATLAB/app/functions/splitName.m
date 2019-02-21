function S = splitName(str)
    % SPLITNAME Splits an s3 name into bucket and a list of names
    %
    % Splitting the name of an S3 object may be helpful when working with
    % methods like putObject and getObject.
    %
    % Example:
    %   S = splitName('s3://mybucket/some/other/paths')
    %
    %   S =
    %       struct with fields:
    %
    %         protocol: 's3://'
    %           bucket: 'mybucket'
    %             rest: 'some/other/paths'
    %         elements: {'some'  'other'  'paths'}
    %              str: 's3://mybucket/some/other/paths'

    % Copyright 2018 The MathWorks, Inc.

    S = regexp(str, [...
        '(?<protocol>[sS]3://)?', ...
        '(?<bucket>[^/]+)', ...
        '/?(?<rest>.*)', ...
        ], 'names');
   if ~isempty(S.rest)
      elms = regexp(S.rest, '([^/]+)', 'tokens');
      S.elements = [elms{:}];
   else
       S.elements = {};
   end
   S.str = str;

end
