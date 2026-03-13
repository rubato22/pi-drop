```powershell
# Matrix Green Styling
$Green = "Green"
$Cyan = "Cyan"
$Red = "Red"

Clear-Host
Write-Host "====================================================" -ForegroundColor $Green
Write-Host "   ⚡ PI-DROP // TAILSCALE WINDOWS AUTO-RECEIVER    " -ForegroundColor $Green
Write-Host "====================================================" -ForegroundColor $Green
Write-Host ""

# 1. Check if Tailscale is installed
if (-not (Get-Command "tailscale" -ErrorAction SilentlyContinue)) {
    Write-Host "[!] Tailscale is not installed or not in your system PATH!" -ForegroundColor $Red
    Write-Host "[!] Please install the Windows Tailscale app first." -ForegroundColor $Red
    Write-Host ""
    Pause
    Exit
}

Write-Host "[*] Security protocols initialized. Tailscale detected." -ForegroundColor $Green

# 2. Ask user for directory
$DefaultDir = "C:\Taildrop"
Write-Host "Where should incoming Taildrop files be saved?" -ForegroundColor $Green
$TaildropDir = Read-Host "(Example: D:\Media\Photos or C:\Taildrop [Press Enter for Default])"

if ([string]::IsNullOrWhiteSpace($TaildropDir)) {
    $TaildropDir = $DefaultDir
}

# 3. Create directory
if (-not (Test-Path $TaildropDir)) {
    Write-Host "[*] Creating directory and setting permissions..." -ForegroundColor $Green
    New-Item -ItemType Directory -Force -Path $TaildropDir | Out-Null
}

# 4. Find exact Tailscale Path for Task Scheduler
$TailscalePath = (Get-Command tailscale.exe).Source

# 5. Create the Windows Background Task (Daemon)
Write-Host "[*] Writing invisible Scheduled Task daemon..." -ForegroundColor $Green
$TaskName = "PiDrop_AutoReceive"

# Remove old task if it exists
Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction SilentlyContinue

# Build the new task using the absolute path
$Action = New-ScheduledTaskAction -Execute $TailscalePath -Argument "file get --loop `"$TaildropDir`""
$Trigger = New-ScheduledTaskTrigger -AtLogOn
$Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -Hidden

Register-ScheduledTask -Action $Action -Trigger $Trigger -Settings $Settings -TaskName $TaskName -Description "Silently catches Taildrop files in the background" | Out-Null

# 6. Start the daemon right now
Start-ScheduledTask -TaskName $TaskName

Write-Host ""
Write-Host "====================================================" -ForegroundColor $Green
Write-Host "  SUCCESS! WINDOWS PI-DROP IS NOW ACTIVE.           " -ForegroundColor $Green
Write-Host "====================================================" -ForegroundColor $Green
Write-Host "Any files sent to this PC via Taildrop will instantly" -ForegroundColor $Green
Write-Host "appear in: $TaildropDir" -ForegroundColor $Cyan
Write-Host ""
Write-Host "NOTE: To prevent conflicts, close the Tailscale GUI in your system tray" -ForegroundColor $Red
Write-Host "if you want this background service to handle all incoming files." -ForegroundColor $Red
Write-Host ""
Pause
