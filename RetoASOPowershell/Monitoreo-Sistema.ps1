# Monitoreo-Sistema.ps1
# Módulo simplificado de monitorización

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$LogFile = Join-Path $ScriptDir 'logs\sistema.log'

function Menu-Monitoreo {
    Clear-Host
    Write-Host "--- MONITOREO DEL SISTEMA ---" -ForegroundColor Cyan
    Write-Host "1) Mostrar uso básico de memoria y disco"
    Write-Host "2) Mostrar top 10 procesos (CPU) y guardar en log"
    Write-Host "0) Volver"
    $opc = Read-Host "Seleccione"
    switch ($opc) {
        "1" { Mostrar-Recursos }
        "2" { Monitor-Tareas }
        "0" { return }
        default { Write-Host "Opción inválida." -ForegroundColor Red }
    }
}

function Mostrar-Recursos {
    Clear-Host
    try {
        $os = Get-CimInstance Win32_OperatingSystem
        $totalMB = [math]::Round($os.TotalVisibleMemorySize/1024,2)
        $freeMB  = [math]::Round($os.FreePhysicalMemory/1024,2)
        $usedMB  = $totalMB - $freeMB
        $line = "Memoria: Total ${totalMB}MB | Usada ${usedMB}MB | Libre ${freeMB}MB"
        Write-Host $line -ForegroundColor Yellow
        Add-Content -Path $LogFile -Value ("$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss'): $line")
    } catch {
        Write-Host "No se pudo obtener info de memoria." -ForegroundColor Red
    }

    try {
        $drives = Get-PSDrive -PSProvider FileSystem | Select-Object Name,Free
        Write-Host "`nDiscos:" -ForegroundColor Yellow
        $drives | Format-Table -AutoSize
        Add-Content -Path $LogFile -Value ("$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss'): Discos: " + ($drives | Out-String))
    } catch {
        Write-Host "No se pudo obtener info de discos." -ForegroundColor Red
    }
}

function Monitor-Tareas {
    Clear-Host
    Write-Host "Top 10 procesos por CPU:" -ForegroundColor Cyan
    $top = Get-Process | Sort-Object -Property CPU -Descending | Select-Object -First 10 Id,ProcessName,CPU,PM
    $top | Format-Table -AutoSize
    # Guardar en log la salida (texto)
    $text = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss'): Top procesos:`n" + ($top | Out-String)
    Add-Content -Path $LogFile -Value $text
    Write-Host "`n(La información anterior se ha guardado en logs\sistema.log)" -ForegroundColor Green
}
