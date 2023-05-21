# WinClean script - PowerShell version

# Display a warning message
Write-Host "WARNING: This script will clean up temporary files, clear the recycle bin, and perform disk cleanup. Make sure to back up any important data before running this script."

# Prompt the user for confirmation before proceeding
$confirmation = Read-Host "Do you want to continue? (Y/N)"
if ($confirmation -ne "Y") {
    Write-Host "Script execution canceled."
    exit
}

# Clean up temporary files
Write-Host "Cleaning up temporary files..."
Remove-Item -Path $env:TEMP\* -Force -Recurse
Write-Host "Temporary files cleaned."

# Clear the recycle bin
Write-Host "Clearing the recycle bin..."
Remove-Item -Path "C:\$Recycle.Bin" -Recurse -Force
Write-Host "Recycle bin cleared."

# Perform disk cleanup of system files
Write-Host "Performing disk cleanup..."
Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1" -Wait
Write-Host "Disk cleanup of system files completed."

# Clean temporary internet files
Write-Host "Cleaning temporary internet files..."
Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\Windows\INetCache\*.*" -Force -Recurse
Write-Host "Temporary internet files cleaned."

# Clean browser cache and history
Write-Host "Cleaning browser cache and history..."
# Chrome
Remove-Item -Path "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache" -Recurse -Force
Remove-Item -Path "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\History" -Force
# Firefox
Remove-Item -Path "$env:APPDATA\Mozilla\Firefox\Profiles\*\cache2" -Recurse -Force
Remove-Item -Path "$env:APPDATA\Mozilla\Firefox\Profiles\*\places.sqlite" -Force
Write-Host "Browser cache and history cleaned."

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
