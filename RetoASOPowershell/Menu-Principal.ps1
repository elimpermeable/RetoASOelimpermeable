# Menu-Principal.ps1

# Asegurar que consola use UTF8 para caracteres
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Directorio del script (ruta base)
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location $ScriptDir

# Crear carpetas si no existen
if (-not (Test-Path "$ScriptDir\logs")) { New-Item -ItemType Directory -Path "$ScriptDir\logs" | Out-Null }
if (-not (Test-Path "$ScriptDir\backups")) { New-Item -ItemType Directory -Path "$ScriptDir\backups" | Out-Null }

# Dot-source (cargar módulos simples)
. "$ScriptDir\Funciones-Servicio.ps1"
. "$ScriptDir\Monitoreo-Sistema.ps1"
. "$ScriptDir\Backup-Sistema.ps1"

# Mensaje de bienvenida con fecha
$fecha = Get-Date -Format "dddd, dd MMMM yyyy HH:mm:ss"
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Bienvenido al Sistema - $fecha" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Cyan

# Menú principal simplificado
do {
    Write-Host "Menú Principal:" -ForegroundColor White
    Write-Host " 1) Gestión de servicios"
    Write-Host " 2) Monitoreo del sistema"
    Write-Host " 3) Copias de seguridad"
    Write-Host " 0) Salir"
    $op = Read-Host "Elige opción (número)"

    switch ($op) {
        "1" { Menu-Servicios }
        "2" { Menu-Monitoreo }
        "3" { Menu-Backup }
        "0" { Write-Host "Saliendo..." -ForegroundColor Yellow; break }
        default { Write-Host "Opción no válida." -ForegroundColor Red }
    }

    Write-Host "`nPulsa ENTER para continuar..."
    [void][System.Console]::ReadKey($true)
    Clear-Host
} while ($true)
