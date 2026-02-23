# Documentación del Reto ASO: Infraestructura AWS y Servicios de Archivos

Este documento recoge las evidencias de la implementación de la infraestructura desplegada en Amazon Web Services (AWS) y la configuración de los servicios de red (Samba y NFS) solicitados en el reto.

---

## 1. Infraestructura en AWS

### 1.1. Instancias desplegadas
Se han creado las instancias necesarias en EC2 para simular el entorno de servidor y clientes.

> **Captura requerida:** Panel de instancias de AWS mostrando las máquinas en ejecución.

![Instancias creadas en AWS](images/aso_aws_instances.png)
*(Insertar aquí captura de pantalla de las instancias en AWS)*

### 1.2. Configuración de Red y Seguridad
Se han configurado los **Security Groups** para permitir el tráfico necesario en los puertos de los servicios (SSH, SMB para Samba, y los puertos RPC/NFS).

> **Captura requerida:** Reglas de entrada (Inbound rules) de los Security Groups configurados.

![Security Groups configurados](images/aso_aws_sg.png)
*(Insertar aquí captura de pantalla de los Security Groups)*

---

## 2. Estado de los Servicios

### 2.1. Servicio Samba (Docker)
El servicio Samba se encuentra desplegado y en ejecución mediante contenedores.

> **Captura requerida:** Salida del comando `docker compose ps` verificando el estado del contenedor.

!Samba en ejecución
*(Insertar aquí captura del comando `docker compose ps`)*

### 2.2. Servicio NFS
El servidor NFS está activo y exportando los directorios configurados.

> **Captura requerida:** Salida del comando `showmount -e` o `exportfs` mostrando los recursos compartidos.

!NFS exportado

![ServidorNFS](Imagenes/NFS _server_funcionando.png)
---

## 3. Pruebas de Conectividad y Acceso

### 3.1. Acceso desde Cliente Linux
Verificación de acceso y montaje de los recursos compartidos (tanto Samba como NFS) desde la instancia cliente Linux.

> **Captura requerida:** Terminal del cliente Linux mostrando el acceso/montaje a Samba y NFS.

!Acceso desde cliente Linux
*(Insertar aquí captura del acceso desde Linux)*

### 3.2. Acceso desde Cliente Windows
Verificación de acceso al recurso compartido Samba desde la instancia cliente Windows.

> **Captura requerida:** Explorador de archivos o terminal de Windows accediendo al recurso compartido.

!Acceso desde cliente Windows
*(Insertar aquí captura del acceso desde Windows)*

### 3.3. Verificación de Escritura (Archivos de prueba)
Se ha comprobado la capacidad de escritura creando archivos de prueba en los recursos compartidos desde los clientes.

> **Captura requerida:** Listado de archivos mostrando los ficheros de prueba creados en los volúmenes compartidos.

!Archivos de prueba creados
*(Insertar aquí captura de los archivos creados en los recursos compartidos)*
