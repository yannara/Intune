# Defender / Windows Security Center race condition detector + remediation
# Run elevated or as SYSTEM
#
# Based on / adapted from: https://call4cloud.nl/FixWSCDefender.ps1
#
# Modified by: Pavel Mirochnitchenko, MVP
# Date: 2026-09-11
#
# Changelog (modifications from the original):
#   - Added Invoke-IntuneComplianceSync: after all script logic completes (in a finally
#     block, runs on every exit path), triggers an Intune compliance re-sync via
#     "intunemanagementextension://synccompliance" against IntuneWindowsAgent.exe.
#     (Earlier revision stopped/started the IntuneManagementExtension service instead;
#     that approach was replaced because it killed the service supervising the script's
#     own execution, causing Intune to report the run as failed and auto-retry it
#     several times. The URI trigger doesn't touch the service, so it avoids this.)
#   - Changed log output location from C:\ProgramData\DefenderWscRace\ to
#     C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\ (alongside IME's own logs).
#   - Renamed the log file from DefenderWscRace.log to Device_Defender_fix.log.
#   - Added detection for stale antivirus signatures and overdue quick/full scans
#     (Test-SignatureOrScanStale), using Get-MpComputerStatus's AntivirusSignatureAge,
#     QuickScanOverdue, and FullScanOverdue, with a configurable $MaxSignatureAgeDays
#     fallback threshold.
#   - Added a remediation branch for that case: runs MpCmdRun.exe -SignatureUpdate
#     followed by a quick scan (-Scan -ScanType 1), then re-checks and logs whether
#     the stale state cleared.
#   - Added corresponding log lines for signature version/age/last-updated and
#     quick/full scan age and overdue status on every run.

$ErrorActionPreference = 'Stop'

$DefenderGuid = '{D68DDC3A-831F-4fae-9E44-DA132C1ACF46}'
$WscRegPath   = "HKLM:\SOFTWARE\Microsoft\Security Center\Provider\Av\$DefenderGuid"

# Exact values observed during this issue
$BrokenState  = 0x060100   # 393472
$HealthyState = 0x061100   # 397568

# Fallback threshold in case QuickScanOverdue/FullScanOverdue aren't populated
# (some builds leave these $null rather than $false when never scanned)
$MaxSignatureAgeDays = 3

$LogRoot = 'C:\ProgramData\Microsoft\IntuneManagementExtension\Logs'
$LogFile = Join-Path $LogRoot 'Device_Defender_fix.log'

New-Item -Path $LogRoot -ItemType Directory -Force | Out-Null

function Write-Log {
    param([string]$Message)

    $Line = '{0}  {1}' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss.fff'), $Message

    Write-Output $Line
    Add-Content -Path $LogFile -Value $Line
}

function Convert-ToHexState {
    param($Value)

    if ($null -eq $Value) {
        return 'N/A'
    }

    return '0x{0:X6}' -f [int]$Value
}

function Get-DefenderWscState {

    $Mp = $null
    $Wmi = $null
    $RegistryState = $null
    $WscService = $null

    try {
        $Mp = Get-MpComputerStatus
    }
    catch {
        Write-Log "Get-MpComputerStatus failed: $($_.Exception.Message)"
    }

    try {
        $Wmi = Get-CimInstance `
            -Namespace 'root\SecurityCenter2' `
            -ClassName 'AntiVirusProduct' |
            Where-Object {
                $_.instanceGuid -eq $DefenderGuid -or
                $_.displayName -match 'Microsoft Defender|Windows Defender'
            } |
            Select-Object -First 1
    }
    catch {
        Write-Log "SecurityCenter2 query failed: $($_.Exception.Message)"
    }

    try {
        if (Test-Path $WscRegPath) {
            $RegistryState = (Get-ItemProperty -Path $WscRegPath -Name 'STATE').STATE
        }
    }
    catch {
        Write-Log "Security Center registry query failed: $($_.Exception.Message)"
    }

    try {
        $WscService = Get-Service -Name 'wscsvc'
    }
    catch {
        Write-Log "Unable to query wscsvc: $($_.Exception.Message)"
    }

    [PSCustomObject]@{
        AMRunningMode              = $Mp.AMRunningMode
        AMServiceEnabled           = $Mp.AMServiceEnabled
        AntivirusEnabled           = $Mp.AntivirusEnabled
        RealTimeProtectionEnabled  = $Mp.RealTimeProtectionEnabled
        PlatformVersion            = $Mp.AMProductVersion
        SignatureVersion           = $Mp.AntivirusSignatureVersion

        SignatureAge               = $Mp.AntivirusSignatureAge
        SignatureLastUpdated       = $Mp.AntivirusSignatureLastUpdated
        QuickScanAge               = $Mp.QuickScanAge
        QuickScanOverdue           = $Mp.QuickScanOverdue
        FullScanAge                = $Mp.FullScanAge
        FullScanOverdue            = $Mp.FullScanOverdue

        WmiDisplayName             = $Wmi.displayName
        WmiProductState            = $Wmi.productState
        WmiProductStateHex         = Convert-ToHexState $Wmi.productState

        RegistryState              = $RegistryState
        RegistryStateHex           = Convert-ToHexState $RegistryState

        WscServiceStatus           = $WscService.Status
    }
}

function Test-DefenderReallyOn {
    param($State)

    return (
        $State.AMServiceEnabled -eq $true -and
        $State.AntivirusEnabled -eq $true -and
        $State.RealTimeProtectionEnabled -eq $true -and
        $State.AMRunningMode -eq 'Normal'
    )
}

function Test-WscBroken {
    param($State)

    $WmiBroken = (
        $null -ne $State.WmiProductState -and
        [int]$State.WmiProductState -eq $BrokenState
    )

    $RegistryBroken = (
        $null -ne $State.RegistryState -and
        [int]$State.RegistryState -eq $BrokenState
    )

    return ($WmiBroken -or $RegistryBroken)
}

function Test-WscHealthy {
    param($State)

    $WmiHealthy = (
        $null -ne $State.WmiProductState -and
        [int]$State.WmiProductState -eq $HealthyState
    )

    $RegistryHealthy = (
        $null -ne $State.RegistryState -and
        [int]$State.RegistryState -eq $HealthyState
    )

    return ($WmiHealthy -and $RegistryHealthy)
}

function Test-SignatureOrScanStale {
    param($State)

    $SignatureStale = (
        ($State.QuickScanOverdue -eq $true) -or
        ($State.FullScanOverdue -eq $true) -or
        (
            $null -ne $State.SignatureAge -and
            [int]$State.SignatureAge -gt $MaxSignatureAgeDays
        )
    )

    return $SignatureStale
}

function Invoke-IntuneComplianceSync {

    $ImeExe = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Intune Management Extension\Microsoft.Management.Services.IntuneWindowsAgent.exe'

    try {
        if (-not (Test-Path $ImeExe)) {

            Write-Log "IntuneWindowsAgent.exe not found at $ImeExe"
            return
        }

        Write-Log 'Triggering Intune compliance sync via intunemanagementextension://synccompliance'
        Start-Process -FilePath $ImeExe -ArgumentList 'intunemanagementextension://synccompliance'
        Write-Log 'Compliance sync triggered.'
    }
    catch {
        Write-Log "Failed to trigger compliance sync: $($_.Exception.Message)"
    }
}

Write-Log '============================================================'
Write-Log 'Starting Defender / Windows Security Center health check'

try {

$Before = Get-DefenderWscState

Write-Log "Defender platform       : $($Before.PlatformVersion)"
Write-Log "AM running mode         : $($Before.AMRunningMode)"
Write-Log "AM service enabled      : $($Before.AMServiceEnabled)"
Write-Log "Antivirus enabled       : $($Before.AntivirusEnabled)"
Write-Log "Real time protection    : $($Before.RealTimeProtectionEnabled)"
Write-Log "WSC service             : $($Before.WscServiceStatus)"
Write-Log "WMI productState        : $($Before.WmiProductState) [$($Before.WmiProductStateHex)]"
Write-Log "Registry STATE          : $($Before.RegistryState) [$($Before.RegistryStateHex)]"
Write-Log "Signature version       : $($Before.SignatureVersion)"
Write-Log "Signature age (days)    : $($Before.SignatureAge)"
Write-Log "Signature last updated  : $($Before.SignatureLastUpdated)"
Write-Log "Quick scan age (days)   : $($Before.QuickScanAge) | Overdue: $($Before.QuickScanOverdue)"
Write-Log "Full scan age (days)    : $($Before.FullScanAge) | Overdue: $($Before.FullScanOverdue)"

$DefenderReallyOn     = Test-DefenderReallyOn $Before
$WscBroken            = Test-WscBroken $Before
$SignatureOrScanStale = Test-SignatureOrScanStale $Before

if (-not $DefenderReallyOn) {

    Write-Log 'Defender itself is not reporting a normal active state.'
    Write-Log 'This does NOT match the WSC race condition. No remediation performed.'

    exit 0
}

if (-not $WscBroken) {

    Write-Log 'Defender is active and the known broken WSC state was not detected.'

    if (-not $SignatureOrScanStale) {

        Write-Log 'Signatures and scans are current. No remediation required.'
        exit 0
    }

    Write-Log '*** STALE SIGNATURES / OVERDUE SCAN DETECTED ***'
    Write-Log 'This can trigger Intune noncompliance ("Antivirus" check) even when real-time protection is on.'
    Write-Log 'Attempting signature update followed by a quick scan.'

    $MpCmdRun = Join-Path $env:ProgramFiles 'Windows Defender\MpCmdRun.exe'

    if (-not (Test-Path $MpCmdRun)) {

        Write-Log "MpCmdRun.exe not found at $MpCmdRun"
        exit 1
    }

    try {
        Write-Log 'Running MpCmdRun.exe -SignatureUpdate'

        $SigProcess = Start-Process `
            -FilePath $MpCmdRun `
            -ArgumentList '-SignatureUpdate' `
            -Wait `
            -PassThru `
            -NoNewWindow

        Write-Log "SignatureUpdate exit code: $($SigProcess.ExitCode)"
    }
    catch {
        Write-Log "SignatureUpdate failed: $($_.Exception.Message)"
    }

    try {
        Write-Log 'Running MpCmdRun.exe -Scan -ScanType 1 (quick scan)'

        $ScanProcess = Start-Process `
            -FilePath $MpCmdRun `
            -ArgumentList '-Scan', '-ScanType', '1' `
            -Wait `
            -PassThru `
            -NoNewWindow

        Write-Log "Quick scan exit code: $($ScanProcess.ExitCode)"
    }
    catch {
        Write-Log "Quick scan failed: $($_.Exception.Message)"
    }

    $AfterScan = Get-DefenderWscState

    Write-Log "Signature age after remediation      : $($AfterScan.SignatureAge)"
    Write-Log "Quick scan overdue after remediation : $($AfterScan.QuickScanOverdue)"

    if (-not (Test-SignatureOrScanStale $AfterScan)) {

        Write-Log '*** SIGNATURE/SCAN REMEDIATION SUCCESSFUL ***'
        exit 0
    }

    Write-Log '*** SIGNATURE/SCAN REMEDIATION DID NOT FULLY CLEAR STALE STATE ***'
    Write-Log 'The scan may still be finalizing and reporting back; a later compliance re-check may resolve on its own.'
    exit 1
}

Write-Log '*** RACE CONDITION DETECTED ***'
Write-Log 'Defender reports itself active but Windows Security Center reports 0x060100.'

#
# Make sure Security Center itself is running first.
#

try {

    $WscSvc = Get-Service -Name 'wscsvc'

    if ($WscSvc.Status -ne 'Running') {

        Write-Log 'Windows Security Center service is not running. Starting it.'

        Start-Service -Name 'wscsvc'

        Start-Sleep -Seconds 15

        $AfterWscStart = Get-DefenderWscState

        Write-Log "After starting wscsvc, WMI      : $($AfterWscStart.WmiProductStateHex)"
        Write-Log "After starting wscsvc, Registry : $($AfterWscStart.RegistryStateHex)"

        if (Test-WscHealthy $AfterWscStart) {

            Write-Log 'Windows Security Center state recovered without resetting Defender.'
            exit 0
        }
    }
}
catch {
    Write-Log "Could not start/check wscsvc: $($_.Exception.Message)"
}

#
# Confirm the mismatch still exists before doing ResetPlatform
#

$Confirm = Get-DefenderWscState

if (-not (Test-DefenderReallyOn $Confirm)) {

    Write-Log 'Defender runtime state changed before remediation.'
    Write-Log 'ResetPlatform cancelled.'

    exit 1
}

if (-not (Test-WscBroken $Confirm)) {

    Write-Log 'WSC state recovered by itself before remediation.'
    exit 0
}

#
# Known workaround
#

$MpCmdRun = Join-Path $env:ProgramFiles 'Windows Defender\MpCmdRun.exe'

if (-not (Test-Path $MpCmdRun)) {

    Write-Log "MpCmdRun.exe not found at $MpCmdRun"
    exit 1
}

Write-Log 'Running MpCmdRun.exe -ResetPlatform'
Write-Log "Platform before reset: $($Confirm.PlatformVersion)"

try {

    $Process = Start-Process `
        -FilePath $MpCmdRun `
        -ArgumentList '-ResetPlatform' `
        -Wait `
        -PassThru `
        -NoNewWindow

    Write-Log "ResetPlatform exit code: $($Process.ExitCode)"
}
catch {

    Write-Log "ResetPlatform failed: $($_.Exception.Message)"
    exit 1
}

#
# Defender and WSC can take a little time to settle.
#

Write-Log 'Waiting for Defender and Windows Security Center to republish state.'

$Recovered = $false
$After = $null

for ($Attempt = 1; $Attempt -le 18; $Attempt++) {

    Start-Sleep -Seconds 5

    try {

        $After = Get-DefenderWscState

        Write-Log "Check $Attempt | WMI=$($After.WmiProductStateHex) Registry=$($After.RegistryStateHex) Platform=$($After.PlatformVersion)"

        if (
            (Test-DefenderReallyOn $After) -and
            (Test-WscHealthy $After)
        ) {

            $Recovered = $true
            break
        }
    }
    catch {
        Write-Log "Post repair check $Attempt failed: $($_.Exception.Message)"
    }
}

if ($Recovered) {

    Write-Log '*** REMEDIATION SUCCESSFUL ***'
    Write-Log "Platform after reset : $($After.PlatformVersion)"
    Write-Log "WMI productState      : $($After.WmiProductStateHex)"
    Write-Log "Registry STATE        : $($After.RegistryStateHex)"

    exit 0
}

Write-Log '*** REMEDIATION FAILED ***'

if ($null -ne $After) {
    Write-Log "Defender platform : $($After.PlatformVersion)"
    Write-Log "WMI productState  : $($After.WmiProductStateHex)"
    Write-Log "Registry STATE    : $($After.RegistryStateHex)"
}

exit 1

}
finally {

    Write-Log 'Main script logic finished. Triggering Intune compliance sync.'
    Invoke-IntuneComplianceSync
}