classdef Anatomy
    % Anatomy Class for Managing Freesurfer Recon-all Output
    % 
    % This class is designed to manage the output folders from the Freesurfer
    % recon-all pipeline and keep track of the processing steps (pipeline) used 
    % to generate derivatives. It provides methods to run the recon-all and 
    % fs_segment commands, check and create necessary folders, display the 
    % processing pipeline, and generate a report using MATLAB Report Generator.
    %
    % Properties:
    %   label    - Path to the label folder
    %   mri      - Path to the mri folder
    %   scripts  - Path to the scripts folder
    %   stats    - Path to the stats folder
    %   surf     - Path to the surf folder
    %   tmp      - Path to the tmp folder
    %   touch    - Path to the touch folder
    %   trash    - Path to the trash folder
    %   Subject  - Instance of the Subject class containing subject information
    %   pipeline - Cell array to track the functions used in the processing pipeline
    %   anatDir  - Path to the anat folder within the output folder
    %   t1Dir    - Directory where the T1 file is stored
    %   outputFolder - Main output folder
    %   reconAllParams - Cell array to store the name-value parameters passed to recon-all
    %
    % Methods:
    %   Anatomy(subject, t1Dir, outputFolder) - Constructor to initialize the Anatomy object
    %   runReconAll(obj, varargin) - Method to run recon-all for the given subject
    %   runFsSegment(obj) - Method to run fs_segment for the given subject
    %   checkFolders(obj) - Method to check and create necessary folders
    %   updatePaths(obj) - Method to update the paths of the output folders
    %   displayPipeline(obj) - Method to display the processing pipeline
    %   generatePipelineReport(obj, reportPath) - Method to generate a report of the pipeline
    
    properties
        label
        mri
        scripts
        stats
        surf
        tmp
        touch
        trash
        Subject
        pipeline
        anatDir
        t1Dir
        outputFolder
        reconAllParams
    end
    
    methods
        function obj = Anatomy(subject, t1Dir, outputFolder)
            % Anatomy Constructor
            %
            % Initializes the Anatomy object with paths to the Freesurfer
            % output folders and a Subject object.
            %
            % Inputs:
            %   subject      - Instance of the Subject class
            %   t1Dir       - Directory where the T1 file is stored
            %   outputFolder - Main output folder for Freesurfer results
            
            if nargin > 0
                obj.Subject = subject;
                obj.t1Dir = t1Dir;
                obj.outputFolder = outputFolder;
                obj.anatDir = fullfile(outputFolder, 'anat');
                
                % Define paths relative to the anat folder
                obj.label = fullfile(obj.anatDir, 'label');
                obj.mri = fullfile(obj.anatDir, 'mri');
                obj.scripts = fullfile(obj.anatDir, 'scripts');
                obj.stats = fullfile(obj.anatDir, 'stats');
                obj.surf = fullfile(obj.anatDir, 'surf');
                obj.tmp = fullfile(obj.anatDir, 'tmp');
                obj.touch = fullfile(obj.anatDir, 'touch');
                obj.trash = fullfile(obj.anatDir, 'trash');
                
                obj.pipeline = {}; % Initialize the pipeline
                obj.reconAllParams = {}; % Initialize the recon-all parameters storage
            end
        end
        
        function runReconAll(obj, varargin)
            % Run Recon-all
            %
            % Executes the Freesurfer recon-all command for the subject
            % using the T1 file directory and output folder, and adds 
            % the function name to the pipeline property.
            %
            % Optional Name-Value Pairs:
            %   'FLAIR'     - Path to the FLAIR image (default: '')
            %   'T2'        - Path to the T2 image (default: '')
            %   'threads'   - Number of threads to use (default: 1)
            %   'autorecon' - Stage of recon-all to run (default: '-all')
            %   'subjectDir' - Directory where the subject folder will be created (default: '')
            %
            % Assumes the Subject class has an 'id' property.
            
            subjectID = obj.Subject.subject_name;
             [t1, ~] = fs_findVolume (obj.t1Dir, 'T1w');
            
            % Example for multiple T1 files
            fs_recon_all(subjectID, t1, 'subjectDir', obj.outputFolder, varargin{:});
            
            % Add to pipeline and store parameters
            obj.pipeline{end+1} = 'recon-all';
            obj.reconAllParams{end+1} = varargin;
            
            % Update folder paths after recon-all completes
            obj.updatePaths();
        end
        
        function runFsSegment(obj)
            % Run FsSegment
            %
            % Executes the fs_segment command for the subject
            % and adds the function name to the pipeline property.
            %
            % Assumes the Subject class has an 'id' property.
            
            subjectID = obj.Subject.id;
            command = sprintf('fs_segment -s %s', subjectID);
            fs_execute(command);
            
            % Add to pipeline
            obj.pipeline{end+1} = 'fs_segment';
        end
        
        function checkFolders(obj)
            % Check and Create Folders
            %
            % Checks if the necessary Freesurfer output folders exist,
            % and creates them if they do not.
            
            folders = {obj.label, obj.mri, obj.scripts, obj.stats, obj.surf, obj.tmp, obj.touch, obj.trash};
            for i = 1:length(folders)
                if ~isfolder(folders{i})
                    mkdir(folders{i});
                    fprintf('Created folder: %s\n', folders{i});
                end
            end
        end
        
        function updatePaths(obj)
            % Update Paths
            %
            % Updates the paths of the output folders after running recon-all.
            
            obj.label = fullfile(obj.anatDir, 'label');
            obj.mri = fullfile(obj.anatDir, 'mri');
            obj.scripts = fullfile(obj.anatDir, 'scripts');
            obj.stats = fullfile(obj.anatDir, 'stats');
            obj.surf = fullfile(obj.anatDir, 'surf');
            obj.tmp = fullfile(obj.anatDir, 'tmp');
            obj.touch = fullfile(obj.anatDir, 'touch');
            obj.trash = fullfile(obj.anatDir, 'trash');
        end
        
        function displayPipeline(obj)
            % Display Pipeline
            %
            % Displays the sequence of functions executed in the processing pipeline.
            
            fprintf('Pipeline for subject %s:\n', obj.Subject.id);
            for i = 1:length(obj.pipeline)
                fprintf('%d. %s\n', i, obj.pipeline{i});
            end
        end
        
        function generatePipelineReport(obj, reportPath)
            % Generate Pipeline Report
            %
            % Generates a PDF report of the processing pipeline using MATLAB Report Generator.
            %
            % Inputs:
            %   reportPath - Path to save the generated report
            
            import mlreportgen.report.*
            import mlreportgen.dom.*
            
            % Create a new report
            report = Report(reportPath, 'pdf');
            open(report);
            
            % Add a title page
            titlepg = TitlePage;
            titlepg.Title = 'Pipeline Report';
            titlepg.Author = 'MATLAB Toolbox';
            titlepg.Subtitle = sprintf('Subject: %s', obj.Subject.id);
            add(report, titlepg);
            
            % Add a table of contents
            toc = TableOfContents;
            add(report, toc);
            
            % Add a section for the pipeline
            sect = Section;
            sect.Title = 'Pipeline';
            for i = 1:length(obj.pipeline)
                para = Paragraph(sprintf('%d. %s', i, obj.pipeline{i}));
                add(sect, para);
                
                % Add the parameters for recon-all
                if strcmp(obj.pipeline{i}, 'recon-all')
                    paramsPara = Paragraph('Parameters:');
                    add(paramsPara, BulletList(obj.reconAllParams{i}));
                    add(sect, paramsPara);
                end
            end
            add(report, sect);
            
            % Close and view the report
            close(report);
            rptview(report);
        end
    end
end
