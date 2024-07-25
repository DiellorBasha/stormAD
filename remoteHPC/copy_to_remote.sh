#!/usr/bin/expect -f

# Variables
set timeout -1
set remote_user [lindex $argv 0]
set remote_host [lindex $argv 1]
set local_file [lindex $argv 2]
set remote_dir [lindex $argv 3]
set ssh_key "~/id_rsa"  # Path to the SSH key in the home directory

# Ensure the ssh_key file exists and change permissions to -rw-------
if {[file exists $ssh_key]} {
    exec chmod 600 $ssh_key
} else {
    puts "Error: SSH key file $ssh_key does not exist."
    exit 1
}

# Start SCP session to copy the local file to the remote server
spawn scp -i $ssh_key $local_file $remote_user@$remote_host:$remote_dir

# Handle prompts during the SCP process
expect {
    "Are you sure you want to continue connecting (yes/no)?" {
        send "yes\r"
        exp_continue
    }
    "Passcode or option" {
        send "1\r"
    }
}

# Interact with the remote shell (if needed)
expect "$ "
#dos2unix /home/dbasha/remote_dataset_contents.sh
