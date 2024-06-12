function relativePaths = extractRelativePaths(filePaths, prefix)
    % Initialize the cell array to store the relative paths
    relativePaths = cell(size(filePaths));
    
    % Define the prefix to search for
   % prefix = 'data_release_7.0';
    
    % Iterate through the file paths
    for k = 1:length(filePaths)
        % Find the start index of the prefix in the current file path
        idx = strfind(filePaths{k}, prefix);
        
        if ~isempty(idx)
            % Extract the part of the file path after the prefix
            relativePaths{k} = filePaths{k}(idx + length(prefix):end);
        else
            % If the prefix is not found, return the original path
            relativePaths{k} = filePaths{k};
        end
    end
end
