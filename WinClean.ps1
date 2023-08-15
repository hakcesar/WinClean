# WinClean script - PowerShell version 1.0

# Set console colors
$Host.UI.RawUI.BackgroundColor = "Black"
$Host.UI.RawUI.ForegroundColor = "White"
Clear-Host

# Hi :)
$asciiArt = @"




 ____      ____  _             ______  _____                            
|_  _|    |_  _|(_)          .' ___  ||_   _|                           
  \ \  /\  / /  __   _ .--. / .'   \_|  | |      .---.  ,--.   _ .--.   
   \ \/  \/ /  [  | [ `.-. || |         | |   _ / /__\\`'_\ : [ `.-. |  
    \  /\  /    | |  | | | |\ `.___.'\ _| |__/ || \__.,// | |, | | | |  
     \/  \/    [___][___||__]`.____ .'|________| '.__.'\'-;__/[___||__] 
                                                                        


                                                                 

                                                                
                                
"@
Write-Host $asciiArt
Write-Host "Author: hakcesar"
Write-Host "Blog: https://hakcesar.com"
Write-Host ""

# Check if the script is running as administrator
$isAdmin = ([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544"
if (-not $isAdmin) {
    Write-Host "This script requires administrative privileges. Please run the script as an administrator."
    exit
}

# Function to update the progress bar
function Update-ProgressBar {
    param (
        [int]$current,
        [int]$total
    )

    $progress = [math]::Round(($current / $total) * 100)
    $progressBarWidth = 30
    $completedWidth = [math]::Round(($progress / 100) * $progressBarWidth)
    $remainingWidth = $progressBarWidth - $completedWidth

    $progressBar = ("#" * $completedWidth) + ("-" * $remainingWidth)
    Write-Host "`r[$progressBar] $progress%   " -NoNewline
}


try {
# Display a warning message
Write-Host "WARNING: This script will perform basic cleanup. Make sure to back up any important data before running this script."

# Prompt the user for confirmation before proceeding
$confirmation = Read-Host "Do you want to continue? (Y/N)"
if ($confirmation -ne "Y") {
    Write-Host "Script execution canceled."
    exit
}

Write-Host " "

# Clean up temporary files
Write-Host "Cleaning up temporary files..."
Remove-Item -Path $env:TEMP\* -Force -Recurse -ErrorAction Stop
Update-ProgressBar -current 1 -total 8
Write-Host "Temporary files cleaned."
Write-Host " "
Start-Sleep -Seconds 5

# Clear the recycle bin
Write-Host "Clearing the recycle bin..."
Clear-RecycleBin -Force -ErrorAction SilentlyContinue
Update-ProgressBar -current 2 -total 8
Write-Host "Permanently deleted the items in the recycle bin."
Write-Host " "
Start-Sleep -Seconds 5

# Perform disk cleanup of system files
Write-Host "Performing disk cleanup..."
Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1" -Wait
Update-ProgressBar -current 3 -total 8
Write-Host "Disk cleanup of system files completed."
Write-Host " "
Start-Sleep -Seconds 2

# Run system scans
Write-Host "The final cleanup process may take several minutes depending on your system's performance."
Write-Host " "
Start-Sleep -Seconds 3

# Run SFC tool
Write-Host "The System File Checker (SFC) tool scans and repairs corrupted or missing system files."
Write-Host "This process will help ensure the integrity of your system files."
try {
    Start-Process -FilePath "sfc.exe" -ArgumentList "/scannow" -Wait -NoNewWindow
    Update-ProgressBar -current 4 -total 8
    Write-Host "SFC scan completed."
} catch {
    Write-Host "An error occurred while running SFC: $_"
}
Write-Host " "
Start-Sleep -Seconds 5

# Run DISM health scan
try {
    Start-Process -FilePath "dism.exe" -ArgumentList "/Online /NoRestart /Cleanup-Image /ScanHealth" -Wait -NoNewWindow
    Write-Host "DISM scan health completed."
} catch {
    Write-Host "An error occurred while running DISM scan health: $_"
}

# If DISM detects corruption try to repair
if ($error) {
    Write-Host "DISM: Image corruption detected. Attempting repair..."
    try {
        Start-Process -FilePath "dism.exe" -ArgumentList "/Online /NoRestart /Cleanup-Image /RestoreHealth" -Wait -NoNewWindow
        Write-Host "DISM restore health completed."
    } catch {
        Write-Host "An error occurred while running DISM restore health: $_"
    }
} else {
    Update-ProgressBar -current 5 -total 8
    Write-Host "DISM: No image corruption detected."
}
Write-Host " "
Start-Sleep -Seconds 5

# Run chkdsk on system drive
$systemDrive = [System.IO.Path]::GetPathRoot($env:SystemDrive)
Write-Host "Running chkdsk on system drive ($systemDrive)..."
try {
    $chkdskOutput = Invoke-Expression -Command "chkdsk $systemDrive /F /R"
    Write-Host $chkdskOutput
    $errorsFound = $chkdskOutput -match "errors found"
    
    if ($errorsFound) {
        Update-ProgressBar -current 6 -total 8
        Write-Host "Errors found on $systemDrive. Scheduling full chkdsk at next reboot."
    } else {
        Update-ProgressBar -current 7 -total 8
        Write-Host "No errors found on $systemDrive. Skipping full chkdsk at next reboot."
    }
} catch {
    Write-Host "An error occurred while running chkdsk: $_"
}
Write-Host " "
Start-Sleep -Seconds 5


# Complete
Update-ProgressBar -current 8 -total 8
Write-Host "`nCleanup complete. Your PC will thank you later :)"
Write-Host " "

} catch {
    Write-Host "An error occurred: $_"
}



