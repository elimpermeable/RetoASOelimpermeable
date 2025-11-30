# Funciones-Servicio.ps1
# Sin tildes y con el menu solicitado

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$SeguimientoFile = "$ScriptDir\servicios_seguimiento.txt"

# Crear archivo si no existe
if (-not (Test-Path $SeguimientoFile)) {
    New-Item -ItemType File -Path $SeguimientoFile | Out-Null
}

function Menu-Servicios {
    Clear-Host
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "    GESTION DE SERVICIOS" -ForegroundColor Green
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1) Listar servicios"
    Write-Host "2) Anadir servicio al seguimiento"
    Write-Host "3) Buscar servicio"
    Write-Host "4) Modificar seguimiento"
    Write-Host "5) Eliminar de seguimiento"
    Write-Host "6) Controlar servicio (Iniciar/Detener)"
    Write-Host "7) Volver al menu principal"
    Write-Host ""

    $op = Read-Host "Selecciona una opcion"

    switch ($op) {
        "1" { Listar-Servicios }
        "2" { Anadir-Seguimiento }
        "3" { Buscar-Servicio }
        "4" { Modificar-Seguimiento }
        "5" { Eliminar-Seguimiento }
        "6" { Controlar-Servicio }
        "7" { return }
        default { Write-Host "Opcion no valida" -ForegroundColor Red }
    }

    Write-Host ""
    Write-Host "Pulsa ENTER para continuar..."
    [void][System.Console]::ReadKey($true)
    Menu-Servicios
}

###############################################################
# 1) LISTAR SERVICIOS DEL SISTEMA
###############################################################

function Listar-Servicios {
    Write-Host "Servicios instalados:" -ForegroundColor Cyan
    Get-Service | Select Name, Status
}

###############################################################
# 2) ANADIR SERVICIO AL SEGUIMIENTO
###############################################################

function Anadir-Seguimiento {
    $serv = Read-Host "Introduce el nombre del servicio"

    if (Get-Service -Name $serv -ErrorAction SilentlyContinue) {
        Add-Content $SeguimientoFile $serv
        Write-Host "Servicio anadido al seguimiento." -ForegroundColor Green
    }
    else {
        Write-Host "El servicio no existe." -ForegroundColor Red
    }
}

###############################################################
# 3) BUSCAR SERVICIO
###############################################################

function Buscar-Servicio {
    $serv = Read-Host "Introduce el nombre del servicio a buscar"

    if (Get-Service -Name $serv -ErrorAction SilentlyContinue) {
        Get-Service -Name $serv | Format-Table Name, Status, DisplayName
    }
    else {
        Write-Host "El servicio no existe." -ForegroundColor Red
    }
}

###############################################################
# 4) MODIFICAR SEGUIMIENTO
###############################################################

function Modificar-Seguimiento {
    $contenido = Get-Content $SeguimientoFile

    if ($contenido.Count -eq 0) {
        Write-Host "No hay servicios en seguimiento." -ForegroundColor Yellow
        return
    }

    Write-Host "Servicios en seguimiento:"
    $i = 1
    foreach ($line in $contenido) {
        Write-Host "$i) $line"
        $i++
    }

    $num = Read-Host "Numero del servicio a modificar"

    if ($num -gt 0 -and $num -le $contenido.Count) {
        $nuevo = Read-Host "Nuevo nombre del servicio"

        $contenido[$num-1] = $nuevo
        $contenido | Set-Content $SeguimientoFile
        Write-Host "Servicio modificado correctamente." -ForegroundColor Green
    }
    else {
        Write-Host "Numero no valido." -ForegroundColor Red
    }
}

###############################################################
# 5) ELIMINAR DE SEGUIMIENTO
###############################################################

function Eliminar-Seguimiento {
    $contenido = Get-Content $SeguimientoFile

    if ($contenido.Count -eq 0) {
        Write-Host "No hay servicios en seguimiento." -ForegroundColor Yellow
        return
    }

    Write-Host "Servicios en seguimiento:"
    $i = 1
    foreach ($line in $contenido) {
        Write-Host "$i) $line"
        $i++
    }

    $num = Read-Host "Numero del servicio a eliminar"

    if ($num -gt 0 -and $num -le $contenido.Count) {
        $nuevoContenido = $contenido | Where-Object { $_ -ne $contenido[$num-1] }
        $nuevoContenido | Set-Content $SeguimientoFile
        Write-Host "Servicio eliminado." -ForegroundColor Green
    }
    else {
        Write-Host "Numero no valido." -ForegroundColor Red
    }
}

###############################################################
# 6) CONTROLAR SERVICIO (INICIAR / DETENER)
###############################################################

function Controlar-Servicio {
    $serv = Read-Host "Introduce el nombre del servicio"

    $obj = Get-Service -Name $serv -ErrorAction SilentlyContinue
    if (-not $obj) {
        Write-Host "El servicio no existe." -ForegroundColor Red
        return
    }

    Write-Host "Estado actual: $($obj.Status)"
    Write-Host "1) Iniciar servicio"
    Write-Host "2) Detener servicio"

    $op = Read-Host "Selecciona una opcion"

    switch ($op) {
        "1" { Start-Service -Name $serv; Write-Host "Servicio iniciado." -ForegroundColor Green }
        "2" { Stop-Service -Name $serv; Write-Host "Servicio detenido." -ForegroundColor Yellow }
        default { Write-Host "Opcion no valida." -ForegroundColor Red }
    }
}
