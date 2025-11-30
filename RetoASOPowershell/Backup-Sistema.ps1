# Backup-Sistema.ps1
# Copias de seguridad simples sin tildes

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$BackupDir = "$ScriptDir\backups"

if (-not (Test-Path $BackupDir)) {
    New-Item -ItemType Directory -Path $BackupDir | Out-Null
}

function Menu-Backup {
    Clear-Host
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "          COPIAS DE SEGURIDAD" -ForegroundColor Green
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1) Realizar copia manual"
    Write-Host "2) Ver copias existentes"
    Write-Host "3) Eliminar copia"
    Write-Host "4) Volver al menu principal"
    Write-Host ""

    $op = Read-Host "Selecciona una opcion"

    switch ($op) {
        "1" { Hacer-Backup }
        "2" { Ver-Backups }
        "3" { Eliminar-Backup }
        "4" { return }
        default { Write-Host "Opcion no valida" -ForegroundColor Red }
    }

    Write-Host ""
    Write-Host "Pulsa ENTER para continuar..."
    [void][System.Console]::ReadKey($true)
    Menu-Backup
}

###################################################
# 1) HACER BACKUP
###################################################

function Hacer-Backup {
    $origen = Read-Host "Ruta origen"
    if (-not (Test-Path $origen)) {
        Write-Host "Ruta no valida." -ForegroundColor Red
        return
    }

    $fecha = Get-Date -Format "yyyyMMdd-HHmmss"
    $destino = "$BackupDir\backup-$fecha"

    Copy-Item -Path $origen -Destination $destino -Recurse -Force
    Write-Host "Copia creada en: $destino" -ForegroundColor Green
}

###################################################
# 2) VER BACKUPS
###################################################

function Ver-Backups {
    Write-Host "Copias almacenadas:" -ForegroundColor Cyan
    Get-ChildItem -Path $BackupDir
}

###################################################
# 3) ELIMINAR BACKUP
###################################################

function Eliminar-Backup {
    $backups = Get-ChildItem $BackupDir

    if ($backups.Count -eq 0) {
        Write-Host "No hay copias para eliminar." -ForegroundColor Yellow
        return
    }

    Write-Host "Copias disponibles:"
    $i = 1
    foreach ($b in $backups) {
        Write-Host "$i) $($b.Name)"
        $i++
    }

    $num = Read-Host "Numero de la copia a eliminar"

    if ($num -gt 0 -and $num -le $backups.Count) {
        Remove-Item $backups[$num-1].FullName -Recurse -Force
        Write-Host "Copia eliminada." -ForegroundColor Green
    }
    else {
        Write-Host "Numero no valido." -ForegroundColor Red
    }
}
