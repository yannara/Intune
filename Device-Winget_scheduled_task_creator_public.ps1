#Start logging
Start-Transcript -Path "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\winget_upgrade_all_apps_recurrent_scheduled_task_creator.log"

#Create folders for data saving
New-Item -ItemType directory -Path C:\Intune -ErrorAction SilentlyContinue
New-Item -ItemType directory -Path C:\Intune\Winget -ErrorAction SilentlyContinue

#Enable All Tasks History
wevtutil set-log Microsoft-Windows-TaskScheduler/Operational /enabled:true

#Copy file from package root to the desired location
Copy-Item $PSScriptRoot\Device-Winget_upgrade_all_apps_public.ps1 -Destination C:\Intune\Winget -ErrorAction SilentlyContinue

# Define the scheduled task action
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"C:\Intune\Winget\Device-Winget_upgrade_all_apps_public.ps1`""
 
# Define the trigger to run the task once a month
$trigger = New-ScheduledTaskTrigger -Weekly -WeeksInterval 4 -DaysOfWeek Monday -At 10am
 
# Define the scheduled task settings
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -Compatibility Win8 -RunOnlyIfNetworkAvailable -DontStopOnIdleEnd -WakeToRun
 
# Define the scheduled task principal (current user)
$principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
 
# Register the scheduled task
Register-ScheduledTask -TaskName "Winget upgrade all apps" -Action $action -Trigger $trigger -Settings $settings -Principal $principal

#Stop logging
Stop-Transcript