#Rename hostname based on prefix set and serial
$Prefix = 'LB'
$Serial = Get-WMIObject -Class "Win32_BIOS" | Select -Expand SerialNumber
$NewComputername = $Prefix + $Serial
Write-Output $NewComputername
Rename-Computer -NewName $NewComputername -Force
#Create Detection method
New-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\LABS" -ErrorAction SilentlyContinue
New-Item -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\LABS\RenameComputer" -ErrorAction SilentlyContinue
#Create registry value under recently created key
New-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\LABS\RenameComputer" -Name Version -Value "1.0" -PropertyType String -Force -ErrorAction SilentlyContinue 