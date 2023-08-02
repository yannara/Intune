#Start logging
Start-Transcript -Path "C:\Windows\Debug\LocalAdmin_v1.4.txt"
#Create new admin user and change it's properties. Applies also to existing users.
Remove-LocalUser -Name "labsadmin" -ErrorAction SilentlyContinue
New-LocalUser "labsadmin" -Password (ConvertTo-SecureString -AsPlainText -Force 'Zipperi2012') -FullName "LABS Admin" -Description "Local admin account" -UserMayNotChangePassword:$true -PasswordNeverExpires:$true
Add-LocalGroupMember -SID "S-1-5-32-544" -Member "labsadmin"
#Create Detection method
New-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\LABS" -ErrorAction SilentlyContinue
New-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\LABS\LocalAdminAccount" -ErrorAction SilentlyContinue
#Create registry value under recently created key
New-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\LABS\LocalAdminAccount" -Name Version -Value "1.4" -PropertyType String -Force -ErrorAction SilentlyContinue  
#Stop logging
Stop-Transcript