# WinClean script - PowerShell version

# Display a warning message
Write-Host "WARNING: This script will clean up temporary files, clear the recycle bin, and perform disk cleanup. Make sure to back up any important data before running this script."

# Prompt the user for confirmation before proceeding
$confirmation = Read-Host "Do you want to continue? (Y/N)"
if ($confirmation -ne "Y") {
    Write-Host "Script execution canceled."
    exit
}


# Disable Microsoft Edge and Microsoft Edge Update
Write-Host "Disabling Microsoft Edge startup impact..."

# Get the path to the msedge.exe executable
#edgePath = Get-Command msedge.exe | Select-Object -Property Path

# Disable msedge.exe
Set-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run $edgePath -Value $null

# Restart Explorer
Stop-Process -Name explorer.exe
Start-Process -Name explorer.exe

Write-Host "Microsoft Edge startup impact disabled."
Start-Sleep -Seconds 5

# Clean up temporary files
Write-Host "Cleaning up temporary files..."
Remove-Item -Path $env:TEMP\* -Force -Recurse -ErrorAction Stop
Write-Host "Temporary files cleaned."
Start-Sleep -Seconds 5

# Clear the recycle bin
Write-Host "Clearing the recycle bin..."
Clear-RecycleBin -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 5

# Perform disk cleanup of system files
Write-Host "Performing disk cleanup..."
Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1" -Wait
Write-Host "Disk cleanup of system files completed."
Start-Sleep -Seconds 5


# Uninstall unwanted or unnecessary programs
<# function Uninstall-Program {
    param(
        [string]$programName
    )

    Write-Host "Uninstalling program: $programName"
    Start-Process -FilePath "wmic" -ArgumentList "product where `"`"name='$programName'`" call uninstall" -Wait
    Write-Host "Program '$programName' uninstalled."
} #>

# Example usage
Write-Host "Cleanup complete."
