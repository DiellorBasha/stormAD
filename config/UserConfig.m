classdef UserConfig
    properties
        % User Information
        username
        email
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
            
            if exist(obj.configFile, 'file')
                obj = obj.loadConfig();
            else
                obj = obj.promptUserInput();
            end
        end
        
        function obj = promptUserInput(obj)
            % Prompt user for all necessary information
            obj.username = input('Enter your username: ', 's');
            obj.email = input('Enter your email: ', 's');
            obj.sshKeyPath = input('Enter path to SSH key (leave blank if not using): ', 's');
            
            obj.matlabPath = matlabroot;
            obj.winScriptDir = input('Enter Windows script directory: ', 's');
            
            obj.wslDistro = input('Enter WSL distribution (e.g., Ubuntu): ', 's');
            obj.wslUsername = input('Enter WSL username: ', 's');
            obj.wslWorkDir = input('Enter WSL working directory: ', 's');
            
            obj.remoteHostname = input('Enter remote HPC hostname: ', 's');
            obj.remoteUsername = input('Enter remote HPC username: ', 's');
            obj.remoteWorkDir = input('Enter remote HPC working directory: ', 's');
            obj.remoteModules = input('Enter remote modules to load (comma-separated): ', 's');
            
            % New prompts for database environment
            obj.dbPath = input('Enter SQLite database path: ', 's');
            obj.dbName = input('Enter SQLite database name: ', 's');
            
            obj.saveConfig();
        end
        
        function saveConfig(obj)
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
        
        % New method to get full database file path
        function dbFilePath = getDbFilePath(obj)
            dbFilePath = fullfile(obj.dbPath, obj.dbName);
        end
    end
end