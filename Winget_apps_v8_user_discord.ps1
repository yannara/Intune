#Start logging
Start-Transcript -Path "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\LABS_winget_Discord_v8_install_script.log"
#Download winget to local drive, CHANGE the location for your need
Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile C:\Intune\Winget\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
#Install Winget to user context
Add-AppxPackage -Path 'C:\Intune\Winget\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle'
#Wait 15 seconds
Start-Sleep -Seconds 15
#Install the app
winget install Discord.Discord --silent --accept-package-agreements --accept-source-agreements
#Wait 120 seconds
Start-Sleep -Seconds 120
#Removing autostart feature for Discord
Remove-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" -Name Discord -Force -ErrorAction SilentlyContinue
#End logging
Stop-Transcript
Exit