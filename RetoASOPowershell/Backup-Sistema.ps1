# Backup-Sistema.ps1
# Copias de seguridad de servicios y configuracion con restauracion y menu funcional

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$BackupDir = "$ScriptDir\backups"

if (-not (Test-Path $BackupDir)) {
    New-Item -ItemType Directory -Path $BackupDir | Out-Null
}

# Rutas de archivos importantes
$ServiciosCSV = "$ScriptDir\servicios_seguimiento.txt"
$ConfigCSV = "$ScriptDir\Configuracion.csv"

function Menu-Backup {
    do {
        Clear-Host
        Write-Host "==========================================" -ForegroundColor Cyan
        Write-Host "          COPIAS DE SEGURIDAD" -ForegroundColor Green
        Write-Host "==========================================" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "1) Realizar copia de servicios y configuracion"
        Write-Host "2) Ver copias existentes"
        Write-Host "3) Eliminar copia"
        Write-Host "4) Restaurar copia de seguridad"
        Write-Host "5) Volver al menu principal"
        Write-Host ""

        $op = (Read-Host "Selecciona una opcion").Trim()

        switch ($op) {
            "1" { Hacer-Backup }
            "2" { Ver-Backups }
            "3" { Eliminar-Backup }
            "4" { Restaurar-Backup }
            "5" { break }
            default { Write-Host "Opcion no valida" -ForegroundColor Red }
        }

        Write-Host ""
        Read-Host "Pulsa ENTER para continuar..."
    } while ($true)
}

###################################################
# 1) HACER BACKUP DE SERVICIOS
###################################################
function Hacer-Backup {
    if (-not (Test-Path $ServiciosCSV)) {
        Write-Host "Archivo de servicios no encontrado: $ServiciosCSV" -ForegroundColor Red
        return
    }
    if (-not (Test-Path $ConfigCSV)) {
        Write-Host "Archivo de configuracion no encontrado: $ConfigCSV" -ForegroundColor Red
        return
    }

    $fecha = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupNombre = "backup_servicios_$fecha.zip"
    $destino = Join-Path $BackupDir $backupNombre

    Compress-Archive -Path $ServiciosCSV, $ConfigCSV -DestinationPath $destino -Force
    Write-Host "Backup creado: $destino" -ForegroundColor Green
}

###################################################
# 2) VER BACKUPS
###################################################
function Ver-Backups {
    Write-Host "Copias almacenadas:" -ForegroundColor Cyan
    $backups = Get-ChildItem -Path $BackupDir -Filter "*.zip"
    if ($backups.Count -eq 0) {
        Write-Host "No hay backups disponibles." -ForegroundColor Yellow
        return
    }
    foreach ($b in $backups) {
        Write-Host "- $($b.Name)"
    }
}

###################################################
# 3) ELIMINAR BACKUP
###################################################
function Eliminar-Backup {
    $backups = Get-ChildItem $BackupDir -Filter "*.zip"

    if ($backups.Count -eq 0) {
        Write-Host "No hay backups para eliminar." -ForegroundColor Yellow
        return
    }

    Write-Host "Copias disponibles:"
    for ($i=0; $i -lt $backups.Count; $i++) {
        Write-Host "$($i+1)) $($backups[$i].Name)"
    }

    $num = Read-Host "Numero de la copia a eliminar"

    if ($num -gt 0 -and $num -le $backups.Count) {
        Remove-Item $backups[$num-1].FullName -Force
        Write-Host "Backup eliminado." -ForegroundColor Green
    }
    else {
        Write-Host "Numero no valido." -ForegroundColor Red
    }
}

###################################################
# 4) RESTAURAR BACKUP
###################################################
function Restaurar-Backup {
    $backups = Get-ChildItem $BackupDir -Filter "*.zip"

    if ($backups.Count -eq 0) {
        Write-Host "No hay backups para restaurar." -ForegroundColor Yellow
        return
    }

    Write-Host "Copias disponibles para restaurar:"
    for ($i=0; $i -lt $backups.Count; $i++) {
        Write-Host "$($i+1)) $($backups[$i].Name)"
    }

    $num = Read-Host "Numero de la copia a restaurar"

    if ($num -gt 0 -and $num -le $backups.Count) {
        $backupSeleccionado = $backups[$num-1].FullName
        Expand-Archive -Path $backupSeleccionado -DestinationPath $ScriptDir -Force
        Write-Host "Backup restaurado: $backupSeleccionado" -ForegroundColor Green
    }
    else {
        Write-Host "Numero no valido." -ForegroundColor Red
    }
}


