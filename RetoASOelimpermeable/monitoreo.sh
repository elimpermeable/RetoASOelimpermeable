#!/bin/bash
# Monitoreo de servidores

ARCHIVO_SERVIDORES="servidores.txt"
LOG_ESTADO="estado_servidores.log"

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

monitorear_servidores() {
    echo "Estado de los servidores" > $LOG_ESTADO
    while IFS="#" read -r nombre ip puerto estado descripcion; do
        if ping -c 1 -W 1 $ip &> /dev/null; then
            echo "$nombre#$ip#$puerto#activo#$descripcion" | tee -a $LOG_ESTADO
        else
            echo "$nombre#$ip#$puerto#inactivo#$descripcion" | tee -a $LOG_ESTADO
        fi
    done < $ARCHIVO_SERVIDORES
    echo "Monitoreo completado."
}

estadisticas_sistema() {
    total=$(wc -l < $ARCHIVO_SERVIDORES)
    activos=$(grep -c "#activo#" $LOG_ESTADO)
    inactivos=$(grep -c "#inactivo#" $LOG_ESTADO)
    echo "Total: $total, Activos: $activos, Inactivos: $inactivos"
    if [ $total -gt 0 ]; then
        porcentaje=$((activos*100/total))
        echo "Disponibilidad: $porcentaje%"
    fi
}
