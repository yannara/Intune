#Create new folder for Theme pictures if not exist
New-Item -ItemType directory -Path C:\Yourfolder -ErrorAction SilentlyContinue
#Copy the file to folder
Copy-Item $PSScriptRoot\Your_Lockscreen_v1.0.jpg C:\Yourfolder
Copy-Item $PSScriptRoot\Your_Wallpaper_v1.0.jpg C:\Yourfolder
#Disable Lockscreen to blur
New-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System" -ErrorAction SilentlyContinue
New-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System" -Name DisableAcrylicBackgroundOnLogon -Value "1" -PropertyType DWord -Force -ErrorAction SilentlyContinue
#Set Lockscreen location 
New-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Personalization" -ErrorAction SilentlyContinue
New-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Name LockScreenImage -Value "C:\Yourfolder\Your_Lockscreen_v1.0.jpg" -PropertyType String -Force -ErrorAction SilentlyContinue