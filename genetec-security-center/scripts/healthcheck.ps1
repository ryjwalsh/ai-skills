<#
    healthcheck.ps1 - Genetec Security Center read-only health collector

    PURPOSE
      Collects the evidence that Genetec documentation asks for before opening a
      support case, and performs the port and service checks that the official
      troubleshooting topics prescribe.

    THIS SCRIPT IS READ-ONLY.
      It does not start, stop or configure any service, does not write to any
      .gconfig file, does not touch the registry, does not delete anything, and
      does not modify firewall rules. Every command below is a query. The only
      thing it writes is an optional transcript file in a folder you choose.

    SOURCE TRACEABILITY - every check maps to a documented instruction:
      [S21] Troubleshooting the main server in Security Center
            - "In Windows Services, verify that the Genetec Server service is running."
            - "run the Command Prompt and enter the command line netstat -na | find"[PortNumber]""
            - "open the command prompt as administrator and enter the following command: eventvwr.msc.
               Make sure to check application, system, and Genetec event logs."
            - "In Windows, check the amount of space available on the C drive."
            - "Open the Windows Task Manager and select the Performance tab to check the CPU and memory usage."
            - "check the System event log for Event ID 41"
            - "open C:\Program Data\Genetec Security Center [5.x], and then open the Dumps or Logs folders"
      [S20] Troubleshooting the Archiver
            - "telnet <IP address> <port number>"
            - "tnc -computer name (IP or DNS name of the server) -port (port number)"
            - "Locate the Archiver.gconfig file in the Configuration files folder ... check that they are readable"
            - "In Windows, go to C:\Windows\System32\msmq. Right-click the Storage folder > Properties.
               ... The queue becomes full when the storage folder contains 520 items or the queue size exceeds 1 GB"
            - "verify the response time for the mqsvc.exe process. A response time above 50 ms is high.
               A value above 100 ms is critical."
            - "check for disk full or disk 80% events in the Archiver logs (C:\ArchiverLogs by default)"
      [S22] Working with logs and traces for Security Center
            - default log path "C:\ProgramData\Genetec Security Center [X.Y]\Logs"
            - SQL ERRORLOG at "C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\Log"
      [S3]  Default ports used by Security Center 5.14 - the port list checked below
      [S13] Security Center build numbers - "you must provide the Security Center build number"
      [S7]  Installation and Upgrade Guide 5.14.0.0 - service names GenetecServer and GenetecWatchdog,
            default install path C:\Program Files (x86)\Genetec Security Center 5.14
      [S9]  Release Notes 5.14.0.0 - the 10 second time synchronization threshold

    NOT DOCUMENTED, THEREFORE NOT ATTEMPTED:
      There is no documented HTTP health-check endpoint for any Security Center role,
      so this script does not probe one. See known-gaps.md section G.

    USAGE
      .\healthcheck.ps1
      .\healthcheck.ps1 -DirectoryHost sc-main01 -OutputFolder C:\Temp\SCHealth
      .\healthcheck.ps1 -Ports 5500,443,80,554,555,560,605,8012

    Run in a normal or elevated PowerShell session. Elevation gives fuller
    results for service and event log queries but is not required.
#>

[CmdletBinding()]
param(
    [string] $DirectoryHost = $env:COMPUTERNAME,
    [int[]]  $Ports = @(5500, 80, 443, 8012, 554, 555, 558, 560, 570, 605, 654, 1433, 4595, 9603),
    [string] $OutputFolder
)

$ErrorActionPreference = 'Continue'

if ($OutputFolder) {
    if (-not (Test-Path -LiteralPath $OutputFolder)) {
        Write-Warning "OutputFolder does not exist. Not creating it. Transcript skipped: $OutputFolder"
        $OutputFolder = $null
    } else {
        $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
        Start-Transcript -Path (Join-Path $OutputFolder "sc-healthcheck-$stamp.txt") -Append | Out-Null
    }
}

function Write-Section {
    param([string] $Title)
    Write-Output ''
    Write-Output ('=' * 78)
    Write-Output "  $Title"
    Write-Output ('=' * 78)
}

Write-Section "Genetec Security Center read-only health check"
Write-Output "Run at         : $(Get-Date -Format 'u')"
Write-Output "Local computer : $env:COMPUTERNAME"
Write-Output "Target host    : $DirectoryHost"
Write-Output "This script is READ-ONLY. No service, file, registry or firewall change is made."

# ---------------------------------------------------------------------------
# 1. Windows services  [S21] [S7]
# ---------------------------------------------------------------------------
Write-Section "1. Genetec Windows services  [S21]"
foreach ($svc in 'GenetecServer', 'GenetecWatchdog') {
    $s = Get-Service -Name $svc -ErrorAction SilentlyContinue
    if ($null -eq $s) {
        Write-Output "$svc : NOT INSTALLED on this machine"
    } else {
        $wmi = Get-CimInstance -ClassName Win32_Service -Filter "Name='$svc'" -ErrorAction SilentlyContinue
        Write-Output "$svc : Status=$($s.Status)  StartType=$($s.StartType)"
        if ($wmi) {
            Write-Output "    LogOn account : $($wmi.StartName)"
            Write-Output "    Binary path   : $($wmi.PathName)"
        }
    }
}
Write-Output ""
Write-Output "Note: GenetecWatchdog is a documented dependency of GenetecServer [S7]."

Write-Section "1b. SQL Server services on this machine  [S21]"
$sql = Get-Service -ErrorAction SilentlyContinue | Where-Object { $_.Name -like 'MSSQL*' -or $_.Name -eq 'SQLBrowser' -or $_.Name -like 'SQLAgent*' }
if ($sql) { $sql | Select-Object Name, Status, StartType | Format-Table -AutoSize | Out-String | Write-Output }
else { Write-Output "No local SQL Server services found (the database may be remote)." }

Write-Section "1c. MSMQ service  [S20]"
$msmq = Get-Service -Name 'MSMQ' -ErrorAction SilentlyContinue
if ($msmq) { Write-Output "MSMQ : Status=$($msmq.Status)  StartType=$($msmq.StartType)" }
else { Write-Output "MSMQ : NOT INSTALLED. Documented fix is to enable 'Microsoft Message Queue (MSMQ) Server' in Windows Features [S20]." }

# ---------------------------------------------------------------------------
# 2. Installed version and build number  [S13]
# ---------------------------------------------------------------------------
Write-Section "2. Installed Security Center version and build  [S13]"
$installRoots = @(
    'C:\Program Files (x86)\Genetec Security Center 5.14',
    'C:\Program Files (x86)\Genetec Security Center 5.13',
    'C:\Program Files\Genetec Security Center 5.14',
    'C:\Program Files\Genetec Security Center 5.13'
)
$found = $false
foreach ($root in $installRoots) {
    if (Test-Path -LiteralPath $root) {
        $found = $true
        Write-Output "Install folder : $root"
        foreach ($exe in 'GenetecServer.exe', 'ConfigTool.exe', 'SecurityDesk.exe', 'GenetecWatchdog.exe') {
            $p = Join-Path $root $exe
            if (Test-Path -LiteralPath $p) {
                $v = (Get-Item -LiteralPath $p).VersionInfo
                Write-Output ("    {0,-24} FileVersion={1}  ProductVersion={2}" -f $exe, $v.FileVersion, $v.ProductVersion)
            }
        }
    }
}
if (-not $found) { Write-Output "No default Security Center install folder found. Check a custom /ISInstallDir path [S7]." }
Write-Output ""
Write-Output "Compare the build against the tables in references/version-matrix.md."
Write-Output "If the build is not listed there you are most likely running a hotfix [S13]."

# ---------------------------------------------------------------------------
# 3. Configuration files present and readable  [S20] [S23]
# ---------------------------------------------------------------------------
Write-Section "3. Configuration files  [S20] [S23]"
foreach ($root in $installRoots) {
    $cfgDir = Join-Path $root 'ConfigurationFiles'
    if (Test-Path -LiteralPath $cfgDir) {
        Write-Output "ConfigurationFiles : $cfgDir"
        Get-ChildItem -LiteralPath $cfgDir -Filter '*.gconfig' -ErrorAction SilentlyContinue |
            Select-Object Name, Length, LastWriteTime | Format-Table -AutoSize | Out-String | Write-Output
        foreach ($f in @('GenetecServer.gconfig', 'Archiver.gconfig', 'License.gconfig')) {
            $p = Join-Path $cfgDir $f
            if (Test-Path -LiteralPath $p) {
                try {
                    [xml]$null = Get-Content -LiteralPath $p -Raw -ErrorAction Stop
                    Write-Output "    $f : present, readable, parses as XML"
                } catch {
                    Write-Output "    $f : present but DOES NOT PARSE - possible corruption [S20]"
                }
            } else {
                Write-Output "    $f : not present"
            }
        }
    }
}
Write-Output ""
Write-Output "If Archiver.gconfig is missing, the documented fix is to regenerate it from Server Admin:"
Write-Output "  Actions > Console > Commands > Archiver Agent commands > GenerateConfigFile  [S20]"

# ---------------------------------------------------------------------------
# 4. Port reachability  [S20] [S21]
# ---------------------------------------------------------------------------
Write-Section "4. Port reachability to $DirectoryHost  [S20]"
Write-Output "Documented equivalents: 'telnet <IP address> <port number>' and"
Write-Output "'tnc -computer (IP or DNS name of the server) -port (port number)'  [S20]"
Write-Output ""
$results = foreach ($p in $Ports) {
    $r = Test-NetConnection -ComputerName $DirectoryHost -Port $p -InformationLevel Quiet -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
    [pscustomobject]@{ Port = $p; Reachable = [bool]$r }
}
$results | Format-Table -AutoSize | Out-String | Write-Output

Write-Section "4b. Local listeners on the checked ports  [S21]"
Write-Output "Documented equivalent: netstat -na piped to find on the port number  [S21]"
Write-Output ""
$listen = Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue | Where-Object { $Ports -contains $_.LocalPort }
if ($listen) {
    $listen | ForEach-Object {
        $proc = Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue
        [pscustomobject]@{
            LocalAddress = $_.LocalAddress
            LocalPort    = $_.LocalPort
            ProcessId    = $_.OwningProcess
            Process      = if ($proc) { $proc.ProcessName } else { 'unknown' }
        }
    } | Sort-Object LocalPort | Format-Table -AutoSize | Out-String | Write-Output
} else {
    Write-Output "No local listeners found on the checked ports."
}

# ---------------------------------------------------------------------------
# 5. Disk space  [S21] [S20]
# ---------------------------------------------------------------------------
Write-Section "5. Disk space  [S21]"
Write-Output "Low disk space on C: is a documented cause of the Genetec Server service failing"
Write-Output "and of the Archiver going offline [S21] [S20]."
Write-Output ""
Get-CimInstance -ClassName Win32_LogicalDisk -Filter 'DriveType=3' -ErrorAction SilentlyContinue |
    Select-Object DeviceID,
        @{ n = 'SizeGB';  e = { [math]::Round($_.Size / 1GB, 1) } },
        @{ n = 'FreeGB';  e = { [math]::Round($_.FreeSpace / 1GB, 1) } },
        @{ n = 'FreePct'; e = { if ($_.Size) { [math]::Round(100 * $_.FreeSpace / $_.Size, 1) } } } |
    Format-Table -AutoSize | Out-String | Write-Output

# ---------------------------------------------------------------------------
# 6. CPU and memory  [S21]
# ---------------------------------------------------------------------------
Write-Section "6. CPU and memory  [S21]"
$os = Get-CimInstance -ClassName Win32_OperatingSystem -ErrorAction SilentlyContinue
if ($os) {
    Write-Output ("Total RAM : {0} GB" -f [math]::Round($os.TotalVisibleMemorySize / 1MB, 1))
    Write-Output ("Free RAM  : {0} GB" -f [math]::Round($os.FreePhysicalMemory / 1MB, 1))
    Write-Output ("OS        : {0} (build {1})" -f $os.Caption, $os.BuildNumber)
}
Write-Output ""
Write-Output "Top 10 processes by working set:"
Get-Process -ErrorAction SilentlyContinue |
    Sort-Object -Property WorkingSet64 -Descending |
    Select-Object -First 10 Name, Id, @{ n = 'WorkingSetMB'; e = { [math]::Round($_.WorkingSet64 / 1MB, 1) } } |
    Format-Table -AutoSize | Out-String | Write-Output

# ---------------------------------------------------------------------------
# 7. MSMQ queue size  [S20]
# ---------------------------------------------------------------------------
Write-Section "7. MSMQ queue size  [S20]"
Write-Output "The queue is full at 520 items or when it exceeds 1 GB; in both cases archiving stops [S20]."
Write-Output ""
$msmqStore = 'C:\Windows\System32\msmq\Storage'
if (Test-Path -LiteralPath $msmqStore) {
    $items = Get-ChildItem -LiteralPath $msmqStore -Recurse -File -ErrorAction SilentlyContinue
    $count = ($items | Measure-Object).Count
    $bytes = ($items | Measure-Object -Property Length -Sum).Sum
    Write-Output ("Storage folder : {0}" -f $msmqStore)
    Write-Output ("Contains       : {0} items  (documented full threshold: 520)" -f $count)
    Write-Output ("Size           : {0} MB    (documented full threshold: 1024 MB)" -f [math]::Round(($bytes / 1MB), 1))
    if ($count -ge 520) { Write-Output "  WARNING: item count is at or above the documented full threshold." }
    if ($bytes -ge 1GB) { Write-Output "  WARNING: queue size is at or above the documented full threshold." }
} else {
    Write-Output "MSMQ Storage folder not found at $msmqStore."
}

# ---------------------------------------------------------------------------
# 8. Log and dump folders  [S22] [S20] [S21]
# ---------------------------------------------------------------------------
Write-Section "8. Log and dump folders  [S22] [S20]"
$logPaths = @()
$logPaths += (Get-ChildItem -LiteralPath 'C:\ProgramData' -Directory -Filter 'Genetec Security Center*' -ErrorAction SilentlyContinue |
              ForEach-Object { Join-Path $_.FullName 'Logs'; Join-Path $_.FullName 'Dumps' })
$logPaths += 'C:\ArchiverLogs'
$logPaths += (Join-Path $env:ALLUSERSPROFILE 'Genetec\Installation')

foreach ($lp in ($logPaths | Select-Object -Unique)) {
    if (Test-Path -LiteralPath $lp) {
        $files  = Get-ChildItem -LiteralPath $lp -Recurse -File -ErrorAction SilentlyContinue
        $cnt    = ($files | Measure-Object).Count
        $sum    = ($files | Measure-Object -Property Length -Sum).Sum
        $newest = ($files | Sort-Object LastWriteTime -Descending | Select-Object -First 1)
        Write-Output ("{0}" -f $lp)
        Write-Output ("    files={0}  totalMB={1}  newest={2}" -f $cnt, [math]::Round(($sum / 1MB), 1), $(if ($newest) { $newest.LastWriteTime } else { 'n/a' }))
    } else {
        Write-Output ("{0}  (not present)" -f $lp)
    }
}

Write-Section "8b. Archiver log grep for documented disk events  [S20]"
Write-Output "Documented instruction: check for disk full or disk 80% events in the Archiver logs"
Write-Output "(C:\ArchiverLogs by default)  [S20]"
Write-Output ""
if (Test-Path -LiteralPath 'C:\ArchiverLogs') {
    $recent = Get-ChildItem -LiteralPath 'C:\ArchiverLogs' -Recurse -File -ErrorAction SilentlyContinue |
              Where-Object { $_.LastWriteTime -gt (Get-Date).AddDays(-7) }
    if ($recent) {
        $hits = $recent | Select-String -Pattern 'disk full', 'disk 80', 'Disk access unauthorized', 'Disk access restored' -SimpleMatch -ErrorAction SilentlyContinue
        if ($hits) {
            $hits | Select-Object -Last 40 | ForEach-Object { Write-Output ("    {0}:{1}: {2}" -f $_.Filename, $_.LineNumber, $_.Line.Trim()) }
        } else {
            Write-Output "    No matches in Archiver logs from the last 7 days."
        }
    } else {
        Write-Output "    No Archiver log files modified in the last 7 days."
    }
} else {
    Write-Output "    C:\ArchiverLogs not present. The path is set by ArchiverLogPath in Archiver.gconfig [S20]."
}

# ---------------------------------------------------------------------------
# 9. Windows event logs  [S21] [S22]
# ---------------------------------------------------------------------------
Write-Section "9. Windows event logs - Application, System and Genetec  [S21] [S22]"
Write-Output "Documented instruction: make sure to check application, system, and Genetec event logs [S21]"
Write-Output ""
foreach ($logName in 'Application', 'System', 'Genetec') {
    Write-Output "--- $logName : last 15 Error or Warning entries (7 days) ---"
    try {
        Get-WinEvent -FilterHashtable @{ LogName = $logName; Level = 2, 3; StartTime = (Get-Date).AddDays(-7) } -MaxEvents 15 -ErrorAction Stop |
            Select-Object TimeCreated, LevelDisplayName, ProviderName, @{ n = 'FirstLine'; e = { ($_.Message -split "`n")[0] } } |
            Format-Table -AutoSize -Wrap | Out-String | Write-Output
    } catch {
        Write-Output "    Could not read the $logName log (it may not exist, or elevation may be required)."
    }
}

Write-Output "--- System log : Event ID 41 (unclean shutdown) in the last 30 days  [S21] ---"
try {
    $e41 = Get-WinEvent -FilterHashtable @{ LogName = 'System'; Id = 41; StartTime = (Get-Date).AddDays(-30) } -ErrorAction Stop
    if ($e41) {
        $e41 | Select-Object TimeCreated, Id, ProviderName | Format-Table -AutoSize | Out-String | Write-Output
        Write-Output "    Documented meaning: the SQL server or installation might be corrupted. Contact Technical Support [S21]."
    } else {
        Write-Output "    None found."
    }
} catch {
    Write-Output "    None found, or the System log could not be read."
}

Write-Output "--- Directory failover database-lock error  [S21] ---"
try {
    $lock = Get-WinEvent -FilterHashtable @{ LogName = 'Application'; StartTime = (Get-Date).AddDays(-30) } -ErrorAction Stop |
            Where-Object { $_.Message -like '*Unable to take the database lock*' } | Select-Object -First 5
    if ($lock) {
        $lock | Select-Object TimeCreated, ProviderName | Format-Table -AutoSize | Out-String | Write-Output
        Write-Output "    Documented fix: restart the Genetec Server service on your failover server [S21]."
    } else {
        Write-Output "    None found."
    }
} catch {
    Write-Output "    Could not scan the Application log."
}

# ---------------------------------------------------------------------------
# 10. SQL Server error logs  [S22]
# ---------------------------------------------------------------------------
Write-Section "10. SQL Server ERRORLOG location  [S22]"
Write-Output "Documented default: C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\Log"
Write-Output "The instance folder name varies by version and install settings [S22]."
Write-Output ""
$sqlRoot = 'C:\Program Files\Microsoft SQL Server'
if (Test-Path -LiteralPath $sqlRoot) {
    Get-ChildItem -LiteralPath $sqlRoot -Directory -Filter 'MSSQL*' -ErrorAction SilentlyContinue | ForEach-Object {
        $logDir = Join-Path $_.FullName 'MSSQL\Log'
        if (Test-Path -LiteralPath $logDir) {
            Write-Output "    $logDir"
            Get-ChildItem -LiteralPath $logDir -Filter 'ERRORLOG*' -ErrorAction SilentlyContinue |
                Select-Object Name, Length, LastWriteTime | Format-Table -AutoSize | Out-String | Write-Output
        }
    }
} else {
    Write-Output "    No local SQL Server installation folder found; the database may be remote."
}

# ---------------------------------------------------------------------------
# 11. Time synchronization  [S9] [S21]
# ---------------------------------------------------------------------------
Write-Section "11. Time synchronization  [S9]"
Write-Output "From 5.14.0.0, Security Center raises health events when the Directory server and a"
Write-Output "connected failover or expansion server drift more than 10 seconds apart [S9]."
Write-Output "Correct Windows date and time is also a documented Directory-offline check [S21]."
Write-Output ""
Write-Output ("Local time (UTC) : {0}" -f (Get-Date).ToUniversalTime().ToString('u'))
Write-Output ("Time zone        : {0}" -f (Get-TimeZone -ErrorAction SilentlyContinue).Id)
if ($DirectoryHost -ne $env:COMPUTERNAME) {
    try {
        $remote = Invoke-Command -ComputerName $DirectoryHost -ScriptBlock { (Get-Date).ToUniversalTime() } -ErrorAction Stop
        $delta  = [math]::Abs(((Get-Date).ToUniversalTime() - $remote).TotalSeconds)
        Write-Output ("Remote time (UTC): {0}" -f $remote.ToString('u'))
        Write-Output ("Offset           : {0} seconds  (documented alert threshold: 10)" -f [math]::Round($delta, 1))
        if ($delta -gt 10) { Write-Output "  WARNING: offset exceeds the documented 10 second threshold [S9]." }
    } catch {
        Write-Output "Remote time      : could not be read (PowerShell remoting may be disabled). Compare manually."
    }
}

# ---------------------------------------------------------------------------
# Wrap up
# ---------------------------------------------------------------------------
Write-Section "Next steps"
Write-Output "Before contacting the Genetec Technical Assistance Center, the documentation asks for:"
Write-Output "  * the Security Center build number from the About page of a client running on the"
Write-Output "    Directory or an expansion server  [S13]"
Write-Output "  * Windows Application, System and Genetec event logs saved with Save All Events As  [S22]"
Write-Output "  * dump files from C:\ProgramData\Genetec Security Center [5.x]\Dumps  [S21]"
Write-Output "  * a console trace using the trace logger name Technical Support gives you, plus the"
Write-Output "    exact time the issue occurred  [S22]"
Write-Output "  * for MSMQ issues: role database size and version, free disk, mqsvc.exe disk response"
Write-Output "    time, and the MSMQ queue size  [S20]"
Write-Output "  * run the Database Anonymization Tool before sharing any database backup  [S9]"
Write-Output ""
Write-Output "See references/operations.md section 13 for the full evidence checklist."

if ($OutputFolder) { Stop-Transcript | Out-Null }
