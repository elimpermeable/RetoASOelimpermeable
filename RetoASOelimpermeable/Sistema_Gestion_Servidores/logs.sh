#!/bin/bash
# Gestión de logs

menu_logs() {
    PS3="Elige una opción: "
    select opcion in "Ver logs" "Limpiar logs" "Volver al menú principal"; do
        case $opcion in
            "Ver logs") ver_logs ;;
            "Limpiar logs") limpiar_logs ;;
            "Volver al menú principal") break ;;
            *) echo "Opción no válida" ;;
        esac
    done
}
