#Start logging
Start-Transcript -Path "C:\Windows\Debug\RemoveAdmin_2.1.txt"
#Remove current user from local admin group
Remove-LocalGroupMember -SID "S-1-5-32-544" -Member "AzureAD\$env:USERNAME"
#Stop logging
Stop-Transcript