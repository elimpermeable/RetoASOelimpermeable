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
            $cpu = Get-Counter "\Processor(_Total)\% Processor Time"
            $valorCPU = [math]::Round($cpu.CounterSamples[0].CookedValue, 2)
            Write-Host "$valorCPU %"
        }
        "2" {
            Clear-Host
            Write-Host "Uso de memoria:" -ForegroundColor Yellow
            $mem = Get-CimInstance Win32_OperatingSystem
            $total = [math]::Round($mem.TotalVisibleMemorySize / 1KB, 2)
            $free = [math]::Round($mem.FreePhysicalMemory / 1KB, 2)
            $used = $total - $free
            Write-Host "Total: $total MB"
            Write-Host "Usada: $used MB"
            Write-Host "Libre: $free MB"
        }
        "3" {
            Clear-Host
            Write-Host "Espacio en disco:" -ForegroundColor Yellow
            Get-PSDrive -PSProvider FileSystem | ForEach-Object {
                $used = $_.Used / 1GB
                $free = $_.Free / 1GB
                $total = $used + $free
                Write-Host "$($_.Name): Total = $([math]::Round($total,2)) GB, Usado = $([math]::Round($used,2)) GB, Libre = $([math]::Round($free,2)) GB"
            }
        }
        "4" {
            Clear-Host
            Write-Host "Procesos activos (Top 15 por CPU):" -ForegroundColor Yellow
            Get-Process | Sort-Object CPU -Descending | Select-Object -First 15 Name, Id, CPU | Format-Table -AutoSize
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

