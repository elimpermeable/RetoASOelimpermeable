# Monitoreo-Sistema.ps1
# Monitoreo del sistema simple y funcional

function Menu-Monitoreo {
    Clear-Host
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "        MONITOREO DEL SISTEMA" -ForegroundColor Green
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1) Uso de CPU"
    Write-Host "2) Uso de memoria"
    Write-Host "3) Espacio en disco"
    Write-Host "4) Procesos activos"
    Write-Host "5) Volver al menu principal"
    Write-Host ""

    $op = Read-Host "Selecciona una opcion"

    switch ($op) {
        "1" {
            Clear-Host
            Write-Host "Uso de CPU total:" -ForegroundColor Yellow
            try {
                # Usar Win32_Processor para obtener uso de CPU
                $cpuLoad = Get-CimInstance Win32_Processor | Measure-Object -Property LoadPercentage -Average | Select-Object -ExpandProperty Average
                Write-Host "$([math]::Round($cpuLoad,2)) %"
            }
            catch {
                Write-Host "Error al obtener el uso de CPU: $_" -ForegroundColor Red
            }
        }
        "2" {
            Clear-Host
            Write-Host "Uso de memoria:" -ForegroundColor Yellow
            try {
                $mem = Get-CimInstance Win32_OperatingSystem
                $totalMB = [math]::Round($mem.TotalVisibleMemorySize / 1024,2)
                $freeMB = [math]::Round($mem.FreePhysicalMemory / 1024,2)
                $usedMB = [math]::Round($totalMB - $freeMB,2)
                Write-Host "Total: $totalMB MB"
                Write-Host "Usada: $usedMB MB"
                Write-Host "Libre: $freeMB MB"
            }
            catch {
                Write-Host "Error al obtener memoria: $_" -ForegroundColor Red
            }
        }
        "3" {
            Clear-Host
            Write-Host "Espacio en disco:" -ForegroundColor Yellow
            try {
                Get-PSDrive -PSProvider FileSystem | ForEach-Object {
                    $used = $_.Used / 1GB
                    $free = $_.Free / 1GB
                    $total = $used + $free
                    Write-Host "$($_.Name): Total = $([math]::Round($total,2)) GB, Usado = $([math]::Round($used,2)) GB, Libre = $([math]::Round($free,2)) GB"
                }
            }
            catch {
                Write-Host "Error al obtener espacio en disco: $_" -ForegroundColor Red
            }
        }
        "4" {
            Clear-Host
            Write-Host "Procesos activos (Top 15 por CPU):" -ForegroundColor Yellow
            try {
                Get-Process | Sort-Object CPU -Descending | Select-Object -First 15 Name, Id, CPU | Format-Table -AutoSize
            }
            catch {
                Write-Host "Error al listar procesos: $_" -ForegroundColor Red
            }
        }
        "5" { return }
        default {
            Write-Host "Opcion no valida" -ForegroundColor Red
        }
    }

    Write-Host ""
    Read-Host "Pulsa ENTER para continuar..."
    Menu-Monitoreo
}


