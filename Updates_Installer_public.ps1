#Install prerequisite
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.021 -Force
Install-Module -Name PSWindowsUpdate -Force
Import-Module -Name PSWindowsUpdate -Force
#Register to MS Update Service
Add-WUServiceManager -ServiceID "7971f918-a847-4430-9279-4a52d1efe18d" -Confirm:$false
#Download and install drivers. Multiple times because command might break between driver installs
Install-WindowsUpdate -Install -AcceptAll -UpdateType Software -MicrosoftUpdate -NotCategory 'Definition Updates' -Download -IgnoreReboot | Out-File "C:\Yourfoldersomewhere\Updates_Install_part1_$(Get-date -Format dd-MMM-yyyy-hh.mm.ss).log" -Force -ErrorAction SilentlyContinue
Start-Sleep -s 30
Install-WindowsUpdate -Install -AcceptAll -UpdateType Software -MicrosoftUpdate -NotCategory 'Definition Updates' -Download -IgnoreReboot | Out-File "C:\Yourfoldersomewhere\Updates_Install_part2_$(Get-date -Format dd-MMM-yyyy-hh.mm.ss).log" -Force -ErrorAction SilentlyContinue
Start-Sleep -s 30
Install-WindowsUpdate -Install -AcceptAll -UpdateType Software -MicrosoftUpdate -NotCategory 'Definition Updates' -Download -IgnoreReboot | Out-File "C:\Yourfoldersomewhere\Updates_Install_part3_$(Get-date -Format dd-MMM-yyyy-hh.mm.ss).log" -Force -ErrorAction SilentlyContinue
Start-Sleep -s 30
Install-WindowsUpdate -Install -AcceptAll -UpdateType Software -MicrosoftUpdate -NotCategory 'Definition Updates' -Download -IgnoreReboot | Out-File "C:\Yourfoldersomewhere\Updates_Install_part4_$(Get-date -Format dd-MMM-yyyy-hh.mm.ss).log" -Force -ErrorAction SilentlyContinue
Start-Sleep -s 30
Install-WindowsUpdate -Install -AcceptAll -UpdateType Software -MicrosoftUpdate -NotCategory 'Definition Updates' -Download -IgnoreReboot | Out-File "C:\Yourfoldersomewhere\Updates_Install_part5_$(Get-date -Format dd-MMM-yyyy-hh.mm.ss).log" -Force -ErrorAction SilentlyContinue
Start-Sleep -s 30
Install-WindowsUpdate -Install -AcceptAll -UpdateType Software -MicrosoftUpdate -NotCategory 'Definition Updates' -Download -IgnoreReboot | Out-File "C:\Yourfoldersomewhere\Updates_Install_part6_$(Get-date -Format dd-MMM-yyyy-hh.mm.ss).log" -Force -ErrorAction SilentlyContinue
Start-Sleep -s 30
Install-WindowsUpdate -Install -AcceptAll -UpdateType Software -MicrosoftUpdate -NotCategory 'Definition Updates' -Download -IgnoreReboot | Out-File "C:\Yourfoldersomewhere\Updates_Install_part7_$(Get-date -Format dd-MMM-yyyy-hh.mm.ss).log" -Force -ErrorAction SilentlyContinue
Start-Sleep -s 30
Install-WindowsUpdate -Install -AcceptAll -UpdateType Software -MicrosoftUpdate -NotCategory 'Definition Updates' -Download -IgnoreReboot | Out-File "C:\Yourfoldersomewhere\Updates_Install_part8_$(Get-date -Format dd-MMM-yyyy-hh.mm.ss).log" -Force -ErrorAction SilentlyContinue
Start-Sleep -s 30
#Create file Detection method
New-Item "C:\Yourfoldersomewhere\Updates_detect_file.txt" -ItemType File -Value "This Windows has been successfully patched during Autopilot"