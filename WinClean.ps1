# WinClean script - PowerShell version

# Display a warning message
Write-Host "WARNING: This script will clean up temporary files, clear the recycle bin, and perform disk cleanup. Make sure to back up any important data before running this script."

# Prompt the user for confirmation before proceeding
$confirmation = Read-Host "Do you want to continue? (Y/N)"
if ($confirmation -ne "Y") {
    Write-Host "Script execution canceled."
    exit
}

# Disbale non-essentially startup programs

# If Microsoft Edge is not set to start automatically, do nothing
$edgePath = Get-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Run | Select-Object -Property Value | Where-Object {$_ -eq "msedge.exe"}

if ($edgePath -eq $null) {
    Write-Host "Microsoft Edge is not set to start automatically."
}
else {
# Disable Microsoft Edge from starting automatically
    Set-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Run $edgePath -Value $null
    Write-Host "Disabling Microsoft Edge startup impact..."
}

Write-Host "Microsoft Edge startup impact disabled."

# Restart Explorer
Write-Host "Restarting Windows Explorer."
taskkill /f /im explorer.exe
start explorer.exe
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
