classdef PluginConfig

    % PluginConfig: Manages the plugin configuration for stormAD
    %
    % This class handles the configuration of plugins for stormAD, including:
    %   - Mandatory fields (Name, Version, URLs)
    %   - Optional settings (AutoUpdate, AutoLoad, Category, etc.)
    %   - Installation and loading parameters
    %   - Dependency management
    %   - Custom functions for version checking, installation, and loading
    %
    % The class provides methods for:
    %   - Initializing plugin configurations
    %   - Writing configurations to JSON files
    %
    % This class is designed to work with the Brainstorm neuroimaging application
    % and follows the plugin structure defined in the bst_plugin function.


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
        Name
        Category
        Version
        AutoUpdate
        AutoLoad
        URLzip
        URLinfo
        ExtraMenus
        TestFile
        ReadmeFile
        LogoFile
        MinMatlabVer
        CompiledStatus
        RequiredPlugs
        UnloadPlugs
        LoadFolders
        GetVersionFcn
        DownloadedFcn
        InstalledFcn
        UninstalledFcn
        LoadedFcn
        UnloadedFcn
        DeleteFiles
        DeleteFilesBin
        InstallDate
        SubFolder
        Path
        Processes
        isLoaded
        isManaged
    end
    
    methods
        function obj = PluginConfig(pluginName)
            % Initialize with default values from Brainstorm template
            template = db_template('plugdesc');
            fields = fieldnames(template);
            for i = 1:length(fields)
                obj.(fields{i}) = template.(fields{i});
            end
            
            % Set plugin specific values
            if nargin < 1
                pluginName = 'stormAD';
            end
            obj.Name = pluginName;
            obj.Category = 'Neuroimaging';
            obj.Version = '1.0.0'; % Update this as needed
            obj.AutoUpdate = 1;
            obj.AutoLoad = 0;
            obj.URLzip = ['https://github.com/DiellorBasha/' pluginName '/archive/refs/heads/main.zip']; % Update with actual URL
            obj.URLinfo = ['https://github.com/DiellorBasha/' pluginName]; % Update with actual URL
            obj.TestFile = [lower(pluginName) '_main.m']; % Update with actual main file name
            obj.ReadmeFile = 'README.md';
            obj.LogoFile = [lower(pluginName) '_logo.png']; % Update with actual logo file name
            obj.MinMatlabVer = 9.3; % R2017b, update as needed
            obj.RequiredPlugs = {};
            obj.InstallDate = datestr(now, 'yyyy-mm-dd HH:MM:SS');
            obj.SubFolder = lower(pluginName);
        end
        
        function writeJSON(obj, configDir)
            if nargin < 2
                configDir = fullfile(fileparts(matlabroot), 'brainstorm3', 'external', lower(obj.Name), 'config');
            end
            
            % Ensure config directory exists
            if ~exist(configDir, 'dir')
                mkdir(configDir);
            end
            
            % Convert object to struct
            s = struct();
            props = properties(obj);
            for i = 1:length(props)
                s.(props{i}) = obj.(props{i});
            end
            
            % Write JSON file
            filename = fullfile(configDir, 'plugin_description.json');
            fid = fopen(filename, 'w');
            encoded = jsonencode(s, 'PrettyPrint', true);
            fwrite(fid, encoded, 'char');
            fclose(fid);
            
            fprintf('Plugin description JSON file written to: %s\n', filename);
        end
    end
end