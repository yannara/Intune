#Start logging (v3.6, 3.8, 4.1, 4.6)
Start-Transcript -Path "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\Device_Configuration-Registry_v4.7.log"

#LABS Windows Client OS Cloud Device Configuration
#12.9.2026 v4.7 @Pavel Mirochnitchenko

#Settings change and version
#Removed multiple obsolete enteties from v3.2 release
#Moved regional settings from User Settings to Device Settings (v4.7)
Set-winhomelocation -GeoID "77"
Set-Culture -CultureInfo "fi-FI"
Set-TimeZone -Name 'FLE Standard Time' -PassThru

#Disable Lockscreen to blur (v1.0, v2.3)
New-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System" -ErrorAction SilentlyContinue
New-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System" -Name DisableAcrylicBackgroundOnLogon -Value "1" -PropertyType DWord -Force -ErrorAction SilentlyContinue
#Disable Grouping in Taskbar (v.1.31, v2.3)
New-Item -Path "Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -ErrorAction SilentlyContinue
New-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name NoTaskGrouping -Value "1" -PropertyType DWord -Force -ErrorAction SilentlyContinue
#Disable Fast startup (v 1.4, 1.5, v2.3)
New-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name HiberbootEnabled -Value "0" -PropertyType DWord -Force
#Disable Fujitsu Battery Check (v2.0, 2.1, 2.2, v2.3, v2.6)
Remove-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run" -Name "FjBatteryLimitter" -Force -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run" -Name "FUJ02B1_Apps" -Force -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run" -Name "FUJ02E3_BatteryChargingControlUpdate" -Force -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" -Name "FUJ02E3_BatteryChargingControlUpdate" -Force -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "FUJ02B1_Apps" -Force -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "FUJ02E3_BatteryChargingControlUpdate" -Force -ErrorAction SilentlyContinue
#Bypass Windows 11 hardware check (v2.8)
New-Item -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\Setup\MoSetup" -ErrorAction SilentlyContinue
New-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\Setup\MoSetup" -Name AllowUpgradesWithUnsupportedTPMOrCPU -Value "1" -PropertyType DWord -Force -ErrorAction SilentlyContinue
#Set Lockscreen location (v3.9, v4.3)
New-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Personalization" -ErrorAction SilentlyContinue
New-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Name LockScreenImage -Value "C:\Intune\Netox_Lockscreen.jpg" -PropertyType String -Force -ErrorAction SilentlyContinue
#Set Lockscreen location for Windows Professional SKU (v3.5, v3.7, v3.9, v4.0)
New-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP" -ErrorAction SilentlyContinue
New-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP" -Name LockScreenImagePath -Value "C:\Intune\Netox_Lockscreen.jpg" -PropertyType String -Force -ErrorAction SilentlyContinue
New-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP" -Name LockScreenImageUrl -Value "C:\Intune\Netox_Lockscreen.jpg" -PropertyType String -Force -ErrorAction SilentlyContinue
New-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP" -Name LockScreenImageStatus -Value "0" -PropertyType DWord -Force -ErrorAction SilentlyContinue
#Disable Tips and Suggestions Notifications (v3.7)
New-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -ErrorAction SilentlyContinue
New-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name DisableSoftLanding -Value "1" -PropertyType DWord -Force -ErrorAction SilentlyContinue
#Disable Automatic restart during BSOD (v4.2)
New-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CrashControl" -Name AutoReboot -Value "0" -PropertyType DWord -Force -ErrorAction SilentlyContinue
#Disable First Run Welcome Page in Edge browser
New-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\MicrosoftEdge" -ErrorAction SilentlyContinue
New-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\MicrosoftEdge" -Name PreventFirstRunPage -Value "1" -PropertyType DWord -Force -ErrorAction SilentlyContinue

#Version Management
Remove-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" -Name "LABS Device Configuration" -Force -ErrorAction SilentlyContinue
New-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" -Name "LABS Device Configuration" -Value "v4.7" -PropertyType String -Force

#Stop logging (v3.5)
Stop-Transcript