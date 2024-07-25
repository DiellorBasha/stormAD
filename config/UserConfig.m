classdef UserConfig

% UserConfig: Manages user configuration for the StormAD plugin in Brainstorm
    %
    % This class handles user-specific settings and environment configurations
    % for the StormAD plugin, including:
    %   - User information (username, email)
    %   - Project paths (Brainstorm, StormAD)
    %   - Windows and WSL environment settings
    %   - Remote HPC configuration
    %   - Database settings
    %   - Brainstorm global data
    %   - Plugin configuration
    %
    % The class provides methods for:
    %   - Initializing and loading configurations
    %   - Prompting user for input
    %   - Saving and updating configurations
    %   - Managing SSH keys
    %   - Handling plugin configurations

    %     Mandatory fields
%     ================
%     - 
%     - 
%     - 
%     - 
%
%     Optional fields
%     ===============

% @=============================================================================
% This class is part of the stormAD module of the Brainstorm software, developed
% for the analysis of multimodal neuroimaging datasets in Alzheimer's Disease. 
% https://neuroimage.usc.edu/brainstorm/stormAD
%
% It is distributed as an extension of the Brainstorm software 
% https://neuroimage.usc.edu/brainstorm
% 
% Copyright (c) University of Southern California & McGill University
% This software is distributed under the terms of the GNU General Public License
% as published by the Free Software Foundation. Further details on the GPLv3
% license can be found at http://www.gnu.org/copyleft/gpl.html.
% 
% FOR RESEARCH PURPOSES ONLY. THE SOFTWARE IS PROVIDED "AS IS," AND THE
% UNIVERSITY OF SOUTHERN CALIFORNIA AND ITS COLLABORATORS DO NOT MAKE ANY
% WARRANTY, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF
% MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, NOR DO THEY ASSUME ANY
% LIABILITY OR RESPONSIBILITY FOR THE USE OF THIS SOFTWARE.
%
% For more information type "brainstorm license" at command prompt.
% =============================================================================@
%
% Authors: Diellor Basha, 2024-2026

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
        
        % Brainstorm Data
        GlobalData
        PluginConfig
        
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
            obj.PluginConfig = PluginConfig('stormAD');
            
            % Populate GlobalData
            try
                obj.GlobalData = db_template('GlobalData');
            catch ME
                warning('Failed to load Brainstorm GlobalData template: %s', ME.identifier, ME.message);
                obj.GlobalData = struct();
            end
            
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
        
        function obj = updateGlobalData(obj)
            try
                obj.GlobalData = db_template('GlobalData');
                fprintf('GlobalData updated successfully.\n');
            catch ME
                warning('Failed to update GlobalData: %s', ME.identifier, ME.message);
            end
        end
        
        function writePluginConfig(obj)
            obj.PluginConfig.writeJSON(fullfile(obj.stormADProjectDir, 'config'));
        end
    end
end