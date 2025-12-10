# Establece la codificación de salida de la consola a UTF8 (para mostrar caracteres especiales correctamente)
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Obtiene la ruta donde está guardado este script
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Cambia el directorio actual a la carpeta donde está el script
Set-Location $ScriptDir

# Crear carpeta "logs" si no existe
if (-not (Test-Path "$ScriptDir\logs")) { 
    New-Item -ItemType Directory -Path "$ScriptDir\logs" | Out-Null
}

# Crear carpeta "backups" si no existe
if (-not (Test-Path "$ScriptDir\backups")) { 
    New-Item -ItemType Directory -Path "$ScriptDir\backups" | Out-Null
}

# Cargar módulos externos para que las funciones estén disponibles
. "$ScriptDir\Funciones-Servicio.ps1"    # Funciones relacionadas con servicios
. "$ScriptDir\Monitoreo-Sistema.ps1"    # Funciones de monitoreo del sistema
. "$ScriptDir\Backup-Sistema.ps1"       # Funciones de backup
. "$ScriptDir\Configuracion-Sistema.ps1" # Funciones de configuración del sistema

# Guardamos la fecha y hora actual en formato legible
$fecha = Get-Date -Format "dddd dd MMMM yyyy HH:mm:ss"

# Mensaje de bienvenida y cabecera visual
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "    SISTEMA DE GESTION DE SERVICIOS" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Mensaje de bienvenida con la fecha actual
Write-Host "Bienvenido Administrador...Fecha actual del sistema: $fecha" -ForegroundColor Yellow
Write-Host ""

# Bucle principal del menú
do {
    # Mostrar las opciones del menú principal
    Write-Host "1) Gestion de servicios"
    Write-Host "2) Monitoreo del sistema"
    Write-Host "3) Copias de seguridad"
    Write-Host "4) Configuracion del sistema"
    Write-Host "5) Salir"
    Write-Host ""

    # Solicita al usuario que seleccione una opción
    $op = Read-Host "Selecciona una opcion"

    # Evaluar la opción ingresada
    switch ($op) {
        "1" { Menu-Servicios }       # Llama al menú de gestión de servicios
        "2" { Menu-Monitoreo }       # Llama al menú de monitoreo
        "3" { Menu-Backup }          # Llama al menú de backups
        "4" { Menu-Configuracion }   # Llama al menú de configuración del sistema
        "5" { Write-Host "Saliendo..." -ForegroundColor Red; break } # Salir del bucle y terminar el script
        default { Write-Host "Opcion no valida" -ForegroundColor Red } # Si no es opción válida, muestra error
    }

    # Pausa para que el usuario vea el resultado antes de limpiar pantalla
    Write-Host ""
    Write-Host "Pulsa ENTER para continuar..."
    [void][System.Console]::ReadKey($true)

    # Limpiar pantalla antes de volver a mostrar el menú
    Clear-Host

    # Mostrar nuevamente la cabecera después de limpiar
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "    SISTEMA DE GESTION DE SERVICIOS" -ForegroundColor Green
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host ""

# El bucle se repite infinitamente hasta que el usuario elija "Salir"
} while ($true)

