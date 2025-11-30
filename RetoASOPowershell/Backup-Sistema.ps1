# Backup-Sistema.ps1
# Módulo básico de backups

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$BackupDir = Join-Path $ScriptDir 'backups'
$ServiciosCsv = Join-Path $ScriptDir 'Servicios-Seguimiento.csv'
$LogFile = Join-Path $ScriptDir 'logs\sistema.log'

function Menu-Backup {
    Clear-Host
    Write-Host "--- BACKUPS ---" -ForegroundColor Cyan
    Write-Host "1) Crear backup (zip) de Servicios-Seguimiento.csv"
    Write-Host "2) Listar backups"
    Write-Host "0) Volver"
    $opc = Read-Host "Seleccione"
    switch ($opc) {
        "1" { Crear-Backup }
        "2" { Get-ChildItem -Path $BackupDir -Filter *.zip | Select Name,LastWriteTime | Format-Table -AutoSize }
        "0" { return }
        default { Write-Host "Opción inválida." -ForegroundColor Red }
    }
}

function Crear-Backup {
    if (-not (Test-Path $ServiciosCsv)) {
        Write-Host "No existe Servicios-Seguimiento.csv. No hay nada que respaldar." -ForegroundColor Yellow
        return
    }
    $ts = Get-Date -Format "yyyyMMdd_HHmmss"
    $dest = Join-Path $BackupDir "backup_$ts.zip"
    try {
        Compress-Archive -Path $ServiciosCsv -DestinationPath $dest -Force
        Write-Host "Backup creado: $dest" -ForegroundColor Green
        Add-Content -Path $LogFile -Value ("$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss'): Backup creado - " + (Split-Path $dest -Leaf))
    } catch {
        Write-Host "Error creando el backup." -ForegroundColor Red
        Add-Content -Path $LogFile -Value ("$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss'): Error backup - $_")
    }
}
