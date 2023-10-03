#Start logging
Start-Transcript -Path "C:\Windows\Debug\RemoveAdmin_2.2.txt"
#Remove current user from local admin group
Remove-LocalGroupMember -SID "S-1-5-32-544" -Member "AzureAD\$env:USERNAME" -ErrorAction SilentlyContinue
#Stop logging
Stop-Transcript
