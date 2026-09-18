#Create folder for logging (User context can't write under ProgramData)
New-Item -ItemType directory -Path C:\Intune\Logs -ErrorAction SilentlyContinue
#Start logging (v5.8)
Start-Transcript -Path "C:\Intune\Logs\User_Configuration-Registry_v5.8.log"
#LABS Windows Client OS Cloud User Configuration
#25.2.2026 v5.8 @Pavel Mirochnitchenko

#Settings change and version
#Removed multiple obsolete enteties from v3.8 release
#Re-done completely regional Settings to Finnish (v5.7)
Set-winhomelocation -GeoID "77"
Set-Culture -CultureInfo "fi-FI"
Set-TimeZone -Name 'FLE Standard Time' -PassThru

#Remove Search in Taskbar (v1.4 v2.8)
New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Search" -Name SearchboxTaskbarMode -Value "0" -PropertyType DWord -Force
#Disable Dark Theme (v5.4,5.5)
New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name AppsUseLightTheme -Value "1" -PropertyType DWord -Force
#Set Taskbar color to match wallpaper (v1.5 v2.8, v4.0)
New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name ColorPrevalence -Value "1" -PropertyType DWord -Force
#Automatically pick an color from wallpaper to windows menu (v1.7, v2.1 v2.8)
New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Control Panel\Desktop" -Name AutoColorization -Value "1" -PropertyType DWord -Force
#Always show all icons in the notification area (v1.5 v2.8)
New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name EnableAutoTray -Value "0" -PropertyType DWord -Force
#Reconfigure keyboard to FIN (v1.6 v2.8)
Remove-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Keyboard Layout\Preload" -Name 1 -Force -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Keyboard Layout\Preload" -Name 2 -Force -ErrorAction SilentlyContinue
New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Keyboard Layout\Preload" -Name 1 -Value "0000040b" -PropertyType String -Force
#Set virtual keyboard to appear automatically (v2.3 v2.8)
New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Software\Microsoft\TabletTip\1.7" -Name EnableDesktopModeAutoInvoke -Value "1" -PropertyType DWord -Force
#Show hidden file extensions (v2.4 v2.8)
New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name HideFileExt -Value "0" -PropertyType DWord -Force
#VLC Player language setting (v3.4, v3.5)
New-Item -Path "Registry::HKEY_CURRENT_USER\SOFTWARE\VideoLAN" -ErrorAction SilentlyContinue
New-Item -Path "Registry::HKEY_CURRENT_USER\SOFTWARE\VideoLAN\VLC" -ErrorAction SilentlyContinue
New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\SOFTWARE\VideoLAN\VLC" -Name Lang -Value "en" -PropertyType String -Force -ErrorAction SilentlyContinue
#Set Taskbar alightment to left in Windows 11
New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name TaskbarAl -Value "0" -PropertyType DWord -Force -ErrorAction SilentlyContinue
#Set Custom Wallpaper in use (v4.1, 4.9, 5.2, 5.3, 5.4)
New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Control Panel\Desktop" -Name WallPaper -Value "C:\Intune\Netox_Wallpaper.jpg" -PropertyType String -Force -ErrorAction SilentlyContinue
#Enable Show More Options in File Explorer for Windows 11 (v4.2, v4.3, v4.4)
New-Item -Path "Registry::HKEY_CURRENT_USER\SOFTWARE\CLASSES\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" -Force -Value Null
#Remove Discord autolaunch (v4.5)
Remove-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" -Name Discord -Force -ErrorAction SilentlyContinue

#Version Management
Remove-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Environment" -Name "LABS User Configuration" -Force -ErrorAction SilentlyContinue
New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Environment" -Name "LABS User Configuration" -Value "v5.8" -PropertyType String -Force
#Stop logging
Stop-Transcript