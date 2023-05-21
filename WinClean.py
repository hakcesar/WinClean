import os
import subprocess

# Clean temporary files
def clean_temp_files():
    print("Cleaning temporary files...")
    subprocess.run('del /q/f/s %TEMP%\\*.*', shell=True)
    print("Temporary files cleaned.")

# Clear recycle bin
def clear_recycle_bin():
    print("Clearing recycle bin...")
    subprocess.run('rd /s/q C:\\$Recycle.Bin', shell=True)
    print("Recycle bin cleared.")

# Perform disk cleanup of system files
def perform_disk_cleanup():
    print("Performing disk cleanup of system files...")
    subprocess.run('cleanmgr /sagerun:1', shell=True)
    print("Disk cleanup of system files completed.")

# Clean temporary internet files
def clean_temp_internet_files():
    print("Cleaning temporary internet files...")
    subprocess.run('del /q/f/s "%LOCALAPPDATA%\\Microsoft\\Windows\\INetCache\\*.*"', shell=True)
    print("Temporary internet files cleaned.")

# Clean browser cache and history
def clean_browser_data():
    print("Cleaning browser cache and history...")
    # Chrome
    subprocess.run('rd /s/q "%LOCALAPPDATA%\\Google\\Chrome\\User Data\\Default\\Cache"', shell=True)
    subprocess.run('del /q/f/s "%LOCALAPPDATA%\\Google\\Chrome\\User Data\\Default\\History"', shell=True)
    # Firefox
    subprocess.run('rd /s/q "%APPDATA%\\Mozilla\\Firefox\\Profiles\\*\\cache2"', shell=True)
    subprocess.run('del /q/f/s "%APPDATA%\\Mozilla\\Firefox\\Profiles\\*\\places.sqlite"', shell=True)
    print("Browser cache and history cleaned.")

# Uninstall unwanted or unnecessary programs
# def uninstall_program(program_name):
#    print(f"Uninstalling program: {program_name}")
#    subprocess.run(f'start /wait wmic product where "name=\'{program_name}\'" call uninstall', shell=True)
#    print(f"Program '{program_name}' uninstalled.")

# Display warning message
def display_warning():
    print("WARNING: This script will perform operations that may result in the loss of important files.")
    print("Please ensure that you have backed up any essential data before proceeding.")

# Example usage
if __name__ == '__main__':
    display_warning()
    response = input("Do you want to proceed? (Y/N): ")
    if response.lower() == 'y':
        clean_temp_files()
        clear_recycle_bin()
        perform_disk_cleanup()
        clean_temp_internet_files()
        clean_browser_data()
        #uninstall_program("Unwanted Program 1")
        #uninstall_program("Unwanted Program 2")
        # Add more uninstall_program calls as needed
    else:
        print("Script execution canceled.")
