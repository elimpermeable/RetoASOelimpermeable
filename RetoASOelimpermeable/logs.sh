#!/bin/bash
# Gestión de logs

LOG_ESTADO="estado_servidores.log"
LOG_BACKUP="backup.log"

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

ver_logs() {
    cat $LOG_ESTADO $LOG_BACKUP
}

limpiar_logs() {
    > $LOG_ESTADO
    > $LOG_BACKUP
    echo "Logs limpiados"
}
