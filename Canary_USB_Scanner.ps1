# ==============================================================================
#  CANARY USB SCANNER - v1.0 🦜
#  Repositorio: https://github.com/0xBlackCanary/Canary-USB-Scanner
# ==============================================================================

# --- COMPROBACIÓN DE ADMINISTRADOR ---
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "`n [!] ERROR: Permisos insuficientes." -ForegroundColor Red
    Write-Host " Por favor, ejecuta PowerShell como ADMINISTRADOR." -ForegroundColor Yellow
    Exit
}

Clear-Host
Write-Host "  🦜 CANARY USB SCANNER 🦜" -ForegroundColor Cyan
Write-Host "  ------------------------" -ForegroundColor DarkGray
Write-Host "  v1.0 | @0xBlackCanary " -ForegroundColor Gray

# Limpiar eventos previos
Unregister-Event -SourceIdentifier "USBWatcher" -ErrorAction SilentlyContinue

$logPath = "$env:USERPROFILE\Desktop\Canary_USB_Log.txt"
$extPeligrosas = '^\.(exe|bat|cmd|scr|vbs|ps1|hta|wsf|lnk|com|pif|run)$'

Write-Host "`n[+] Escaner ACTIVO" -ForegroundColor Cyan
Write-Host "[+] Vigilando puertos USB... (Ctrl+C para salir)" -ForegroundColor Gray

# Query WMI
$query = "SELECT * FROM __InstanceCreationEvent WITHIN 2 WHERE TargetInstance ISA 'Win32_DiskDrive' AND TargetInstance.InterfaceType = 'USB'"

Register-WmiEvent -Query $query -SourceIdentifier "USBWatcher" -Action {
    $usb = $EventArgs.NewEvent.TargetInstance
    Write-Host "`n[!] DISPOSITIVO DETECTADO: $($usb.Model)" -ForegroundColor Yellow
    
    Start-Sleep -Seconds 2
    
    $partitions = Get-WmiObject -Query "ASSOCIATORS OF {Win32_DiskDrive.DeviceID='$($usb.DeviceID)'} WHERE AssocClass = Win32_DiskDriveToDiskPartition"
    foreach ($partition in $partitions) {
        $logicalDisks = Get-WmiObject -Query "ASSOCIATORS OF {Win32_DiskPartition.DeviceID='$($partition.DeviceID)'} WHERE AssocClass = Win32_LogicalDiskToPartition"
        
        foreach ($logical in $logicalDisks) {
            $driveLetter = $logical.DeviceID + "\"
            
            if (Test-Path $driveLetter) {
                Write-Host "[+] Analizando unidad: $driveLetter" -ForegroundColor Cyan
                
                $hallazgos = Get-ChildItem -Path $driveLetter -Force -ErrorAction SilentlyContinue | Where-Object {
                    $esPeligroso = ($_.Extension -match $extPeligrosas) -or ($_.Name -eq 'autorun.inf')
                    $esOcultoSospechoso = ($_.Attributes -match 'Hidden') -and ($_.Name -notlike '.*')
                    $esExcepcion = ($_.Name -like '._*') -or ($_.Name -eq '.DS_Store') -or ($_.Name -eq 'System Volume Information')
                    
                    ($esPeligroso -or $esOcultoSospechoso) -and -not $esExcepcion
                }

                if ($hallazgos) {
                    Write-Host "[-] ⚠️ ¡PELIGRO! Archivos sospechosos detectados." -ForegroundColor Red
                    $hallazgos | ForEach-Object { Write-Host "    -> $($_.Name)" -ForegroundColor Red }
                    
                    1..3 | ForEach-Object { [console]::beep(1000, 250); Start-Sleep -Milliseconds 100 }
                    
                    Add-Content -Path $logPath -Value "$(Get-Date) - ALERTA en $($usb.Model) ($driveLetter). Archivos: $($hallazgos.Name -join ', ')"
                    
                    Write-Host "[!] Expulsando por seguridad..." -ForegroundColor Red
                    try {
                        $shell = New-Object -ComObject Shell.Application
                        $shell.Namespace(17).ParseName($logical.DeviceID).InvokeVerb("Eject")
                        Write-Host "[OK] Dispositivo desconectado." -ForegroundColor Green
                    } catch {
                        Write-Host "[!] Error al expulsar. Desconecte manualmente." -ForegroundColor Yellow
                    }
                } else {
                    Write-Host "[✓] USB Limpio: No se detectaron amenazas. 🦜" -ForegroundColor Green
                    Add-Content -Path $logPath -Value "$(Get-Date) - USB Limpio: $($usb.Model)"
                }
            }
        }
    }
    Write-Host "--------------------------------------------" -ForegroundColor DarkGray
}

while ($true) { Start-Sleep -Seconds 1 }
