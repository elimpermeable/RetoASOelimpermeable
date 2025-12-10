###########################################################
# Backup-Sistema.ps1
# Sistema de copias de seguridad con menú, restauración,
# eliminación y compresión. Versión con comentarios detallados.
###########################################################

# Obtiene la ruta donde está guardado el script
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Define la carpeta donde se guardarán los backups
$BackupDir = "$ScriptDir\backups"

# Si la carpeta de backups no existe, la crea
if (-not (Test-Path $BackupDir)) {
    New-Item -ItemType Directory -Path $BackupDir | Out-Null
}

# Rutas de los archivos que se incluirán en la copia
$ServiciosCSV = "$ScriptDir\servicios_seguimiento.txt"
$ConfigCSV = "$ScriptDir\Configuracion.csv"


###################################################
# MENÚ PRINCIPAL DEL MÓDULO DE BACKUPS
###################################################
function Menu-Backup {
    do {
        Clear-Host   # Limpia la pantalla para mostrar el menú limpio

        # Cabecera visual del menú
        Write-Host "==========================================" -ForegroundColor Cyan
        Write-Host "          COPIAS DE SEGURIDAD" -ForegroundColor Green
        Write-Host "==========================================" -ForegroundColor Cyan

        # Opciones del menú
        Write-Host ""
        Write-Host "1) Realizar copia de servicios y configuracion"
        Write-Host "2) Ver copias existentes"
        Write-Host "3) Eliminar copia"
        Write-Host "4) Restaurar copia de seguridad"
        Write-Host "5) Volver al menu principal"
        Write-Host ""

        # Solicita al usuario una opción
        $op = (Read-Host "Selecciona una opcion").Trim()

        # Ejecuta la función correspondiente según opción elegida
        switch ($op) {
            "1" { Hacer-Backup }
            "2" { Ver-Backups }
            "3" { Eliminar-Backup }
            "4" { Restaurar-Backup }
            "5" { return }   # Sale de la función
            default { Write-Host "Opcion no valida" -ForegroundColor Red }
        }

        # Espera antes de volver al menú
        Write-Host ""
        Read-Host "Pulsa ENTER para continuar..."

    } while ($true)   # Mantiene el menú en bucle infinito
}


###################################################
# 1) REALIZAR BACKUP
###################################################
function Hacer-Backup {

    # Verifica que el archivo de servicios existe
    if (-not (Test-Path $ServiciosCSV)) {
        Write-Host "Archivo de servicios no encontrado: $ServiciosCSV" -ForegroundColor Red
        return
    }

    # Verifica que el archivo de configuración existe
    if (-not (Test-Path $ConfigCSV)) {
        Write-Host "Archivo de configuracion no encontrado: $ConfigCSV" -ForegroundColor Red
        return
    }

    # Genera un nombre único usando fecha y hora
    $fecha = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupNombre = "backup_servicios_$fecha.zip"

    # Crea la ruta final del archivo comprimido
    $destino = Join-Path $BackupDir $backupNombre

    # Comprime los dos archivos de configuración en un ZIP
    Compress-Archive -Path $ServiciosCSV, $ConfigCSV -DestinationPath $destino -Force

    # Informa al usuario que el backup está realizado
    Write-Host "Backup creado: $destino" -ForegroundColor Green
}


###################################################
# 2) MOSTRAR LISTA DE BACKUPS
###################################################
function Ver-Backups {

    Write-Host "Copias almacenadas:" -ForegroundColor Cyan

    # Obtiene todos los archivos ZIP del directorio de copias
    $backups = Get-ChildItem -Path $BackupDir -Filter "*.zip"

    # Si no hay archivos ZIP, informa
    if ($backups.Count -eq 0) {
        Write-Host "No hay backups disponibles." -ForegroundColor Yellow
        return
    }

    # Muestra el nombre de cada copia
    foreach ($b in $backups) {
        Write-Host "- $($b.Name)"
    }
}


###################################################
# 3) ELIMINAR UN BACKUP EXISTENTE
###################################################
function Eliminar-Backup {

    # Obtiene todos los ZIP del directorio
    $backups = Get-ChildItem $BackupDir -Filter "*.zip"

    # Si no hay ZIP, no hay nada que borrar
    if ($backups.Count -eq 0) {
        Write-Host "No hay backups para eliminar." -ForegroundColor Yellow
        return
    }

    # Muestra un listado numerado de copias
    Write-Host "Copias disponibles:"
    for ($i=0; $i -lt $backups.Count; $i++) {
        Write-Host "$($i+1)) $($backups[$i].Name)"
    }

    # Pide al usuario cuál borrar
    $numInput = (Read-Host "Numero de la copia a eliminar").Trim()
    $num = 0

    # Valida que el usuario introduzca un número
    if (-not [int]::TryParse($numInput, [ref]$num)) {
        Write-Host "Numero no valido." -ForegroundColor Red
        return
    }

    # Comprueba que el número esté dentro del rango
    if ($num -gt 0 -and $num -le $backups.Count) {

        # Elimina el archivo seleccionado
        Remove-Item $backups[$num-1].FullName -Force
        Write-Host "Backup eliminado." -ForegroundColor Green

    }
    else {
        Write-Host "Numero fuera de rango." -ForegroundColor Red
    }
}


###################################################
# 4) RESTAURAR COPIA DE SEGURIDAD (SIN ERRORES)
###################################################
function Restaurar-Backup {

    # Obtiene los archivos ZIP disponibles
    $backups = Get-ChildItem $BackupDir -Filter "*.zip"

    # Si no hay copias, informa
    if ($backups.Count -eq 0) {
        Write-Host "No hay backups para restaurar." -ForegroundColor Yellow
        return
    }

    # Muestra copias disponibles con índice numérico
    Write-Host "Copias disponibles para restaurar:"
    for ($i=0; $i -lt $backups.Count; $i++) {
        Write-Host "$($i+1)) $($backups[$i].Name)"
    }

    # Solicita selección del usuario
    $numInput = (Read-Host "Numero de la copia a restaurar").Trim()
    $num = 0

    # Verifica que es número válido
    if (-not [int]::TryParse($numInput, [ref]$num)) {
        Write-Host "Numero no valido." -ForegroundColor Red
        return
    }

    # Valida rango
    if ($num -gt 0 -and $num -le $backups.Count) {

        # Obtiene la ruta completa del ZIP seleccionado
        $backupSeleccionado = $backups[$num-1].FullName

        # Pide confirmación al usuario antes de sobrescribir archivos
        $conf = Read-Host "Se restauraran los archivos del backup. Sobrescribir si existen? (S/N)"
        if ($conf -ne "S" -and $conf -ne "s") {
            Write-Host "Restauracion cancelada." -ForegroundColor Yellow
            return
        }

        # Descomprime el ZIP en la carpeta del script silenciosamente
        $null = Expand-Archive -Path $backupSeleccionado -DestinationPath $ScriptDir -Force -ErrorAction SilentlyContinue

        # Informa que se restauró correctamente
        Write-Host "Backup restaurado: $backupSeleccionado" -ForegroundColor Green
    }
    else {
        Write-Host "Numero fuera de rango." -ForegroundColor Red
    }
}

