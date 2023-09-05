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
Write-Host "By: @hakcesar"
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
try {
    Remove-Item -Path $env:TEMP\* -Force -Recurse -ErrorAction Stop
    Update-ProgressBar -current 1 -total 7
    Write-Host "Temporary files cleaned."
} catch {
    Write-Host "An error occurred: $_"
}
Write-Host " "
Start-Sleep -Seconds 2

# Clear the recycle bin
Write-Host "Clearing the recycle bin..."
Clear-RecycleBin -Force -ErrorAction SilentlyContinue
Update-ProgressBar -current 2 -total 7
Write-Host "Permanently deleted the items in the recycle bin."
Write-Host " "
Start-Sleep -Seconds 2

# Perform disk cleanup of system files
Write-Host "Performing disk cleanup..."
Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1" -Wait
Update-ProgressBar -current 3 -total 7
Write-Host "Disk cleanup of system files completed."
Write-Host " "
Start-Sleep -Seconds 2

# Run system scans
Write-Host "The final cleanup process may take several minutes depending on your system's performance."
Write-Host " "
Start-Sleep -Seconds 3

# Run SFC tool
Write-Host "SFC (System File Checker) is a built-in utility that scans and restores critical Windows system files, helping to maintain system integrity and reliability."
Start-Sleep -Seconds 3
Write-Host " "
Write-Host "Running SFC..."
try {
    Start-Process -FilePath "sfc.exe" -ArgumentList "/scannow" -Wait -NoNewWindow
    Update-ProgressBar -current 4 -total 7
    Write-Host "SFC scan completed."
} catch {
    Write-Host "An error occurred while running SFC: $_"
}
Start-Sleep -Seconds 2

# Run DISM health scan
Write-Host " "
Write-Host "DISM (Deployment Image Servicing and Management) is a command-line tool that repairs and maintains Windows system images, fixing potential corruption and enhancing system stability."
Start-Sleep -Seconds 3
Write-Host " "
Write-Host "Running DISM..."
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
        Update-ProgressBar -current 5 -total 7
        Write-Host "DISM restore health completed."
    } catch {
        Write-Host "An error occurred while running DISM restore health: $_"
    }
} else {
    Update-ProgressBar -current 5 -total 7
    Write-Host "DISM: No image corruption detected."
}
Write-Host " "
Start-Sleep -Seconds 2

# Run chkdsk on system drive
$systemDrive = [System.IO.Path]::GetPathRoot($env:SystemDrive)
Write-Host "chkdsk (Check Disk) is a system utility that scans and repairs potential issues in your computer's file system, ensuring data integrity and stability."
Start-Sleep -Seconds 3
Write-Host "Running chkdsk on system drive ($systemDrive)..."
try {
    $chkdskOutput = Invoke-Expression -Command "chkdsk $systemDrive /F /R"
    Write-Host $chkdskOutput
    $errorsFound = $chkdskOutput -match "errors found"
    
    if ($errorsFound) {
        Update-ProgressBar -current 6 -total 7
        Write-Host "Errors found on $systemDrive. Scheduling full chkdsk at next reboot."
    } else {
        Update-ProgressBar -current 6 -total 7
        Write-Host "No errors found on $systemDrive. Skipping full chkdsk at next reboot."
    }
} catch {
    Write-Host "An error occurred while running chkdsk: $_"
}
Write-Host " "
Start-Sleep -Seconds 2

# Complete
Update-ProgressBar -current 7 -total 7
Write-Host "`nCleanup complete."
Write-Host " "
Write-Host "Your PC will thank you later :)"
Write-Host " "
} catch {
    Write-Host "An error occurred: $_"
}



