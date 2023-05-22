# WinClean script - PowerShell version

# Display a warning message
Write-Host "WARNING: This script will clean up temporary files, clear the recycle bin, and perform disk cleanup. Make sure to back up any important data before running this script."

# Prompt the user for confirmation before proceeding
$confirmation = Read-Host "Do you want to continue? (Y/N)"
if ($confirmation -ne "Y") {
    Write-Host "Script execution canceled."
    exit
}

# Disable common program startup impact
Write-Host "Disabling program startup impact..."

# Disable Microsoft Edge
$edgeExclusion = "Microsoft.MicrosoftEdge"
$edgeUpdateExclusion = "Microsoft.MicrosoftEdge.Update"

$edgeStartupStatus = (Get-MpPreference).ExclusionProcess | Where-Object { $_ -eq $edgeExclusion }
if ($edgeStartupStatus) {
    Write-Host "Microsoft Edge startup impact is already disabled."
}
else {
    Set-MpPreference -ExclusionProcess ($edgeExclusion, $edgeUpdateExclusion)
    Write-Host "Microsoft Edge startup impact disabled."
}

Write-Host "Program startup impact disabled."

# Clean up temporary files
Write-Host "Cleaning up temporary files..."
Remove-Item -Path $env:TEMP\* -Force -Recurse
Write-Host "Temporary files cleaned."
Start-Sleep -Seconds 2

# Clear the recycle bin
Write-Host "Clearing the recycle bin..."
Clear-RecycleBin -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

# Perform disk cleanup of system files
Write-Host "Performing disk cleanup..."
Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1" -Wait
Write-Host "Disk cleanup of system files completed."
Start-Sleep -Seconds 2


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
