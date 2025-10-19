#!/bin/bash
# Funciones de gestión de servidores

gestion_servidores() {
    PS3="Elige una opción: "
    select opcion in "Añadir servidor" "Listar servidores" "Buscar servidor" "Modificar servidor" "Eliminar servidor" "Ordenar servidores" "Volver al menú principal"; do
        case $opcion in
            "Añadir servidor") añadir_servidor ;;
            "Listar servidores") listar_servidores ;;
            "Buscar servidor") buscar_servidor ;;
            "Modificar servidor") modificar_servidor ;;
            "Eliminar servidor") eliminar_servidor ;;
            "Ordenar servidores") ordenar_servidores ;;
            "Volver al menú principal") break ;;
            *) echo "Opción no válida" ;;
        esac
    done
}
