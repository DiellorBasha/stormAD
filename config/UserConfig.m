classdef UserConfig
    properties
        % User Information
        username
        email
        
        % Project Paths
        brainstormUserDir
        stormADProjectDir
        stormADUserDir
        sshKeyPath
        
        % Windows Environment
        matlabPath
        winScriptDir
        
        % WSL Environment
        wslDistro
        wslUsername
        wslWorkDir
        
        % Remote HPC Environment
        remoteHostname
        remoteUsername
        remoteWorkDir
        remoteModules
        
        % Database Environment
        dbPath
        dbName
        
        % Configuration file path
        configFile
    end
    
    methods
        function obj = UserConfig(configFile)
            if nargin < 1
                obj.configFile = 'user_config.mat';
            else
                obj.configFile = configFile;
            end
            
            % Set default paths
            obj.brainstormUserDir = fullfile(getenv('USERPROFILE'), '.brainstorm');
            obj.stormADProjectDir = fullfile(fileparts(matlabroot), 'brainstorm3', 'external', 'stormAD');
            obj.stormADUserDir = fullfile(obj.brainstormUserDir, '.stormAD');
            obj.sshKeyPath = fullfile(obj.stormADUserDir, '.ssh', 'id_rsa');
            
            if exist(obj.configFile, 'file')
                obj = obj.loadConfig();
            else
                obj = obj.promptUserInput();
            end
        end
        
        function obj = promptUserInput(obj)
            % Prompt user for necessary information
            obj.username = input('Enter your username: ', 's');
            obj.email = input('Enter your email: ', 's');
            
            obj.matlabPath = matlabroot;
            obj.winScriptDir = fullfile(obj.stormADProjectDir, 'scripts');
            
            obj.wslDistro = input('Enter WSL distribution (e.g., Ubuntu): ', 's');
            obj.wslUsername = input('Enter WSL username: ', 's');
            obj.wslWorkDir = input('Enter WSL working directory: ', 's');
            
            obj.remoteHostname = input('Enter remote HPC hostname: ', 's');
            obj.remoteUsername = input('Enter remote HPC username: ', 's');
            obj.remoteWorkDir = input('Enter remote HPC working directory: ', 's');
            obj.remoteModules = input('Enter remote modules to load (comma-separated): ', 's');
            
            obj.dbPath = obj.stormADUserDir;
            obj.dbName = 'stormAD.sqlite';
            
            obj.saveConfig();
        end
        
        function saveConfig(obj)
            % Ensure the StormAD user directory exists
            if ~exist(obj.stormADUserDir, 'dir')
                mkdir(obj.stormADUserDir);
            end
            
            % Save the configuration file in the StormAD user directory
            obj.configFile = fullfile(obj.stormADUserDir, 'user_config.mat');
            save(obj.configFile, 'obj');
            fprintf('Configuration saved to %s\n', obj.configFile);
        end
        
        function obj = loadConfig(obj)
            load(obj.configFile, 'obj');
            fprintf('Configuration loaded from %s\n', obj.configFile);
        end
        
        function obj = updateConfig(obj, field, value)
            if isprop(obj, field)
                obj.(field) = value;
                obj.saveConfig();
            else
                error('Invalid field name: %s', field);
            end
        end
        
        function displayConfig(obj)
            disp('Current Configuration:');
            disp(obj);
        end
        
        function dbFilePath = getDbFilePath(obj)
            dbFilePath = fullfile(obj.dbPath, obj.dbName);
        end
        
        function ensureSSHKey(obj)
            if ~exist(obj.sshKeyPath, 'file')
                sshDir = fileparts(obj.sshKeyPath);
                if ~exist(sshDir, 'dir')
                    mkdir(sshDir);
                end
                % Generate SSH key (this is a placeholder - you'll need to implement the actual key generation)
                system(['ssh-keygen -t rsa -b 4096 -f "' obj.sshKeyPath '" -N ""']);
                fprintf('SSH key generated at %s\n', obj.sshKeyPath);
            else
                fprintf('SSH key already exists at %s\n', obj.sshKeyPath);
            end
        end
    end
end