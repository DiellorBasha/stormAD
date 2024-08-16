function csvData = importCSV()
    % Prompt the user to select a folder
    folderPath = uigetdir(pwd, 'Select a folder containing .csv files');
    
    % Check if the user selected a folder or cancelled the dialog
    if folderPath == 0
        error('No folder selected. Operation cancelled.');
    end
    
    % Get a list of all .csv files in the selected folder
    csvFiles = dir(fullfile(folderPath, '*.csv'));
    
    % Check if any .csv files are found
    if isempty(csvFiles)
        error('No .csv files found in the selected folder.');
    end
    
    % Initialize a structure array to store the data from each .csv file
    csvData = struct('filename', [], 'filepath', [], 'data', []);
    
    % Loop through each .csv file and import the data
    for k = 1:numel(csvFiles)
        % Get the full file path
        filePath = fullfile(folderPath, csvFiles(k).name);
        
        % Read the .csv file into a table
        csvData(k).data = readtable(filePath);
        % Store the filename
        csvData(k).filename = csvFiles(k).name;
        % Store the file path
        csvData(k).filepath = filePath;
    end
end
