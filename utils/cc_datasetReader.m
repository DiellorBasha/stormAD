
remoteRepositoryPath = '/project/def-jpoirier/PREVENT-AD/data_release_7.0/'
localFilePath = '/export02/data/dbasha/PAD7/data_release_7.0/dataset_structure.txt';

%scp username@beluga.computacanada.ca:path/to/file.f
%/path/to/local/directory

% example
%scp dbasha@beluga.computecanada.ca:projects/def-baillet/dbasha/dataset_structure.txt /export02/data/dbasha/PAD7/data_release_7.0/

fileID = fopen(localFilePath, 'r'); 
filePaths = textscan(fileID, '%s', 'Delimiter', '\n');
filePaths = filePaths{1};
fclose(fileID); 

% Initialize tables
subjects = table([], 'VariableNames', {'SubjectName'});
sessions = table([],[], 'VariableNames', {'SubjectID', 'SesssionName'});


fileTypes = table([1; 2; 3], {'raw'; 'repository_derivative'; 'local_derivative'}, 'VariableNames', {'FileTypeID', 'TypeName'});
files = table([], [], [], '', '', '', 'VariableNames', {'SessionID', 'FileTypeID', 'FilePath', 'FileName', 'Source', 'OtherMetadata'});

% Initialize counters and maps
subjectIDMap = containers.Map('KeyType', 'char', 'ValueType', 'int32');
sessionIDMap = containers.Map('KeyType', 'char', 'ValueType', 'int32');
subjectCounter = 0;
sessionCounter = 0;

% Parse the file paths
for i = 1:length(filePaths)
    fullPath = filePaths{i};
    relativePath = strrep(fullPath, remoteRepositoryPath, '');
    pathParts = strsplit(fullPath, filesep);
    
    if length(pathParts) < 3
        continue; % Skip invalid paths
    end
    
    subjectName = pathParts{3};
    sessionName = pathParts{4};
    fileName = pathParts{end};
    
    % Add or get Subject ID
    if ~isKey(subjectIDMap, subjectName)
        subjectCounter = subjectCounter + 1;
        subjectIDMap(subjectName) = subjectCounter;
        subjects = [subjects; {subjectName}];
    end
    subjectID = subjectIDMap(subjectName);
    
    % Add or get Session ID
    sessionKey = [subjectName, '_', sessionName];
    if ~isKey(sessionIDMap, sessionKey)
        sessionCounter = sessionCounter + 1;
        sessionIDMap(sessionKey) = sessionCounter;
        sessions = [sessions; {subjectID, sessionName}];
    end
    sessionID = sessionIDMap(sessionKey);
    
    % Add file information
    files = [files; {sessionID, 1, fullPath, fileName, 'repository', '{}'}]; % Assuming raw data
end

% Display the tables
disp(subjects);
disp(sessions);
disp(fileTypes);
disp(files);