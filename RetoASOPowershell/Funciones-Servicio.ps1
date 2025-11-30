# Funciones-Servicio.ps1
# Módulo simplificado para gestionar servicios y el CSV de seguimiento

# Archivo CSV local
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$ServiciosCsv = Join-Path $ScriptDir 'Servicios-Seguimiento.csv'

# Asegurar que el CSV existe (cabecera mínima)
if (-not (Test-Path $ServiciosCsv)) {
    "Nombre,Estado" | Out-File -FilePath $ServiciosCsv -Encoding UTF8
}

function Menu-Servicios {
    Clear-Host
    Write-Host "--- GESTIÓN DE SERVICIOS ---" -ForegroundColor Cyan
    Write-Host "1) Listar servicios del equipo"
    Write-Host "2) Añadir servicio al seguimiento (CSV)"
    Write-Host "3) Eliminar servicio del seguimiento (CSV)"
    Write-Host "0) Volver"
    $opc = Read-Host "Seleccione"
    switch ($opc) {
        "1" { Get-Service | Select-Object Name,DisplayName,Status | Format-Table -AutoSize }
        "2" { Add-Seguimiento }
        "3" { Remove-Seguimiento }
        "0" { return }
        default { Write-Host "Opción inválida." -ForegroundColor Red }
    }
}

function Add-Seguimiento {
    param()
    $name = Read-Host "Nombre del servicio (ej. Spooler)"
    try {
        $svc = Get-Service -Name $name -ErrorAction Stop
        $obj = [PSCustomObject]@{
            Nombre = $svc.Name
            Estado = $svc.Status
        }
        # Evitar duplicados simples
        $exists = Import-Csv $ServiciosCsv | Where-Object { $_.Nombre -eq $svc.Name }
        if ($exists) {
            Write-Host "El servicio ya está en el seguimiento." -ForegroundColor Yellow
            return
        }
        $obj | Export-Csv -Path $ServiciosCsv -Append -NoTypeInformation -Encoding UTF8
        Write-Host "Servicio agregado al seguimiento." -ForegroundColor Green
    } catch {
        Write-Host "Servicio no encontrado: $name" -ForegroundColor Red
    }
}

function Remove-Seguimiento {
    param()
    $name = Read-Host "Nombre del servicio a eliminar del seguimiento"
    try {
        $lista = Import-Csv $ServiciosCsv
        $nueva = $lista | Where-Object { $_.Nombre -ne $name }
        $nueva | Export-Csv $ServiciosCsv -NoTypeInformation -Encoding UTF8
        Write-Host "Si existía, se ha eliminado del seguimiento." -ForegroundColor Green
    } catch {
        Write-Host "Error al procesar el CSV." -ForegroundColor Red
    }
}
