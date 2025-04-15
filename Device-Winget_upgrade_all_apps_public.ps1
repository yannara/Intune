#Start logging
Start-Transcript -Path "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\winget_upgrade_all_apps_recurrent.log"

#Create folders for data saving
New-Item -ItemType directory -Path C:\Intune -ErrorAction SilentlyContinue
New-Item -ItemType directory -Path C:\Intune\Winget -ErrorAction SilentlyContinue

#Install Winget components baded in Microsoft Docs instruction
Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile C:\Intune\Winget\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle -TimeoutSec 0
Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile C:\Intune\Winget\Microsoft.VCLibs.x64.14.00.Desktop.appx -TimeoutSec 0
Invoke-WebRequest -Uri https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.8.6/Microsoft.UI.Xaml.2.8.x64.appx -OutFile C:\Intune\Winget\Microsoft.UI.Xaml.2.8.x64.appx -TimeoutSec 0

#Apply packages in System Context

#Component Microsoft.VCLibs is okay to fail because Windows might be patched already
Add-AppxProvisionedPackage -Online -PackagePath 'C:\Intune\Winget\Microsoft.VCLibs.x64.14.00.Desktop.appx' -SkipLicense -ErrorAction SilentlyContinue
Add-AppxProvisionedPackage -Online -PackagePath 'C:\Intune\Winget\Microsoft.UI.Xaml.2.8.x64.appx' -SkipLicense -ErrorAction SilentlyContinue
Add-AppxProvisionedPackage -Online -PackagePath 'C:\Intune\Winget\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle' -SkipLicense
Start-Sleep -Seconds 120

#Select newest winget.exe file based on folder order and set it as winget variable 
$winget=Get-ChildItem -Path 'C:\Program Files\WindowsApps\' -Filter winget.exe -recurse | Sort-Object -Property 'FullName' -Descending | Select-Object -First 1 -ExpandProperty FullName | Tee-Object -FilePath C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\winget_upgrade_all_apps_recurrent_file-found-from.log

#Reset source
Start-Process -FilePath $winget -NoNewWindow -Wait -ArgumentList 'source reset --force --verbose-logs' -RedirectStandardOutput C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\LABS_winget_upgrade_all_apps_recurrent_source-reset.log
Start-Sleep -Seconds 120

#Upgrade Winget source
Start-Process -FilePath $winget -NoNewWindow -Wait -ArgumentList 'source update' -RedirectStandardOutput C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\winget_upgrade_all_apps_recurrent_source-update.log
Start-Sleep -Seconds 120

#Upgrade desired apps
Start-Process -FilePath $winget -NoNewWindow -Wait -ArgumentList 'upgrade Google.Chrome --silent --accept-package-agreements --accept-source-agreements' -RedirectStandardOutput C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\winget_upgrade_all_apps_recurrent_Chrome.log
Start-Process -FilePath $winget -NoNewWindow -Wait -ArgumentList 'upgrade VideoLAN.VLC --silent --accept-package-agreements --accept-source-agreements' -RedirectStandardOutput C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\winget_upgrade_all_apps_recurrent_VLC.log
Start-Process -FilePath $winget -NoNewWindow -Wait -ArgumentList 'upgrade 7zip.7zip --silent --accept-package-agreements --accept-source-agreements' -RedirectStandardOutput C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\winget_upgrade_all_apps_recurrent_7Zip_october.log

#Stop logging
Stop-Transcript
