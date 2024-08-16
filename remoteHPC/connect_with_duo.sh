#!/usr/bin/expect -f

# Variables
set timeout -1
set remote_user [lindex $argv 0]
set remote_host [lindex $argv 1]
set directory_to_list [lindex $argv 2]
set local_dir [lindex $argv 3]
set local_script [lindex $argv 4]


# Start SSH session
spawn ssh -i id_rsa $remote_user@$remote_host

# Handle host key verification and Duo Push prompt
expect {
    "Are you sure you want to continue connecting (yes/no)?" {
        send "yes\r"
        exp_continue
    }
    "Passcode or option" {
        send "1\r"
    }
}
    # Execute the script on the remote server with arguments
    send "bash /home/$remote_user/remote_dataset_contents.sh $directory_to_list /home/$remote_user/output\r"
    expect "$ "
    send "exit\r"
}

# Copy the generated files from the remote server to the local machine
expect "$ " {
    spawn scp -r -i id_rsa $remote_user@$remote_host:/home/$remote_user/output $local_dir
    expect {
        "Are you sure you want to continue connecting (yes/no)?" {
            send "yes\r"
            exp_continue
        }
    }
    expect "$ "
}
