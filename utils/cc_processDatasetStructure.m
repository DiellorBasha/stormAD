% Prompt the user to input the remote repository path
remoteRepositoryPath = input('Enter the remote repository path (e.g., /project/def-jpoirier/PREVENT-AD/data_release_7.0): ', 's');

% Define the path to the dataset structure file
datasetFilePath = 'data/PAD7/data_release_7.0_Info/dataset_structure.txt';

% Read the file contents
fileID = fopen(datasetFilePath, 'r');
filePaths = textscan(fileID, '%s', 'Delimiter', '\n');
fclose(fileID);
filePaths = filePaths{1};

% Remove the remote repository path to make the paths relative
cleanedPaths = strrep(filePaths, remoteRepositoryPath, '');

% Save cleaned paths for the next step
cleanedFilePath = 'data/PAD7/data_release_7.0_Info/cleaned_dataset_structure.txt';
fileID = fopen(cleanedFilePath, 'w');
fprintf(fileID, '%s\n', cleanedPaths{:});
fclose(fileID);
%% 

% Define the path to the cleaned dataset structure file
cleanedFilePath = 'data/PAD7/data_release_7.0_Info/cleaned_dataset_structure.txt';

% Read the cleaned file contents
datasetStructure = cc_readDatasetStructure(cleanedFilePath);

datasets = unique(datasetStructure.dataset);

    % Split the table into different datasets
petDataset = datasetStructure(strcmp(datasetStructure.dataset, 'pet'), :);
mriDataset = datasetStructure(strcmp(datasetStructure.dataset, 'mri'), :);

    % Split petDataset into derivatives and raw
                  
             rawPET = petDataset(contains(petDataset.subject, 'sub-'),:);
             petModalities = unique(rawPET.modality(~ismissing(rawPET.modality)));         
             petSessions = unique(rawPET.session(~ismissing(rawPET.session) & contains(rawPET.session,'ses-')));
             petSubjects = unique(rawPET.subject(~ismissing(rawPET.subject) & contains(rawPET.subject, 'sub-')));
             petAbeta = unique(rawPET.file(~ismissing(rawPET.file) & contains(rawPET.file, 'trc-18FNAV4694') & contains(rawPET.file, 'nii.gz')));
             petTau = unique(rawPET.file(~ismissing(rawPET.file) & contains(rawPET.file, 'trc-18Fflortaucipir') & contains(rawPET.file, 'nii.gz')));
             
             derivativesPET = petDataset(contains(petDataset.subject, 'derivatives'),:);
             derivativesPET = renamevars(derivativesPET, ["subject", "session", "modality", "file", "file_deriv"], ...
                                                          ["derivatives", "pipeline", "subject", "session", "file"]);
             wavesMRI = mriDataset(contains(mriDataset.subject, 'wave'),:);
             wavesMRI = renamevars(wavesMRI, ["subject", "session", "modality", "file", "file_deriv"], ...
                                                          ["waves", "subject", "session", "modality", "file"]);
             
             mriWaves = unique(wavesMRI.waves(~ismissing(wavesMRI.waves) & contains(wavesMRI.waves,'wave')));
             mriModalities = unique(wavesMRI.modality(~ismissing(wavesMRI.modality)));         
             mriSessions = unique(wavesMRI.session(~ismissing(wavesMRI.session) & contains(wavesMRI.session,'ses-')));
             mriSubjects = unique(wavesMRI.subject(~ismissing(wavesMRI.subject) & contains(wavesMRI.subject,'sub-')));
            
             for k = 1:length(mriModalities)
             mriData(k).modality = mriModalities(k);
             mriData(k).data = unique(wavesMRI.file(~ismissing(wavesMRI.file) & contains(wavesMRI.modality, mriModalities(k)) & contains(wavesMRI.file, 'nii.gz')));
             mriData(k).T1 = unique(wavesMRI.file(~ismissing(wavesMRI.file) & contains(wavesMRI.modality, mriModalities(k)) & contains(wavesMRI.file, '_T1w.nii.gz')));
             mriData(k).T1runs = unique(wavesMRI.file(~ismissing(wavesMRI.file) & contains(wavesMRI.modality, mriModalities(k)) & contains(wavesMRI.file, '_T1w.nii.gz') & contains(wavesMRI.file, 'run')));
             end

            rf = rowfilter(wavesMRI)

            mriAnat = wavesMRI(rf.modality == "anat", :);
            subjectsMulti = sessionJoin.sub;
            joinKey = string(sessionJoin.sub)
            
            mriAnatSub = innerjoin( mriAnat, sessionJoin, "Keys", "subject");
             rf = rowfilter(  mriAnatSub )

             mriT1 =  mriAnatSub(endsWith(mriAnatSub.file, '_T1w.nii.gz'), :);
               
             for k = 1:height(mriT1)              
             sBase{k,1}  = mriT1.session{k}(1:8);
             end
                              mriT1.sessionBase = sBase
sessionJoinLabels = sessionJoin.sessionBase;
mriT1Labels = mriT1.sessionBase;

% Find the rows in mriT1 that match sessionJoin labels
matchingRows = ismember(mriT1Labels, sessionJoinLabels);

% Obtain the subset of mriT1 with matching session labels
subset_mriT1 = mriT1(matchingRows, :);
            maxComponents = 0;
                    for k = 1:length(mriAnat)
                        currentFile = strsplit(mriAnat{k}, '_');
                        maxComponents = max(maxComponents, length(currentFile));
                    end
                    
                    variableNames = strcat('Component', string(1:maxComponents));
                    componentTable = table('Size', [length(mriAnat), maxComponents], ...,
                        'VariableTypes', repmat("string", 1, maxComponents), ..., 
                        'VariableNames', variableNames);
                       
                    for k = 1:length(mriAnat)
                        currentFile = strsplit(mriAnat{k}, '_');
                        componentTable{k, 1:length(currentFile)} = currentFile;
                    end
                
                      vols1 = [unique(componentTable.Component3(~ismissing(componentTable.Component3)));
                             unique(componentTable.Component4(~ismissing(componentTable.Component4))) ;
                            unique(componentTable.Component5(~ismissing(componentTable.Component5)))];
                      mriVols = unique(vols1);
              
                    

             pipelines = unique(derivativesPET.pipeline);
             for k = 1:length(pipelines)     
             idx = find(contains(derivativesPET.pipeline, pipelines(k)));
             pipelinesPET{k} = derivativesPET(idx,:);
             end


    uniqueSubjects = unique(datasetStructure.subject);
        
         if any(contains(uniqueSubjects, 'wave'))
             idx = find(contains(uniqueSubjects, 'wave'));
             waves = uniqueSubjects(idx);
             for k = 1:length(waves)
                 waveTables{k} = datasetTable(strcmp(datasetTable.subject, waves{k}), :);
             end
         end
        
         if any(contains(uniqueSubjects, 'derivatives'))
             idx = find(contains(uniqueSubjects, 'derivatives'));
             derivatives = uniqueSubjects(idx);
             for k = 1:length(waves)
                 derivativesTables{k} = datasetTable(strcmp(datasetTable.subject, derivatives{k}), :);
             end
         end

% Initialize tables
subjects = table([], 'VariableNames', {'SubjectName'});
sessions = table([], [], 'VariableNames', {'SubjectID', 'SessionName'});
fileTypes = table([1; 2; 3], {'raw'; 'repository_derivative'; 'local_derivative'}, 'VariableNames', {'FileTypeID', 'TypeName'});
files = table('Size', [0 6], 'VariableTypes', {'int32', 'int32', 'string', 'string', 'string', 'string'}, ...
    'VariableNames', {'SessionID', 'FileTypeID', 'FilePath', 'FileName', 'Source', 'OtherMetadata'});

% Initialize counters and maps
subjectIDMap = containers.Map('KeyType', 'char', 'ValueType', 'int32');
sessionIDMap = containers.Map('KeyType', 'char', 'ValueType', 'int32');
subjectCounter = 0;
sessionCounter = 0;

% Parse the cleaned file paths
for i = 1:length(filePaths)
    fullPath = filePaths{i};
    pathParts = strsplit(fullPath, filesep);
    
    % Skip invalid paths
    if length(pathParts) < 3
        continue;
    end
    
    % Determine the dataset type (e.g., pet, mri, etc.)
    datasetType = pathParts{2};
    
    % Process subject directories
    if contains(fullPath, 'sub-')
        subjectName = pathParts{3};
        if length(pathParts) >= 4
            sessionName = pathParts{4};
        else
            sessionName = ''; % If session name is not present, set it to an empty string
        end
        
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
        
        % Determine the file type
        if contains(fullPath, 'derivatives')
            fileTypeID = 2; % repository_derivative
        else
            fileTypeID = 1; % raw
        end
        
        % Add file information
        fileName = pathParts{end};
        files = [files; {sessionID, fileTypeID, fullPath, fileName, 'repository', '{}'}];
    elseif contains(fullPath, '.json')
        % Handle BIDS descriptor files separately if needed
        files = [files; {NaN, 1, fullPath, pathParts{end}, 'repository', '{}'}];
    end
end

% Display the tables
disp(subjects);
disp(sessions);
disp(fileTypes);
disp(files);

% Save tables to .mat file (optional)
save('/export02/data/dbasha/PAD7/data_release_7.0/dataset_metadata.mat', 'subjects', 'sessions', 'fileTypes', 'files');
