# Created by ChatGTP & Pavel Mirochnitchenko MVP 
# Use as detection script for Microsoft Intune Remediation function.
# Based on return code of device status. Fails if any device has a missing driver (ConfigManagerErrorCode other than 0)
# Use together with Update_Drivers_from_Microsoft_v16_Remediation.ps1 - script.

try {
    $unconfiguredDevices = Get-WmiObject Win32_PnPEntity | Where-Object {
        $_.ConfigManagerErrorCode -ne 0
    }

    if ($unconfiguredDevices.Count -gt 0) {
        Write-Output "Devices with missing or problematic drivers found:"
        $unconfiguredDevices | Select-Object Name, DeviceID, ConfigManagerErrorCode | Format-Table | Out-String | Write-Output
        exit 1
    } else {
        Write-Output "All devices have drivers installed."
        exit 0
    }
}
catch {
    Write-Error "Detection script error: $_"
    exit 1
}
