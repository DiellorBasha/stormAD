function jsonFiles = findAllJsonFiles(folder)
    % Find all .json files in a folder and all its subfolders
    % Inputs:
    %   folder - The path to the folder where the search will start
    % Outputs:
    %   jsonFiles - A cell array containing the full paths to the .json files found

    % Initialize the cell array to hold the paths of the .json files
    jsonFiles = {};
    
    % Create a recursive function to search for .json files
    function searchForJsonFiles(currentFolder)
        % Get a list of all files and folders in the current folder
        dirData = dir(currentFolder);
        % Extract the folder names
        subDirs = {dirData([dirData.isdir]).name};
        % Remove the '.' and '..' directories
        subDirs = subDirs(~ismember(subDirs, {'.', '..'}));
        
        % Look for .json files in the current folder
        for i = 1:length(dirData)
            % Check if the file has a .json extension
            if ~dirData(i).isdir && endsWith(dirData(i).name, '.json')
                % Add the full path of the .json file to the cell array
                jsonFiles{end+1} = fullfile(currentFolder, dirData(i).name); %#ok<AGROW>
            end
        end
        
        % Recursively search in each subfolder
        for i = 1:length(subDirs)
            searchForJsonFiles(fullfile(currentFolder, subDirs{i}));
        end
    end

    % Start the search from the input folder
    searchForJsonFiles(folder);
end
