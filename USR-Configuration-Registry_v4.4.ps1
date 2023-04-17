#Start logging
Start-Transcript -Path "C:\LABS\Logs_USR-Configuration-Registry_v4.4.txt"

#LABS Windows Client OS Cloud User Configuration
#24.2.2023 v4.4 @Pavel Mirochnitchenko

#Settings change and version
#Removed multiple obsolete enteties from v3.8 release
#Regional Settings to Finnish (v1.0, v1.9, v2.6, v2.7, v2.8)
New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Control Panel\International" -Name Locale -Value "0000040B" -PropertyType String -Force
New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Control Panel\International" -Name LocaleName -Value "fi-FI" -PropertyType String -Force
New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Control Panel\International" -Name sCountry -Value "Finland" -PropertyType String -Force
New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Control Panel\International" -Name sCurrency -Value "€" -PropertyType String -Force 
New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Control Panel\International" -Name sDate -Value "." -PropertyType String -Force
New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Control Panel\International" -Name sLanguage -Value "FIN" -PropertyType String -Force
New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Control Panel\International" -Name sLongDate -Value "dddd d. MMMM yyyy" -PropertyType String -Force
New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Control Panel\International" -Name sShortDate -Value "d.M.yyyy" -PropertyType String -Force
New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Control Panel\International" -Name sShortTime -Value "H.mm" -PropertyType String -Force
New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Control Panel\International" -Name sTimeFormat -Value "H:mm:ss" -PropertyType String -Force
New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Control Panel\International" -Name sYearMonth -Value "MMMM yyyy" -PropertyType String -Force
New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Control Panel\International\Geo" -Name Nation -Value "77" -PropertyType String -Force
New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Control Panel\International\Geo" -Name Name -Value "FI" -PropertyType String -Force

#Remove Search in Taskbar (v1.4 v2.8)
New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Search" -Name SearchboxTaskbarMode -Value "0" -PropertyType DWord -Force
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
#Set Custom Wallpaper in use (v4.1)
New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Control Panel\Desktop" -Name WallPaper -Value "C:\LABS\Telia_Wallpaper_v1.4.jpg" -PropertyType String -Force -ErrorAction SilentlyContinue
#Enable Show More Options in File Explorer for Windows 11 (v4.2, v4.3, v4.4)
New-Item -Path "Registry::HKEY_CURRENT_USER\SOFTWARE\CLASSES\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" -Force -Value Null


#Version Management
Remove-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Environment" -Name "LABS User Configuration" -Force -ErrorAction SilentlyContinue
New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Environment" -Name "LABS User Configuration" -Value "v4.4" -PropertyType String -Force
#Create new folder for savings if not exist (v3.8)
New-Item -ItemType directory -Path C:\LABS -ErrorAction SilentlyContinue
#Create log file
New-Item "C:\LABS\USR-Conf_v4.4.txt" -ItemType File -Value "LABS Windows Client OS Cloud User Configuration"
Add-Content "C:\LABS\USR-Conf_v4.4.txt" "USR-Conf_v4.4"
Add-Content "C:\LABS\USR-Conf_v4.4.txt" "24.2.2023 @Pavel Mirochnitchenko"
#Stop logging
Stop-Transcript