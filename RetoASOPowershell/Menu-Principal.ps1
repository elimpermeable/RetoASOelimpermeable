# Menu-Principal.ps1


[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location $ScriptDir

# Crear carpetas si no existen
if (-not (Test-Path "$ScriptDir\logs")) { New-Item -ItemType Directory -Path "$ScriptDir\logs" | Out-Null }
if (-not (Test-Path "$ScriptDir\backups")) { New-Item -ItemType Directory -Path "$ScriptDir\backups" | Out-Null }

# Cargar modulos
. "$ScriptDir\Funciones-Servicio.ps1"
. "$ScriptDir\Monitoreo-Sistema.ps1"
. "$ScriptDir\Backup-Sistema.ps1"

# Mensaje bienvenida sin tildes
$fecha = Get-Date -Format "dddd dd MMMM yyyy HH:mm:ss"
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "    SISTEMA DE GESTION DE SERVICIOS" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Bienvenido Administrador...Fecha actual del sistema: $fecha" -ForegroundColor Yellow
Write-Host ""

do {
    Write-Host "1) Gestion de servicios"
    Write-Host "2) Monitoreo del sistema"
    Write-Host "3) Copias de seguridad"
    Write-Host "4) Configuracion del sistema"
    Write-Host "5) Salir"
    Write-Host ""
    $op = Read-Host "Selecciona una opcion"

    switch ($op) {
        "1" { Menu-Servicios }
        "2" { Menu-Monitoreo }
        "3" { Menu-Backup }
        "4" { Menu-Configuracion }
        "5" { Write-Host "Saliendo..." -ForegroundColor Red; break }
        default { Write-Host "Opcion no valida" -ForegroundColor Red }
    }

    Write-Host ""
    Write-Host "Pulsa ENTER para continuar..."
    [void][System.Console]::ReadKey($true)
    Clear-Host

    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "    SISTEMA DE GESTION DE SERVICIOS" -ForegroundColor Green
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host ""

} while ($true)
