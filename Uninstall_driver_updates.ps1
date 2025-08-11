#Start logging
Start-Transcript -Path "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\LABS_Uninstall_Drivers_Update.log"
#Uninstall this app by deleting folder with logs
Remove-Item -Recurse -Force -Path "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\LABS_Drivers_Update_v15.log"
#Stop logging
Stop-Transcript