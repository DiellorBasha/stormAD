function lastPart = extractLastPart(filename)
    % EXTRACTLASTPART Helper function: Extract the last part of a filename
    % after the underscore
    % Used to find BIDS-annotated files such as _T1w, _FLAIR, _pet.
   
    % Remove the file extension
    [~, name, ~] = fileparts(filename);
    
    % Find the position of the last underscore
    underscoreIdx = strfind(name, '_');
    
    if isempty(underscoreIdx)
        error('The filename does not contain underscores.');
    end
    
    % Extract the last part of the filename
    lastPart = name(underscoreIdx(end)+1:end);
end
