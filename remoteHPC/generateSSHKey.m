function generateSSHKey(key_name, output_dir)
    % generateSSHKey Generates an SSH key with the specified name and directory
    %
    % If no input arguments are provided, the function will generate the key
    % with the default name 'cc-key' in the directory 'config' within the
    % root folder of the project.
    %
    % Arguments:
    %   key_name (optional) - The name of the key file to be generated (default: 'cc-key')
    %   output_dir (optional) - The directory where the key file will be stored (default: fullfile(fproj.RootFolder, 'config'))
    fproj.RootFolder = getenv("STORMNET_DIR");

    % Define default values
    if nargin < 1 || isempty(key_name)
        key_name = 'id_rsa';
    end
    if nargin < 2 || isempty(output_dir)
        % Assuming fproj.RootFolder is defined in the workspace
        if exist('fproj', 'var') && isfield(fproj, 'RootFolder')
            output_dir = fullfile(fproj.RootFolder, 'config');
        else
            error('fproj.RootFolder is not defined. Please provide a valid output directory.');
        end
    end

    % Ensure the output directory exists
    if ~exist(output_dir, 'dir')
        mkdir(output_dir);
    end

    % Construct the full key path
    full_key_path = fullfile(output_dir, key_name);

    % Check if the key file already exists
    if exist(full_key_path, 'file') || exist([full_key_path '.pub'], 'file')
        fprintf('The key file %s already exists. Aborting key generation.\n', full_key_path);
        return;
    end

    % Construct the command to generate the SSH key
    command = sprintf('echo y | ssh-keygen -t rsa -b 2048 -f "%s" -N ""', full_key_path);

    % Execute the command
    system(command);

    command = sprintf('ssh-add "%s.pub"', full_key_path);

    % Display message indicating the key generation is complete
    fprintf('SSH key generated and saved to: %s\n', full_key_path);

      % Change file permissions to restrict access
    changePermissionsCommand = sprintf('icacls "%s" /inheritance:r /remove "Everyone" /grant:r "%s:(R)"', strcat(full_key_path, '.pub'), getenv('USERNAME'));
    [status, cmdout] = system(changePermissionsCommand);
    if status ~= 0
        error('Failed to change permissions for %s. Error: %s', sshKeyPath, cmdout);
    end

end
