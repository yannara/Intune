#Create folders for logging
New-Item -ItemType directory -Path C:\Intune -ErrorAction SilentlyContinue
New-Item -ItemType directory -Path C:\Intune\Logs -ErrorAction SilentlyContinue
#Hide LABS folder
$f=get-item C:\Intune -Force
$f.attributes="Hidden"
#Start logging
Start-Transcript -Path "C:\Intune\Logs\winget_install_apps_v1.6.log"
#Install Winget
Install-Module -Name Microsoft.WinGet.Client -Confirm:$False -Force
Start-Sleep -Seconds 15
#Reser source
Start-Process -FilePath "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe\winget.exe" -NoNewWindow -Wait -ArgumentList 'source reset --force'
Start-Sleep -Seconds 15
#Upgrade Winget source
Start-Process -FilePath "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe\winget.exe" -NoNewWindow -Wait -ArgumentList 'source update --disable-interactivity'
Start-Sleep -Seconds 15
#Install 7zip with Winget
Start-Process -FilePath "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe\winget.exe" -NoNewWindow -Wait -ArgumentList 'install 7zip.7zip --silent --accept-package-agreements --accept-source-agreements'
Start-Sleep -Seconds 15
#Install VLC player with Winget
Start-Process -FilePath "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe\winget.exe" -NoNewWindow -Wait -ArgumentList 'install VideoLAN.VLC --silent --accept-package-agreements --accept-source-agreements'
Start-Sleep -Seconds 15
#Stop logging
Stop-Transcript
#Create detection method
New-Item "C:\Intune\Logs\winget_install_apps_v1.6.txt" -ItemType File -Value "Winget Application installer"