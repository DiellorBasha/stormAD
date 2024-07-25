param (
    [string]$username,
    [string]$hostname,
    [string]$password = "",
    [string]$keyPath = ""
)

# Function to connect using password
function ConnectWithPassword {
    param (
        [string]$username,
        [string]$hostname,
        [string]$password
    )

    $sshCommand = "ssh $username@$hostname"
    $process = Start-Process -FilePath "cmd.exe" -ArgumentList "/c $sshCommand" -PassThru -NoNewWindow -RedirectStandardInput "input.txt" -RedirectStandardOutput "output.txt" -RedirectStandardError "error.txt"
    
    Start-Sleep -Seconds 2
    Add-Content -Path "input.txt" -Value "$password`n"
    
    Start-Sleep -Seconds 2

    # Check for Duo authentication prompt
    $output = Get-Content -Path "output.txt"
    if ($output -match "Duo two-factor login for") {
        Add-Content -Path "input.txt" -Value "1`n"
        Start-Sleep -Seconds 2
    }

    $process | Stop-Process
    $output = Get-Content -Path "output.txt"
    $output
}

# Function to connect using SSH key
function ConnectWithKey {
    param (
        [string]$username,
        [string]$hostname,
        [string]$keyPath
    )

    $sshCommand = "ssh -i $keyPath $username@$hostname"
    $process = Start-Process -FilePath "cmd.exe" -ArgumentList "/c $sshCommand" -PassThru -NoNewWindow -RedirectStandardOutput "output.txt" -RedirectStandardError "error.txt"
    
    Start-Sleep -Seconds 5

    # Check for Duo authentication prompt
    $output = Get-Content -Path "output.txt"
    if ($output -match "Duo two-factor login for") {
        Add-Content -Path "input.txt" -Value "1`n"
        Start-Sleep -Seconds 2
    }

    $process | Stop-Process
    $output = Get-Content -Path "output.txt"
    $output
}

# Check if password or keyPath is provided
if ($password -ne "") {
    ConnectWithPassword -username $username -hostname $hostname -password $password
} elseif ($keyPath -ne "") {
    ConnectWithKey -username $username -hostname $hostname -keyPath $keyPath
} else {
    Write-Output "Please provide a password or keyPath."
}
