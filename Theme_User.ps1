#Set Custom Wallpaper in use
New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Control Panel\Desktop" -Name WallPaper -Value " C:\Yourfolder\Your_Wallpaper_v1.0.jpg" -PropertyType String -Force -ErrorAction SilentlyContinue
#Set Taskbar color to match wallpaper (v1.5 v2.8, v4.0)
New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name ColorPrevalence -Value "1" -PropertyType DWord -Force
#Automatically pick an color from wallpaper to windows menu (v1.7, v2.1 v2.8)
New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Control Panel\Desktop" -Name AutoColorization -Value "1" -PropertyType DWord -Force