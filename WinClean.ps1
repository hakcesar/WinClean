# WinClean script - PowerShell version

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

Clear-Host

# Display a warning message
Write-Host "WARNING: This script will clean up temporary files, clear the recycle bin, and perform disk cleanup. Make sure to back up any important data before running this script."

# Prompt the user for confirmation before proceeding
$confirmation = Read-Host "Do you want to continue? (Y/N)"
if ($confirmation -ne "Y") {
    Write-Host "Script execution canceled."
    exit
}

# Disbale non-essential startup programs
Write-Host " "

# If Microsoft Edge is not set to start automatically, do nothing
$edgePath = Get-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Run | Select-Object -Property Value | Where-Object {$_ -eq "msedge.exe"}

if ($edgePath -eq $null) {
    Write-Host "Microsoft Edge is not set to start automatically."
    Write-Host " "
}
else {
    # Disable Microsoft Edge from starting automatically
    Write-Host "Disabling Microsoft Edge startup impact..."
    Set-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Run $edgePath -Value $null
    Write-Host "Microsoft Edge startup impact disabled."
    Write-Host " "
}

# Restart Explorer
Write-Host "Stopping Windows Explorer."
taskkill /f /im explorer.exe
Write-Host "Restarting Windows Explorer."
Write-Host " "
start explorer.exe
Start-Sleep -Seconds 5

# Clean up temporary files
Write-Host "Cleaning up temporary files..."
Remove-Item -Path $env:TEMP\* -Force -Recurse -ErrorAction Stop
Update-ProgressBar -current 1 -total 4
Write-Host "Temporary files cleaned."
Write-Host " "
Start-Sleep -Seconds 5

# Clear the recycle bin
Write-Host "Clearing the recycle bin..."
Clear-RecycleBin -Force -ErrorAction SilentlyContinue
Update-ProgressBar -current 2 -total 4
Write-Host "Permanently deleted the items in the recycle bin."
Write-Host " "
Start-Sleep -Seconds 5

# Perform disk cleanup of system files
Write-Host "Performing disk cleanup..."
Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1" -Wait
Update-ProgressBar -current 3 -total 4
Write-Host "Disk cleanup of system files completed."
Write-Host " "
Start-Sleep -Seconds 5

# Example usage
Update-ProgressBar -current 4 -total 4
Write-Host "`nCleanup complete."
Write-Host " "


