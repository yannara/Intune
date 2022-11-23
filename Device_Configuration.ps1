#Disable Lockscreen to blur
New-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System" -ErrorAction SilentlyContinue
New-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System" -Name DisableAcrylicBackgroundOnLogon -Value "1" -PropertyType DWord -Force -ErrorAction SilentlyContinue