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
        end
        
        function disp(obj)
            % Custom display method for BSTENV objects
            disp('Brainstorm Environment Settings:');
            disp('--------------------------------');
            props = properties(obj);
            for i = 1:length(props)
                fprintf('%s: %s\n', props{i}, string(obj.(props{i})));
            end
        end
    end
end