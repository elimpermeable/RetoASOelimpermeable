# 🧠 Sistema de Gestión de Servidores (Bash)

Este proyecto es un conjunto de scripts Bash que permiten **gestionar, monitorear y respaldar servidores** de manera sencilla desde la terminal.  
Está dividido en módulos para mantener el código organizado y facilitar su mantenimiento.

---

## 📁 Estructura del proyecto

```
├── menu_principal.sh        # Script principal (menú del sistema)
├── funciones_servidor.sh    # Gestión de servidores
├── monitoreo.sh             # Monitoreo y estadísticas del sistema
├── backup.sh                # Copias de seguridad
├── logs.sh                  # Gestión de logs
├── servidores.txt           # Lista de servidores registrados
└── configuracion.conf       # Archivo de configuración (opcional)
```

---

## 🚀 Uso general

1. Asegúrate de dar permisos de ejecución a los scripts:
   ```bash
   chmod +x *.sh
   ```

2. Ejecuta el menú principal:
   ```bash
   ./menu_principal.sh
   ```

3. Desde el menú podrás:
   - Gestionar servidores (añadir, listar, buscar, modificar, eliminar)
   - Monitorear el estado de los servidores
   - Crear o restaurar copias de seguridad
   - Ver o limpiar logs
   - Editar la configuración del sistema

---

## 🧩 Descripción de cada script

### 1. **menu_principal.sh**
Es el **punto de entrada principal** del sistema.  
Muestra un menú interactivo con las opciones disponibles e invoca las funciones definidas en los demás módulos.

**Opciones del menú:**
- Gestión de servidores  
- Monitoreo del sistema  
- Copias de seguridad  
- Gestión de logs  
- Configuración (abre `configuracion.conf` con `nano`)  
- Salir del sistema  

---

### 2. **funciones_servidor.sh**
Maneja el archivo `servidores.txt`, donde se guardan todos los servidores registrados.  
Cada línea tiene el formato:

```
nombre#ip#puerto#estado#descripcion
```

**Funciones principales:**
- **Añadir servidor:** Pide los datos y los agrega al archivo.  
- **Listar servidores:** Muestra todos los servidores guardados.  
- **Buscar servidor:** Permite buscar por nombre, IP o estado.  
- **Modificar servidor:** Permite editar los datos de un servidor existente.  
- **Eliminar servidor:** Borra un servidor por nombre.  
- **Ordenar servidores:** Ordena alfabéticamente el archivo.  

---

### 3. **monitoreo.sh**
Permite comprobar el estado de los servidores y obtener estadísticas básicas del sistema.

**Funciones:**
- **Monitorear servidores:**  
  Hace ping a cada IP listada en `servidores.txt` y registra si está “activo” o “inactivo” en `estado_servidores.log`.  
- **Ver estadísticas del sistema:**  
  Muestra el número total de servidores, cuántos están activos/inactivos y el porcentaje de disponibilidad.  

**Ejemplo de uso:**
```bash
Total: 5, Activos: 4, Inactivos: 1
Disponibilidad: 80%
```

---

### 4. **backup.sh**
Se encarga de crear y restaurar **copias de seguridad** del sistema.

**Funciones:**
- **Crear backup:**  
  Comprime el archivo `servidores.txt` y `configuracion.conf` dentro del directorio `backup/` con un nombre que incluye la fecha y hora.  
  También registra la acción en `backup.log`.  
- **Restaurar backup:**  
  Muestra los backups disponibles y permite descomprimir uno para restaurarlo.  

**Ejemplo de archivo generado:**
```
backup/backup_20251020_153045.tar.gz
```

---

### 5. **logs.sh**
Gestiona los registros del sistema.

**Funciones:**
- **Ver logs:**  
  Muestra el contenido combinado de `estado_servidores.log` y `backup.log`.  
- **Limpiar logs:**  
  Borra el contenido de ambos logs (sin eliminarlos).  

---

### 6. **servidores.txt**
Archivo que contiene la lista de servidores gestionados por el sistema.  
Ejemplo de contenido:

```
google_dns#8.8.8.8#53#activo#Servidor DNS de Google
cloudflare_dns#1.1.1.1#53#activo#Servidor DNS Cloudflare
opendns#208.67.222.222#53#activo#Servidor DNS OpenDNS
servidor_web#93.184.216.34#80#activo#Servidor web público
servidor_inactivo#192.168.1.100#80#inactivo#Servidor de prueba
```

---

## 🛠️ Requisitos

- Sistema operativo Linux o macOS.  
- Bash 4.0 o superior.  
- Herramientas estándar de Linux: `tar`, `grep`, `sort`, `ping`, `nano`.

---

## 🧹 Recomendaciones

- Realiza un **backup** antes de modificar el archivo de servidores.  
- Usa nombres descriptivos para identificar fácilmente cada servidor.  
- Limpia los logs periódicamente si el sistema se usa con frecuencia.  

---

## 📜 Licencia
Este proyecto puede usarse y modificarse libremente con fines educativos o administrativos.  
