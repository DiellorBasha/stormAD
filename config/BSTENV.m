classdef BSTENV
    % BSTENV: Stores Brainstorm environment variables and settings
    %
    % This class encapsulates various Brainstorm environment settings and
    % system information, providing easy access to commonly used paths and
    % version information.
    %
    % Properties include:
    %   - Directory paths (user, home, temporary, reports, etc.)
    %   - Version information (Brainstorm, MATLAB, Java)
    %   - System settings (memory, byte order)
    
    properties
        UserDir             % User home directory
        BrainstormHomeDir   % Application directory of Brainstorm
        BrainstormUserDir   % User home directory for Brainstorm
        BrainstormTmpDir    % User Brainstorm temporary directory
        UserReportsDir      % User reports directory
        UserMexDir          % User temporary directory
        UserProcessDir      % User custom processes directory
        UserDefaultsDir     % User defaults directory
        UserPluginsDir      % User plugins directory
        BrainstormDbFile    % User brainstorm.mat file
        BrainstormDbDir     % User database directory
        Version             % Brainstorm version
        MatlabVersion       % MATLAB version (number * 100)
        MatlabReleaseName   % MATLAB version (release name)
        JavaVersion         % Java version
        isJavacomponent     % 1 if javacomponent is available, 0 otherwise
        SystemMemory        % Amount of memory available, in Mb
        ByteOrder           % Byte order used to read and save binary files
    end
    
    methods
        function obj = BSTENV()
            % Constructor: Initialize BSTENV object with current Brainstorm settings
            obj.UserDir = bst_get('UserDir');
            obj.BrainstormHomeDir = bst_get('BrainstormHomeDir');
            obj.BrainstormUserDir = bst_get('BrainstormUserDir');
            obj.BrainstormTmpDir = bst_get('BrainstormTmpDir');
            obj.UserReportsDir = bst_get('UserReportsDir');
            obj.UserMexDir = bst_get('UserMexDir');
            obj.UserProcessDir = bst_get('UserProcessDir');
            obj.UserDefaultsDir = bst_get('UserDefaultsDir');
            obj.UserPluginsDir = bst_get('UserPluginsDir');
            obj.BrainstormDbFile = bst_get('BrainstormDbFile');
            obj.BrainstormDbDir = bst_get('BrainstormDbDir');
            obj.Version = bst_get('Version');
            obj.MatlabVersion = bst_get('MatlabVersion');
            obj.MatlabReleaseName = bst_get('MatlabReleaseName');
            obj.JavaVersion = bst_get('JavaVersion');
            obj.isJavacomponent = bst_get('isJavacomponent');
            obj.SystemMemory = bst_get('SystemMemory');
            obj.ByteOrder = bst_get('ByteOrder');
            obj.saveToFile;
        end
        
        function saveToFile(obj)
            % Save the properties of BSTENV to a structure and save to file
            bst_env.UserDir = obj.UserDir;
            bst_env.BrainstormHomeDir = obj.BrainstormHomeDir;
            bst_env.BrainstormUserDir = obj.BrainstormUserDir;
            bst_env.BrainstormTmpDir = obj.BrainstormTmpDir;
            bst_env.UserReportsDir = obj.UserReportsDir;
            bst_env.UserMexDir = obj.UserMexDir;
            bst_env.UserProcessDir = obj.UserProcessDir;
            bst_env.UserDefaultsDir = obj.UserDefaultsDir;
            bst_env.UserPluginsDir = obj.UserPluginsDir;
            bst_env.BrainstormDbFile = obj.BrainstormDbFile;
            bst_env.BrainstormDbDir = obj.BrainstormDbDir;
            bst_env.Version = obj.Version;
            bst_env.MatlabVersion = obj.MatlabVersion;
            bst_env.MatlabReleaseName = obj.MatlabReleaseName;
            bst_env.JavaVersion = obj.JavaVersion;
            bst_env.isJavacomponent = obj.isJavacomponent;
            bst_env.SystemMemory = obj.SystemMemory;
            bst_env.ByteOrder = obj.ByteOrder;
            
            % Define the directory and file path
            db_dir = fullfile(obj.BrainstormUserDir, '.stormAD');
            if ~exist(db_dir, 'dir')
                mkdir(db_dir);
            end
            file_path = fullfile(db_dir, 'bst_env.mat');
            
            % Save the structure to the file
            save(file_path, 'bst_env');
        end
    end
end
