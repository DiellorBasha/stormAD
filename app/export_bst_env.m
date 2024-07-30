function varargout = process_stormad_export_db(varargin)
    % PROCESS_STORMAD_EXPORT_DB: Exports data to stormAD database
    
    eval(macro_method);
    end
    
    %% ===== GET DESCRIPTION =====
    function sProcess = GetDescription() %#ok<DEFNU>
        % Description of the process
        sProcess.Comment     = 'Export data to stormAD database';
        sProcess.FileTag     = '';
        sProcess.Category    = 'Custom';
        sProcess.SubGroup    = 'File';
        sProcess.Index       = 983;
        % Definition of the input accepted by this process
        sProcess.InputTypes  = {'data'};
        sProcess.OutputTypes = {'data'};
        sProcess.nInputs     = 1;
        sProcess.nMinFiles   = 1;
        
        % Options: Sensor types
        sProcess.options.sensortypes.Comment = 'Sensor types or names (empty=all): ';
        sProcess.options.sensortypes.Type    = 'text';
        sProcess.options.sensortypes.Value   = 'SEEG';
        sProcess.options.sensortypes.InputTypes = {'data'};
        sProcess.options.sensortypes.Group   = 'input';
    end
    
    %% ===== FORMAT COMMENT =====
    function Comment = FormatComment(sProcess) %#ok<DEFNU>
        Comment = sProcess.Comment;
    end
    
    %% ===== RUN =====
    function OutputFiles = Run(sProcess, sInputs) %#ok<DEFNU>
        % Initialize returned list of files
        OutputFiles = {};
        
        % Define the fixed database location for stormAD
        stormad_db = fullfile(fileparts(mfilename('fullpath')), 'stormAD', 'db');
        
        % Display progress bar
        startValue = bst_progress('get');
        bst_progress('text', 'Extracting data to stormAD');
        
        % ===== PROCESS =====
        
        % Get all unique subjects
        [uniqueSubj, ~, J] = unique({sInputs.SubjectFile});
        iGroups = cell(1, length(uniqueSubj));
        for i = 1:length(uniqueSubj)
            iGroups{i} = find(J == i)';
            SubjectNames{i} = sInputs(iGroups{i}(1)).SubjectName;
            ConditionNames{i} = sInputs(iGroups{i}(1)).Condition;
        end   
        
        % Create database folder if it does not exist 
        if ~exist(stormad_db, 'file')
            mkdir(stormad_db);
        end
    
        % Move all patient data files into one folder patient directory 
        for pp = 1:length(SubjectNames)
            bst_progress('set',  round(startValue + pp/length(SubjectNames)*100));
            bst_progress('text', SubjectNames{pp});
            
            % Create the name of the subject in stormAD (SubjectNameCondition)
            stormad_pt_dir = fullfile(stormad_db, strcat(SubjectNames{pp}, ConditionNames{pp}));
            
            % Load channel file
            ChannelMat = in_bst_channel(sInputs(iGroups{pp}(1)).ChannelFile);
            
            % Get channels we want to process
            if ~isempty(sProcess.options.sensortypes.Value)
                [iChannels, SensorComment] = channel_find(ChannelMat.Channel, sProcess.options.sensortypes.Value);
            else
                iChannels = 1:length(ChannelMat.Channel);
            end
            
            % No sensors: error
            if isempty(iChannels)
                Messages = 'No sensors are selected.';
                bst_report('Warning', sProcess, sInputs, Messages);
                return;
            end
            
            % Read the first file in the list, to initialize the loop
            DataMat = in_bst(sInputs(iGroups{pp}(1)).FileName, [], 0);
            epochSize = size(DataMat.F);
            Time = DataMat.Time;
            
            % Select 'good' Channels (not marked as BAD)
            flag_good_chan = DataMat.ChannelFlag == 1; 
            
            % Initialize the load matrix: [Nchannels x Ntime x Nepochs]
            F = zeros(sum(flag_good_chan(iChannels)), epochSize(2), length(iGroups{pp}));
            
            % Initialize the bst_history : [Nepochs x Nprocesses x 3) ]
            bst_history = cell(size(DataMat.History,1), size(DataMat.History,2), length(iGroups{pp}));
    
            % Reading all the group files in a big matrix
            for i = 1:length(iGroups{pp})
                % Read the file #i
                DataMat = in_bst(sInputs(iGroups{pp}(i)).FileName, [], 0);
                
                % Check the dimensions of the recordings matrix in this file
                if ~isequal(size(DataMat.F), epochSize)
                    % Add an error message to the report
                    bst_report('Error', sProcess, sInputs, 'One file has a different number of channels or a different number of time samples.');
                    % Stop the process
                    return;
                end
                % Add the current file in the big load matrix
                F(:,:,i) = DataMat.F(iChannels(flag_good_chan(iChannels)), :);
                bst_history(:,:,i) = DataMat.History; 
            end
    
            if exist(stormad_pt_dir, 'dir')
                error('Patient exists, please remove patient from stormAD_db'); 
            else
                % Create Output name
                outname = fullfile(stormad_pt_dir, strcat(SubjectNames{pp}, ConditionNames{pp}, '_signal_LFP.mat'));
                
                % Get data and remove bad channels
                Favg = mean(F, 3); 
                labels = {ChannelMat.Channel(iChannels(flag_good_chan(iChannels))).Name}; 
                Time = DataMat.Time;
                bst_version = bst_get('Version');
                df = size(F, 3);
                
                % Create patient directory and save file
                mkdir(stormad_pt_dir);
                save(outname, 'Time', 'F', 'df', 'labels', 'Favg', 'bst_history', 'bst_version');
            end 
        end
        
        % Launch stormApp GUI on the new created database
        run(fullfile(fileparts(mfilename('fullpath')), 'stormAD', 'app', 'stormApp.mlapp'));
    end
    