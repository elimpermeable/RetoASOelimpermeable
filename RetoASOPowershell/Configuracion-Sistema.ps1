# Configuracion-Sistema.ps1
# Muy simple, sin tildes

function Menu-Configuracion {
    Clear-Host
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "         CONFIGURACION DEL SISTEMA" -ForegroundColor Green
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1) Mostrar informacion del sistema"
    Write-Host "2) Cambiar nombre del equipo"
    Write-Host "3) Volver al menu principal"
    Write-Host ""

    $op = Read-Host "Selecciona una opcion"

    switch ($op) {
        "1" { systeminfo }
        "2" { Cambiar-Nombre }
        "3" { return }
        default { Write-Host "Opcion no valida" -ForegroundColor Red }
    }

    Write-Host ""
    Write-Host "Pulsa ENTER para continuar..."
    [void][System.Console]::ReadKey($true)
    Menu-Configuracion
}

function Cambiar-Nombre {
    $nuevo = Read-Host "Nuevo nombre del equipo"
    Rename-Computer -NewName $nuevo -Force
    Write-Host "Nombre cambiado. Reinicia para aplicar cambios." -ForegroundColor Yellow
}
