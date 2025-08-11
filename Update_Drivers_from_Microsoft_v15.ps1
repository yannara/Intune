#Created by Pavel Mirochnitchenko MVP.
#Matches any available drivers from Microsoft Update Catalog based on Plug&Play detection. Also updates BIOS if available. Compatible with Intune Autopilot. 
﻿#Start logging
Start-Transcript -Path "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\LABS_Drivers_Update_v15.log"
#Install prerequisite
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.021 -Force
Install-Module -Name PSWindowsUpdate -Force
Import-Module -Name PSWindowsUpdate -Force
#Register to MS Update Service
Add-WUServiceManager -ServiceID "7971f918-a847-4430-9279-4a52d1efe18d" -Confirm:$false
#Download and install drivers. Multiple times because command might break between driver installs
Install-WindowsUpdate -Install -AcceptAll -UpdateType Driver -MicrosoftUpdate -ForceDownload -ForceInstall -IgnoreReboot -RecurseCycle 4 | Out-File "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\LABS_Drivers_Install_from_Microsoft_Catalog_part1_$(Get-date -Format dd-MMM-yyyy-hh.mm.ss).log" -Force -ErrorAction SilentlyContinue
Start-Sleep -s 30
Install-WindowsUpdate -Install -AcceptAll -UpdateType Driver -MicrosoftUpdate -ForceDownload -ForceInstall -IgnoreReboot -RecurseCycle 4 | Out-File "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\LABS_Drivers_Install_from_Microsoft_Catalog_part2_$(Get-date -Format dd-MMM-yyyy-hh.mm.ss).log" -Force -ErrorAction SilentlyContinue
Start-Sleep -s 30
Install-WindowsUpdate -Install -AcceptAll -UpdateType Driver -MicrosoftUpdate -ForceDownload -ForceInstall -IgnoreReboot -RecurseCycle 4 | Out-File "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\LABS_Drivers_Install_from_Microsoft_Catalog_part3_$(Get-date -Format dd-MMM-yyyy-hh.mm.ss).log" -Force -ErrorAction SilentlyContinue
Start-Sleep -s 30
Install-WindowsUpdate -Install -AcceptAll -UpdateType Driver -MicrosoftUpdate -ForceDownload -ForceInstall -IgnoreReboot -RecurseCycle 4 | Out-File "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\LABS_Drivers_Install_from_Microsoft_Catalog_part4_$(Get-date -Format dd-MMM-yyyy-hh.mm.ss).log" -Force -ErrorAction SilentlyContinue
Start-Sleep -s 30
Install-WindowsUpdate -Install -AcceptAll -UpdateType Driver -MicrosoftUpdate -ForceDownload -ForceInstall -IgnoreReboot -RecurseCycle 4 | Out-File "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\LABS_Drivers_Install_from_Microsoft_Catalog_part5_$(Get-date -Format dd-MMM-yyyy-hh.mm.ss).log" -Force -ErrorAction SilentlyContinue
Start-Sleep -s 30
Install-WindowsUpdate -Install -AcceptAll -UpdateType Driver -MicrosoftUpdate -ForceDownload -ForceInstall -IgnoreReboot -RecurseCycle 4 | Out-File "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\LABS_Drivers_Install_from_Microsoft_Catalog_part6_$(Get-date -Format dd-MMM-yyyy-hh.mm.ss).log" -Force -ErrorAction SilentlyContinue
Start-Sleep -s 30
Install-WindowsUpdate -Install -AcceptAll -UpdateType Driver -MicrosoftUpdate -ForceDownload -ForceInstall -IgnoreReboot -RecurseCycle 4 | Out-File "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\LABS_Drivers_Install_from_Microsoft_Catalog_part7_$(Get-date -Format dd-MMM-yyyy-hh.mm.ss).log" -Force -ErrorAction SilentlyContinue
Start-Sleep -s 30
Install-WindowsUpdate -Install -AcceptAll -UpdateType Driver -MicrosoftUpdate -ForceDownload -ForceInstall -IgnoreReboot -RecurseCycle 4 | Out-File "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\LABS_Drivers_Install_from_Microsoft_Catalog_part8_$(Get-date -Format dd-MMM-yyyy-hh.mm.ss).log" -Force -ErrorAction SilentlyContinue
Start-Sleep -s 30
#Create detection method
Add-Content "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\LABS_Drivers_Update_v15.log" "Drivers update completed" -ErrorAction SilentlyContinue
#Stop logging
Stop-Transcript
