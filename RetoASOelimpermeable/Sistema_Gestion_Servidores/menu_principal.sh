#!/bin/bash
# Menú principal del sistema

source ./funciones_servidor.sh
source ./monitoreo.sh
source ./backup.sh
source ./logs.sh

while true; do
    clear
    echo "====== SISTEMA DE GESTIÓN DE SERVIDORES ======"
    PS3="Elige una opción: "
    select opcion in "Gestión de servidores" "Monitoreo del sistema" "Copias de seguridad" "Gestión de logs" "Configuración" "Salir"; do
        case $opcion in
            "Gestión de servidores") gestion_servidores ;;
            "Monitoreo del sistema") menu_monitoreo ;;
            "Copias de seguridad") menu_backup ;;
            "Gestión de logs") menu_logs ;;
            "Configuración") nano configuracion.conf ;;
            "Salir") echo "Saliendo..."; exit 0 ;;
            *) echo "Opción no válida" ;;
        esac
        break
    done
done
