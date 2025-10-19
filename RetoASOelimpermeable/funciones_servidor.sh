#!/bin/bash
# Funciones de gestión de servidores
ARCHIVO_SERVIDORES="servidores.txt"

gestion_servidores() {
    PS3="Elige una opción: "
    select opcion in "Añadir servidor" "Listar servidores" "Buscar servidor" "Modificar servidor" "Eliminar servidor" "Ordenar servidores" "Volver al menú principal"; do
        case $opcion in
            "Añadir servidor") 
                echo -n "Nombre del servidor: "; read nombre
                echo -n "IP: "; read ip
                echo -n "Puerto: "; read puerto
                echo -n "Estado (activo/inactivo): "; read estado
                echo -n "Descripción: "; read descripcion
                echo "$nombre#$ip#$puerto#$estado#$descripcion" >> $ARCHIVO_SERVIDORES
                echo "Servidor añadido!"
                ;; 
            "Listar servidores") cat $ARCHIVO_SERVIDORES ;; 
            "Buscar servidor") 
                echo -n "Introduce nombre, IP o estado: "; read busqueda
                grep -i "$busqueda" $ARCHIVO_SERVIDORES || echo "No encontrado"
                ;; 
            "Modificar servidor")
                echo -n "Introduce nombre del servidor a modificar: "; read nombre_mod
                if grep -q "$nombre_mod" $ARCHIVO_SERVIDORES; then
                    grep -v "$nombre_mod" $ARCHIVO_SERVIDORES > tmp.txt && mv tmp.txt $ARCHIVO_SERVIDORES
                    echo -n "Nuevo nombre: "; read nombre
                    echo -n "IP: "; read ip
                    echo -n "Puerto: "; read puerto
                    echo -n "Estado: "; read estado
                    echo -n "Descripción: "; read descripcion
                    echo "$nombre#$ip#$puerto#$estado#$descripcion" >> $ARCHIVO_SERVIDORES
                else
                    echo "Servidor no encontrado"
                fi
                ;; 
            "Eliminar servidor")
                echo -n "Introduce nombre del servidor a eliminar: "; read nombre_del
                grep -v "$nombre_del" $ARCHIVO_SERVIDORES > tmp.txt && mv tmp.txt $ARCHIVO_SERVIDORES
                echo "Servidor eliminado (si existía)"
                ;; 
            "Ordenar servidores") sort $ARCHIVO_SERVIDORES -o $ARCHIVO_SERVIDORES ;; 
            "Volver al menú principal") break ;; 
            *) echo "Opción no válida" ;; 
        esac
    done
}
