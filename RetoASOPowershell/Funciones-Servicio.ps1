# Funciones-Servicio.ps1

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
    Write-Host "1) Listar Servicios"
    Write-Host "2) Anadir Servicios de Interes"
    Write-Host "3) Consultar Servicio"
    Write-Host "4) Listar Servicios de Interes"
    Write-Host "5) Eliminar de Servicios de Interes"
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
        Write-Host "Añadido como Servicio de Interes." -ForegroundColor Green
    }
    else {
        Write-Host "El servicio no existe." -ForegroundColor Red
    }
}

###############################################################
# 3) BUSCAR SERVICIO
###############################################################

function Buscar-Servicio {
    $serv = Read-Host "Introduce el nombre del servicio a consultar"

    # Intentar obtener el servicio
    $info = Get-WmiObject Win32_Service -Filter "Name='$serv'" -ErrorAction SilentlyContinue

    if ($info) {
        # Mostrar informacion ampliada
        $resultado = [PSCustomObject]@{
            Nombre       = $info.Name
            DisplayName  = $info.DisplayName
            Estado       = $info.State
            TipoInicio   = $info.StartMode
            Descripcion  = $info.Description
            PID          = $info.ProcessId
        }

        $resultado | Format-Table -AutoSize
    }
    else {
        Write-Host "El servicio no existe." -ForegroundColor Red
    }
}


###############################################################
# 4) LISTAR SERVICIOS DE INTERES
###############################################################

function Modificar-Seguimiento {
    $contenido = Get-Content $SeguimientoFile

    if ($contenido.Count -eq 0) {
        Write-Host "No hay servicios de interes." -ForegroundColor Yellow
        return
    }

    Write-Host "Servicios de Interes:"
    $i = 1
    foreach ($line in $contenido) {
        Write-Host "$i) $line"
        $i++
    }
}

###############################################################
# 5) ELIMINAR DE SEGUIMIENTO
###############################################################

function Eliminar-Seguimiento {
    # FORZAMOS siempre array aunque solo haya una línea
    $contenido = @(Get-Content $SeguimientoFile)

    if ($contenido.Count -eq 0) {
        Write-Host "No hay Servicios de Interes." -ForegroundColor Yellow
        return
    }

    Write-Host "Servicios de Interes:"
    for ($i = 0; $i -lt $contenido.Count; $i++) {
        Write-Host "$($i+1)) $($contenido[$i])"
    }

    $num = Read-Host "Numero del servicio a eliminar"

    if ($num -gt 0 -and $num -le $contenido.Count) {

        # Eliminamos la línea seleccionada
        $contenido = $contenido | Where-Object { $_ -ne $contenido[$num-1] }

        $contenido | Set-Content $SeguimientoFile

        Write-Host "Servicio eliminado correctamente." -ForegroundColor Green
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
