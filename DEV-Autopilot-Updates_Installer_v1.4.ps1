#Start logging
Start-Transcript -Path "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\Device_Autopilot_Updates_v1.4.log"
#Install prerequisite
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.021 -Force
Install-Module -Name PSWindowsUpdate -Force
Import-Module -Name PSWindowsUpdate -Force
#Register to MS Update Service
Add-WUServiceManager -ServiceID "7971f918-a847-4430-9279-4a52d1efe18d" -Confirm:$false
#Download and install drivers. Multiple times because command might break between driver installs
Install-WindowsUpdate -Install -AcceptAll -UpdateType Software -MicrosoftUpdate -NotCategory 'Definition Updates' -Download -IgnoreReboot | Out-File "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\Device_Autopilot_Updates_Install_part1_$(Get-date -Format dd-MMM-yyyy-hh.mm.ss).log" -Force -ErrorAction SilentlyContinue
Start-Sleep -s 30
Install-WindowsUpdate -Install -AcceptAll -UpdateType Software -MicrosoftUpdate -NotCategory 'Definition Updates' -Download -IgnoreReboot | Out-File "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\Device_Autopilot_Updates_Install_part2_$(Get-date -Format dd-MMM-yyyy-hh.mm.ss).log" -Force -ErrorAction SilentlyContinue
Start-Sleep -s 30
Install-WindowsUpdate -Install -AcceptAll -UpdateType Software -MicrosoftUpdate -NotCategory 'Definition Updates' -Download -IgnoreReboot | Out-File "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\Device_Autopilot_Updates_Install_part3_$(Get-date -Format dd-MMM-yyyy-hh.mm.ss).log" -Force -ErrorAction SilentlyContinue
Start-Sleep -s 30
Install-WindowsUpdate -Install -AcceptAll -UpdateType Software -MicrosoftUpdate -NotCategory 'Definition Updates' -Download -IgnoreReboot | Out-File "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\Device_Autopilot_Updates_Install_part4_$(Get-date -Format dd-MMM-yyyy-hh.mm.ss).log" -Force -ErrorAction SilentlyContinue
Start-Sleep -s 30
Install-WindowsUpdate -Install -AcceptAll -UpdateType Software -MicrosoftUpdate -NotCategory 'Definition Updates' -Download -IgnoreReboot | Out-File "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\Device_Autopilot_Updates_Install_part5_$(Get-date -Format dd-MMM-yyyy-hh.mm.ss).log" -Force -ErrorAction SilentlyContinue
Start-Sleep -s 30
Install-WindowsUpdate -Install -AcceptAll -UpdateType Software -MicrosoftUpdate -NotCategory 'Definition Updates' -Download -IgnoreReboot | Out-File "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\Device_Autopilot_Updates_Install_part6_$(Get-date -Format dd-MMM-yyyy-hh.mm.ss).log" -Force -ErrorAction SilentlyContinue
Start-Sleep -s 30
Install-WindowsUpdate -Install -AcceptAll -UpdateType Software -MicrosoftUpdate -NotCategory 'Definition Updates' -Download -IgnoreReboot | Out-File "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\Device_Autopilot_Updates_Install_part7_$(Get-date -Format dd-MMM-yyyy-hh.mm.ss).log" -Force -ErrorAction SilentlyContinue
Start-Sleep -s 30
Install-WindowsUpdate -Install -AcceptAll -UpdateType Software -MicrosoftUpdate -NotCategory 'Definition Updates' -Download -IgnoreReboot | Out-File "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\Device_Autopilot_Updates_Install_part8_$(Get-date -Format dd-MMM-yyyy-hh.mm.ss).log" -Force -ErrorAction SilentlyContinue
Start-Sleep -s 30
#Stop logging
Stop-Transcript
New-Item "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\Device_Autopilot_Updates_v1.4_detect.log" -ItemType File -Value "LABS Update Installer during Autopilot"