function subjectFolderPath = findSubjectFolder(subjectName, baseDir)
    % List all folders in the base directory
    dirInfo = dir(baseDir);
    
    % Filter out non-folders and '.' and '..'
    dirInfo = dirInfo([dirInfo.isdir] & ~ismember({dirInfo.name}, {'.', '..'}));
    
    % Initialize the output variable
    subjectFolderPath = '';
    
    % Loop through each folder and check if the name matches the subject name
    for k = 1:numel(dirInfo)
        if strcmp(dirInfo(k).name, subjectName)
            subjectFolderPath = fullfile(baseDir, dirInfo(k).name);
            return;
        end
    end
    
    % If no match is found, display a message
    if isempty(subjectFolderPath)
        disp(['No folder found for subject ', subjectName]);
    end
end
