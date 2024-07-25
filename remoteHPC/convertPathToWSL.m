function wslPath = convertPathToWSL(winPath)
    % Convert a Windows path to a WSL-compatible path
    % Replace backslashes with forward slashes
    wslPath = strrep(winPath, '\', '/');
    
    % Replace 'C:' with '/mnt/c'
    wslPath = strrep(wslPath, 'C:', '/mnt/c');
    
    % Enclose in quotes to handle spaces
    wslPath = ['"' wslPath '"'];
end