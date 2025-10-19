#!/bin/bash
# Copias de seguridad

menu_backup() {
    PS3="Elige una opción: "
    select opcion in "Crear backup" "Restaurar backup" "Volver al menú principal"; do
        case $opcion in
            "Crear backup") crear_backup ;;
            "Restaurar backup") restaurar_backup ;;
            "Volver al menú principal") break ;;
            *) echo "Opción no válida" ;;
        esac
    done
}
