# ===============================
# Función: Cargar configuración
# Lee y convierte el archivo JSON
# ===============================
function Get-Config {
    # Lee el archivo config.json desde la misma carpeta del script
    $path = Join-Path $PSScriptRoot "config.json"

    # Convierte el JSON a un objeto PowerShell tipado
    return Get-Content $path | ConvertFrom-Json
}

# ===============================
# Función: Guardar configuración
# Escribe los cambios en el JSON
# ===============================
function Save-Config($config) {
    # Convierte el objeto a JSON legible y guarda cambios
    $config | ConvertTo-Json -Depth 5 | Out-File (Join-Path $PSScriptRoot "config.json")
}

# ===============================
# Función: Menú de configuración
# ===============================
function Menu-Configuracion {
    Clear-Host

    # Cargar configuración actual
    $config = Get-Config

    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "         CONFIGURACION DEL SISTEMA" -ForegroundColor Green
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Configuración actual cargada del JSON:"
    Write-Host "Nombre del sistema: $($config.SystemName)"
    Write-Host "Ruta de Backups:    $($config.BackupPath)"
    Write-Host "Ruta de Logs:       $($config.LogsPath)"
    Write-Host "Copias maximas:     $($config.MaxBackupCopies)"
    Write-Host "Compresion:         $($config.EnableCompression)"
    Write-Host ""
    Write-Host "1) Mostrar informacion del sistema"
    Write-Host "2) Cambiar nombre del sistema (solo JSON)"
    Write-Host "3) Cambiar directorio de backups"
    Write-Host "4) Cambiar directorio de logs"
    Write-Host "5) Volver al menu principal"
    Write-Host ""

    $op = Read-Host "Selecciona una opcion"

    switch ($op) {

        # Mostrar systeminfo real de Windows
        "1" { systeminfo }

        # Cambiar nombre del sistema en el JSON
        "2" { 
            $nuevo = Read-Host "Nuevo nombre del sistema"
            $config.SystemName = $nuevo
            Save-Config $config
            Write-Host "Nombre actualizado correctamente." -ForegroundColor Yellow
        }

        # Cambiar carpeta donde se guardan backups
        "3" {
            $nuevo = Read-Host "Nueva ruta para backups"
            $config.BackupPath = $nuevo
            Save-Config $config
            Write-Host "Ruta de backups actualizada." -ForegroundColor Yellow
        }

        # Cambiar carpeta donde se guardan logs
        "4" {
            $nuevo = Read-Host "Nueva ruta para logs"
            $config.LogsPath = $nuevo
            Save-Config $config
            Write-Host "Ruta de logs actualizada." -ForegroundColor Yellow
        }

        # Volver al menú principal
        "5" { return }

        default { 
            Write-Host "Opcion no valida" -ForegroundColor Red 
        }
    }

    Write-Host ""
    Write-Host "Pulsa ENTER para continuar..."
    [void][System.Console]::ReadKey($true)
    Menu-Configuracion
}

# Llamada inicial (si se ejecuta este script directamente)
Menu-Configuracion

