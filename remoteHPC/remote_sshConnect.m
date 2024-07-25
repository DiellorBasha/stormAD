function remote_sshConnect(remoteConfigPath)
    % Extract data from remoteConfig structure
    remoteConfig = read_dbconfig(fullfile('config', 'remoteConfig.txt'));
    remoteUser = remoteConfig.remoteUser;
    remoteServer = remoteConfig.remoteServer;
    sshKeyPath = remoteConfig.sshKeyPath; % Path to your private key file
        remoteDirectory = '/project/def-jpoirier/PREVENT-AD/data_release_7.0';
        remoteHomeDir = '/home/dbasha';

    localBashScript = 'remote_dataset_contents.sh';
    localExpectScript = 'connect_with_duo.sh';
    localCopyScript = 'copy_to_remote.sh';
    localBashScriptPath = fullfile(getenv("STORMNET_DIR"), '/remoteHPC/', localBashScript);
    
    fullSSHKeyPath = fullfile(getenv("STORMNET_DIR"), sshKeyPath);
        % Define the destination path in WSL
        wslDirectory = "\\wsl$\";
        wslDistribution = "Ubuntu";
        wslHomeDir = '/home/dbasha';
        wslSSHKeyDestPath = fullfile(wslDirectory, wslDistribution, wslHomeDir, 'id_rsa');
        wslSSHKeyDestRelativePath =  convertPathToWSL(fullfile(wslHomeDir, 'id_rsa'));
        wslScriptDestPath =  fullfile(wslDirectory, wslDistribution, wslHomeDir, localBashScript);
        wslScriptDestRelativePath =  convertPathToWSL(fullfile(wslHomeDir, localBashScript));
           
        % Define the path to the expect script
            expectScriptPath = fullfile(getenv("STORMNET_DIR"), 'remoteHPC', 'connect_with_duo.sh');
            expectScriptPathDest = fullfile(wslDirectory, wslDistribution, wslHomeDir, localExpectScript);
            expectScriptRelativePath = convertPathToWSL(fullfile(wslHomeDir, localExpectScript));
                wslExpectScriptPath = convertPathToWSL(expectScriptPath);
    
    % Copy the SSH key from Windows to WSL
    copyfile(fullSSHKeyPath, wslSSHKeyDestPath);
    copyfile(localBashScriptPath, wslScriptDestPath);
        copyfile(expectScriptPath, expectScriptPathDest);
        copyfile(fullfile(getenv("STORMNET_DIR"), 'remoteHPC', 'copy_to_remote.sh'), fullfile(wslDirectory, wslDistribution, wslHomeDir, 'copy_to_remote.sh'));

        chmodCommand = sprintf('wsl chmod +x %s', expectScriptRelativePath);

        % Execute the chmod command
        [status, cmdout] = system(chmodCommand);

        chmodCommand = sprintf('wsl chmod +x %s', '"/home/dbasha/copy_to_remote.sh"');

        % Execute the chmod command
        [status, cmdout] = system(chmodCommand);


    % Change the permissions of the SSH key in WSL
    chmodCommandWSL = sprintf('wsl chmod 600 %s', wslSSHKeyDestRelativePath);
    [status, cmdout] = system(chmodCommandWSL);
    if status ~= 0
        error('Failed to change permissions for SSH key in WSL. Error: %s', cmdout);
    end

    % Define the path to the expect script
    expectScriptPath = fullfile(getenv("STORMNET_DIR"), 'remoteHPC', 'connect_with_duo.sh');
    wslExpectScriptPath = convertPathToWSL(expectScriptPath);

  
     % Define the path to the local text file
          % ./connect_with_duo.sh <remote_user> <remote_host> <ssh_key_path> <remote_dir> <remote_home_dir> <local_dir>
    % Run the expect script using WSL
    command = sprintf('wsl %s %s %s %s %s %s', wslExpectScriptPath, remoteUser, remoteServer, wslSSHKeyPath, remoteDir, localDir, wslLocalScriptPath);
    [status, cmdout] = system(command);

    expectCommand = sprintf('wsl %s %s %s %s %s %s %s', wslExpectScriptPath, remoteUser, remoteServer, wslSSHKeyDestRelativePath, remoteDirectory, remoteHomeDir, wslHomeDir);
    [status, cmdout] = system(expectCommand);
    if status ~= 0
        error('Failed to connect to the remote server. Error: %s', cmdout);
    end


end