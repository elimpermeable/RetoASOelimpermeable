#!/bin/bash
# Monitoreo de servidores

menu_monitoreo() {
    PS3="Elige una opción: "
    select opcion in "Monitorear servidores" "Ver estadísticas del sistema" "Volver al menú principal"; do
        case $opcion in
            "Monitorear servidores") monitorear_servidores ;;
            "Ver estadísticas del sistema") estadisticas_sistema ;;
            "Volver al menú principal") break ;;
            *) echo "Opción no válida" ;;
        esac
    done
}
