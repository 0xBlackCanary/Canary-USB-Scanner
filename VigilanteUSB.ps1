# =============================================
#   CANARY USB SENTINEL v1.1
#   Vigilancia silenciosa estilo Canary Token
#   Para 0xBlackCanary 🦜
# =============================================

param(
    [switch]$Silent
)

# ================== CONFIGURACIÓN ==================
$Config = @{
    LogPath           = "$env:USERPROFILE\Desktop\Canary_USB_Log.txt"
    AlertSound        = $true
    AutoEject         = $true
    ShowNotifications = $true
    DangerousExt      = @('.exe','.bat','.cmd','.scr','.vbs','.ps1','.hta','.wsf','.js','.jse','.lnk')
}

# ================== FUNCIONES ==================
function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    Add-Content -Path $Config.LogPath -Value "$timestamp - $Message" -ErrorAction SilentlyContinue
}

function Send-ToastNotification {
    param([string]$Title, [string]$Message, [string]$Type = "Warning")
    if (-not $Config.ShowNotifications) { return }
    try {
        New-BurntToastNotification -Text $Title, $Message `
            -Sound "Alarm" -ExpirationTime (Get-Date).AddMinutes(5) | Out-Null
    } catch { }
}

# ================== INICIO ==================
Clear-Host
Write-Host "`n🦜 CANARY USB SENTINEL v1.1 - Activo" -ForegroundColor Cyan
Write-Host "   🛡️  Vigilancia silenciosa estilo Canary Token iniciada..." -ForegroundColor Gray
Write-Log "=== CANARY USB SENTINEL INICIADO ==="

if (-not (Test-Path $Config.LogPath)) {
    New-Item -Path $Config.LogPath -ItemType File -Force | Out-Null
}

Write-Host "`n✅ Sentinel en espera. Inserta un USB para activar la detección." -ForegroundColor Green
Write-Host "   (Ctrl+C para detener)" -ForegroundColor DarkGray

# ================== MONITOREO ==================
$query = "SELECT * FROM __InstanceCreationEvent WITHIN 2 WHERE TargetInstance ISA 'Win32_DiskDrive' AND TargetInstance.InterfaceType = 'USB'"

Register-WmiEvent -Query $query -SourceIdentifier "CanaryUSBWatcher" -Action {
    $usb = $EventArgs.NewEvent.TargetInstance
    $usbName = if ($usb.Model) { $usb.Model.Trim() } else { "USB Desconocido" }

    Write-Host "`n[!] USB DETECTADO → $usbName" -ForegroundColor Yellow
    Write-Log "USB detectado: $usbName"

    Start-Sleep -Milliseconds 800

    $partitions = Get-WmiObject -Query "ASSOCIATORS OF {Win32_DiskDrive.DeviceID='$($usb.DeviceID)'} WHERE AssocClass = Win32_DiskDriveToDiskPartition"

    foreach ($partition in $partitions) {
        $logicalDisks = Get-WmiObject -Query "ASSOCIATORS OF {Win32_DiskPartition.DeviceID='$($partition.DeviceID)'} WHERE AssocClass = Win32_LogicalDiskToPartition"

        foreach ($logical in $logicalDisks) {
            $driveLetter = $logical.DeviceID

            if (Test-Path $driveLetter) {
                Write-Host "   Unidad: $driveLetter" -ForegroundColor Green

                $suspiciousFiles = Get-ChildItem -Path "$driveLetter\" -Recurse -Force -ErrorAction SilentlyContinue |
                    Where-Object {
                        $_.Extension -in $Config.DangerousExt -or
                        $_.Name -eq 'autorun.inf' -or
                        ($_.Attributes -match 'Hidden' -and $_.Name -like '.*')
                    } |
                    Where-Object { -not ($_.Name -like '._*' -or $_.FullName -like '*\.Spotlight-V100*' -or $_.FullName -like '*\.fseventsd*' -or $_.Name -eq '.DS_Store') }

                if ($suspiciousFiles) {
                    Write-Host "   🚨 PELIGRO DETECTADO" -ForegroundColor Red
                    $suspiciousFiles | ForEach-Object {
                        Write-Host "      → $($_.FullName)" -ForegroundColor Red
                    }

                    Write-Log "¡ALERTA! Archivos sospechosos en $usbName ($driveLetter)"
                    $suspiciousFiles | ForEach-Object { Write-Log "      → $($_.FullName)" }

                    if ($Config.AlertSound) {
                        for($i=0; $i -lt 5; $i++) {
                            [console]::beep(1100, 180)
                            Start-Sleep -Milliseconds 80
                            [console]::beep(750, 250)
                        }
                    }

                    Send-ToastNotification -Title "🚨 Canary USB Alert" -Message "Archivos sospechosos en $usbName" -Type "Danger"

                    if ($Config.AutoEject) {
                        Write-Host "   Expulsando USB..." -ForegroundColor Red
                        try {
                            $shell = New-Object -ComObject Shell.Application
                            $shell.Namespace(17).ParseName($driveLetter).InvokeVerb("Eject")
                            Write-Host "   ✅ USB expulsado" -ForegroundColor Green
                            Write-Log "USB expulsado automáticamente"
                        } catch {
                            Write-Host "   ⚠️ Expulsión manual recomendada" -ForegroundColor Yellow
                        }
                    }
                }
                else {
                    Write-Host "   ✅ Unidad limpia" -ForegroundColor Green
                    Write-Log "USB limpio: $usbName ($driveLetter)"
                }
            }
        }
    }
}

try { 
    while ($true) { Start-Sleep -Seconds 2 } 
}
catch {
    Write-Host "`n🛑 Canary USB Sentinel detenido." -ForegroundColor Cyan
    Write-Log "Sentinel detenido por el usuario"
    Unregister-Event -SourceIdentifier "CanaryUSBWatcher" -ErrorAction SilentlyContinue
}
