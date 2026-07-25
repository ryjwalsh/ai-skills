<#
    healthcheck.ps1 - READ-ONLY SAFR Server health sweep (Windows, on-premises)

    Every command below is either a documented SAFR script invoked in its
    documented read-only form, or a standard read-only Windows cmdlet.

    Source IDs (see ../sources.md):
      [S4]  SAFR Support Scripts       - check.bat, portcheck.py, syscollect.py paths
      [S3]  SAFR Server Logging        - log file paths, default levels, 14-day retention
      [S8]  Server Backup and Restore  - backup output path
      [S9]  On-Premises Licensing      - cv-instam.real port 443
      [S14] Status Page                - default service ports
      [S26] REST API Overview          - local OpenAPI doc ports

    DELIBERATELY NOT INCLUDED - these change state:
      start.bat / stop.bat            (service control)
      configure-ports / configure-ssl (except -p, omitted for safety)
      reconfigure                     (changes hostname)
      backup.py / restore.py          (writes data)
      syscollect.py                   (writes an archive; run manually when opening a ticket)
      uninstaller.exe                 (destructive)
      anything in the internal-use-only list [S4]

    Usage:  powershell -ExecutionPolicy Bypass -File .\healthcheck.ps1
    Nothing is modified. Output is a plain-text report on stdout.
#>

[CmdletBinding()]
param(
    [string] $ProgramRoot = 'C:\Program Files\RealNetworks\SAFR',
    [string] $DataRoot    = 'C:\ProgramData\RealNetworks\SAFR',
    [string] $BackupRoot  = 'C:\Program Files\RealNetworks\SAFR-backups',
    [int]    $LogAgeDays  = 3
)

function Write-Section([string] $Title) {
    Write-Output ''
    Write-Output ('=' * 72)
    Write-Output "  $Title"
    Write-Output ('=' * 72)
}

Write-Output "SAFR read-only health check - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
Write-Output "Host: $env:COMPUTERNAME"

# ---------------------------------------------------------------- paths [S4][S3]
Write-Section 'Installation paths'
foreach ($p in @($ProgramRoot, (Join-Path $ProgramRoot 'bin'), $DataRoot, $BackupRoot)) {
    $state = if (Test-Path -LiteralPath $p) { 'present' } else { 'MISSING' }
    Write-Output ("{0,-9} {1}" -f $state, $p)
}

$portsConf = Join-Path $ProgramRoot 'safrports.conf'
if (Test-Path -LiteralPath $portsConf) {
    Write-Output "present   $portsConf"
} else {
    Write-Output "MISSING   $portsConf  (licensing scripts then fall back to port 8080) [S9]"
}

# ------------------------------------------------------------- service check [S4]
Write-Section 'Service status - check.bat [S4]'
$checkBat = Join-Path $ProgramRoot 'bin\check.bat'
if (Test-Path -LiteralPath $checkBat) {
    try { & $checkBat 2>&1 | ForEach-Object { Write-Output $_ } }
    catch { Write-Output "check.bat failed to execute: $($_.Exception.Message)" }
} else {
    Write-Output "check.bat not found at $checkBat"
}

# ----------------------------------------------------------------- ports [S4]
Write-Section 'Port inventory - portcheck.py [S4]'
$portCheck = Join-Path $ProgramRoot 'bin\portcheck.py'
if (Test-Path -LiteralPath $portCheck) {
    if (Get-Command python -ErrorAction SilentlyContinue) {
        try { & python $portCheck 2>&1 | ForEach-Object { Write-Output $_ } }
        catch { Write-Output "portcheck.py failed: $($_.Exception.Message)" }
    } else {
        Write-Output 'python not on PATH; run manually:'
        Write-Output ('  python "{0}"' -f $portCheck)
    }
} else {
    Write-Output "portcheck.py not found at $portCheck"
}

# ------------------------------------------- documented default ports [S14][S26]
Write-Section 'Documented default service ports - local listen check [S14][S26]'
$svc = [ordered]@{
    'COVI  (HTTPS)' = 8080
    'COVI  (HTTP)'  = 8081
    'CVEV  (HTTPS)' = 8082
    'CVEV  (HTTP)'  = 8083
    'VIRGA (HTTPS)' = 8084
    'VIRGA (HTTP)'  = 8085
    'CVOS  (HTTPS)' = 8086
    'CVOS  (HTTP)'  = 8087
}
foreach ($name in $svc.Keys) {
    $port = $svc[$name]
    $open = $false
    try { $open = (Test-NetConnection -ComputerName 'localhost' -Port $port -InformationLevel Quiet -WarningAction SilentlyContinue) } catch { }
    Write-Output ("{0,-14} {1,-6} {2}" -f $name, $port, $(if ($open) { 'listening' } else { 'not listening' }))
}
Write-Output 'Note: these are documented DEFAULTS. portcheck.py output above is authoritative. [S4]'

# ------------------------------------------------------ licence reachability [S9]
Write-Section 'Licence server reachability - cv-instam.real:443 [S9]'
Write-Output 'The server discontinues operation if it cannot report within Max Days Between Reports. [S9]'
try {
    $lic = Test-NetConnection -ComputerName 'cv-instam.real' -Port 443 -InformationLevel Quiet -WarningAction SilentlyContinue
    Write-Output ("cv-instam.real:443  {0}" -f $(if ($lic) { 'reachable' } else { 'NOT reachable' }))
} catch {
    Write-Output "cv-instam.real:443  probe failed: $($_.Exception.Message)"
}
Write-Output 'If unreachable, confirm the correct FQDN with the vendor before changing firewall rules. See known-gaps.md.'

# ----------------------------------------------------------------- disk [S16]
Write-Section 'Disk space (1TB available storage is the documented requirement) [S16]'
Get-PSDrive -PSProvider FileSystem |
    Where-Object { $_.Used -ne $null } |
    Select-Object Name,
        @{n='UsedGB'; e={[math]::Round($_.Used/1GB,1)}},
        @{n='FreeGB'; e={[math]::Round($_.Free/1GB,1)}} |
    Format-Table -AutoSize | Out-String | Write-Output

# ------------------------------------------------------------- log survey [S3]
Write-Section 'Log files - presence, size, freshness [S3]'
$logs = @(
    'covi\logs\covi-ws.log',
    'covi\logs\catalina.log',
    'covi\logs\localhost.log',
    'covi\logs\safrcovi-stderr.log',
    'covi\logs\commons-daemon.log',
    'covi\logs\audit.log',
    'cv-event\logs\app.log',
    'cv-event\logs\access.log',
    'cv-event\logs\metrics.log',
    'cv-event\logs\sync.log',
    'cv-event\logs\bioindex.log',
    'cv-event\logs\reaper.log',
    'virga\logs\app.log',
    'virga\logs\access.log',
    'virga\logs\virga.out',
    'virga\logs\configs.log',
    'cv-reports\logs\app.log',
    'cv-reports\logs\cv-reports.out',
    'cv-object-storage\logs\app.log',
    'cv-object-storage\logs\cv-object-storage.out',
    'cv-object-storage\logs\cv-object-storage.err'
)
$rows = foreach ($rel in $logs) {
    $full = Join-Path $DataRoot $rel
    if (Test-Path -LiteralPath $full) {
        $f = Get-Item -LiteralPath $full
        [pscustomobject]@{
            Log      = $rel
            SizeKB   = [math]::Round($f.Length/1KB,1)
            Modified = $f.LastWriteTime
            AgeHours = [math]::Round(((Get-Date) - $f.LastWriteTime).TotalHours,1)
        }
    } else {
        [pscustomobject]@{ Log = $rel; SizeKB = 'absent'; Modified = ''; AgeHours = '' }
    }
}
$rows | Format-Table -AutoSize | Out-String | Write-Output

# --------------------------------------------------------- recent errors [S3]
Write-Section "ERROR and WARN lines in the last $LogAgeDays day(s) [S3]"
Write-Output 'Reminder: Application logs default to WARN on COVI, Event Server, VIRGA and CVOS,'
Write-Output 'and Performance logging defaults to OFF. Absence of entries is often expected. [S3]'
$cutoff = (Get-Date).AddDays(-$LogAgeDays)
$hits = Get-ChildItem -LiteralPath $DataRoot -Recurse -Filter *.log -ErrorAction SilentlyContinue |
    Where-Object { $_.LastWriteTime -gt $cutoff } |
    Select-String -Pattern 'ERROR', 'WARN', 'Exception' -ErrorAction SilentlyContinue |
    Select-Object -Last 60
if ($hits) {
    $hits | ForEach-Object { Write-Output ("{0}:{1}: {2}" -f $_.Filename, $_.LineNumber, $_.Line.Trim()) }
} else {
    Write-Output 'No matching lines in recently modified logs.'
}

# ----------------------------------------------------------------- backups [S8]
Write-Section 'Most recent backup [S8]'
if (Test-Path -LiteralPath $BackupRoot) {
    $newest = Get-ChildItem -LiteralPath $BackupRoot -Filter 'SAFR-backup-*.tgz' -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($newest) {
        Write-Output ("{0}  {1} MB  {2}" -f $newest.Name, [math]::Round($newest.Length/1MB,1), $newest.LastWriteTime)
        Write-Output ("Age: {0} day(s)" -f [math]::Round(((Get-Date) - $newest.LastWriteTime).TotalDays,1))
    } else {
        Write-Output "No SAFR-backup-*.tgz found in $BackupRoot"
    }
} else {
    Write-Output "Backup root not present: $BackupRoot"
}

# ------------------------------------------------------------------ next steps
Write-Section 'Next steps (run manually - these write files or change state)'
Write-Output 'Support bundle for a vendor ticket [S4]:'
Write-Output ('  python "{0}"' -f (Join-Path $ProgramRoot 'bin\syscollect.py'))
Write-Output ''
Write-Output 'Per-feed telemetry, VIRGO [S19]:'
Write-Output '  virgo service monitor'
Write-Output '  virgo service monitor > my.csv'
Write-Output ''
Write-Output 'Web Console Status page: read Version, Environment, Load, Latency, licence limits [S14]'
Write-Output 'Local OpenAPI spec: https://<server>:8080/docs/index.html [S26]'
Write-Output ''
Write-Output 'Report complete. Nothing was modified.'
