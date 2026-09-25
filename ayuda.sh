#!/bin/bash
# Re-ejecutar automáticamente con Bash si el script se llama con 'sh' o 'dash' (común en Debian/Ubuntu)
if [ -z "$BASH_VERSION" ]; then
    exec bash "$0" "$@"
fi

# =============================================================================
#  ayuda.sh - Guía interactiva de comandos de terminal
# =============================================================================
#
#  DESCRIPCIÓN
#  -----------
#  Script interactivo que permite consultar comandos de terminal de forma
#  amigable. Puedes navegar por categorías, buscar por palabra clave, ver
#  el detalle de cada comando y ejecutarlo de forma controlada.
#
#  USO
#  ---
#    ./ayuda.sh                → abre el menú interactivo
#    ./ayuda.sh borrar         → busca directamente "borrar"
#
#  AUTOR
#  -----
#  edelacruzcr (https://github.com/edelacruzcr/Shell-ayuda)
#
#  LICENCIA
#  --------
#  MIT - úsalo, modifícalo y compártelo libremente.
#
# =============================================================================


# =============================================================================
# 1. COLORES Y ESTILOS
# =============================================================================
G=$'\033[1;32m'   # Verde esmeralda → comandos y números
C=$'\033[1;36m'   # Cian brillante  → títulos de sección
B=$'\033[1;34m'   # Azul suave      → recuadros y bordes
M=$'\033[1;35m'   # Magenta         → separadores
D=$'\033[0;90m'   # Gris tenue      → notas y ayudas
Y=$'\033[1;33m'   # Amarillo suave  → ejemplos
R=$'\033[0m'      # Reset           → vuelve al color por defecto


# =============================================================================
# 2. BASE DE DATOS DE COMANDOS
# =============================================================================
# Formato:
#   "comando|descripción corta|ejemplo|explicación larga|categoría"
#
CMDS=(

  # ---------------------------------------------------------------------------
  # CATEGORÍA: archivos
  # ---------------------------------------------------------------------------
  "pwd|muestra en qué carpeta estás|pwd|Imprime la ruta completa de la carpeta en la que estás trabajando.\n\n  • Sintaxis: pwd [opciones]\n  • Argumentos: No requiere argumentos obligatorios.\n  • Opciones y Banderas principales:\n    - -P : Muestra la ruta física real resolviendo enlaces simbólicos.\n    - -L : Muestra la ruta lógica (incluye enlaces simbólicos, opción por defecto).\n  • Qué más puedes hacer: Usar '\$(pwd)' dentro de scripts para guardar la ubicación actual en variables.|archivos"
  "cd <nombre_de_carpeta>|entra a una carpeta|cd Documentos|Cambia tu ubicación actual al directorio especificado.\n\n  • Sintaxis: cd <nombre_de_carpeta>\n  • Argumentos y Atajos:\n    - <nombre_de_carpeta> : Ruta relativa o absoluta a la carpeta destino.\n    - ~ (virgulilla)        : Va directo a tu carpeta personal Home (/home/usuario).\n    - ..                    : Sube un nivel al directorio padre superior.\n    - - (guion)             : Regresa al último directorio previo (\$OLDPWD).\n  • Ejemplos de uso:\n    - cd Documentos/Proyectos  → Entra a carpetas anidadas.\n    - cd /var/log             → Usa ruta absoluta desde la raíz.\n  • Tip: Presiona la tecla Tab para autocompletar el nombre de la carpeta.|archivos"
  "cd ..|sube al directorio padre|cd ..|Navega un nivel hacia arriba en la jerarquía de carpetas.\n\n  • Sintaxis: cd ..\n  • Argumentos y Variaciones:\n    - ..         : Representa el directorio padre un nivel arriba.\n    - cd ../..   : Sube dos niveles de carpetas seguidos.\n    - cd ../../Fotos : Sube dos niveles y entra a la carpeta Fotos.|archivos"
  "cd ~|va a tu carpeta personal|cd ~|Navega directamente a tu directorio personal (Home del usuario).\n\n  • Sintaxis: cd ~ (o simplemente 'cd' sin argumentos)\n  • Argumentos:\n    - ~ : Representa la ruta /home/tu_usuario.\n  • Ejemplos:\n    - cd ~/Descargas  → Va directo a tu carpeta de descargas desde cualquier lugar.|archivos"
  "cd -|vuelve a la carpeta anterior|cd -|Regresa al último directorio en el que estuviste antes del comando cd previo.\n\n  • Sintaxis: cd -\n  • Argumentos:\n    - - : Consulta la variable de entorno \$OLDPWD para cambiar al directorio anterior.|archivos"
  "ls|lista archivos y carpetas|ls|Muestra los nombres de los archivos y carpetas del directorio actual.\n\n  • Sintaxis: ls [opciones] [carpeta]\n  • Desglose completo de Opciones y Banderas:\n    - -l : Lista en formato largo detallado (permisos, propietario, tamaño y fecha).\n    - -a (o --all) : Muestra todos los archivos, incluidos los ocultos (que inician con punto '.').\n    - -A : Muestra archivos ocultos pero omite los enlaces a carpetas '.' y '..'.\n    - -h (o --human-readable) : Muestra tamaños de archivo en formato legible (KB, MB, GB).\n    - -t : Ordena la lista por fecha de modificación (los más recientes primero).\n    - -r (o --reverse) : Invierte el orden de la lista (de Z a A o de más viejo a más nuevo).\n    - -S : Ordena los archivos por peso o tamaño de disco (de mayor a menor).\n    - -R (o --recursive) : Muestra el contenido de la carpeta y de todas sus subcarpetas.\n    - -d : Lista la carpeta misma como elemento sin desplegar su contenido interno.\n    - -1 : Muestra los archivos en una sola columna vertical simple.\n    - -i : Imprime el número de índice interno (inode) de cada archivo.\n    - -X : Ordena la lista alfabéticamente según la extensión (.txt, .png, etc.).\n    - -F : Añade un símbolo al final (/ para carpetas, * para ejecutables).\n    - -u : Ordena la lista según la última fecha de acceso o lectura al archivo.\n    - -g : Muestra el listado largo ocultando el nombre del usuario propietario.|archivos"
  "ls -lah|lista todo con detalles|ls -lah|Muestra una lista detallada con permisos, propietario, tamaño y fecha de modificación.\n\n  • Sintaxis: ls -lah [ruta_opcional]\n  • Desglose de Banderas Combinadas:\n    - -l : Formato de lista detallada (permisos, propietario, bytes, fecha).\n    - -a : Incluye archivos ocultos (los que inician con punto '.').\n    - -h : Muestra tamaños en unidades legibles (KB, MB, GB).\n    - -t : Ordena por fecha de modificación (ls -laht).\n    - -S : Ordena por peso o tamaño (ls -lahS).\n    - -r : Invierte el orden del listado (ls -lahtr).|archivos"
  "mkdir <nombre_de_carpeta>|crea una nueva carpeta|mkdir MisDocumentos|Crea un directorio o carpeta nueva en la ubicación actual.\n\n  • Sintaxis: mkdir [opciones] <nombre_de_carpeta...>\n  • Opciones principales:\n    - -p : Crea la ruta completa de carpetas intermedias si no existen.\n    - -v : Muestra un mensaje informativo en pantalla por cada carpeta creada.\n    - -m <modo> : Asigna permisos octales iniciales (ejemplo: mkdir -m 755 carpeta).\n  • Ejemplos:\n    - mkdir Proyecto1 Proyecto2  → Crea múltiples carpetas al mismo tiempo.\n    - mkdir \"Mi Carpeta\"        → Usa comillas si el nombre contiene espacios.|archivos"
  "mkdir -p <ruta/anidada>|crea carpetas con subcarpetas|mkdir -p proyectos/2026/fotos|Crea la estructura completa de carpetas intermedias sin arrojar error si ya existen.\n\n  • Sintaxis: mkdir -p <ruta/completa/anidada>\n  • Desglose de banderas:\n    - -p : Crea automáticamente todas las carpetas padres que no existan en la ruta.\n    - -v : Muestra en pantalla cada carpeta a medida que se crea.|archivos"
  "rmdir <nombre_de_carpeta>|elimina una carpeta vacía|rmdir CarpetaVacia|Elimina una carpeta únicamente si no contiene ningún archivo o subcarpeta.\n\n  • Sintaxis: rmdir [opciones] <nombre_de_carpeta>\n  • Opciones útiles:\n    - -p : Elimina la carpeta y sus carpetas padres si también quedan vacías.\n  • Nota de seguridad: Si la carpeta tiene contenido, la terminal dará error (evita borrados accidentales). Usa 'rm -r' para carpetas con archivos.|archivos"
  "touch <nombre_de_archivo.txt>|crea un archivo vacío|touch notas.txt|Crea un archivo nuevo vacío o actualiza la fecha de modificación si el archivo ya existe.\n\n  • Sintaxis: touch [opciones] <nombre_de_archivo...>\n  • Opciones principales:\n    - -a : Actualiza únicamente la fecha de acceso del archivo.\n    - -m : Actualiza únicamente la fecha de modificación.\n    - -c : No crea el archivo si este no existe previamente.\n  • Ejemplos:\n    - touch archivo1.txt archivo2.txt  → Crea varios archivos vacíos a la vez.|archivos"
  "cp <origen.txt> <destino.txt>|copia un archivo|cp notas.txt copia_notas.txt|Copia un archivo desde una ruta de origen a una de destino.\n\n  • Sintaxis: cp [opciones] <origen> <destino>\n  • Desglose completo de Opciones y Banderas:\n    - -r (o -R) : Copia una carpeta completa con todo su contenido de forma recursiva.\n    - -i : Pregunta en pantalla antes de reemplazar o sobrescribir un archivo existente.\n    - -f : Fuerza la copia reemplazando el archivo destino sin pedir confirmación.\n    - -n : Evita sobrescribir cualquier archivo que ya exista en el destino.\n    - -u : Copia solo si el archivo de origen es más reciente que el de destino.\n    - -v : Muestra en pantalla el nombre de cada archivo que se va copiando.\n    - -p : Conserva la fecha de modificación, permisos y propietario originales del archivo.\n    - -a : Copia conservando todo (permisos, fechas, enlaces simbólicos y estructura).\n    - -l : Crea enlaces duros en lugar de copiar los datos del archivo.\n    - -s : Crea accesos directos (enlaces simbólicos) en lugar de copiar los datos.\n    - -b : Crea una copia de respaldo automática de los archivos que se sobrescriban.\n    - -L : Sigue los enlaces simbólicos copiando el archivo real al que apuntan.|archivos"
  "cp -r <carpeta_origen> <destino>|copia una carpeta completa|cp -r Fotos/ CopiaFotos/|Copia un directorio completo con todos sus archivos y subcarpetas anidadas.\n\n  • Sintaxis: cp -r [opciones] <carpeta_origen> <carpeta_destino>\n  • Desglose de Opciones:\n    - -r : Obligatorio para procesar todo el contenido interno de la carpeta.\n    - -a : Copia recursiva conservando permisos, enlaces simbólicos y propietarios.\n    - -v : Muestra detalladamente los archivos que se van copiando.|archivos"
  "mv <origen> <destino>|mueve o renombra|mv viejo.txt nuevo.txt|Mueve archivos/carpetas a otra ubicación o los renombra si están en la misma ruta.\n\n  • Sintaxis: mv [opciones] <origen> <destino>\n  • Desglose completo de Opciones y Banderas:\n    - -i : Pregunta en pantalla antes de reemplazar un archivo existente en el destino.\n    - -f : Fuerza el movimiento o renombrado sin solicitar confirmación.\n    - -n : Evita sobrescribir cualquier archivo que ya exista en la carpeta destino.\n    - -u : Mueve el archivo solo si el origen es más reciente que el destino.\n    - -v : Muestra en pantalla la acción realizada y el nombre del archivo movido.\n    - -b : Crea una copia de seguridad automática del archivo que sea reemplazado.\n    - -t <carpeta> : Mueve todos los archivos indicados hacia la carpeta especificada.|archivos"
  "rm <nombre_de_archivo.txt>|elimina un archivo|rm archivo_viejo.txt|Elimina un archivo de manera permanente del sistema de archivos.\n\n  • Sintaxis: rm [opciones] <archivo_o_carpeta>\n  • Desglose completo de Opciones y Banderas:\n    - -r (o -R) : Elimina una carpeta completa con todos sus archivos y subcarpetas.\n    - -f : Fuerza la eliminación inmediata sin pedir confirmación e ignorando advertencias.\n    - -i : Pregunta confirmación en pantalla antes de borrar cada archivo.\n    - -I : Pregunta confirmación una sola vez antes de borrar más de 3 archivos o carpetas.\n    - -v : Muestra en pantalla el nombre de cada archivo que se va eliminando.\n    - -d : Elimina directorios o carpetas que estén completamente vacías.\n    - --no-preserve-root : Permite procesar la raíz '/' (¡EXTREMADAMENTE PELIGROSO!).\n    - --preserve-root : Protege la raíz del sistema '/' para evitar borrados accidentales.|archivos"
  "rm -r <nombre_de_carpeta>|elimina carpeta y contenido|rm -r CarpetaObsoleta|Elimina de forma recursiva una carpeta junto con todos sus archivos y subcarpetas internas.\n\n  • Sintaxis: rm -r [opciones] <nombre_de_carpeta>\n  • Desglose de Opciones:\n    - -r : Elimina el directorio y todo su contenido anidado.\n    - -f : Fuerza la eliminación ignorando advertencias.\n    - -i : Pide confirmación previa antes de borrar.|archivos"
  "rm -i <nombre_de_archivo.txt>|elimina pidiendo confirmación|rm -i documento.pdf|Pide confirmación previa ('y' o 'n') en pantalla antes de borrar cada archivo.\n\n  • Sintaxis: rm -i <nombre_de_archivo>\n  • Opciones:\n    - -i : Solicita autorización explícita antes de eliminar cada elemento.|archivos"
  "ln -s <ruta_real> <enlace>|crea un acceso directo|ln -s /var/www/html mi_web|Crea un enlace simbólico (acceso directo) hacia un archivo o carpeta en el sistema.\n\n  • Sintaxis: ln -s [opciones] <objetivo_original> <nombre_del_acceso_directo>\n  • Opciones principales:\n    - -s : Crea un enlace simbólico (acceso directo) en lugar de un enlace físico.\n    - -f : Sobrescribe cualquier acceso directo preexistente con el mismo nombre.\n    - -v : Muestra en pantalla la confirmación de la creación del enlace.|archivos"
  "tar -czvf <archivo.tar.gz> <carpeta>|comprime carpeta en tar.gz|tar -czvf respaldo.tar.gz MisDocumentos/|Comprime y empaqueta una carpeta completa en un archivo comprimido .tar.gz.\n\n  • Sintaxis: tar [opciones] <archivo.tar.gz> [archivos_o_carpetas]\n  • Desglose completo de Opciones y Banderas:\n    - -c : Crea un nuevo archivo comprimido o paquete.\n    - -x : Extrae o descomprime el contenido de un paquete.\n    - -t : Muestra la lista de archivos dentro del paquete sin extraer nada.\n    - -v : Muestra en pantalla la lista de archivos procesados mientras trabaja.\n    - -f : Indica el nombre del archivo comprimido sobre el que se va a trabajar.\n    - -z : Usa compresión Gzip (para archivos que terminan en .tar.gz o .tgz).\n    - -j : Usa compresión Bzip2 (para archivos que terminan en .tar.bz2).\n    - -J : Usa compresión XZ de máxima reducción (para archivos .tar.xz).\n    - -C <carpeta> : Cambia a la carpeta indicada antes de extraer los archivos.\n    - -u : Agrega al paquete solo los archivos que sean más nuevos que los guardados.\n    - -r : Añade archivos nuevos al final de un paquete .tar ya existente.\n    - -p : Conserva los permisos originales de cada archivo al descomprimir.\n    - -k : Evita sobrescribir archivos que ya existan en la carpeta al extraer.|archivos"
  "tar -xzvf <archivo.tar.gz>|descomprime archivo tar.gz|tar -xzvf respaldo.tar.gz|Descomprime y extrae todo el contenido de un paquete comprimido .tar.gz.\n\n  • Sintaxis: tar -xzvf <archivo.tar.gz> [-C ruta_destino]\n  • Desglose de Banderas:\n    - -x : Extrae el contenido del paquete.\n    - -z : Descomprime mediante el algoritmo Gzip.\n    - -v : Muestra los archivos extraídos en pantalla.\n    - -f : Especifica el nombre del archivo comprimido a procesar.\n    - -C <ruta> : Extrae el contenido en un directorio destino específico.|archivos"
  "zip -r <archivo.zip> <carpeta>|crea archivo comprimido zip|zip -r mis_fotos.zip Fotos/|Crea un paquete comprimido en formato estándar .zip compatible con Windows y macOS.\n\n  • Sintaxis: zip -r [opciones] <nombre_final.zip> <carpeta_o_archivos>\n  • Opciones principales:\n    - -r : Incluye subcarpetas y archivos internos de forma recursiva.\n    - -e : Cifra y protege el archivo ZIP generado solicitando una contraseña.\n    - -q : Ejecuta la compresión de forma silenciosa.|archivos"
  "unzip <archivo.zip>|extrae un archivo zip|unzip mis_fotos.zip|Extrae el contenido completo de un archivo comprimido .zip en la carpeta actual.\n\n  • Sintaxis: unzip [opciones] <archivo.zip>\n  • Opciones principales:\n    - -l : Lista el contenido del paquete ZIP sin realizar la extracción.\n    - -d <ruta> : Especifica la carpeta destino donde se extraerán los archivos.\n    - -q : Extrae de forma silenciosa sin mostrar el listado.|archivos"
  "chown <usuario>:<grupo> <archivo>|cambia propietario y grupo|chown juan:desarrollo notas.txt|Modifica el usuario dueño y el grupo asignado a un archivo o carpeta en el sistema.\n\n  • Sintaxis: chown [opciones] <usuario>:<grupo> <archivo_o_carpeta>\n  • Desglose completo de Opciones y Banderas:\n    - -R : Aplica los cambios de propietario recursivamente a todo el contenido interno.\n    - -v : Muestra un informe detallado en pantalla por cada archivo procesado.\n    - -c : Informa únicamente cuando se produce una modificación efectiva en la propiedad.\n    - -f : Silencia la mayoría de los mensajes de error sobre archivos no modificados.\n    - --reference=<ref> : Aplica el mismo propietario y grupo de un archivo de referencia.|archivos"

  # ---------------------------------------------------------------------------
  # CATEGORÍA: ver
  # ---------------------------------------------------------------------------
  "cat <nombre_de_archivo.txt>|muestra todo el contenido|cat notas.txt|Imprime el contenido completo de uno o varios archivos en la terminal.\n\n  • Sintaxis: cat [opciones] <archivo...>\n  • Desglose de Opciones y Banderas:\n    - -n : Numera todas las líneas comenzando desde la 1.\n    - -b : Numera solo las líneas que tienen contenido (ignora líneas en blanco).\n    - -s : Reduce múltiples líneas en blanco consecutivas a una sola.\n    - -E : Muestra el símbolo '$' al final de cada línea para ver dónde terminan.\n    - -T : Muestra las tabulaciones como '^I' para identificarlas fácilmente.\n    - -A : Muestra todos los caracteres ocultos (tabulaciones, finales de línea y no imprimibles).\n    - -v : Muestra caracteres especiales no imprimibles.\n    - -e : Muestra caracteres ocultos y añade '$' al final de cada línea.\n    - -t : Muestra caracteres ocultos y resalta las tabulaciones como '^I'.\n    - cat a.txt b.txt > unificado.txt : Une dos o más archivos en uno nuevo.\n    - cat archivo.txt >> existente.txt : Agrega el contenido al final de un archivo ya existente.\n    - cat > nuevo.txt : Permite escribir texto directamente en consola y guardarlo (Ctrl+D para terminar).|ver"
  "less <nombre_de_archivo.txt>|visualiza por páginas navegables|less log_sistema.txt|Abre un visor interactivo amigable para leer archivos grandes página por página.\n\n  • Sintaxis: less [opciones] <nombre_de_archivo>\n  • Desglose de Opciones y Teclas de Navegación:\n    - -N : Muestra el número de línea al lado izquierdo del texto.\n    - -S : Muestra líneas largas en una sola fila continua sin envolverlas.\n    - -i : Ignora si las letras son mayúsculas o minúsculas al hacer búsquedas.\n    - -X : Mantiene el contenido visible en la pantalla tras salir del visor.\n    - /texto : Busca una palabra hacia adelante dentro del archivo.\n    - ?texto : Busca una palabra hacia atrás dentro del archivo.\n    - n : Salta a la siguiente coincidencia encontrada.\n    - N : Vuelve a la coincidencia anterior.\n    - g : Salta inmediatamente al inicio (primera línea) del archivo.\n    - G : Salta inmediatamente al final (última línea) del archivo.\n    - d (o Ctrl+D) : Avanza media página hacia abajo.\n    - u (o Ctrl+U) : Retrocede media página hacia arriba.\n    - F : Monitorea en tiempo real las nuevas líneas que se agregan al archivo.\n    - q : Sale del visor less inmediatamente.|ver"
  "more <nombre_de_archivo.txt>|visor página por página clásico|more documento.txt|Visualizador clásico de texto por páginas.\n\n  • Sintaxis: more <nombre_de_archivo.txt>\n  • Controles:\n    - Barra espaciadora : Avanza una página completa.\n    - Enter             : Avanza línea por línea.\n    - q                 : Sale del visor inmediatamente.|ver"
  "head <nombre_de_archivo.txt>|muestra primeras 10 líneas|head lista_contactos.txt|Muestra únicamente las primeras 10 líneas iniciales de un archivo de texto.\n\n  • Sintaxis: head [opciones] <nombre_de_archivo>\n  • Desglose de Opciones y Ejemplos:\n    - -n <N> : Muestra las primeras N líneas del archivo (ejemplo: head -n 20 archivo.txt).\n    - -c <N> : Muestra los primeros N bytes o caracteres del archivo.\n    - -q : Oculta el encabezado con el nombre del archivo si lees varios a la vez.\n    - -v : Muestra siempre el nombre del archivo arriba del contenido.\n    - -z : Separa las líneas con carácter nulo en lugar de salto de línea.\n    - head -n -5 archivo.txt : Muestra todo el archivo excepto las últimas 5 líneas.\n    - head -c 1K archivo.txt : Muestra únicamente el primer Kilobyte (1 KB) de datos.\n    - head -c 1M archivo.txt : Muestra únicamente el primer Megabyte (1 MB) de datos.\n    - head -n 1 archivo.txt : Muestra únicamente la primera línea (cabecera).|ver"
  "head -n <numero> <archivo.txt>|muestra las N líneas iniciales|head -n 25 servidor.log|Imprime la cantidad exacta de líneas iniciales que le indiques.\n\n  • Sintaxis: head -n <numero_de_lineas> <nombre_de_archivo.txt>\n  • Ejemplo:\n    - head -n 5 datos.txt  → Imprime solo las primeras 5 líneas.|ver"
  "tail <nombre_de_archivo.txt>|muestra últimas 10 líneas|tail historial.log|Muestra únicamente las últimas 10 líneas finales de un archivo.\n\n  • Sintaxis: tail [opciones] <nombre_de_archivo>\n  • Desglose de Opciones y Ejemplos:\n    - -n <N> : Muestra las últimas N líneas del archivo (ejemplo: tail -n 50 archivo.log).\n    - -c <N> : Muestra los últimos N bytes del archivo.\n    - -f : Monitorea el archivo en tiempo real mostrando cada nueva línea que se agregue.\n    - -F : Sigue monitoreando en tiempo real aunque el archivo cambie o se reinicie.\n    - -q : Oculta el encabezado con el nombre del archivo cuando lees múltiples archivos.\n    - -v : Muestra siempre la cabecera con el nombre del archivo.\n    - -s <seg> : Ajusta el tiempo de espera en segundos entre revisiones de nuevas líneas.\n    - tail -n +10 archivo.txt : Muestra todo el archivo empezando desde la línea 10.\n    - tail -f -n 20 log.txt : Muestra las últimas 20 líneas y se queda monitoreando en vivo.\n    - Ctrl+C : Detiene y cierra el monitoreo en tiempo real.|ver"
  "tail -n <numero> <archivo.txt>|muestra las N líneas finales|tail -n 50 errores.log|Imprime la cantidad especificada de líneas finales de un archivo.\n\n  • Sintaxis: tail -n <numero_de_lineas> <nombre_de_archivo.txt>\n  • Ejemplo:\n    - tail -n 100 app.log  → Imprime las últimas 100 líneas del registro.|ver"
  "tail -f <nombre_de_archivo.log>|monitorea cambios en tiempo real|tail -f /var/log/syslog|Mantiene el archivo abierto y muestra en vivo cada nueva línea agregada.\n\n  • Sintaxis: tail -f <nombre_de_archivo.log>\n  • Qué más puedes hacer:\n    - Para detener el seguimiento en vivo pulsa la combinación de teclas Ctrl+C.\n    - tail -f -n 20 app.log  → Muestra las últimas 20 líneas y se queda monitoreando en tiempo real.|ver"
  "wc -l <nombre_de_archivo.txt>|cuenta total de líneas|wc -l lista_usuarios.txt|Cuenta la cantidad exactas de líneas de texto presentes en un archivo.\n\n  • Sintaxis: wc [opciones] <nombre_de_archivo...>\n  • Desglose de Opciones principales:\n    - -l : Cuenta e imprime el número total de líneas de texto.\n    - -w : Cuenta e imprime el número total de palabras.\n    - -c : Cuenta e imprime la cantidad total de bytes o peso del archivo.\n    - -m : Cuenta e imprime la cantidad total de caracteres en el texto.\n    - -L : Muestra cuántos caracteres tiene la línea más larga del archivo.\n    - wc -l archivo.txt : Muestra solo el conteo de líneas.\n    - ls | wc -l : Cuenta cuántos archivos o carpetas hay en la carpeta actual.|ver"
  "wc -w <nombre_de_archivo.txt>|cuenta total de palabras|wc -w ensayo.txt|Cuenta el número de palabras contenidas en el archivo.\n\n  • Sintaxis: wc -w <nombre_de_archivo.txt>\n  • Opciones adicionales de wc:\n    - wc -c archivo.txt  → Cuenta la cantidad de bytes/caracteres.|ver"
  "nl <nombre_de_archivo.txt>|imprime texto con líneas numeradas|nl script.sh|Imprime el contenido de un archivo anteponiendo el número de línea correspondiente.\n\n  • Sintaxis: nl <nombre_de_archivo.txt>\n  • Qué más puedes hacer: Facilita encontrar líneas específicas en archivos de código fuente o configuración.|ver"
  "column -t <archivo.txt>|alinea datos en columnas limpias|column -t datos.csv|Analiza el texto y alinea dinámicamente las palabras en columnas ordenadas.\n\n  • Sintaxis: column -t <nombre_de_archivo.txt>\n  • Qué más puedes hacer:\n    - column -t -s',' archivo.csv  → Especifica la coma (,) como separador de columnas.|ver"
  "xxd <nombre_de_archivo>|ver contenido en código hexadecimal|xxd imagen.png|Muestra una volcado hexadecimal y su representación ASCII equivalente lado a lado.\n\n  • Sintaxis: xxd <nombre_de_archivo>\n  • Qué más puedes hacer:\n    - xxd -l 64 archivo.bin  → Muestra únicamente los primeros 64 bytes en hexadecimal.|ver"
  "hexdump -C <nombre_de_archivo>|inspecciona bytes en formato hex|hexdump -C datos.raw|Inspecciona el contenido interno byte a byte de archivos binarios o ejecutables.\n\n  • Sintaxis: hexdump -C <nombre_de_archivo>\n  • Opción -C: Muestra el volcado canónico en formato hexadecimal y texto ASCII.|ver"
  "view <nombre_de_archivo.txt>|abre en Vim en modo solo lectura|view archivo_protegido.conf|Abre un archivo con el editor Vim bloqueando cambios accidentales.\n\n  • Sintaxis: view <nombre_de_archivo.txt>\n  • Ventaja: Permite usar la potencia de búsqueda y navegación de Vim sin riesgo de modificar el archivo.|ver"

  # ---------------------------------------------------------------------------
  # CATEGORÍA: buscar
  # ---------------------------------------------------------------------------
  "grep <texto_a_buscar> <archivo.txt>|busca una palabra en un archivo|grep error log.txt|Busca e imprime todas las líneas que contengan la palabra o texto especificado.\n\n  • Sintaxis: grep [opciones] \"<texto_a_buscar>\" <archivo_o_carpeta>\n  • Desglose completo de Opciones y Banderas:\n    - -i : Ignora si las letras son mayúsculas o minúsculas al buscar la palabra.\n    - -r (o -R) : Busca la palabra en todos los archivos de la carpeta y sus subcarpetas.\n    - -n : Muestra el número de línea exacto donde se encontró la coincidencia.\n    - -v : Invierte la búsqueda: muestra únicamente las líneas que NO contienen la palabra.\n    - -c : Cuenta la cantidad total de líneas donde aparece la palabra (solo muestra el número).\n    - -w : Busca únicamente la palabra completa (evita encontrarla como parte de otra palabra).\n    - -E : Permite usar expresiones regulares avanzadas para patrones complejos.\n    - -P : Permite usar expresiones regulares de estilo Perl.\n    - -l : Muestra únicamente los nombres de los archivos donde se encontró la palabra.\n    - -L : Muestra los nombres de los archivos donde NO se encontró la palabra.\n    - -o : Muestra únicamente el pedazo de texto que coincidió, no la línea entera.\n    - -A <N> : Muestra N líneas de texto que están DESPUÉS de la línea encontrada.\n    - -B <N> : Muestra N líneas de texto que están ANTES de la línea encontrada.\n    - -C <N> : Muestra N líneas de texto ANTES y DESPUÉS de la línea encontrada.\n    - -h : Oculta el nombre del archivo al mostrar los resultados en pantalla.\n    - -H : Fuerza a mostrar el nombre del archivo antes de cada resultado.\n    - -m <N> : Detiene la búsqueda en el archivo después de encontrar N coincidencias.\n    - --exclude=\"*.log\" : Excluye de la búsqueda los archivos que coincidan con ese formato.|buscar"
  "grep -i <texto> <archivo.txt>|busca ignorando mayúsculas|grep -i error log.txt|Busca coincidencias sin hacer distinción entre mayúsculas y minúsculas.\n\n  • Sintaxis: grep -i \"<texto_a_buscar>\" <nombre_de_archivo.txt>\n  • Banderas utilizadas:\n    - -i : Encuentra 'ERROR', 'Error', 'error' o 'eRrOr' indistintamente.|buscar"
  "grep -r <texto> <carpeta>|busca en todos los archivos del dir|grep -r TODO ./src|Busca la palabra indicada en todos los archivos de la carpeta y sus subcarpetas.\n\n  • Sintaxis: grep -r [opciones] \"<texto_a_buscar>\" <directorio>\n  • Banderas combinadas útiles:\n    - -r : Escanea todos los archivos de carpetas y subcarpetas.\n    - -rn : Busca de forma recursiva e imprime el número de línea de cada hallazgo.|buscar"
  "grep -n <texto> <archivo.txt>|muestra el número de línea|grep -n ERROR log.txt|Antepone el número de línea exacto a cada coincidencia encontrada.\n\n  • Sintaxis: grep -n \"<texto_a_buscar>\" <nombre_de_archivo.txt>\n  • Banderas utilizadas:\n    - -n : Antepone el número de línea a las salidas impresas.|buscar"
  "grep -v <texto> <archivo.txt>|filtra e imprime lo que NO coincide|grep -v INFO sistema.log|Muestra únicamente las líneas que NO contengan la palabra especificada.\n\n  • Sintaxis: grep -v \"<texto_a_excluir>\" <nombre_de_archivo.txt>\n  • Banderas utilizadas:\n    - -v : Filtra y excluye las coincidencias del patrón.|buscar"
  "grep -c <texto> <archivo.txt>|cuenta cuántas líneas coinciden|grep -c WARNING app.log|Muestra el conteo numérico total de líneas que coinciden sin imprimir el texto.\n\n  • Sintaxis: grep -c \"<texto_a_buscar>\" <nombre_de_archivo.txt>\n  • Banderas utilizadas:\n    - -c : Muestra el total de coincidencias numéricas.|buscar"
  "grep -w <palabra> <archivo.txt>|busca únicamente la palabra exacta|grep -w \"fin\" notas.txt|Evita coincidencias parciales (ej: 'fin' no coincidirá con 'final' ni 'definir').\n\n  • Sintaxis: grep -w \"<palabra_exacta>\" <nombre_de_archivo.txt>\n  • Banderas utilizadas:\n    - -w : Fuerza la coincidencia solo con palabras aisladas completas.|buscar"
  "grep -E '<regex>' <archivo.txt>|busca usando expresiones regulares|grep -E '[0-9]{3}' datos.txt|Permite utilizar expresiones regulares avanzadas POSIX ERE (patrones complejos).\n\n  • Sintaxis: grep -E \"<patron_expresion_regular>\" <nombre_de_archivo.txt>\n  • Banderas utilizadas:\n    - -E : Permite operadores como '|', '+', '?', etc. (ej: \"error|warning\").|buscar"
  "find <dir> -name <patron>|busca archivos por nombre|find . -name \"*.txt\"|Realiza una búsqueda profunda en el sistema de archivos según el nombre especificado.\n\n  • Sintaxis: find <carpeta_inicio> [criterios_de_búsqueda] [acciones]\n  • Desglose completo de Opciones y Criterios de Búsqueda:\n    - -name \"<patron>\" : Busca archivos por nombre exacto (distingue mayúsculas y minúsculas). Ejemplo: -name \"*.txt\".\n    - -iname \"<patron>\" : Busca por nombre SIN distinguir entre letras mayúsculas y minúsculas.\n    - -type f : Filtra para encontrar únicamente archivos regulares (omite carpetas).\n    - -type d : Filtra para encontrar únicamente carpetas o directorios.\n    - -type l : Filtra para encontrar únicamente accesos directos (enlaces simbólicos).\n    - -type b / c / s : Filtra por dispositivos de bloques (b), caracteres (c) o sockets (s).\n    - -size +50M : Encuentra archivos que pesen MÁS de 50 MegaBytes (+50M, -10k, +1G).\n    - -size -10k : Encuentra archivos que pesen MENOS de 10 KiloBytes.\n    - -mtime -7 : Encuentra archivos modificados en los ÚLTIMOS 7 días.\n    - -mtime +30 : Encuentra archivos modificados HACE MÁS de 30 días.\n    - -atime -1 : Encuentra archivos leídos o accedidos en las últimas 24 horas.\n    - -ctime -7 : Encuentra archivos cuyos permisos o estado cambiaron en los últimos 7 días.\n    - -mmin -60 : Encuentra archivos cuya última modificación fue en los últimos 60 minutos.\n    - -amin -30 : Encuentra archivos leídos en los últimos 30 minutos.\n    - -maxdepth N : Limita la búsqueda a un máximo de N niveles de subcarpetas hacia abajo.\n    - -mindepth N : Salta los primeros N niveles de carpetas y busca solo desde esa profundidad.\n    - -user <usuario> : Busca únicamente archivos que pertenezcan a ese usuario del sistema.\n    - -group <grupo> : Busca únicamente archivos que pertenezcan a ese grupo de usuarios.\n    - -perm 644 : Encuentra archivos que tengan exactamente el código de permisos 644.\n    - -empty : Encuentra archivos o carpetas que estén completamente vacíos (0 bytes).\n    - -delete : Elimina directamente en el acto todos los archivos encontrados (usar con cuidado).\n    - -exec <comando> {} \\; : Ejecuta un comando por cada archivo encontrado (donde {} representa la ruta).\n    - -prune : Evita entrar o buscar dentro de una carpeta específica (ejemplo: ignorar .git o node_modules).\n  • Ejemplos combinados:\n    - find . -type f -name \"*.log\"  → Busca solo archivos que terminen en .log.\n    - find /var/log -type f -size +100M → Busca archivos mayores a 100MB.|buscar"
  "find <dir> -type f|busca únicamente archivos|find ./documentos -type f|Filtra la búsqueda para devolver exclusivamente archivos, ignorando carpetas.\n\n  • Sintaxis: find <directorio_inicio> -type f [opciones_adicionales]\n  • Desglose de Opciones de tipo:\n    - -type f : Filtra únicamente archivos regulares.\n    - -type d : Filtra únicamente carpetas/directorios.|buscar"
  "find <dir> -type d|busca únicamente carpetas|find . -type d|Filtra la búsqueda para mostrar exclusivamente carpetas o directorios.\n\n  • Sintaxis: find <directorio_inicio> -type d [opciones_adicionales]\n  • Desglose de Opciones de tipo:\n    - -type d : Filtra exclusivamente carpetas o directorios.|buscar"
  "find <dir> -size +<peso>|busca archivos por peso/tamaño|find . -size +50M|Busca elementos filtrados por su peso en disco (ej: mayores a 50 MegaBytes).\n\n  • Sintaxis: find <directorio_inicio> -size [+|-]<tamaño>[k|M|G]\n  • Desglose de Unidades de tamaño:\n    - k : KiloBytes.\n    - M : MegaBytes.\n    - G : GigaBytes.\n    - +50M : Archivos strictly mayores a 50MB.\n    - -10k : Archivos estrictamente menores a 10KB.|buscar"
  "find <dir> -mtime -<dias>|busca modificados recientemente|find . -mtime -7|Encuentra archivos modificados en los últimos N días especificados.\n\n  • Sintaxis: find <directorio_inicio> -mtime [+|-]<numero_de_dias>\n  • Desglose de Banderas de tiempo:\n    - -mtime -1 : Modificados en las últimas 24 horas.\n    - -mtime -7 : Modificados en los últimos 7 días.\n    - -mtime +30 : Modificados hace más de 30 días.|buscar"
  "find <dir> -empty|busca archivos o carpetas vacías|find . -empty|Ubica de inmediato todos los archivos o carpetas que tienen 0 bytes de contenido.\n\n  • Sintaxis: find <directorio_inicio> -empty [opciones]\n  • Banderas y Combinaciones:\n    - -empty : Detecta 0 bytes de contenido.\n    - find . -type f -empty -delete : Encuentra y borra automáticamente archivos vacíos.|buscar"
  "which <comando>|muestra la ruta del ejecutable|which python3|Localiza e imprime la ruta absoluta del binario ejecutable que usa el sistema.\n\n  • Sintaxis: which [opciones] <nombre_de_comando>\n  • Opciones útiles:\n    - -a : Muestra todas las rutas donde se encuentre el ejecutable en el \$PATH.|buscar"
  "whereis <comando>|ubica ejecutable, código y manual|whereis bash|Muestra la ubicación del binario, las fuentes y las páginas de manual de un programa.\n\n  • Sintaxis: whereis [opciones] <nombre_de_comando>\n  • Opciones principales:\n    - -b : Busca solo binarios ejecutables.\n    - -m : Busca solo páginas de manual.|buscar"
  "locate <archivo>|búsqueda rápida en el índice|locate nginx.conf|Realiza una búsqueda ultra rápida consultando la base de datos de archivos indexados.\n\n  • Sintaxis: locate [opciones] <nombre_de_archivo>\n  • Opciones principales:\n    - -i : Búsqueda insensible a mayúsculas/minúsculas.\n    - -c : Muestra solo la cantidad numérica de coincidencias.\n  • Tip: Ejecuta 'sudo updatedb' para recargar el índice si creaste un archivo hace poco.|buscar"
  "fd <nombre>|alternativa rápida a find|fd notas|Busca archivos de forma interactiva, coloreada y mucho más rápida que el comando find tradicional.\n\n  • Sintaxis: fd [opciones] <nombre_o_patron>\n  • Opciones principales:\n    - -e <ext> : Filtra por extensión de archivo (ej: fd -e pdf).\n    - -H       : Incluye archivos ocultos en la búsqueda.|buscar"

  # ---------------------------------------------------------------------------
  # CATEGORÍA: texto
  # ---------------------------------------------------------------------------
  "echo <mensaje>|imprime un texto en la consola|echo \"Hola Mundo\"|Muestra una cadena de texto o el contenido de variables en la salida estándar de la terminal.\n\n  • Sintaxis: echo \"<mensaje_a_imprimir>\"\n  • Opciones útiles:\n    - echo -e \"Línea 1\\nLínea 2\"  → Habilita la interpretación de saltos de línea (\\n) y tabulaciones (\\t).|texto"
  "echo \$<VARIABLE>|muestra el valor de una variable|echo \$HOME|Muestra el contenido de variables de entorno o del sistema.\n\n  • Sintaxis: echo \$<NOMBRE_DE_VARIABLE>\n  • Ejemplos útiles:\n    - echo \$USER  → Muestra el nombre de tu usuario actual.\n    - echo \$PATH  → Muestra las rutas de ejecución de comandos.|texto"
  "echo <texto> > <archivo.txt>|guarda texto sobrescribiendo el archivo|echo \"nuevo texto\" > notas.txt|Escribe texto en un archivo. Si el archivo ya existía, borra todo su contenido previo.\n\n  • Sintaxis: echo \"<texto>\" > <nombre_de_archivo.txt>\n  • CUIDADO: El operador '>' reemplaza por completo el contenido existente.|texto"
  "echo <texto> >> <archivo.txt>|añade texto al final del archivo|echo \"nueva linea\" >> log.txt|Añade o concatena texto al final de un archivo sin modificar lo que ya tenía dentro.\n\n  • Sintaxis: echo \"<texto>\" >> <nombre_de_archivo.txt>\n  • Operador '>>': Agrega al final (append). Si el archivo no existe, lo crea automáticamente.|texto"
  "cmd1 | cmd2|tubería: envía salida de cmd1 a cmd2|ls -la | grep \".txt\"|Conecta y canaliza la salida de un comando para que sea procesada como entrada de otro.\n\n  • Sintaxis: <comando_salida> | <comando_procesador>\n  • Ejemplos clásicos:\n    - cat usuarios.txt | sort      → Lee el archivo y ordena su texto alfabéticamente.\n    - ps aux | grep \"firefox\"      → Obtiene los procesos y filtra solo los de Firefox.|texto"
  "cmd < <archivo.txt>|envía contenido de archivo como entrada|sort < lista.txt|Lee el contenido de un archivo y lo envía directamente a la entrada de un comando.\n\n  • Sintaxis: <comando> < <nombre_de_archivo.txt>|texto"
  "sort <archivo.txt>|ordena alfabéticamente las líneas|sort nombres.txt|Lee las líneas de un archivo y las imprime en pantalla ordenadas alfabéticamente.\n\n  • Sintaxis: sort [opciones] <nombre_de_archivo.txt>\n  • Desglose de Opciones principales:\n    - -r : Ordena en sentido inverso (de la Z a la A o de mayor a menor).\n    - -n : Ordena por valor numérico real (evita que el 10 quede antes que el 2).\n    - -u : Ordena y elimina automáticamente todas las líneas repetidas.\n    - -k <N> : Ordena tomando como base la columna número N.\n    - -t <sep> : Especifica el carácter separador de columnas (ejemplo: -t',').\n    - -h : Ordena números con formato legible de peso (2K, 10M, 1G).\n    - -V : Ordena versiones de software de forma natural (v1.2, v1.10).\n    - -f : Ignora mayúsculas y minúsculas al ordenar.\n    - -b : Ignora espacios en blanco al inicio de cada línea.\n    - -c : Comprueba si el archivo ya está ordenado sin modificarlo.\n    - -o <archivo> : Guarda el resultado ordenado directamente en un archivo nuevo.\n    - -M : Ordena por meses del año (ENE, FEB ... DIC).\n    - -R : Mezcla y ordena las líneas de forma aleatoria.|texto"
  "sort -n <archivo.txt>|ordena de forma numérica correcta|sort -n precios.txt|Ordena las líneas interpretando los valores como números reales (evita que 10 vaya antes que 2).\n\n  • Sintaxis: sort -n <nombre_de_archivo.txt>|texto"
  "sort -u <archivo.txt>|ordena y elimina líneas duplicadas|sort -u correos.txt|Ordena el texto del archivo y elimina de forma automática todas las líneas repetidas.\n\n  • Sintaxis: sort -u <nombre_de_archivo.txt>|texto"
  "uniq -c <archivo.txt>|cuenta líneas repetidas consecutivas|sort lista.txt | uniq -c|Cuenta la cantidad de repeticiones de cada línea contigua presente en el texto.\n\n  • Sintaxis: uniq [opciones] <nombre_de_archivo.txt>\n  • Desglose de Opciones principales:\n    - -c : Muestra cuántas veces se repite consecutivamente cada línea.\n    - -d : Muestra únicamente las líneas que aparecen duplicadas.\n    - -u : Muestra únicamente las líneas que son únicas (que no se repiten).\n    - -i : Ignora si hay diferencias entre mayúsculas y minúsculas.\n    - -f <N> : Iguala y omite las primeras N columnas antes de comparar.\n    - -s <N> : Omite los primeros N caracteres de cada línea antes de comparar.\n    - -w <N> : Compara como máximo los primeros N caracteres de cada línea.\n    - Nota importante: 'uniq' solo detecta duplicados si están juntos; combina con sort primero ('sort lista.txt | uniq').|texto"
  "cut -d',' -f1 <archivo.csv>|extrae columnas especificando delimitador|cut -d',' -f1 datos.csv|Corta cada línea de texto y extrae columnas específicas indicando el separador.\n\n  • Sintaxis: cut [opciones] <archivo>\n  • Desglose de Opciones principales:\n    - -d '<char>' : Especifica el carácter separador de columnas (ejemplo: -d',' o -d':').\n    - -f <lista> : Elige la número de columna a extraer (ejemplo: -f1 o -f1,3 o -f1-4).\n    - -c <lista> : Extrae por posición de caracteres (ejemplo: -c1-10 extrae los 10 primeros caracteres).\n    - -b <lista> : Extrae por posición de bytes de datos.\n    - -s : Omite las líneas que no contengan el carácter separador especificado.\n    - --complement : Invierte la selección mostrando todas las columnas EXCEPTO las elegidas.\n    - cut -d':' -f1 /etc/passwd : Extrae los nombres de usuario del sistema en Linux.|texto"
  "tr '<origen>' '<destino>'|reemplaza o convierte caracteres|cat texto.txt | tr 'a-z' 'A-Z'|Transforma o sustituye conjuntos de caracteres (ej: convierte minúsculas a mayúsculas).\n\n  • Sintaxis: tr [opciones] '<conjunto1>' ['<conjunto2>']\n  • Desglose de Opciones principales:\n    - -d : Borra del texto todos los caracteres indicados (ejemplo: tr -d '0-9' quita números).\n    - -s : Reduce caracteres repetidos seguidos a uno solo (ejemplo: tr -s ' ' quita espacios dobles).\n    - -c : Aplica el cambio a todos los caracteres EXCEPTO los indicados en el conjunto.\n    - tr 'a-z' 'A-Z' : Convierte todas las letras minúsculas a mayúsculas.\n    - tr -d '\\r' < win.txt > unix.txt : Quita saltos de línea de Windows (\\r) para convertirlos a Linux.|texto"
  "sed 's/<buscar>/<reemplazar>/g' <archivo>|reemplaza texto automáticamente|sed 's/localhost/127.0.0.1/g' config.txt|Potente editor de flujo para buscar y reemplazar patrones de texto en todo el archivo.\n\n  • Sintaxis: sed [opciones] 'instruccion' <nombre_de_archivo.txt>\n  • Desglose de Opciones y Comandos:\n    - s/buscar/reemplazar/g : Reemplaza todas las apariciones del texto en cada línea.\n    - -i : Modifica y guarda los cambios directamente en el archivo original.\n    - -i.bak : Modifica el archivo original pero guarda una copia de respaldo con extensión .bak.\n    - -n : No imprime las líneas automáticamente (útil al combinar con /p para ver solo hallazgos).\n    - -e 'script' : Permite aplicar múltiples cambios o instrucciones de sed a la vez.\n    - -E : Habilita expresiones regulares extendidas (patrones avanzados).\n    - /patron/d : Borra todas las líneas que contengan la palabra o patrón especificado.\n    - 5d : Borra específicamente la línea número 5 del archivo.\n    - /patron/p : Muestra únicamente las líneas que coincidan con la búsqueda.\n    - s/buscar/reemplazar/i : Reemplaza texto sin importar mayúsculas o minúsculas.|texto"
  "awk '{print \$1}' <archivo.txt>|procesa y filtra datos por columnas|awk '{print \$1, \$3}' tabla.txt|Lenguaje de procesamiento de datos por columnas y formateo de texto estructurado.\n\n  • Sintaxis: awk [opciones] 'programa' <nombre_de_archivo.txt>\n  • Desglose de Variables y Opciones principales:\n    - print \$1 : Imprime únicamente la primera columna de cada línea.\n    - print \$0 : Imprime la línea completa.\n    - print NF : Muestra el total de columnas que tiene la línea actual.\n    - print NR : Muestra el número de línea que se está procesando.\n    - -F'<sep>' : Define el separador de columnas (ej: -F',' para archivos CSV o -F':' para /etc/passwd).\n    - -v var=val : Define una variable personalizada antes de procesar el archivo.\n    - BEGIN { ... } : Ejecuta instrucciones al inicio antes de leer el archivo.\n    - END { ... } : Ejecuta instrucciones al final tras terminar de leer el archivo.\n    - /patron/ { ... } : Aplica acciones únicamente en las líneas que coincidan con la palabra.\n    - sum += \$1 : Suma los valores numéricos acumulados de una columna.|texto"
  "tee <archivo.txt>|guarda en archivo y muestra en pantalla|ls -la | tee reporte.txt|Recibe texto de una tubería, lo guarda en un archivo y simultáneamente lo imprime en pantalla.\n\n  • Sintaxis: <comando_salida> | tee [opciones] <nombre_de_archivo.txt>\n  • Desglose de Opciones:\n    - -a : Agrega el texto al final del archivo sin borrar lo que ya tenía (modo append).\n    - -i : Ignora señales de cancelación por teclado (Ctrl+C) para asegurar la escritura.|texto"
  "rev <archivo.txt>|invierte el orden de los caracteres|rev palabras.txt|Invierte de atrás hacia adelante los caracteres de cada línea de texto.\n\n  • Sintaxis: rev <nombre_de_archivo.txt>|texto"

  # ---------------------------------------------------------------------------
  # CATEGORÍA: sistema
  # ---------------------------------------------------------------------------
  "sudo <comando>|ejecuta un comando como superusuario|sudo apt update|Ejecuta una instrucción individual otorgando privilegios temporales de superusuario (root).\n\n  • Sintaxis: sudo [opciones] <comando_a_ejecutar>\n  • Desglose de Opciones principales:\n    - -i : Inicia una terminal interactiva como usuario administrador root.\n    - -u <usuario> : Ejecuta un comando haciéndose pasar por otro usuario específico.\n    - -s : Abre una consola de comandos con la shell por defecto del superusuario.\n    - -k : Borra la clave guardada en caché para exigirla de nuevo de inmediato.\n    - -v : Actualiza la clave guardada en memoria sin ejecutar ningún comando.\n    - -b : Ejecuta la tarea en segundo plano.\n    - -l : Lista los permisos y comandos que tu usuario actual puede usar con sudo.\n    - -E : Mantiene las variables de entorno actuales al ejecutar con permisos root.|sistema"
  "sudo -i|abre consola continua como usuario root|sudo -i|Inicia una sesión de terminal interactiva continua como superusuario root.\n\n  • Sintaxis: sudo -i\n  • Banderas utilizadas:\n    - -i : Inicia sesión interactiva completa cargando el perfil y variables de entorno de root.|sistema"
  "history|muestra historial de comandos pasados|history|Muestra la lista numerada de todas las instrucciones ejecutadas previamente en la terminal.\n\n  • Sintaxis: history [opciones]\n  • Desglose de Opciones y Atajos del Historial:\n    - -c : Borra todo el historial de comandos guardado en la memoria actual.\n    - -d <N> : Borra del historial el comando ubicado en la posición o línea N.\n    - -a : Guarda inmediatamente en el archivo los comandos de la sesión activa.\n    - -w : Sobrescribe el archivo de historial (~/.bash_history) con los comandos actuales.\n    - -r : Carga el historial desde el archivo a la memoria actual.\n    - !N : Ejecuta directamente el comando ubicado en el número de línea N del historial.\n    - !! : Vuelve a ejecutar de inmediato el último comando usado (ejemplo: sudo !!).\n    - !grep : Vuelve a ejecutar el último comando que iniciaba con la palabra 'grep'.\n    - !?texto? : Ejecuta el último comando que contenía la palabra 'texto'.|sistema"
  "history -d <linea>|borra una entrada del historial|history -d 150|Elimina la instrucción ubicada en el número de posición indicado dentro del historial.\n\n  • Sintaxis: history -d <numero_de_linea>\n  • Banderas utilizadas:\n    - -d <N> : Elimina únicamente la posición N del historial.|sistema"
  "history -c|limpia todo el historial de la sesión|history -c|Borra por completo el registro de comandos guardado en la memoria de la sesión actual.\n\n  • Sintaxis: history -c\n  • Banderas utilizadas:\n    - -c : Vacia la lista del historial.|sistema"
  "chmod +x <script.sh>|da permiso de ejecución a un archivo|chmod +x mi_script.sh|Añade permisos de ejecución a un script o binario para poder correrlo con './script.sh'.\n\n  • Sintaxis: chmod [opciones] <modo> <archivo...>\n  • Desglose de Opciones y Simbología de Permisos:\n    - +x / -x : Añade / Quita permiso de ejecución.\n    - +w / -w : Añade / Quita permiso de escritura.\n    - +r / -r : Añade / Quita permiso de lectura.\n    - u/g/o/a  : Usuario (u), Grupo (g), Otros (o), Todos (a).\n    - -R       : Aplica permisos de forma recursiva a carpetas y archivos internos.|sistema"
  "chmod 755 <script.sh>|asigna permisos estándar octales|chmod 755 script.sh|Aplica permisos numéricos: Propietario (Lectura/Escritura/Ejecución), Otros (Lectura/Ejecución).\n\n  • Sintaxis: chmod [opciones] <codigo_octal> <archivo_o_carpeta>\n  • Desglose de Permisos y Opciones:\n    - u+r / u-r : Otorga o quita permiso de lectura al dueño del archivo.\n    - u+w / u-w : Otorga o quita permiso de escritura al dueño del archivo.\n    - u+x / u-x : Otorga o quita permiso de ejecución al dueño del archivo.\n    - g+r / g-w : Otorga lectura o quita escritura al grupo asignado.\n    - o+r / o-x : Otorga lectura o quita ejecución al resto de usuarios (público).\n    - a+rwx : Otorga todos los permisos a Todos (Dueño, Grupo y Público).\n    - 755 : Permiso estándar: Lectura, escritura y ejecución para el dueño; lectura y ejecución para el resto.\n    - 644 : Permiso estándar para archivos: Lectura y escritura para el dueño; solo lectura para los demás.\n    - 600 : Solo lectura y escritura para el dueño (máxima privacidad para llaves de seguridad).\n    - -R : Aplica los permisos a la carpeta y a todo su contenido interno de forma recursiva.\n    - -v : Muestra en pantalla el reporte detallado de cada archivo modificado.|sistema"
  "df -h|muestra espacio libre en discos|df -h|Informa la capacidad total, espacio usado y disponible en todos los discos y particiones montadas.\n\n  • Sintaxis: df [opciones] [disco_o_ruta]\n  • Desglose de Opciones principales:\n    - -h : Muestra los tamaños en formato fácil de leer (KB, MB, GB, TB).\n    - -T : Muestra la columna con el tipo de sistema de archivos (ext4, xfs, btrfs).\n    - -i : Muestra la cantidad de inodes (índices de archivos) usados y disponibles.\n    - -a : Muestra todas las particiones del sistema, incluidas las de 0 bytes.\n    - -k : Muestra el espacio medido en bloques de 1 KiloByte (1 KB).\n    - -m : Muestra el espacio medido en MegaBytes (MB).\n    - -t <tipo> : Filtra para mostrar solo las particiones del tipo indicado (ej: -t ext4).\n    - -x <tipo> : Excluye del reporte cierto tipo de particiones.\n    - --total : Añade una fila final con la suma del espacio de todas las particiones.\n    - -l : Lista únicamente discos locales (omite carpetas compartidas por red).|sistema"
  "du -sh <carpeta>|calcula el tamaño ocupado por una carpeta|du -sh /var/log|Muestra la cantidad total de espacio en disco que consume una carpeta especificada.\n\n  • Sintaxis: du [opciones] [carpeta_o_archivo...]\n  • Desglose de Opciones principales:\n    - -s : Muestra únicamente el peso total acumulado de la carpeta indicada.\n    - -h : Muestra los tamaños en formato fácil de leer (KB, MB, GB).\n    - -a : Muestra el peso individual de cada archivo, no solo de las carpetas.\n    - -c : Muestra una línea al final con el total general acumulado de todo.\n    - -d <N> : Limita el análisis a N niveles de subcarpetas (ejemplo: -d 1).\n    - -b : Muestra el peso exacto expresado en bytes.\n    - -m : Muestra los pesos expresados en MegaBytes.\n    - --exclude=<patron> : Ignora archivos o carpetas que coincidan con un nombre o patrón.\n    - -L : Sigue enlaces simbólicos para calcular el tamaño real del contenido apuntado.|sistema"
  "free -h|muestra la memoria RAM y SWAP libre|free -h|Desglosa el consumo actual, memoria libre, almacenamiento en caché y swap del sistema.\n\n  • Sintaxis: free [opciones]\n  • Desglose de Opciones y Banderas:\n    - -h : Muestra los datos en formato legible para humanos (MB, GB).\n    - -m : Muestra los valores expresados en MegaBytes.\n    - -g : Muestra los valores expresados en GigaBytes.\n    - -s <N> : Actualiza y repite el reporte cada N segundos.|sistema"
  "ps aux|lista todos los procesos del sistema|ps aux|Genera un reporte detallado de cada proceso corriendo en el sistema con su PID, CPU y memoria.\n\n  • Sintaxis: ps [opciones]\n  • Desglose de Opciones principales:\n    - a : Muestra los procesos de todos los usuarios.\n    - u : Muestra datos detallados (usuario, uso de CPU, memoria RAM, hora y comando).\n    - x : Incluye procesos en segundo plano que no tienen una terminal visible.\n    - -e : Muestra absolutamente todos los procesos activos del sistema.\n    - -u <usuario> : Filtra y muestra solo los procesos del usuario especificado.\n    - -p <PID> : Muestra la información del proceso con ese número ID (PID).\n    - -C <nombre> : Filtra los procesos por el nombre exacto de su programa.\n    - --sort=-%cpu : Ordena los procesos de mayor a menor consumo de procesador (CPU).\n    - --sort=-%mem : Ordena los procesos de mayor a menor consumo de memoria RAM.\n    - -H : Muestra los procesos en estructura de árbol para ver cuáles dependen de otros.|sistema"
  "ps aux | grep <proceso>|busca un proceso específico activo|ps aux | grep firefox|Combina 'ps aux' con 'grep' para encontrar el ID (PID) y detalles de un programa en ejecución.\n\n  • Sintaxis: ps aux | grep <nombre_del_programa>\n  • Banderas y Combinaciones:\n    - ps aux | grep -i <programa> : Busca el proceso ignorando mayúsculas/minúsculas.|sistema"
  "top|monitor interactivo de recursos en tiempo real|top|Abre una pantalla interactiva con el uso continuo de CPU, memoria RAM y procesos del sistema.\n\n  • Sintaxis: top [opciones]\n  • Desglose de Teclas e Interacción en Pantalla:\n    - M : Ordena la lista de procesos por el consumo de memoria RAM.\n    - P : Ordena la lista de procesos por el consumo de procesador (CPU).\n    - N : Ordena los procesos por su número identificador (PID).\n    - T : Ordena por el tiempo acumulado de procesador que llevan ejecutándose.\n    - k : Permite escribir el PID de un proceso para cerrarlo inmediatamente.\n    - u : Filtra la lista para ver solo los procesos de un usuario específico.\n    - 1 : Cambia entre ver el consumo de cada núcleo de la CPU o el promedio general.\n    - c : Muestra u oculta la ruta completa y los argumentos del comando en ejecución.\n    - d <seg> : Cambia el intervalo en segundos con el que se actualiza la pantalla.\n    - q : Cierra y sale inmediatamente de la pantalla interactiva de top.|sistema"
  "htop|monitor interactivo avanzado a colores|htop|Versión interactiva mejorada de top con soporte para ratón, barras de colores y filtrado fácil.\n\n  • Sintaxis: htop [opciones]\n  • Controles e Interacción:\n    - F3 : Filtrar procesos por palabra clave.\n    - F4 : Filtrar procesos en árbol jerárquico.\n    - F9 : Enviar señales (SIGKILL, SIGTERM) para cerrar un proceso seleccionado.\n    - q / F10 : Salir de htop.|sistema"
  "kill -9 <pid>|fuerza la terminación de un proceso|kill -9 4821|Envía la señal estricta SIGKILL (-9) para cerrar de inmediato un proceso bloqueado usando su PID.\n\n  • Sintaxis: kill [opciones/señal] <PID...>\n  • Desglose de Señales principales:\n    - -9 (SIGKILL) : Termina incondicional e inmediatamente el proceso sin guardar estado.\n    - -15 (SIGTERM) : Solicita la terminación limpia predeterminada permitiendo al proceso cerrar archivos.\n    - -2 (SIGINT)  : Envía la señal de interrupción idéntica a pulsar Ctrl+C.\n    - -l           : Muestra el listado de todas las señales del sistema.|sistema"
  "killall <nombre>|cierra todos los procesos por su nombre|killall chrome|Finaliza al instante todos los procesos activos que coincidan exactamente con el nombre dado.\n\n  • Sintaxis: killall [opciones] <nombre_del_proceso...>\n  • Desglose de Opciones y Banderas:\n    - -9 : Envía señal SIGKILL incondicional a todos los procesos coincidentes.\n    - -i : Solicita confirmación interactiva antes de terminar cada proceso.\n    - -u <usuario> : Cierra únicamente los procesos que pertenecen a ese usuario.|sistema"
  "uptime|muestra tiempo encendido y carga media|uptime|Informa cuántas horas/días lleva encendido el sistema y el nivel promedio de carga de trabajo.\n\n  • Sintaxis: uptime [opciones]\n  • Opciones principales:\n    - -p : Muestra el tiempo encendido en formato amigable y legible.\n    - -s : Muestra la fecha y hora exacta en la que inició el sistema.|sistema"
  "uname -a|muestra datos del kernel y arquitectura|uname -a|Imprime detalles completos del sistema operativo, versión del kernel Linux y arquitectura de procesador.\n\n  • Sintaxis: uname [opciones]\n  • Desglose de Opciones principales:\n    - -a : Muestra toda la información del sistema operativo y kernel.\n    - -r : Muestra únicamente la versión del kernel de Linux instalado.\n    - -m : Muestra la arquitectura del procesador (ej: x86_64 o aarch64).\n    - -n : Muestra el nombre asignado al equipo en la red (hostname).|sistema"
  "whoami|imprime el nombre del usuario activo|whoami|Muestra en pantalla el nombre del usuario con el que iniciaste sesión actualmente.\n\n  • Sintaxis: whoami\n  • Argumentos: No requiere argumentos.|sistema"
  "ping <servidor_o_ip>|prueba conectividad de red con un host|ping google.com|Envía paquetes de prueba a un dominio o dirección IP para medir latencia y comprobar si hay internet.\n\n  • Sintaxis: ping [opciones] <servidor_o_ip>\n  • Desglose completo de Opciones y Banderas:\n    - -c <N> : Envía únicamente N paquetes y se detiene automáticamente (ej: ping -c 4 google.com).\n    - -i <seg> : Define el intervalo de espera en segundos entre cada paquete enviado.\n    - -s <bytes> : Especifica el tamaño en bytes de los paquetes ICMP enviados.|sistema"

  # ---------------------------------------------------------------------------
  # CATEGORÍA: redes
  # ---------------------------------------------------------------------------
  "ssh <usuario>@<servidor_ip>|conecta a servidor remoto por SSH|ssh root@192.168.1.50|Inicia una sesión de terminal remota segura y cifrada hacia un servidor.\n\n  • Sintaxis: ssh [opciones] <usuario>@<servidor_ip_o_dominio>\n  • Desglose de Opciones principales:\n    - -p <puerto> : Especifica un puerto de conexión diferente al puerto 22 predeterminado.\n    - -i <clave_privada> : Indica la ruta de la llave de seguridad (ej: ~/.ssh/id_rsa).\n    - -v : Modo detallado para diagnosticar problemas de conexión o clave.\n    - -C : Comprime los datos transferidos para acelerar la conexión en redes lentas.\n    - -X : Permite ejecutar programas con ventana gráfica desde el servidor remoto.|redes"
  "ssh -p <puerto> <usuario>@<ip>|conecta SSH con puerto personalizado|ssh -p 2222 usuario@192.168.1.100|Conecta a un servidor SSH que utiliza un puerto alternativo diferente al puerto estándar 22.\n\n  • Sintaxis: ssh -p <puerto> [opciones] <usuario>@<ip>\n  • Desglose de Opciones:\n    - -p <N> : Especifica el número de puerto del servidor SSH remoto.\n    - -i <llave> : Utiliza una llave privada específica para identificarse.|redes"
  "ssh-keygen -t rsa -b 4096|genera clave SSH pública y privada|ssh-keygen -t rsa -b 4096|Genera un par de llaves criptográficas (pública y privada) para autenticación sin contraseña.\n\n  • Sintaxis: ssh-keygen [opciones]\n  • Desglose completo de Opciones y Banderas:\n    - -t <tipo> : Tipo de algoritmo (rsa, ed25519, ecdsa).\n    - -b <bits> : Número de bits de la llave (4096 para rsa recomendado por seguridad).\n    - -f <archivo> : Especifica la ruta y nombre del archivo de salida para la llave.\n    - -C <comentario> : Agrega un comentario descriptivo (ej: tu correo electrónico).|redes"
  "ssh-copy-id <usuario>@<ip>|copia tu clave SSH a servidor remoto|ssh-copy-id root@192.168.1.50|Transfiere tu llave pública (~/.ssh/id_rsa.pub) al servidor para iniciar sesión SSH automáticamente sin contraseña.\n\n  • Sintaxis: ssh-copy-id [opciones] <usuario>@<ip_servidor>\n  • Desglose de Opciones:\n    - -i <llave.pub> : Especifica el archivo de llave pública a copiar.\n    - -p <puerto> : Especifica el puerto SSH del servidor si no usa el 22.|redes"
  "scp <archivo> <usuario>@<ip>:<ruta>|copia archivo a servidor remoto por SSH|scp notas.txt usuario@192.168.1.50:/home/usuario/|Copia un archivo local hacia un servidor remoto de forma cifrada mediante el protocolo SSH.\n\n  • Sintaxis: scp [opciones] <origen> <destino>\n  • Desglose de Opciones principales:\n    - -P <puerto> : Especifica el puerto SSH del servidor si no es el 22.\n    - -r : Copia carpetas completas con todo su contenido interno de forma recursiva.\n    - -i <llave> : Usa un archivo de clave privada para conectarse sin clave.\n    - -C : Comprime la información en el envío para ahorrar ancho de banda.\n    - -v : Muestra detalles de la transferencia para ver qué se está copiando.\n    - -p : Conserva las fechas originales y permisos de los archivos al copiarlos.\n    - -q : Oculta la barra de progreso para hacer transferencias silenciosas.\n    - -l <limite> : Limita la velocidad máxima de transferencia en Kilobits por segundo.\n    - scp usuario@ip:/remoto.txt ./ : Copia un archivo desde el servidor hacia tu computadora.|redes"
  "scp -r <carpeta> <usuario>@<ip>:<ruta>|copia carpeta completa a servidor SSH|scp -r Proyecto/ usuario@192.168.1.50:~/|Copia un directorio completo con todos sus subarchivos y carpetas hacia un servidor remoto.\n\n  • Sintaxis: scp -r [opciones] <carpeta_local> <usuario>@<ip>:<ruta_destino>\n  • Desglose de Opciones:\n    - -r : Modo recursivo para incluir todos los subdirectorios.\n    - -P <puerto> : Define puerto remoto si es diferente a 22.|redes"
  "rsync -avz <origen> <usuario>@<ip>:<destino>|sincroniza archivos eficientemente|rsync -avz ./web/ usuario@192.168.1.50:/var/www/|Transfiere y sincroniza carpetas transfiriendo únicamente las partes de archivos modificados.\n\n  • Sintaxis: rsync [opciones] <origen> <destino>\n  • Desglose de Opciones principales:\n    - -a : Modo archivo completo (conserva permisos, fechas, enlaces y usuarios).\n    - -v : Muestra en pantalla el detalle de los archivos procesados.\n    - -z : Comprime los datos durante la transferencia para reducir el uso de internet.\n    - -P : Muestra barra de progreso en vivo y permite reanudar envíos interrumpidos.\n    - -r : Copia directorios y subcarpetas de forma recursiva.\n    - -u : Omite copiar los archivos que ya estén más actualizados en el destino.\n    - --delete : Borra en el destino los archivos que hayan sido eliminados en el origen.\n    - -e \"ssh -p <puerto>\" : Especifica el puerto o comando SSH a utilizar.\n    - -n : Hace una prueba simulada sin modificar ni enviar archivos reales.\n    - -h : Muestra los pesos en formato entendible (KB, MB, GB).\n    - --exclude=<patron> : Ignora archivos o carpetas que coincidan con un nombre o patrón.|redes"
  "ss -tuln|ver puertos TCP/UDP abiertos|ss -tuln|Muestra las sockets y puertos de red activos escuchando conexiones en el sistema.\n\n  • Sintaxis: ss [opciones]\n  • Desglose de Opciones principales:\n    - -t : Muestra conexiones y sockets del protocolo TCP.\n    - -u : Muestra conexiones del protocolo UDP.\n    - -l : Filtra para ver únicamente los puertos que están escuchando (listening).\n    - -n : Muestra números de puerto e IP en formato numérico sin convertir a nombres.\n    - -p : Muestra el nombre de la aplicación y el PID que está usando el puerto.\n    - -a : Muestra todas las conexiones (tanto activas como en espera).\n    - -4 : Muestra únicamente tráfico o conexiones IPv4.\n    - -6 : Muestra únicamente tráfico o conexiones IPv6.\n    - -s : Muestra un resumen general con estadísticas de conexiones de la red.|redes"
  "netstat -tuln|ver puertos abiertos (método clásico)|netstat -tuln|Muestra conexiones de red, tablas de enrutamiento e interfaces activas (herramienta clásica).\n\n  • Sintaxis: netstat [opciones]\n  • Desglose de Opciones principales:\n    - -t : Muestra conexiones TCP.\n    - -u : Muestra conexiones UDP.\n    - -l : Filtra y muestra únicamente los puertos en estado Listening.\n    - -n : Muestra direcciones IP y puertos en números sin resolver nombres.\n    - -p : Muestra el PID y nombre del programa dueño de la conexión.\n    - -a : Muestra todas las conexiones activas y puertos en escucha.\n    - -r : Muestra la tabla de rutas de red del sistema.|redes"
  "lsof -i :<puerto>|ver qué programa usa un puerto|lsof -i :8080|Muestra qué proceso o aplicación específica está ocupando un puerto de red determinado.\n\n  • Sintaxis: lsof [opciones] -i :<puerto>\n  • Desglose de Opciones principales:\n    - -i : Filtra por archivos de red e internet.\n    - -i :<puerto> : Especifica el número exacto de puerto a consultar (ejemplo: -i :8080).\n    - -iTCP : Filtra únicamente puertos o conexiones TCP.\n    - -iUDP : Filtra únicamente puertos o conexiones UDP.\n    - -P : Muestra números de puerto en vez de nombres de servicio.\n    - -n : Muestra direcciones IP numéricas sin resolver nombres de dominio.\n    - -p <PID> : Muestra todos los archivos que tiene abiertos un proceso por su PID.\n    - -u <usuario> : Muestra los archivos y puertos abiertos por un usuario.|redes"
  "fuser -k <puerto>/tcp|cerrar/matar el proceso de un puerto|sudo fuser -k 8080/tcp|Identifica y termina de inmediato el proceso que ocupa el puerto de red TCP especificado.\n\n  • Sintaxis: fuser [opciones] <puerto>/<protocolo>\n  • Desglose de Opciones principales:\n    - -k : Cierra o mata inmediatamente el proceso que usa el puerto.\n    - -v : Muestra en pantalla información detallada sobre el proceso encontrado.\n    - -i : Pide confirmación antes de cerrar el proceso.\n    - -9 : Envía la señal de terminación forzada (SIGKILL) para cerrar el proceso bloqueado.\n    - -u : Muestra el nombre del usuario dueño del proceso.|redes"
  "sudo ufw status|ver estado del firewall UFW|sudo ufw status verbose|Muestra si el cortafuegos UFW (Uncomplicated Firewall) está activo y sus reglas aplicadas.\n\n  • Sintaxis: ufw [opciones] <comando>\n  • Desglose de Comandos principales:\n    - status verbose : Muestra el estado actual del cortafuegos y las reglas aplicadas.\n    - status numbered : Muestra la lista de reglas enumeradas con su número de orden.\n    - enable : Activa el cortafuegos y lo inicia automáticamente con el sistema.\n    - disable : Desactiva el cortafuegos permitiendo todo el tráfico.\n    - allow <puerto>/tcp : Abre un puerto para permitir conexiones entrantes.\n    - deny <puerto>/tcp : Bloquea o impide conexiones por ese puerto.\n    - delete allow <puerto> : Elimina una regla de apertura creada anteriormente.\n    - reset : Restablece el cortafuegos UFW borrando todas las reglas personalizadas.|redes"
  "sudo ufw enable|activar el firewall UFW|sudo ufw enable|Habilita y activa de inmediato la protección del firewall UFW al arrancar el sistema.\n\n  • Sintaxis: sudo ufw enable\n  • Nota: Aplica todas las reglas guardadas activando la protección del equipo.|redes"
  "sudo ufw disable|desactivar el firewall UFW|sudo ufw disable|Desactiva el firewall UFW permitiendo el libre tráfico de red sin restricciones.\n\n  • Sintaxis: sudo ufw disable\n  • Nota: Las reglas guardadas permanecen intactas pero inactivas.|redes"
  "sudo ufw allow <puerto>|abrir un puerto en el firewall|sudo ufw allow 80/tcp|Añade una regla al firewall para permitir tráfico de red entrante por un puerto especificado.\n\n  • Sintaxis: sudo ufw allow <puerto>/<protocolo>\n  • Ejemplos y Desglose:\n    - 22/tcp  : Permite conexiones entrantes SSH.\n    - 80/tcp  : Permite tráfico HTTP web.\n    - 443/tcp : Permite tráfico seguro HTTPS.|redes"
  "sudo ufw deny <puerto>|cerrar o bloquear puerto en firewall|sudo ufw deny 3306/tcp|Bloquea de inmediato todo acceso o tráfico entrante por un puerto específico.\n\n  • Sintaxis: sudo ufw deny <puerto>/<protocolo>\n  • Desglose:\n    - deny <puerto> : Rechaza conexiones entrantes en el puerto indicado.|redes"
  "sudo ufw delete allow <puerto>|eliminar regla de apertura de puerto|sudo ufw delete allow 80/tcp|Elimina una regla previamente creada permitiendo limpiar o revocar accesos en el firewall.\n\n  • Sintaxis: sudo ufw delete allow <puerto>/<protocolo>\n  • Desglose:\n    - delete : Elimina la regla especificada a continuación.|redes"
  "ip a|ver interfaces de red y direcciones IP|ip a|Muestra las tarjetas e interfaces de red del equipo junto con sus IP locales asignadas.\n\n  • Sintaxis: ip [opciones] <objeto> <comando>\n  • Desglose de Opciones y Comandos:\n    - a (o addr) : Muestra o administra las direcciones IP de las tarjetas de red.\n    - link : Muestra o modifica el estado físico de las tarjetas de red (encendida/apagada).\n    - route : Muestra la tabla de rutas de red del sistema.\n    - -c : Muestra la salida con colores resaltados en la terminal.\n    - -4 : Filtra para ver únicamente direcciones IPv4.\n    - -6 : Filtra para ver únicamente direcciones IPv6.\n    - -br : Muestra un resumen rápido en formato de tabla limpia de una línea.\n    - ip link set <tarjeta> up : Activa una interfaz de red.\n    - ip link set <tarjeta> down : Desactiva una interfaz de red.|redes"
  "curl -s ifconfig.me|ver tu dirección IP pública real|curl -s ifconfig.me|Consulta un servicio externo en internet para obtener la IP pública de tu conexión actual.\n\n  • Sintaxis: curl [opciones] <URL>\n  • Desglose de Opciones principales:\n    - -X <METODO> : Especifica la acción HTTP a realizar (GET, POST, PUT, DELETE, PATCH).\n    - -d \"<datos>\" : Envía información en el cuerpo de la petición (para formularios o datos JSON).\n    - -H \"<Header>\" : Añade encabezados HTTP (ejemplo: -H \"Content-Type: application/json\").\n    - -o <archivo> : Guarda el contenido descargado en un archivo local especificado.\n    - -O : Descarga el archivo conservando el mismo nombre que tiene en internet.\n    - -s : Modo silencioso (oculta la barra de progreso y avisos).\n    - -v : Modo detallado (muestra las cabeceras enviadas y recibidas).\n    - -u <user:pass> : Envía nombre de usuario y contraseña para sitios protegidos.\n    - -L : Sigue redirecciones automáticas si la página cambió de enlace.\n    - -k : Permite conectarse a sitios con certificados SSL inseguros o no válidos.\n    - -I : Trae únicamente los encabezados HTTP sin descargar el contenido de la página.\n    - -m <seg> : Ajusta el tiempo máximo en segundos que esperará para descargar.|redes"
  "nslookup <dominio>|consultar la dirección IP de un dominio|nslookup google.com|Consulta los servidores DNS para conocer la dirección IP asociada a un nombre de dominio web.\n\n  • Sintaxis: nslookup [opciones] <dominio_o_ip>\n  • Desglose de Opciones de nslookup:\n    - nslookup <dominio> : Devuelve el registro de dirección IP del host.\n    - nslookup -type=mx <dominio> : Consulta los servidores de correo (registros MX).\n    - nslookup -type=ns <dominio> : Consulta los servidores de nombres autoritativos (NS).\n    - nslookup -type=any <dominio> : Consulta todos los registros DNS disponibles.|redes"
  "dig <dominio>|inspección DNS detallada de un dominio|dig github.com|Herramienta avanzada para realizar consultas DNS completas (registros A, CNAME, MX, TXT).\n\n  • Sintaxis: dig [opciones] <dominio> [tipo]\n  • Desglose de Opciones y Registros:\n    - +short : Muestra únicamente la respuesta directa (la dirección IP) de forma limpia.\n    - A : Consulta el registro de la dirección IPv4 asociada al dominio web.\n    - AAAA : Consulta el registro de la dirección IPv6 asociada al dominio.\n    - MX : Consulta los servidores de correo electrónico del dominio.\n    - TXT : Consulta los registros de texto (verificaciones de propiedad o seguridad).\n    - CNAME : Consulta alias o nombres alternativos asignados al dominio.\n    - NS : Consulta los servidores DNS autoritativos que gestionan el dominio.\n    - @<servidor_dns> : Realiza la consulta a un servidor DNS específico (ejemplo: @8.8.8.8).|redes"
  "traceroute <host>|trazar la ruta de red hacia un servidor|traceroute 8.8.8.8|Muestra cada uno de los saltos y routers por los que pasan los paquetes de red hasta llegar al destino.\n\n  • Sintaxis: traceroute [opciones] <dominio_o_ip>\n  • Desglose de Opciones principales:\n    - -n : Muestra las direcciones IP de los saltos de red sin resolver sus nombres.\n    - -m <N> : Limita la prueba a un máximo de N saltos o routers intermedios.\n    - -I : Envía paquetes ICMP (ping) en lugar del protocolo UDP predeterminado.\n    - -T : Envía paquetes TCP (útil para atravesar cortafuegos o firewalls).\n    - -p <puerto> : Especifica el número de puerto de destino para la prueba.\n    - -w <seg> : Ajusta el tiempo máximo en segundos que esperará por cada salto.\n    - -q <n> : Número de paquetes de sonda enviados por cada salto.\n    - -f <ttl> : Especifica con qué TTL de salto inicial comenzar la prueba.|redes"

  # ---------------------------------------------------------------------------
  # CATEGORÍA: atajos
  # ---------------------------------------------------------------------------
  "Tab|autocompleta comandos, variables y rutas|Tab|Escribe el inicio de un comando o nombre de archivo y pulsa Tab para completarlo de forma automática.|atajos"
  "Tab Tab|muestra opciones de autocompletado|Tab Tab|Pulsa la tecla Tab dos veces seguidas cuando existan múltiples archivos o comandos parecidos.|atajos"
  "Ctrl+R|búsqueda interactiva en el historial|Ctrl+R|Abre un buscador interactivo. Empieza a escribir cualquier palabra de un comando antiguo para encontrarlo.|atajos"
  "Ctrl+C|cancela la ejecución del comando actual|Ctrl+C|Detiene inmediatamente cualquier programa, script o proceso en ejecución en la pantalla de la terminal.|atajos"
  "Ctrl+L|limpia por completo la pantalla de la consola|Ctrl+L|Limpia todo el texto visible en la pantalla (hace exactamente lo mismo que escribir 'clear').|atajos"
  "Ctrl+U|borra texto desde el cursor al inicio|Ctrl+U|Corta e interactúa borrando todo lo que hayas escrito desde la posición actual del cursor hacia la izquierda.|atajos"
  "Ctrl+K|borra texto desde el cursor al final|Ctrl+K|Corta e interactúa borrando todo lo escrito desde la posición del cursor hacia la derecha.|atajos"
  "Ctrl+Y|pega el último fragmento de texto borrado|Ctrl+Y|Restaura o pega el último bloque de texto que hayas borrado recientemente usando Ctrl+U o Ctrl+K.|atajos"
  "Ctrl+W|borra la palabra anterior al cursor|Ctrl+W|Borra rápidamente una sola palabra hacia atrás desde donde esté ubicado el cursor.|atajos"
  "Ctrl+A|mueve el cursor al principio de la línea|Ctrl+A|Desplaza instantáneamente el cursor de edición al inicio de la línea sin tener que borrar.|atajos"
  "Ctrl+E|mueve el cursor al final de la línea|Ctrl+E|Desplaza instantáneamente el cursor de edición al extremo derecho final de la línea.|atajos"
  "Alt+B|desplaza el cursor una palabra atrás|Alt+B|Navega saltando palabra por palabra hacia la izquierda en la línea de comandos.|atajos"
  "Alt+F|desplaza el cursor una palabra adelante|Alt+F|Navega saltando palabra por palabra hacia la derecha en la línea de comandos.|atajos"
  "Ctrl+Shift+C|copia el texto seleccionado en terminal|Ctrl+Shift+C|Copia al portapapeles el fragmento de texto que hayas seleccionado con el ratón.|atajos"
  "Ctrl+Shift+V|pega texto del portapapeles en terminal|Ctrl+Shift+V|Pega en la línea de comandos el texto o código que tengas copiado en tu portapapeles.|atajos"
  "Flecha arriba|navega hacia atrás en el historial|Flecha arriba|Recorre secuencialmente las instrucciones que ejecutaste en el pasado para no tener que reescribirlas.|atajos"
  "!!|repite el último comando ejecutado|!!|Re-ejecuta automáticamente la última instrucción (muy útil para anteponer sudo: 'sudo !!').|atajos"
  "!n|ejecuta comando número 'n' del historial|!50|Busca y ejecuta directamente la instrucción ubicada en el número especificado de tu historial.|atajos"
  "Ctrl+Z|suspende y envía proceso a segundo plano|Ctrl+Z|Pausa temporalmente la tarea en ejecución y la deja en segundo plano (puedes usar 'fg' para reanudarla).|atajos"
  "fg|reanuda proceso suspendido en primer plano|fg|Vuelve a traer a la pantalla el programa o tarea que habías pausado previamente con Ctrl+Z.|atajos"
  "Ctrl+D|cierra sesión o sale de la terminal|Ctrl+D|Envía el carácter de fin de archivo (EOF) cerrando la shell o la conexión SSH activa.|atajos"

)


# =============================================================================
# 3. FUNCIONES DE INTERFAZ Y NAVEGACIÓN
# =============================================================================

# -----------------------------------------------------------------------------
# 3.0. print_exp()
# -----------------------------------------------------------------------------
# Da formato y color al bloque de explicación de cada comando.
# Detecta automáticamente los siguientes patrones:
#   • Líneas tipo "   - -X : descripción"  → opción verde + flecha + descripción
#   • Líneas tipo "   - -X"                → opción verde suelta
#   • Líneas tipo "  • Título: descripción"→ viñeta amarilla + título en negrita
#   • Líneas tipo "  • texto"              → viñeta amarilla simple
#   • Líneas normales                      → texto con sangría
#
print_exp() {
    local exp="$1"

    # ── Primera pasada: encontrar la opción más larga del bloque ──
    local max_opt=0
    while IFS= read -r line; do
        if [[ "$line" =~ ^[[:space:]]+-[[:space:]]+(.+[^[:space:]])[[:space:]]+:[[:space:]]+(.*)$ ]]; then
            local opt="${BASH_REMATCH[1]}"
            local len=${#opt}
            [ "$len" -gt "$max_opt" ] && max_opt=$len
        fi
    done < <(echo -e "$exp")

    # ── Ajustar el ancho entre un mínimo y un máximo ──
    # Ajusta estos dos números si lo quieres más junto o más separado.
    [ "$max_opt" -lt 14 ] && max_opt=14
    [ "$max_opt" -gt 28 ] && max_opt=28
    local ancho=$((max_opt + 2))

    # ── Segunda pasada: imprimir con el ancho calculado ──
    echo -e "$exp" | while IFS= read -r line; do
        # Ignorar líneas vacías
        [ -z "$line" ] && continue

        # Opciones con descripción: "   - -X (o --xxx) : descripción"
        if [[ "$line" =~ ^[[:space:]]+-[[:space:]]+(.+[^[:space:]])[[:space:]]+:[[:space:]]+(.*)$ ]]; then
            local opt="${BASH_REMATCH[1]}"
            local desc="${BASH_REMATCH[2]}"
            local padded
            padded=$(printf "%-${ancho}s" "$opt")
            printf "     ${G}%s${R} ${C}➜${R}  ${D}%s${R}\n" "$padded" "$desc"
            continue
        fi

        # Opciones sin descripción: "   - -X"
        if [[ "$line" =~ ^[[:space:]]+-[[:space:]]+(.+)$ ]]; then
            local opt="${BASH_REMATCH[1]}"
            printf "     ${G}%s${R}\n" "$opt"
            continue
        fi

        # Viñeta con título: "  • Título: descripción"
        if [[ "$line" =~ ^[[:space:]]*•[[:space:]]+([^:]+):[[:space:]]*(.*)$ ]]; then
            local titulo="${BASH_REMATCH[1]}"
            local resto="${BASH_REMATCH[2]}"
            printf "\n  ${Y}▸${R} ${Y}${B}%s${R}\n" "$titulo"
            [ -n "$resto" ] && printf "     %s\n" "$resto"
            continue
        fi

        # Viñeta simple: "  • texto"
        if [[ "$line" =~ ^[[:space:]]*•[[:space:]]+(.*)$ ]]; then
            local txt="${BASH_REMATCH[1]}"
            printf "  ${Y}▸${R} %s\n" "$txt"
            continue
        fi

        # Línea normal (incluye sub-ejemplos con "    - ")
        if [[ "$line" =~ ^[[:space:]]+-[[:space:]]+(.*)$ ]]; then
            local txt="${BASH_REMATCH[1]}"
            printf "     ${D}•${R} %s\n" "$txt"
            continue
        fi

        printf "  %s\n" "$line"
    done
}


# -----------------------------------------------------------------------------
# 3.1. detalle()
# -----------------------------------------------------------------------------
# Muestra la ficha explicativa completa de un comando individual.
#
detalle() {
    IFS='|' read -r cmd desc ej exp cat <<< "$1"

    echo
    echo "  ${B}╭────────────────────────────────────────────────────────────────────╮${R}"
    echo "  ${B}│${R} ${C}COMANDO:${R}      ${G}${cmd}${R}"
    echo "  ${B}│${R} ${C}CATEGORÍA:${R}    ${Y}${cat}${R}"
    echo "  ${B}│${R} ${C}QUÉ HACE:${R}     ${desc}"
    echo "  ${B}│${R} ${C}EJEMPLO:${R}      ${Y}${ej}${R}"
    echo "  ${B}╰────────────────────────────────────────────────────────────────────╯${R}"
    echo
    echo "  ${C}─── Explicación detallada ───${R}"
    print_exp "$exp"
    echo
}


# -----------------------------------------------------------------------------
# 3.1.0. asistente_rutas()
# -----------------------------------------------------------------------------
# Asistente interactivo para explorar carpetas o buscar archivos si no se conoce la ruta.
# Devuelve la ruta seleccionada en la variable global RUTA_SELECCIONADA.
#
RUTA_SELECCIONADA=""

asistente_rutas() {
    RUTA_SELECCIONADA=""
    local dir_actual="$(pwd)"

    echo
    echo "  ${C}ASISTENTE INTERACTIVO DE RUTAS Y ARCHIVOS:${R}"
    echo "  ${B}──────────────────────────────────────────────────────────────────────────────────${R}"
    echo "  ${G}1)${R} Navegar por carpetas (Entrar/Subir directorio)"
    echo "  ${G}2)${R} Buscar archivo por nombre o extensión (ej: log, .txt, config)"
    echo "  ${G}3)${R} Ver archivos de la carpeta actual ($(pwd))"
    echo "  ${G}0)${R} Cancelar"
    echo "  ${B}──────────────────────────────────────────────────────────────────────────────────${R}"
    read -e -r -p "  Selecciona una opción (0-3): " modo_rutas

    local modo_limpio
    modo_limpio=$(echo "$modo_rutas" | xargs 2>/dev/null)

    if [ "$modo_limpio" = "2" ] || [ "$modo_limpio" = "buscar" ]; then
        echo
        read -e -r -p "  Ingresa el nombre, palabra o extensión a buscar (ej: .txt, log): " patron
        local patron_limpio
        patron_limpio=$(echo "$patron" | xargs 2>/dev/null)
        if [ -z "$patron_limpio" ]; then
            return
        fi

        echo
        echo "  ${C}Buscando coincidencias para \"*$patron_limpio*\" en $(pwd)...${R}"
        local hallazgos=()
        while IFS= read -r linea; do
            if [ -n "$linea" ]; then
                hallazgos+=("$linea")
            fi
        done < <(find . -iname "*$patron_limpio*" 2>/dev/null | grep -v "/\." | head -n 50)

        if [ ${#hallazgos[@]} -eq 0 ]; then
            echo "  ${Y}No se encontraron archivos que coincidan con \"$patron_limpio\".${R}"
            read -r -p "  Presiona Enter para continuar..."
            return
        fi

        echo "  ${B}──────────────────────────────────────────────────────────────────────────────────${R}"
        for (( idx=0; idx<${#hallazgos[@]}; idx++ )); do
            printf "  ${G}%2d)${R} %s\n" "$((idx+1))" "${hallazgos[$idx]}"
        done
        echo "  ${B}──────────────────────────────────────────────────────────────────────────────────${R}"
        read -e -r -p "  Elige un número de archivo (1-${#hallazgos[@]}): " num_h
        num_h=$(echo "$num_h" | xargs 2>/dev/null)
        if [[ "$num_h" =~ ^[0-9]+$ ]] && [ "$num_h" -ge 1 ] && [ "$num_h" -le ${#hallazgos[@]} ]; then
            RUTA_SELECCIONADA="${hallazgos[$((num_h-1))]}"
        fi
        return
    elif [ "$modo_limpio" = "1" ] || [ "$modo_limpio" = "navegar" ]; then
        local ruta_actual="$dir_actual"
        local nav_pagina=0
        local nav_por_pagina=25
        while true; do
            clear
            echo

            # Cargar todos los archivos del directorio actual sin ocultos
            local all_items=()
            while IFS= read -r f; do
                [ -n "$f" ] && all_items+=("$f")
            done < <(ls -1 "$ruta_actual" 2>/dev/null | grep -v "^\\.")

            local nav_total=${#all_items[@]}
            local nav_total_paginas=$(( (nav_total + nav_por_pagina - 1) / nav_por_pagina ))
            [ $nav_total_paginas -lt 1 ] && nav_total_paginas=1
            [ $nav_pagina -ge $nav_total_paginas ] && nav_pagina=$((nav_total_paginas - 1))

            local nav_inicio=$((nav_pagina * nav_por_pagina))
            local nav_fin=$((nav_inicio + nav_por_pagina))
            [ $nav_fin -gt $nav_total ] && nav_fin=$nav_total

            echo "  ${C}NAVEGADOR INTERACTIVO:${R} ${G}$ruta_actual${R}"
            if [ $nav_total_paginas -gt 1 ]; then
                echo "  ${D}(Pagina $((nav_pagina+1)) de $nav_total_paginas - Total: $nav_total)${R}"
            fi
            echo "  ${B}──────────────────────────────────────────────────────────────────────────────────${R}"
            echo "  ${G} 0)${R} ${D}.. Subir al directorio anterior${R}"
            echo "  ${G} s)${R} ${Y}Usar ESTA CARPETA como argumento (busqueda recursiva)${R}"

            for (( ni=nav_inicio; ni<nav_fin; ni++ )); do
                local f="${all_items[$ni]}"
                local display_num=$((ni + 1))
                if [ -d "$ruta_actual/$f" ]; then
                    printf "  ${G}%2d)${R} ${C}%s/${R}\n" "$display_num" "$f"
                else
                    printf "  ${G}%2d)${R} %s\n" "$display_num" "$f"
                fi
            done

            echo "  ${B}──────────────────────────────────────────────────────────────────────────────────${R}"
            echo "  ${D}• Num carpeta (/): Entrar.  Num archivo: Seleccionar.${R}"
            echo "  ${D}• 's': carpeta actual (busqueda recursiva).  '0': subir.  'q': cancelar.${R}"
            if [ $nav_total_paginas -gt 1 ]; then
                echo "  ${Y}• 'n': Siguiente página ($((nav_pagina+2))/$nav_total_paginas).  'p': Página anterior.${R}"
            fi
            echo "  ${C}• 'f <texto>': Filtrar/buscar por nombre (ej. f pruebas)${R}"
            read -e -r -p "  > " resp_nav
            local resp_nav_limpia
            resp_nav_limpia=$(echo "$resp_nav" | tr '[:upper:]' '[:lower:]' | xargs 2>/dev/null)

            if [ "$resp_nav_limpia" = "0" ] || [ "$resp_nav_limpia" = ".." ]; then
                ruta_actual=$(dirname "$ruta_actual")
                nav_pagina=0
            elif [ "$resp_nav_limpia" = "s" ]; then
                RUTA_SELECCIONADA="$ruta_actual"
                break
            elif [ "$resp_nav_limpia" = "q" ] || [ -z "$resp_nav_limpia" ]; then
                break
            elif [ "$resp_nav_limpia" = "n" ]; then
                [ $((nav_pagina + 1)) -lt $nav_total_paginas ] && nav_pagina=$((nav_pagina + 1))
            elif [ "$resp_nav_limpia" = "p" ] || [ "$resp_nav_limpia" = "a" ]; then
                [ $nav_pagina -gt 0 ] && nav_pagina=$((nav_pagina - 1))
            elif [[ "$resp_nav_limpia" =~ ^f[[:space:]] ]]; then
                local filtro_nombre="${resp_nav_limpia#f }"
                local encontrados=()
                for f_item in "${all_items[@]}"; do
                    [[ "${f_item,,}" == *"$filtro_nombre"* ]] && encontrados+=("$f_item")
                done
                if [ ${#encontrados[@]} -eq 0 ]; then
                    echo "  ${Y}No se encontraron coincidencias para '$filtro_nombre'.${R}"
                    read -r -p "  Presiona Enter..."
                elif [ ${#encontrados[@]} -eq 1 ]; then
                    local ruta_elem="$ruta_actual/${encontrados[0]}"
                    if [ -d "$ruta_elem" ]; then
                        ruta_actual="$ruta_elem"; nav_pagina=0
                    else
                        RUTA_SELECCIONADA="$ruta_elem"; break
                    fi
                else
                    echo
                    echo "  ${C}Coincidencias:${R}"
                    for (( fi=0; fi<${#encontrados[@]}; fi++ )); do
                        local ruta_e="$ruta_actual/${encontrados[$fi]}"
                        if [ -d "$ruta_e" ]; then
                            printf "  ${G}%2d)${R} ${C}%s/${R}\n" "$((fi+1))" "${encontrados[$fi]}"
                        else
                            printf "  ${G}%2d)${R} %s\n" "$((fi+1))" "${encontrados[$fi]}"
                        fi
                    done
                    read -e -r -p "  Elige numero: " sel_f
                    sel_f=$(echo "$sel_f" | xargs 2>/dev/null)
                    if [[ "$sel_f" =~ ^[0-9]+$ ]] && [ "$sel_f" -ge 1 ] && [ "$sel_f" -le ${#encontrados[@]} ]; then
                        local ruta_elem="$ruta_actual/${encontrados[$((sel_f-1))]}"
                        if [ -d "$ruta_elem" ]; then
                            ruta_actual="$ruta_elem"; nav_pagina=0
                        else
                            RUTA_SELECCIONADA="$ruta_elem"; break
                        fi
                    fi
                fi
            elif [[ "$resp_nav_limpia" =~ ^[0-9]+$ ]] && [ "$resp_nav_limpia" -ge 1 ] && [ "$resp_nav_limpia" -le $nav_total ]; then
                local elem="${all_items[$((resp_nav_limpia-1))]}"
                local ruta_elem="$ruta_actual/$elem"
                if [ -d "$ruta_elem" ]; then
                    ruta_actual="$ruta_elem"; nav_pagina=0
                else
                    RUTA_SELECCIONADA="$ruta_elem"; break
                fi
            fi
        done
    elif [ "$modo_limpio" = "3" ] || [ "$modo_limpio" = "ls" ]; then
        modo_limpio="1"
        asistente_rutas
        return
    fi
}


# -----------------------------------------------------------------------------
# 3.1.1. ejecutar_comando()
# -----------------------------------------------------------------------------
# Ejecuta de forma interactiva y controlada el comando seleccionado.
#
ejecutar_comando() {
    local cmd="$1"
    local ej="$2"
    local cat="$3"
    local exp="$4"

    if [ "$cat" = "atajos" ]; then
        echo
        echo "  ${Y}Nota:${R} Los atajos de teclado son combinaciones de teclas, no comandos ejecutables."
        read -r -p "  Presiona Enter para continuar..."
        return
    fi

    # Extraer el binario/comando base (ej: 'cat', 'ls', 'grep', 'echo')
    local cmd_base
    cmd_base=$(echo "$cmd" | awk '{print $1}')

    while true; do
        echo
        echo "  ${B}╭────────────────────────────────────────────────────────────────────╮${R}"
        echo "  ${B}│${R} ${C}EJECUCIÓN CONTROLADA DE COMANDO${R}"
        echo "  ${B}├────────────────────────────────────────────────────────────────────┤${R}"
        echo "  ${B}│${R} ${C}Comando:${R}       ${G}$cmd${R}"
        echo "  ${B}│${R} ${C}Ejemplo:${R}       ${Y}$ej${R}"
        if [ -n "$exp" ]; then
            echo "  ${B}├────────────────────────────────────────────────────────────────────┤${R}"
            echo "  ${B}│${R} ${C}Explicación de Opciones y Argumentos:${R}"
            print_exp "$exp"
        fi
        echo "  ${B}╰────────────────────────────────────────────────────────────────────╯${R}"
        echo
        echo "  ${D}• Presiona ${G}Enter${D} para usar el ejemplo completo: ${Y}$ej${R}"
        echo "  ${D}• Escribe solo los argumentos para ${G}$cmd_base${D} (ej. tu texto o ruta)."
        echo "  ${D}• TIP: Usa ${G}Tab${D} para autocompletar, o escribe ${G}?${D} para explorar/buscar rutas.${R}"
        read -e -r -p "  ${C}>${R} " cmd_usuario

        local cmd_usuario_limpio
        cmd_usuario_limpio=$(echo "$cmd_usuario" | xargs 2>/dev/null)

        if [[ "$cmd_usuario_limpio" =~ \? ]] || [ "$cmd_usuario_limpio" = "b" ] || [ "$cmd_usuario_limpio" = "buscar" ] || [ "$cmd_usuario_limpio" = "ls" ]; then
            local texto_previo="${cmd_usuario_limpio//\?/}"
            texto_previo=$(echo "$texto_previo" | xargs 2>/dev/null)

            asistente_rutas
            if [ -n "$RUTA_SELECCIONADA" ]; then
                local ruta_formateada="$RUTA_SELECCIONADA"
                if [[ "$ruta_formateada" =~ \  ]]; then
                    ruta_formateada="\"$ruta_formateada\""
                fi

                if [ "$cmd_base" = "grep" ]; then
                    if [ -z "$texto_previo" ]; then
                        echo
                        echo "  ${D}Ruta seleccionada: ${G}$RUTA_SELECCIONADA${R}"
                        echo "  ${D}Solo escribe la PALABRA o PATRON a buscar dentro de esa ruta:${R}"
                        read -e -r -p "  Patron de busqueda > " texto_busqueda
                        texto_previo=$(echo "$texto_busqueda" | xargs 2>/dev/null)
                    fi

                    if [ -d "$RUTA_SELECCIONADA" ]; then
                        if [[ ! "$cmd" =~ -[a-zA-Z]*r ]] && [[ ! "$texto_previo" =~ -[a-zA-Z]*r ]]; then
                            cmd_base="grep -rn"
                        fi
                    fi

                    if [ -n "$texto_previo" ]; then
                        cmd_usuario_limpio="$texto_previo $ruta_formateada"
                    else
                        cmd_usuario_limpio="$ruta_formateada"
                    fi
                else
                    if [ -n "$texto_previo" ]; then
                        cmd_usuario_limpio="$texto_previo $ruta_formateada"
                    else
                        cmd_usuario_limpio="$ruta_formateada"
                    fi
                fi
            else
                continue
            fi
        fi

        local cmd_final=""
        if [ -z "$cmd_usuario_limpio" ]; then
            cmd_final="$ej"
        else
            local base_token
            base_token=$(echo "$cmd_base" | awk '{print $1}')
            local primer_token
            primer_token=$(echo "$cmd_usuario_limpio" | sed 's/^"\([^"]*\)".*/\1/' | awk '{print $1}')

            if [ "$primer_token" = "$base_token" ] || [ "$primer_token" = "sudo" ]; then
                cmd_final="$cmd_usuario_limpio"
            else
                cmd_final="$cmd_base $cmd_usuario_limpio"
            fi
        fi

        if [[ "$cmd_final" =~ (rm|kill|sudo|dd|chmod\ 777|fuser|mkfs|reboot|shutdown) ]]; then
            echo
            echo "  ${R}[!] ADVERTENCIA DE SEGURIDAD:${R} Este comando puede borrar o modificar recursos del sistema."
            echo "  Comando final: ${G}$cmd_final${R}"
            read -e -r -p "  ¿Estás seguro de que deseas ejecutarlo? (s/N): " confirmacion
            local conf_limpia
            conf_limpia=$(echo "$confirmacion" | tr '[:upper:]' '[:lower:]' | xargs 2>/dev/null)
            if [ "$conf_limpia" != "s" ] && [ "$conf_limpia" != "si" ] && [ "$conf_limpia" != "sí" ]; then
                echo
                echo "  ${Y}Ejecución cancelada por el usuario.${R}"
                read -r -p "  Presiona Enter para continuar..."
                return
            fi
        fi

        echo
        echo "  ${B}──────────────────────────────────────────────────────────────────────────────────${R}"
        echo "  ${G}► Ejecutando:${R} ${C}$cmd_final${R}"
        echo "  ${B}──────────────────────────────────────────────────────────────────────────────────${R}"
        echo

        eval "$cmd_final"
        local codigo_salida=$?

        echo
        echo "  ${B}──────────────────────────────────────────────────────────────────────────────────${R}"
        if [ $codigo_salida -eq 0 ]; then
            echo "  ${G}[OK] Ejecución finalizada con éxito (Código de salida: 0)${R}"
        else
            echo "  ${R}[ERROR] Ejecución finalizada con errores (Código de salida: $codigo_salida)${R}"
        fi
        echo "  ${B}──────────────────────────────────────────────────────────────────────────────────${R}"
        echo
        echo "  ${D}• Presiona ${G}Enter${D} para volver a la lista."
        echo "  ${D}• Escribe ${G}e${D} para volver a ejecutar pasando otros argumentos.${R}"
        read -e -r -p "  > " re_opcion
        local re_limpia
        re_limpia=$(echo "$re_opcion" | tr '[:upper:]' '[:lower:]' | xargs 2>/dev/null)

        if [ "$re_limpia" != "e" ] && [ "$re_limpia" != "x" ] && [ "$re_limpia" != "ejecutar" ]; then
            break
        fi
    done
}


# -----------------------------------------------------------------------------
# 3.2. mostrar_lista()
# -----------------------------------------------------------------------------
# Muestra una lista de comandos con paginación limpia de 15 elementos.
#
mostrar_lista() {
    local -n items=$1
    local titulo="$2"
    local total=${#items[@]}
    local por_pagina=15
    local pagina=0
    local total_paginas=$(( (total + por_pagina - 1) / por_pagina ))

    local max_len=0
    for item in "${items[@]}"; do
        IFS='|' read -r cmd_tmp desc_tmp ej_tmp exp_tmp cat_tmp <<< "$item"
        if [ ${#cmd_tmp} -gt $max_len ]; then
            max_len=${#cmd_tmp}
        fi
    done
    local ancho_col=$((max_len + 3))
    if [ $ancho_col -lt 12 ]; then
        ancho_col=12
    elif [ $ancho_col -gt 38 ]; then
        ancho_col=38
    fi

    while true; do
        clear
        echo
        if [ $total_paginas -gt 1 ]; then
            echo "  ${C}$titulo${R} ${D}(Página $((pagina+1)) de $total_paginas - Total: $total)${R}"
        else
            echo "  ${C}$titulo${R} ${D}(Total: $total)${R}"
        fi
        echo "  ${B}──────────────────────────────────────────────────────────────────────────────────${R}"

        local inicio=$((pagina * por_pagina))
        local fin=$((inicio + por_pagina))
        if [ $fin -gt $total ]; then
            fin=$total
        fi

        for (( i=inicio; i<fin; i++ )); do
            IFS='|' read -r cmd desc ej exp cat <<< "${items[$i]}"
            printf "  ${G}%2d)${R} ${C}%-*s${R} %s\n" "$((i+1))" "$ancho_col" "$cmd" "$desc"
        done

        echo "  ${B}──────────────────────────────────────────────────────────────────────────────────${R}"

        local num_inicio=$((inicio + 1))
        local num_fin=$fin

        echo "  ${D}• Ver / Ejecutar:${R} Escribe el número (${G}$num_inicio-$num_fin${R}) para ver detalle, o ${G}e<número>${R} para ejecutar directo."
        if [ $total_paginas -gt 1 ]; then
            if [ $((pagina + 1)) -lt $total_paginas ] && [ $pagina -gt 0 ]; then
                echo "  ${D}• Cambiar pág:${R}   Escribe ${G}n${R} (siguiente) o ${G}p${R} (anterior)."
            elif [ $((pagina + 1)) -lt $total_paginas ]; then
                echo "  ${D}• Cambiar pág:${R}   Escribe ${G}n${R} (o ${G}s${R}) y pulsa Enter para la siguiente página."
            elif [ $pagina -gt 0 ]; then
                echo "  ${D}• Cambiar pág:${R}   Escribe ${G}p${R} (o ${G}a${R}) y pulsa Enter para la página anterior."
            fi
        fi
        echo "  ${D}• Volver al menú:${R} Presiona la tecla ${G}Enter${R}."
        echo "  ${B}──────────────────────────────────────────────────────────────────────────────────${R}"
        echo
        read -p "  > " resp
        resp_limpia=$(echo "$resp" | tr '[:upper:]' '[:lower:]' | xargs 2>/dev/null)

        if [ "$resp_limpia" = "n" ] || [ "$resp_limpia" = "s" ]; then
            if [ $((pagina + 1)) -lt $total_paginas ]; then
                pagina=$((pagina + 1))
            fi
        elif [ "$resp_limpia" = "p" ] || [ "$resp_limpia" = "a" ]; then
            if [ $pagina -gt 0 ]; then
                pagina=$((pagina - 1))
            fi
        elif [[ "$resp_limpia" =~ ^e[0-9]+$ ]] || [[ "$resp_limpia" =~ ^x[0-9]+$ ]]; then
            local num_ejecutar="${resp_limpia#?}"
            if [ "$num_ejecutar" -ge 1 ] && [ "$num_ejecutar" -le $total ]; then
                local item_sel="${items[$((num_ejecutar-1))]}"
                IFS='|' read -r cmd_sel desc_sel ej_sel exp_sel cat_sel <<< "$item_sel"
                ejecutar_comando "$cmd_sel" "$ej_sel" "$cat_sel" "$exp_sel"
            fi
        elif [[ "$resp" =~ ^[0-9]+$ ]] && [ "$resp" -ge 1 ] && [ "$resp" -le $total ]; then
            local item_sel="${items[$((resp-1))]}"
            IFS='|' read -r cmd_sel desc_sel ej_sel exp_sel cat_sel <<< "$item_sel"
            detalle "$item_sel"
            echo
            if [ "$cat_sel" != "atajos" ]; then
                echo "  ${D}• Acciones:${R} Presiona ${G}e${R} (o ${G}x${R}) para ejecutar este comando, o ${G}Enter${R} para volver."
                read -p "  > " resp_det
                local resp_det_limpia
                resp_det_limpia=$(echo "$resp_det" | tr '[:upper:]' '[:lower:]' | xargs 2>/dev/null)
                if [ "$resp_det_limpia" = "e" ] || [ "$resp_det_limpia" = "x" ] || [ "$resp_det_limpia" = "ejecutar" ]; then
                    ejecutar_comando "$cmd_sel" "$ej_sel" "$cat_sel" "$exp_sel"
                fi
            else
                read -p "  Presiona Enter para continuar..."
            fi
        elif [ -z "$resp" ] || [ "$resp_limpia" = "q" ] || [ "$resp_limpia" = "0" ] || [ "$resp_limpia" = "m" ]; then
            break
        fi
    done
}


# -----------------------------------------------------------------------------
# 3.3. listar()
# -----------------------------------------------------------------------------
listar() {
    local filtro="$1"
    local titulo="$2"
    local entries=()

    for entry in "${CMDS[@]}"; do
        IFS='|' read -r cmd desc ej exp cat <<< "$entry"
        if [ -z "$filtro" ] || [ "$cat" = "$filtro" ]; then
            entries+=("$entry")
        fi
    done

    if [ ${#entries[@]} -eq 0 ]; then
        echo
        echo "  No hay comandos registrados en esta categoría."
        read -p "  Enter para volver..."
        return
    fi

    mostrar_lista entries "$titulo"
}


# -----------------------------------------------------------------------------
# 3.4. buscar()
# -----------------------------------------------------------------------------
buscar() {
    local q="$1"
    local q_lower
    q_lower=$(echo "$q" | tr '[:upper:]' '[:lower:]')
    local entries=()

    for entry in "${CMDS[@]}"; do
        IFS='|' read -r cmd desc ej exp cat <<< "$entry"
        local item_lower
        item_lower=$(echo "$cmd $desc $exp $cat" | tr '[:upper:]' '[:lower:]')
        if [[ "$item_lower" == *"$q_lower"* ]]; then
            entries+=("$entry")
        fi
    done

    if [ ${#entries[@]} -eq 0 ]; then
        echo
        echo "  No se encontraron resultados para: \"$q\""
        read -p "  Presiona Enter para volver..."
        return
    fi

    mostrar_lista entries "RESULTADOS PARA \"$q\":"
}


# -----------------------------------------------------------------------------
# 3.5. menu()
# -----------------------------------------------------------------------------
menu() {
    while true; do
        clear

        echo
        echo "  ${B}╭─────────────────────────────────────────────────╮${R}"
        echo "  ${B}│${R}          ${C}AYUDA INTERACTIVA DE COMANDOS${R}          ${B}│${R}"
        echo "  ${B}│${R}   ${D}Escribe una opción o una palabra para buscar${R}  ${B}│${R}"
        echo "  ${B}╰─────────────────────────────────────────────────╯${R}"
        echo

        echo "  ${C}CATEGORÍAS:${R}"
        echo "    ${G}1)${R} Archivos y carpetas"
        echo "    ${G}2)${R} Ver contenido de archivos"
        echo "    ${G}3)${R} Buscar"
        echo "    ${G}4)${R} Texto y tuberías"
        echo "    ${G}5)${R} Sistema y procesos"
        echo "    ${G}6)${R} Redes, SSH y cortafuegos"
        echo "    ${G}7)${R} Atajos de teclado"
        echo "    ${G}8)${R} Ver TODO"
        echo

        echo "  ${C}BUSCAR:${R}"
        echo "    Escribe cualquier palabra y pulsa Enter."
        echo "    ${D}Ejemplos: ssh, puerto, ufw, borrar, proceso, red, grep...${R}"
        echo

        echo "  ${C}SALIR:${R}"
        echo "    ${G}0${R} o ${G}q${R}"
        echo

        read -p "  ${C}>${R} " opcion
        opcion_limpia=$(echo "$opcion" | tr '[:upper:]' '[:lower:]' | xargs 2>/dev/null)

        case "$opcion_limpia" in
            1|1\)*|1.*|archivos|archivos*) listar "archivos" "ARCHIVOS Y CARPETAS" ;;
            2|2\)*|2.*|ver|ver*)           listar "ver"      "VER CONTENIDO DE ARCHIVOS" ;;
            3|3\)*|3.*|buscar|buscar*)     listar "buscar"   "BUSCAR" ;;
            4|4\)*|4.*|texto|texto*)       listar "texto"    "TEXTO Y TUBERÍAS" ;;
            5|5\)*|5.*|sistema|sistema*)   listar "sistema"  "SISTEMA Y PROCESOS" ;;
            6|6\)*|6.*|redes|redes*|red*)  listar "redes"    "REDES, SSH Y PUERTOS" ;;
            7|7\)*|7.*|atajos|atajos*)     listar "atajos"   "ATAJOS DE TECLADO" ;;
            8|8\)*|8.*|todo|ver\ todo)     listar ""         "TODOS LOS COMANDOS" ;;
            0|q|salir|exit) clear; exit 0 ;;
            "") ;;
            *) buscar "$opcion" ;;
        esac
    done
}


# =============================================================================
# 4. PUNTO DE ENTRADA
# =============================================================================
if [ -n "$1" ]; then
    buscar "$1"
    read -p "  Enter para ir al menú principal..."
fi

menu