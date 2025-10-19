#!/bin/bash
# Copias de seguridad

BACKUP_DIR="backup"
ARCHIVO_SERVIDORES="servidores.txt"
LOG_BACKUP="backup.log"

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

crear_backup() {
    fecha=$(date +"%Y%m%d_%H%M%S")
    mkdir -p $BACKUP_DIR
    tar -czf $BACKUP_DIR/backup_$fecha.tar.gz $ARCHIVO_SERVIDORES configuracion.conf
    echo "Backup creado en $BACKUP_DIR/backup_$fecha.tar.gz" | tee -a $LOG_BACKUP
}

restaurar_backup() {
    echo "Backups disponibles:"
    ls $BACKUP_DIR/*.tar.gz
    echo -n "Nombre del backup a restaurar: "; read archivo
    if [ -f "$archivo" ]; then
        tar -xzf "$archivo"
        echo "Backup restaurado" | tee -a $LOG_BACKUP
    else
        echo "Archivo no encontrado"
    fi
}
