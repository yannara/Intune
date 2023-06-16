#Start logging
Start-Transcript -Path "C:\Windows\Debug\VLC-Player_1.4_Winget.txt"
#Get Winget.exe from subfolder and execute silent installation
Start-Process -FilePath "$PSScriptRoot\Winget\Winget.exe" -Wait -ArgumentList 'install VideoLAN.VLC --silent --accept-package-agreements --accept-source-agreements'
#Waiting 30 seconds
Start-Sleep -Seconds 30
#Creating user default folder and copying config file there.
New-Item -ItemType directory -Path C:\users\Default\Appdata\Roaming\vlc -Force
Copy-Item -Path 'vlcrc' -Destination 'C:\users\Default\Appdata\Roaming\vlc' -Force
#Creating detection method
New-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\LABS\VLC" -ErrorAction SilentlyContinue
New-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\LABS\VLC" -Name Version -Value "1.4" -PropertyType String -Force -ErrorAction SilentlyContinue
Stop-Transcript