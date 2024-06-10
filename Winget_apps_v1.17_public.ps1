#Create folders for logging
New-Item -ItemType directory -Path C:\Intune -ErrorAction SilentlyContinue
New-Item -ItemType directory -Path C:\Intune\Winget -ErrorAction SilentlyContinue
#Start logging
Start-Transcript -Path "C:\Intune\Winget\winget_install_apps_v1.17.log"
#Install Winget components baded in Microsoft Docs instruction
Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile C:\Intune\Winget\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile C:\Intune\Winget\Microsoft.VCLibs.x64.14.00.Desktop.appx
Invoke-WebRequest -Uri https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.8.6/Microsoft.UI.Xaml.2.8.x64.appx -OutFile C:\Intune\Winget\Microsoft.UI.Xaml.2.8.x64.appx
#Apply packages in System Context
#Component Microsoft.VCLibs is okay to fail because Windows might be patched already
Add-AppxProvisionedPackage -Online -PackagePath 'C:\Intune\Winget\Microsoft.VCLibs.x64.14.00.Desktop.appx' -SkipLicense -ErrorAction SilentlyContinue
Add-AppxProvisionedPackage -Online -PackagePath 'C:\Intune\Winget\Microsoft.UI.Xaml.2.8.x64.appx' -SkipLicense -ErrorAction SilentlyContinue
Add-AppxProvisionedPackage -Online -PackagePath 'C:\Intune\Winget\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle' -SkipLicense
Start-Sleep -Seconds 15
#Select newest winget.exe file based on folder order and set it as winget variable. File location will be displayed in C:\Intune\Winget\Winget-file-found-from.log. If log file is missing, winget.exe is not found.
$winget=Get-ChildItem -Path 'C:\Program Files\WindowsApps\' -Filter winget.exe -recurse | Sort-Object -Property 'FullName' -Descending | Select-Object -First 1 -ExpandProperty FullName | Tee-Object -FilePath C:\Intune\Winget\Winget-file-found-from.log
#Reset source
Start-Process -FilePath $winget -NoNewWindow -Wait -ArgumentList 'source reset --force --verbose-logs' -RedirectStandardOutput C:\Intune\Winget\Winget-source-reset.log
Start-Sleep -Seconds 15
#Upgrade Winget source
Start-Process -FilePath $winget -NoNewWindow -Wait -ArgumentList 'source update' -RedirectStandardOutput C:\Intune\Winget\Winget-source-update.log
Start-Sleep -Seconds 15
#Install 7zip with Winget
Start-Process -FilePath $winget -NoNewWindow -Wait -ArgumentList 'install 7zip.7zip --silent --accept-package-agreements --accept-source-agreements' -RedirectStandardOutput C:\Intune\Winget\Winget-install-7zip.log
Start-Sleep -Seconds 15
#Install VLC player with Winget
Start-Process -FilePath $winget -NoNewWindow -Wait -ArgumentList 'install VideoLAN.VLC --silent --accept-package-agreements --accept-source-agreements' -RedirectStandardOutput C:\Intune\Winget\Winget-install-VLC.log
Start-Sleep -Seconds 15
#Stop logging
Stop-Transcript
#Create detection method
New-Item "C:\Intune\Winget\winget_install_apps_end_v1.17.txt" -ItemType File -Value "Winget Application installer"