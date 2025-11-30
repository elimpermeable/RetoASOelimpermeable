# Monitoreo-Sistema.ps1
# Sin tildes, simple y funcional

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
        "1" { Get-Counter "\Processor(_Total)\% Processor Time" | Select -Expand CounterSamples }
        "2" { Get-CimInstance Win32_OperatingSystem | Select FreePhysicalMemory, TotalVisibleMemorySize }
        "3" { Get-PSDrive -PSProvider FileSystem | Select Name, Free, Used }
        "4" { Get-Process | Select Name, Id, CPU | Sort-Object CPU -Descending | Select -First 15 }
        "5" { return }
        default { Write-Host "Opcion no valida" -ForegroundColor Red }
    }

    Write-Host ""
    Write-Host "Pulsa ENTER para continuar..."
    [void][System.Console]::ReadKey($true)
    Menu-Monitoreo
}
