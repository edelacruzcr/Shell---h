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
#  amigable. Puedes navegar por categorías, buscar por palabra clave y ver
#  el detalle de cada comando con ejemplo y explicación.
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
# 1. COLORES Y ESTILOS (Paleta amigable y moderna)
# =============================================================================
G=$'\033[1;32m'   # Verde esmeralda → comandos y números
C=$'\033[1;36m'   # Cian brillante  → títulos de sección
B=$'\033[1;34m'   # Azul suave      → recuadros y bordes amigables
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
  "pwd|muestra en qué carpeta estás|pwd|Imprime la ruta completa de la carpeta en la que estás trabajando.\n\n  • Sintaxis: pwd\n  • Argumentos: No requiere argumentos.\n  • Opciones útiles:\n    - pwd -P : Muestra la ruta física real resolviendo enlaces simbólicos.\n  • Qué más puedes hacer: Usar '\$(pwd)' dentro de scripts para guardar la ubicación actual en variables.|archivos"
  "cd <nombre_de_carpeta>|entra a una carpeta|cd Documentos|Cambia tu ubicación actual al directorio especificado.\n\n  • Sintaxis: cd <nombre_de_carpeta>\n  • Ejemplos útiles:\n    - cd Documentos/Proyectos  → Entra a carpetas anidadas.\n    - cd /var/log             → Usa ruta absoluta desde la raíz.\n  • Tip: Presiona la tecla Tab para autocompletar el nombre de la carpeta.|archivos"
  "cd ..|sube al directorio padre|cd ..|Navega un nivel hacia arriba en la jerarquía de carpetas.\n\n  • Sintaxis: cd ..\n  • Qué más puedes hacer:\n    - cd ../..        → Sube dos niveles seguidos.\n    - cd ../../Fotos  → Sube dos niveles y entra a la carpeta Fotos.|archivos"
  "cd ~|va a tu carpeta personal|cd ~|Navega directamente a tu directorio personal (Home del usuario).\n\n  • Sintaxis: cd ~ (o simplemente 'cd' sin argumentos)\n  • Qué representa '~': Es un atajo para '/home/tu_usuario'.\n  • Ejemplo: cd ~/Descargas  → Va directo a tu carpeta de descargas desde cualquier lugar.|archivos"
  "cd -|vuelve a la carpeta anterior|cd -|Regresa al último directorio en el que estuviste antes del comando cd previo.\n\n  • Sintaxis: cd -\n  • Qué más puedes hacer: Es muy útil para alternar rápidamente entre dos carpetas lejanas en la terminal (\$OLDPWD).|archivos"
  "ls|lista archivos y carpetas|ls|Muestra los nombres de los archivos y carpetas del directorio actual.\n\n  • Sintaxis: ls [ruta_opcional]\n  • Opciones comunes:\n    - ls /var/log  → Lista el contenido de otra carpeta especificada.\n  • Tip: Por defecto no muestra archivos ocultos que empiezan con punto (.).|archivos"
  "ls -lah|lista todo con detalles|ls -lah|Muestra una lista detallada con permisos, propietario, tamaño y fecha de modificación.\n\n  • Sintaxis: ls -lah [ruta_opcional]\n  • Desglose de banderas:\n    - -l : Formato largo detallado (permisos, dueño, bytes, fecha).\n    - -a : Incluye archivos ocultos (los que inician con '.').\n    - -h : Muestra tamaños legibles para humanos (KB, MB, GB).\n  • Opciones extra:\n    - ls -laht : Ordena los archivos por fecha de modificación (los más recientes primero).\n    - ls -lahS : Ordena los archivos por tamaño (los más grandes primero).|archivos"
  "mkdir <nombre_de_carpeta>|crea una nueva carpeta|mkdir MisDocumentos|Crea un directorio o carpeta nueva en la ubicación actual.\n\n  • Sintaxis: mkdir <nombre_de_carpeta>\n  • Ejemplos:\n    - mkdir Proyecto1 Proyecto2  → Crea múltiples carpetas al mismo tiempo.\n    - mkdir \"Mi Carpeta\"        → Usa comillas si el nombre contiene espacios.|archivos"
  "mkdir -p <ruta/anidada>|crea carpetas con subcarpetas|mkdir -p proyectos/2026/fotos|Crea la estructura completa de carpetas intermedias sin arrojar error si ya existen.\n\n  • Sintaxis: mkdir -p <ruta/completa/anidada>\n  • Opciones:\n    - -p (parents): Crea de forma automática todas las carpetas padres que no existan en la ruta.|archivos"
  "rmdir <nombre_de_carpeta>|elimina una carpeta vacía|rmdir CarpetaVacia|Elimina una carpeta únicamente si no contiene ningún archivo o subcarpeta.\n\n  • Sintaxis: rmdir <nombre_de_carpeta>\n  • Nota de seguridad: Si la carpeta tiene contenido, la terminal dará error (evita borrados accidentales). Usa 'rm -r' para carpetas con archivos.|archivos"
  "touch <nombre_de_archivo.txt>|crea un archivo vacío|touch notas.txt|Crea un archivo nuevo vacío o actualiza la fecha de modificación si el archivo ya existe.\n\n  • Sintaxis: touch <nombre_de_archivo>\n  • Qué más puedes hacer:\n    - touch archivo1.txt archivo2.txt  → Crea varios archivos vacíos a la vez.\n    - Sirve para preparar archivos antes de editarlos con nano o VS Code.|archivos"
  "cp <origen.txt> <destino.txt>|copia un archivo|cp notas.txt copia_notas.txt|Copia un archivo desde una ruta de origen a una de destino.\n\n  • Sintaxis: cp <archivo_origen> <archivo_destino>\n  • Ejemplos útiles:\n    - cp notas.txt ~/Documentos/  → Copia el archivo a otra carpeta manteniendo su nombre.\n    - cp -i notas.txt copia.txt   → Pide confirmación antes de sobrescribir si el destino ya existe.|archivos"
  "cp -r <carpeta_origen> <destino>|copia una carpeta completa|cp -r Fotos/ CopiaFotos/|Copia un directorio completo con todos sus archivos y subcarpetas anidadas.\n\n  • Sintaxis: cp -r <carpeta_origen> <carpeta_destino>\n  • Banderas claves:\n    - -r (recursive): Obligatorio para procesar todo el contenido interno de la carpeta.|archivos"
  "mv <origen> <destino>|mueve o renombra|mv viejo.txt nuevo.txt|Mueve archivos/carpetas a otra ubicación o los renombra si están en la misma ruta.\n\n  • Sintaxis: mv <origen> <destino>\n  • Ejemplos:\n    - Renombrar: mv datos.txt final.txt\n    - Mover:     mv archivo.txt ~/Documentos/\n  • Opción recomendada:\n    - mv -i origen destino  → Pide confirmación si va a sobrescribir un archivo existente.|archivos"
  "rm <nombre_de_archivo.txt>|elimina un archivo|rm archivo_viejo.txt|Elimina un archivo de manera permanente del sistema de archivos.\n\n  • Sintaxis: rm <nombre_de_archivo>\n  • ADVERTENCIA: En la terminal de Linux NO hay papelera de reciclaje; la eliminación es instantánea y definitiva.|archivos"
  "rm -r <nombre_de_carpeta>|elimina carpeta y contenido|rm -r CarpetaObsoleta|Elimina de forma recursiva una carpeta junto con todos sus archivos y subcarpetas internas.\n\n  • Sintaxis: rm -r <nombre_de_carpeta>\n  • Opción de fuerza bruta:\n    - rm -rf <carpeta>  → Fuerza la eliminación ignorando advertencias y permisos de lectura.\n  • PRECAUCIÓN EXTREMA: Revisa bien la ruta antes de usar '-rf'.|archivos"
  "rm -i <nombre_de_archivo.txt>|elimina pidiendo confirmación|rm -i documento.pdf|Pide confirmación previa ('y' o 'n') en pantalla antes de borrar cada archivo.\n\n  • Sintaxis: rm -i <nombre_de_archivo>\n  • Recomendación: Excelente práctica para aprendices al borrar archivos importantes o usar comodines (ej: rm -i *.txt).|archivos"
  "ln -s <ruta_real> <enlace>|crea un acceso directo|ln -s /var/www/html mi_web|Crea un enlace simbólico (acceso directo) hacia un archivo o carpeta en el sistema.\n\n  • Sintaxis: ln -s <objetivo_original> <nombre_del_acceso_directo>\n  • Qué más puedes hacer: Te permite acceder rápidamente a rutas profundas o compartir librerías sin duplicar archivos.|archivos"
  "tar -czvf <archivo.tar.gz> <carpeta>|comprime carpeta en tar.gz|tar -czvf respaldo.tar.gz MisDocumentos/|Comprime y empaqueta una carpeta completa en un archivo comprimido .tar.gz.\n\n  • Sintaxis: tar -czvf <nombre.tar.gz> <carpeta_a_comprimir>\n  • Explicación de banderas:\n    - -c : Crear un nuevo paquete.\n    - -z : Comprimir usando el algoritmo Gzip.\n    - -v : Mostrar en pantalla cada archivo procesado (Verbose).\n    - -f : Especificar el nombre del archivo resultante.|archivos"
  "tar -xzvf <archivo.tar.gz>|descomprime archivo tar.gz|tar -xzvf respaldo.tar.gz|Descomprime y extrae todo el contenido de un paquete comprimido .tar.gz.\n\n  • Sintaxis: tar -xzvf <archivo.tar.gz>\n  • Qué más puedes hacer:\n    - tar -xzvf archivo.tar.gz -C /ruta/destino  → Extrae el contenido directamente en otra carpeta especificada.|archivos"
  "zip -r <archivo.zip> <carpeta>|crea archivo comprimido zip|zip -r mis_fotos.zip Fotos/|Crea un paquete comprimido en formato estándar .zip compatible con Windows y macOS.\n\n  • Sintaxis: zip -r <nombre_final.zip> <carpeta_o_archivos>\n  • Opción importante:\n    - -r (recursive): Necesario para incluir subcarpetas y archivos internos.|archivos"
  "unzip <archivo.zip>|extrae un archivo zip|unzip mis_fotos.zip|Extrae el contenido completo de un archivo comprimido .zip en la carpeta actual.\n\n  • Sintaxis: unzip <archivo.zip>\n  • Qué más puedes hacer:\n    - unzip -l archivo.zip       → Lista el contenido del ZIP sin extraerlo.\n    - unzip archivo.zip -d /ruta → Extrae en un directorio destino específico.|archivos"
  "chown <usuario>:<grupo> <archivo>|cambia propietario y grupo|chown juan:desarrollo notas.txt|Modifica el usuario dueño y el grupo asignado a un archivo o carpeta en el sistema.\n\n  • Sintaxis: chown <usuario>:<grupo> <archivo_o_carpeta>\n  • Qué más puedes hacer:\n    - sudo chown -R usuario:grupo carpeta/  → Cambia el propietario de forma recursiva a todo el contenido interno.|archivos"

  # ---------------------------------------------------------------------------
  # CATEGORÍA: ver
  # ---------------------------------------------------------------------------
  "cat <nombre_de_archivo.txt>|muestra todo el contenido|cat notas.txt|Imprime el contenido completo de uno o varios archivos en la terminal.\n\n  • Sintaxis: cat <nombre_de_archivo.txt>\n  • Qué más puedes hacer con cat:\n    - cat a.txt b.txt > unificado.txt → Une (concatena) dos archivos en uno solo nuevo.\n    - cat -n notas.txt                → Muestra el contenido enumerando cada línea.\n    - cat > nuevo_archivo.txt          → Escribe texto directamente desde la terminal hasta presionar Ctrl+D.\n  • Tip: Para archivos muy largos prefiere usar 'less' para no saturar la pantalla.|ver"
  "less <nombre_de_archivo.txt>|visualiza por páginas navegables|less log_sistema.txt|Abre un visor interactivo amigable para leer archivos grandes página por página.\n\n  • Sintaxis: less <nombre_de_archivo.txt>\n  • Mandos interactivos dentro de less:\n    - Flechas / RePág / AvPág : Desplazar el texto arriba y abajo.\n    - /texto_a_buscar         : Busca una palabra dentro del archivo (N para siguiente coincidencia).\n    - g / G                   : Salta al inicio (g) o al final (G) del archivo.\n    - q                       : Salir del visor y regresar al terminal.|ver"
  "more <nombre_de_archivo.txt>|visor página por página clásico|more documento.txt|Visualizador clásico de texto por páginas.\n\n  • Sintaxis: more <nombre_de_archivo.txt>\n  • Controles:\n    - Barra espaciadora : Avanza una página completa.\n    - Enter             : Avanza línea por línea.\n    - q                 : Sale del visor inmediatamente.|ver"
  "head <nombre_de_archivo.txt>|muestra primeras 10 líneas|head lista_contactos.txt|Muestra únicamente las primeras 10 líneas iniciales de un archivo de texto.\n\n  • Sintaxis: head <nombre_de_archivo.txt>\n  • Qué más puedes hacer: Es ideal para revisar rápidamente la cabecera o estructura de archivos CSV o logs sin cargar todo el archivo.|ver"
  "head -n <numero> <archivo.txt>|muestra las N líneas iniciales|head -n 25 servidor.log|Imprime la cantidad exacta de líneas iniciales que le indiques.\n\n  • Sintaxis: head -n <numero_de_lineas> <nombre_de_archivo.txt>\n  • Ejemplo:\n    - head -n 5 datos.txt  → Imprime solo las primeras 5 líneas.|ver"
  "tail <nombre_de_archivo.txt>|muestra últimas 10 líneas|tail historial.log|Muestra únicamente las últimas 10 líneas finales de un archivo.\n\n  • Sintaxis: tail <nombre_de_archivo.txt>\n  • Uso común: Consultar los registros o eventos más recientes generados por un programa.|ver"
  "tail -n <numero> <archivo.txt>|muestra las N líneas finales|tail -n 50 errores.log|Imprime la cantidad especificada de líneas finales de un archivo.\n\n  • Sintaxis: tail -n <numero_de_lineas> <nombre_de_archivo.txt>\n  • Ejemplo:\n    - tail -n 100 app.log  → Imprime las últimas 100 líneas del registro.|ver"
  "tail -f <nombre_de_archivo.log>|monitorea cambios en tiempo real|tail -f /var/log/syslog|Mantiene el archivo abierto y muestra en vivo cada nueva línea agregada.\n\n  • Sintaxis: tail -f <nombre_de_archivo.log>\n  • Qué más puedes hacer:\n    - Para detener el seguimiento en vivo pulsa la combinación de teclas Ctrl+C.\n    - tail -f -n 20 app.log  → Muestra las últimas 20 líneas y se queda monitoreando en tiempo real.|ver"
  "wc -l <nombre_de_archivo.txt>|cuenta total de líneas|wc -l lista_usuarios.txt|Cuenta la cantidad exactas de líneas de texto presentes en un archivo.\n\n  • Sintaxis: wc -l <nombre_de_archivo.txt>\n  • Qué más puedes hacer: Combinarlo con tuberías para contar resultados, ej: 'ls | wc -l' cuenta cuántos archivos hay en la carpeta.|ver"
  "wc -w <nombre_de_archivo.txt>|cuenta total de palabras|wc -w ensayo.txt|Cuenta el número de palabras contenidas en el archivo.\n\n  • Sintaxis: wc -w <nombre_de_archivo.txt>\n  • Opciones adicionales de wc:\n    - wc -c archivo.txt  → Cuenta la cantidad de bytes/caracteres.|ver"
  "nl <nombre_de_archivo.txt>|imprime texto con líneas numeradas|nl script.sh|Imprime el contenido de un archivo anteponiendo el número de línea correspondiente.\n\n  • Sintaxis: nl <nombre_de_archivo.txt>\n  • Qué más puedes hacer: Facilita encontrar líneas específicas en archivos de código fuente o configuración.|ver"
  "column -t <archivo.txt>|alinea datos en columnas limpias|column -t datos.csv|Analiza el texto y alinea dinámicamente las palabras en columnas ordenadas.\n\n  • Sintaxis: column -t <nombre_de_archivo.txt>\n  • Qué más puedes hacer:\n    - column -t -s',' archivo.csv  → Especifica la coma (,) como separador de columnas.|ver"
  "xxd <nombre_de_archivo>|ver contenido en código hexadecimal|xxd imagen.png|Muestra una volcado hexadecimal y su representación ASCII equivalente lado a lado.\n\n  • Sintaxis: xxd <nombre_de_archivo>\n  • Qué más puedes hacer:\n    - xxd -l 64 archivo.bin  → Muestra únicamente los primeros 64 bytes en hexadecimal.|ver"
  "hexdump -C <nombre_de_archivo>|inspecciona bytes en formato hex|hexdump -C datos.raw|Inspecciona el contenido interno byte a byte de archivos binarios o ejecutables.\n\n  • Sintaxis: hexdump -C <nombre_de_archivo>\n  • Opción -C: Muestra el volcado canónico en formato hexadecimal y texto ASCII.|ver"
  "view <nombre_de_archivo.txt>|abre en Vim en modo solo lectura|view archivo_protegido.conf|Abre un archivo con el editor Vim bloqueando cambios accidentales.\n\n  • Sintaxis: view <nombre_de_archivo.txt>\n  • Ventaja: Permite usar la potencia de búsqueda y navegación de Vim sin riesgo de modificar el archivo.|ver"

  # ---------------------------------------------------------------------------
  # CATEGORÍA: buscar
  # ---------------------------------------------------------------------------
  "grep <texto_a_buscar> <archivo.txt>|busca una palabra en un archivo|grep error log.txt|Busca e imprime todas las líneas que contengan la palabra o texto especificado.\n\n  • Sintaxis: grep <texto_a_buscar> <nombre_de_archivo.txt>\n  • Ejemplos:\n    - grep \"Falló la conexión\" app.log  → Usa comillas si el texto tiene espacios.|buscar"
  "grep -i <texto> <archivo.txt>|busca ignorando mayúsculas|grep -i error log.txt|Busca coincidencias sin hacer distinción entre mayúsculas y minúsculas.\n\n  • Sintaxis: grep -i <texto_a_buscar> <nombre_de_archivo.txt>\n  • Ventaja: Encuentra 'ERROR', 'Error', 'error' o 'eRrOr' indistintamente.|buscar"
  "grep -r <texto> <carpeta>|busca en todos los archivos del dir|grep -r TODO ./src|Busca la palabra indicada en todos los archivos de la carpeta y sus subcarpetas.\n\n  • Sintaxis: grep -r <texto_a_buscar> <directorio>\n  • Opciones combinadas muy útiles:\n    - grep -rn \"mi_funcion\" .  → Busca recursivamente y muestra el número de línea de cada hallazgo.|buscar"
  "grep -n <texto> <archivo.txt>|muestra el número de línea|grep -n ERROR log.txt|Antepone el número de línea exacto a cada coincidencia encontrada.\n\n  • Sintaxis: grep -n <texto_a_buscar> <nombre_de_archivo.txt>\n  • Utilidad: Te ayuda a ubicar rápidamente en qué línea de código ocurrió un suceso.|buscar"
  "grep -v <texto> <archivo.txt>|filtra e imprime lo que NO coincide|grep -v INFO sistema.log|Muestra únicamente las líneas que NO contengan la palabra especificada.\n\n  • Sintaxis: grep -v <texto_a_excluir> <nombre_de_archivo.txt>\n  • Uso común: Filtrar mensajes basura o informativos para conservar solo advertencias o fallos.|buscar"
  "grep -c <texto> <archivo.txt>|cuenta cuántas líneas coinciden|grep -c WARNING app.log|Muestra el conteo numérico total de líneas que coinciden sin imprimir el texto.\n\n  • Sintaxis: grep -c <texto_a_buscar> <nombre_de_archivo.txt>|buscar"
  "grep -w <palabra> <archivo.txt>|busca únicamente la palabra exacta|grep -w \"fin\" notas.txt|Evita coincidencias parciales (ej: 'fin' no coincidirá con 'final' ni 'definir').\n\n  • Sintaxis: grep -w <palabra_exacta> <nombre_de_archivo.txt>|buscar"
  "grep -E '<regex>' <archivo.txt>|busca usando expresiones regulares|grep -E '[0-9]{3}' datos.txt|Permite utilizar expresiones regulares avanzadas POSIX ERE (patrones complejos).\n\n  • Sintaxis: grep -E '<patron_expresion_regular>' <nombre_de_archivo.txt>\n  • Ejemplo:\n    - grep -E \"error|warning\" log.txt  → Busca líneas que contengan 'error' O 'warning'.|buscar"
  "find <dir> -name <patron>|busca archivos por nombre|find . -name \"*.txt\"|Realiza una búsqueda profunda en el sistema de archivos según el nombre especificado.\n\n  • Sintaxis: find <directorio_inicio> -name \"<patron_buscado>\"\n  • Opciones clave:\n    - find . -iname \"*.JPG\"  → Ignora mayúsculas/minúsculas (-iname).\n  • Tip: Encierra siempre los patrones con comodines (*) entre comillas para evitar fallos.|buscar"
  "find <dir> -type f|busca únicamente archivos|find ./documentos -type f|Filtra la búsqueda para devolver exclusivamente archivos, ignorando carpetas.\n\n  • Sintaxis: find <directorio_inicio> -type f\n  • Combinaciones:\n    - find . -type f -name \"*.py\"  → Busca solo archivos que terminen en .py.|buscar"
  "find <dir> -type d|busca únicamente carpetas|find . -type d|Filtra la búsqueda para mostrar exclusivamente carpetas o directorios.\n\n  • Sintaxis: find <directorio_inicio> -type d|buscar"
  "find <dir> -size +<peso>|busca archivos por peso/tamaño|find . -size +50M|Busca elementos filtrados por su peso en disco (ej: mayores a 50 MegaBytes).\n\n  • Sintaxis: find <directorio_inicio> -size [+ o -]<tamaño>[k|M|G]\n  • Ejemplos:\n    - find /var/log -size +100M  → Busca archivos de más de 100MB.\n    - find . -size -10k         → Busca archivos menores a 10KB.|buscar"
  "find <dir> -mtime -<dias>|busca modificados recientemente|find . -mtime -7|Encuentra archivos modificados en los últimos N días especificados.\n\n  • Sintaxis: find <directorio_inicio> -mtime -<numero_de_dias>\n  • Ejemplos:\n    - find . -mtime -1  → Archivos modificados en las últimas 24 horas.\n    - find . -mtime +30 → Archivos modificados hace más de 30 días.|buscar"
  "find <dir> -empty|busca archivos o carpetas vacías|find . -empty|Ubica de inmediato todos los archivos o carpetas que tienen 0 bytes de contenido.\n\n  • Sintaxis: find <directorio_inicio> -empty\n  • Qué más puedes hacer:\n    - find . -type f -empty -delete  → Busca y elimina automáticamente archivos vacíos.|buscar"
  "which <comando>|muestra la ruta del ejecutable|which python3|Localiza e imprime la ruta absoluta del binario ejecutable que usa el sistema.\n\n  • Sintaxis: which <nombre_de_comando>\n  • Ejemplo: which node → Muestra por ejemplo '/usr/bin/node'.|buscar"
  "whereis <comando>|ubica ejecutable, código y manual|whereis bash|Muestra la ubicación del binario, las fuentes y las páginas de manual de un programa.\n\n  • Sintaxis: whereis <nombre_de_comando>|buscar"
  "locate <archivo>|búsqueda rápida en el índice|locate nginx.conf|Realiza una búsqueda ultra rápida consultando la base de datos de archivos indexados.\n\n  • Sintaxis: locate <nombre_de_archivo>\n  • Tip: Si recién creaste un archivo ejecuta antes 'sudo updatedb' para actualizar el índice.|buscar"
  "fd <nombre>|alternativa rápida a find|fd notas|Busca archivos de forma interactiva, coloreada y mucho más rápida que el comando find tradicional.\n\n  • Sintaxis: fd <nombre_o_patron>\n  • Nota: Requiere tener instalada la herramienta 'fd-find'.|buscar"

  # ---------------------------------------------------------------------------
  # CATEGORÍA: texto
  # ---------------------------------------------------------------------------
  "echo <mensaje>|imprime un texto en la consola|echo \"Hola Mundo\"|Muestra una cadena de texto o el contenido de variables en la salida estándar de la terminal.\n\n  • Sintaxis: echo \"<mensaje_a_imprimir>\"\n  • Opciones útiles:\n    - echo -e \"Línea 1\nLínea 2\"  → Habilita la interpretación de saltos de línea (\n) y tabulaciones (\t).|texto"
  "echo \$<VARIABLE>|muestra el valor de una variable|echo \$HOME|Muestra el contenido de variables de entorno o del sistema.\n\n  • Sintaxis: echo \$<NOMBRE_DE_VARIABLE>\n  • Ejemplos útiles:\n    - echo \$USER  → Muestra el nombre de tu usuario actual.\n    - echo \$PATH  → Muestra las rutas de ejecución de comandos.|texto"
  "echo <texto> > <archivo.txt>|guarda texto sobrescribiendo el archivo|echo \"nuevo texto\" > notas.txt|Escribe texto en un archivo. Si el archivo ya existía, borra todo su contenido previo.\n\n  • Sintaxis: echo \"<texto>\" > <nombre_de_archivo.txt>\n  • CUIDADO: El operador '>' reemplaza por completo el contenido existente.|texto"
  "echo <texto> >> <archivo.txt>|añade texto al final del archivo|echo \"nueva linea\" >> log.txt|Añade o concatena texto al final de un archivo sin modificar lo que ya tenía dentro.\n\n  • Sintaxis: echo \"<texto>\" >> <nombre_de_archivo.txt>\n  • Operador '>>': Agrega al final (append). Si el archivo no existe, lo crea automáticamente.|texto"
  "cmd1 | cmd2|tubería: envía salida de cmd1 a cmd2|ls -la | grep \".txt\"|Conecta y canaliza la salida de un comando para que sea procesada como entrada de otro.\n\n  • Sintaxis: <comando_salida> | <comando_procesador>\n  • Ejemplos clásicos:\n    - cat usuarios.txt | sort      → Lee el archivo y ordena su texto alfabéticamente.\n    - ps aux | grep \"firefox\"      → Obtiene los procesos y filtra solo los de Firefox.|texto"
  "cmd < <archivo.txt>|envía contenido de archivo como entrada|sort < lista.txt|Lee el contenido de un archivo y lo envía directamente a la entrada de un comando.\n\n  • Sintaxis: <comando> < <nombre_de_archivo.txt>|texto"
  "sort <archivo.txt>|ordena alfabéticamente las líneas|sort nombres.txt|Lee las líneas de un archivo y las imprime en pantalla ordenadas alfabéticamente.\n\n  • Sintaxis: sort <nombre_de_archivo.txt>\n  • Opciones clave:\n    - sort -r lista.txt  → Ordena en sentido inverso (Z a A).|texto"
  "sort -n <archivo.txt>|ordena de forma numérica correcta|sort -n precios.txt|Ordena las líneas interpretando los valores como números reales (evita que 10 vaya antes que 2).\n\n  • Sintaxis: sort -n <nombre_de_archivo.txt>|texto"
  "sort -u <archivo.txt>|ordena y elimina líneas duplicadas|sort -u correos.txt|Ordena el texto del archivo y elimina de forma automática todas las líneas repetidas.\n\n  • Sintaxis: sort -u <nombre_de_archivo.txt>|texto"
  "uniq -c <archivo.txt>|cuenta líneas repetidas consecutivas|sort lista.txt | uniq -c|Cuenta la cantidad de repeticiones de cada línea contigua presente en el texto.\n\n  • Sintaxis: uniq -c <nombre_de_archivo.txt>\n  • TIP CLAVE: 'uniq' solo detecta líneas duplicadas consecutivas; por eso siempre se debe usar 'sort' antes ('sort archivo | uniq -c').|texto"
  "cut -d',' -f1 <archivo.csv>|extrae columnas especificando delimitador|cut -d',' -f1 datos.csv|Corta cada línea de texto y extrae columnas específicas indicando el separador.\n\n  • Sintaxis: cut -d'<caracter_delimitador>' -f<numero_columna> <archivo>\n  • Ejemplos:\n    - cut -d':' -f1 /etc/passwd  → Extrae solo la primera columna (usuarios) del sistema.|texto"
  "tr '<origen>' '<destino>'|reemplaza o convierte caracteres|cat texto.txt | tr 'a-z' 'A-Z'|Transforma o sustituye conjuntos de caracteres (ej: convierte minúsculas a mayúsculas).\n\n  • Sintaxis: tr '<origen>' '<destino>'\n  • Qué más puedes hacer:\n    - tr -d '\r' < archivo.txt > limpio.txt  → Elimina saltos de línea estilo Windows (\r).|texto"
  "sed 's/<buscar>/<reemplazar>/g' <archivo>|reemplaza texto automáticamente|sed 's/localhost/127.0.0.1/g' config.txt|Potente editor de flujo para buscar y reemplazar patrones de texto en todo el archivo.\n\n  • Sintaxis: sed 's/<texto_buscar>/<nuevo_texto>/g' <nombre_de_archivo.txt>\n  • Opciones:\n    - sed -i 's/viejo/nuevo/g' archivo.txt  → Aplica los cambios directamente en el archivo original (-i = in place).|texto"
  "awk '{print \$1}' <archivo.txt>|procesa y filtra datos por columnas|awk '{print \$1, \$3}' tabla.txt|Lenguaje de procesamiento de datos por columnas y formateo de texto estructurado.\n\n  • Sintaxis: awk '{print \$<columna1>, \$<columna2>}' <nombre_de_archivo.txt>\n  • Ejemplo:\n    - ls -l | awk '{print \$9, \$5}'  → Imprime solo el nombre del archivo y su tamaño en bytes.|texto"
  "tee <archivo.txt>|guarda en archivo y muestra en pantalla|ls -la | tee reporte.txt|Recibe texto de una tubería, lo guarda en un archivo y simultáneamente lo imprime en pantalla.\n\n  • Sintaxis: <comando_salida> | tee <nombre_de_archivo.txt>\n  • Opción de agregar:\n    - comando | tee -a registro.txt  → Añade al final del archivo sin sobrescribir (-a = append).|texto"
  "rev <archivo.txt>|invierte el orden de los caracteres|rev palabras.txt|Invierte de atrás hacia adelante los caracteres de cada línea de texto.\n\n  • Sintaxis: rev <nombre_de_archivo.txt>|texto"

  # ---------------------------------------------------------------------------
  # CATEGORÍA: sistema
  # ---------------------------------------------------------------------------
  "sudo <comando>|ejecuta un comando como superusuario|sudo apt update|Ejecuta una instrucción individual otorgando privilegios temporales de superusuario (root).\n\n  • Sintaxis: sudo <comando_a_ejecutar>\n  • Solicitará la contraseña de tu usuario en la terminal para confirmar los permisos.|sistema"
  "sudo -i|abre consola continua como usuario root|sudo -i|Inicia una sesión de terminal interactiva continua como superusuario root.\n\n  • Sintaxis: sudo -i\n  • ADVERTENCIA: Cualquier comando ejecutado en modo root tiene control absoluto del sistema.\n  • Para salir del modo root escribe 'exit' o pulsa Ctrl+D.|sistema"
  "history|muestra historial de comandos pasados|history|Muestra la lista numerada de todas las instrucciones ejecutadas previamente en la terminal.\n\n  • Sintaxis: history\n  • Qué más puedes hacer:\n    - history | grep \"git\"  → Busca comandos pasados que contengan la palabra 'git'.|sistema"
  "history -d <linea>|borra una entrada del historial|history -d 150|Elimina la instrucción ubicada en el número de posición indicado dentro del historial.\n\n  • Sintaxis: history -d <numero_de_linea>|sistema"
  "history -c|limpia todo el historial de la sesión|history -c|Borra por completo el registro de comandos guardado en la memoria de la sesión actual.\n\n  • Sintaxis: history -c|sistema"
  "chmod +x <script.sh>|da permiso de ejecución a un archivo|chmod +x mi_script.sh|Añade permisos de ejecución a un script o binario para poder correrlo con './script.sh'.\n\n  • Sintaxis: chmod +x <nombre_de_archivo.sh>|sistema"
  "chmod 755 <script.sh>|asigna permisos estándar octales|chmod 755 script.sh|Aplica permisos numéricos: Propietario (Lectura/Escritura/Ejecución), Otros (Lectura/Ejecución).\n\n  • Sintaxis: chmod <codigo_octal> <nombre_de_archivo>\n  • Códigos octales comunes:\n    - 755 : Estándar para scripts y carpetas públicas.\n    - 600 : Solo lectura/escritura para el dueño (ideal para claves privadas o .env).\n    - 777 : Permisos totales a todos los usuarios (¡Peligro en seguridad!).|sistema"
  "df -h|muestra espacio libre en discos|df -h|Informa la capacidad total, espacio usado y disponible en todos los discos y particiones montadas.\n\n  • Sintaxis: df -h\n  • Opción -h: Muestra valores en formatos legibles (Megabytes GB, Gigabytes GB).|sistema"
  "du -sh <carpeta>|calcula el tamaño ocupado por una carpeta|du -sh /var/log|Muestra la cantidad total de espacio en disco que consume una carpeta especificada.\n\n  • Sintaxis: du -sh <nombre_de_carpeta_o_archivo>\n  • Desglose de banderas:\n    - -s : Muestra solo el resumen del total.\n    - -h : Formato legible para humanos (MB/GB).|sistema"
  "free -h|muestra la memoria RAM y SWAP libre|free -h|Desglosa el consumo actual, memoria libre, almacenamiento en caché y swap del sistema.\n\n  • Sintaxis: free -h\n  • Útil para diagnosticar cuando una computadora o servidor está lento por falta de RAM.|sistema"
  "ps aux|lista todos los procesos del sistema|ps aux|Genera un reporte detallado de cada proceso corriendo en el sistema con su PID, CPU y memoria.\n\n  • Sintaxis: ps aux\n  • Qué significan los campos principales:\n    - USER : Usuario dueño del proceso.\n    - PID  : Identificador único del proceso (Process ID).\n    - %CPU / %MEM : Porcentaje de recursos consumidos.|sistema"
  "ps aux | grep <proceso>|busca un proceso específico activo|ps aux | grep firefox|Combina 'ps aux' con 'grep' para encontrar el ID (PID) y detalles de un programa en ejecución.\n\n  • Sintaxis: ps aux | grep <nombre_del_programa>|sistema"
  "top|monitor interactivo de recursos en tiempo real|top|Abre una pantalla interactiva con el uso continuo de CPU, memoria RAM y procesos del sistema.\n\n  • Sintaxis: top\n  • Controles interactivos dentro de top:\n    - M : Ordenar procesos por uso de memoria RAM.\n    - P : Ordenar procesos por uso de procesador CPU.\n    - q : Salir del monitor.|sistema"
  "htop|monitor interactivo avanzado a colores|htop|Versión interactiva mejorada de top con soporte para ratón, barras de colores y filtrado fácil.\n\n  • Sintaxis: htop\n  • Requiere tener instalada la herramienta 'htop' en el sistema.|sistema"
  "kill -9 <pid>|fuerza la terminación de un proceso|kill -9 4821|Envía la señal estricta SIGKILL (-9) para cerrar de inmediato un proceso bloqueado usando su PID.\n\n  • Sintaxis: kill -9 <numero_PID_del_proceso>\n  • TIP: Obtén el número PID usando primero el comando 'ps aux | grep <nombre>'.|sistema"
  "killall <nombre>|cierra todos los procesos por su nombre|killall chrome|Finaliza al instante todos los procesos activos que coincidan exactamente con el nombre dado.\n\n  • Sintaxis: killall <nombre_del_proceso>|sistema"
  "uptime|muestra tiempo encendido y carga media|uptime|Informa cuántas horas/días lleva encendido el sistema y el nivel promedio de carga de trabajo.\n\n  • Sintaxis: uptime|sistema"
  "uname -a|muestra datos del kernel y arquitectura|uname -a|Imprime detalles completos del sistema operativo, versión del kernel Linux y arquitectura de procesador.\n\n  • Sintaxis: uname -a|sistema"
  "whoami|imprime el nombre del usuario activo|whoami|Muestra en pantalla el nombre del usuario con el que iniciaste sesión actualmente.\n\n  • Sintaxis: whoami|sistema"
  "ping <servidor_o_ip>|prueba conectividad de red con un host|ping google.com|Envía paquetes de prueba a un dominio o dirección IP para medir latencia y comprobar si hay internet.\n\n  • Sintaxis: ping <servidor_o_ip>\n  • Para detener el envío continuo de paquetes pulsa la combinación Ctrl+C.|sistema"

  # ---------------------------------------------------------------------------
  # CATEGORÍA: redes (SSH, Puertos y Firewall)
  # ---------------------------------------------------------------------------
  "ssh <usuario>@<servidor_ip>|conecta a servidor remoto por SSH|ssh root@192.168.1.50|Inicia una sesión de terminal remota segura cifrada hacia un servidor.\n\n  • Sintaxis: ssh <usuario>@<ip_o_dominio>\n  • Ejemplos:\n    - ssh admin@miservidor.com  → Conexión usando dominio.\n  • Tip: Para salir de la sesión SSH remota escribe 'exit' o presiona Ctrl+D.|redes"
  "ssh -p <puerto> <usuario>@<ip>|conecta SSH con puerto personalizado|ssh -p 2222 usuario@192.168.1.100|Conecta a un servidor SSH que utiliza un puerto diferente al estándar (22).\n\n  • Sintaxis: ssh -p <numero_puerto> <usuario>@<ip>|redes"
  "ssh-keygen -t rsa -b 4096|genera clave SSH pública y privada|ssh-keygen -t rsa -b 4096|Genera un par de llaves criptográficas para autenticarte en servidores sin usar contraseña.\n\n  • Las llaves se guardan automáticamente en la carpeta '~/.ssh/id_rsa' (privada) y '~/.ssh/id_rsa.pub' (pública).|redes"
  "ssh-copy-id <usuario>@<ip>|copia tu clave SSH a servidor remoto|ssh-copy-id root@192.168.1.50|Transfiere tu llave pública al servidor para iniciar sesión SSH automáticamente sin contraseña.\n\n  • Sintaxis: ssh-copy-id <usuario>@<ip_servidor>|redes"
  "scp <archivo> <usuario>@<ip>:<ruta>|copia archivo a servidor remoto por SSH|scp notas.txt usuario@192.168.1.50:/home/usuario/|Copia un archivo local hacia un servidor remoto de forma cifrada mediante SSH.\n\n  • Sintaxis: scp <archivo_local> <usuario>@<ip>:<ruta_destino>\n  • Para copiar DESDE el servidor a tu PC:\n    - scp usuario@ip:/ruta/remota.txt ./  → Trae el archivo a tu carpeta actual.|redes"
  "scp -r <carpeta> <usuario>@<ip>:<ruta>|copia carpeta completa a servidor SSH|scp -r Proyecto/ usuario@192.168.1.50:~/|Copia una carpeta completa con todo su contenido hacia un servidor remoto.\n\n  • Sintaxis: scp -r <carpeta_local> <usuario>@<ip>:<ruta_destino>|redes"
  "rsync -avz <origen> <usuario>@<ip>:<destino>|sincroniza archivos eficientemente|rsync -avz ./web/ usuario@192.168.1.50:/var/www/|Transfiere y sincroniza carpetas transfiriendo únicamente los archivos modificados (ahorra ancho de banda).\n\n  • Opciones:\n    - -a : Mantiene permisos, fechas y propietarios.\n    - -v : Muestra en pantalla el progreso.\n    - -z : Comprime los datos durante la transferencia.|redes"
  "ss -tuln|ver puertos TCP/UDP abiertos|ss -tuln|Muestra todos los puertos de red activos que están escuchando conexiones en la máquina.\n\n  • Sintaxis: ss -tuln\n  • Desglose de banderas:\n    - -t : Puertos TCP.\n    - -u : Puertos UDP.\n    - -l : Solo los que están escuchando (listening).\n    - -n : Muestra números de puertos (ej: 80) en lugar de nombres de servicio.|redes"
  "netstat -tuln|ver puertos abiertos (método clásico)|netstat -tuln|Muestra la lista de puertos y conexiones de red en el sistema.\n\n  • Sintaxis: netstat -tuln|redes"
  "lsof -i :<puerto>|ver qué programa usa un puerto|lsof -i :8080|Muestra qué proceso o aplicación específica está ocupando un puerto de red determinado.\n\n  • Sintaxis: lsof -i :<numero_de_puerto>\n  • Ejemplo:\n    - lsof -i :3000  → Identifica qué proceso usa el puerto 3000 (servidor web, Node.js, etc).|redes"
  "fuser -k <puerto>/tcp|cerrar/matar el proceso de un puerto|sudo fuser -k 8080/tcp|Cierra y termina de inmediato el proceso bloqueado que está utilizando un puerto TCP específico.\n\n  • Sintaxis: sudo fuser -k <puerto>/tcp\n  • Qué hace: Libera el puerto al instante cerrando la aplicación que lo tenía ocupado.|redes"
  "sudo ufw status|ver estado del firewall UFW|sudo ufw status verbose|Muestra si el firewall UFW está activo y cuáles reglas o puertos están abiertos o bloqueados.\n\n  • Sintaxis: sudo ufw status|redes"
  "sudo ufw enable|activar el firewall UFW|sudo ufw enable|Habilita y activa la protección del cortafuegos UFW en el sistema.|redes"
  "sudo ufw disable|desactivar el firewall UFW|sudo ufw disable|Desactiva el firewall UFW permitiendo todo el tráfico de red.|redes"
  "sudo ufw allow <puerto>|abrir un puerto en el firewall|sudo ufw allow 80/tcp|Añade una regla al firewall para permitir el tráfico entrante por un puerto específico.\n\n  • Ejemplos útiles:\n    - sudo ufw allow 22/tcp   → Abre puerto SSH.\n    - sudo ufw allow 443/tcp  → Abre puerto HTTPS web.|redes"
  "sudo ufw deny <puerto>|cerrar o bloquear puerto en firewall|sudo ufw deny 3306/tcp|Bloquea de inmediato todo acceso o tráfico entrante por un puerto específico.\n\n  • Sintaxis: sudo ufw deny <numero_puerto>/tcp|redes"
  "sudo ufw delete allow <puerto>|eliminar regla de apertura de puerto|sudo ufw delete allow 80/tcp|Elimina una regla previamente creada permitiendo limpiar la configuración del firewall.|redes"
  "ip a|ver interfaces de red y direcciones IP|ip a|Muestra las tarjetas de red del equipo y sus direcciones IP locales asignadas.\n\n  • Sintaxis: ip a (o 'ip addr show')|redes"
  "curl -s ifconfig.me|ver tu dirección IP pública real|curl -s ifconfig.me|Consulta un servicio externo en internet para obtener tu dirección IP pública externa.\n\n  • Sintaxis: curl -s ifconfig.me|redes"
  "nslookup <dominio>|consultar la dirección IP de un dominio|nslookup google.com|Consulta los servidores DNS para conocer la dirección IP asociada a un nombre de dominio web.\n\n  • Sintaxis: nslookup <nombre_de_dominio>|redes"
  "dig <dominio>|inspección DNS detallada de un dominio|dig github.com|Herramienta avanzada para consultar registros DNS (A, CNAME, MX, TXT) de un sitio web.\n\n  • Sintaxis: dig <nombre_de_dominio>|redes"
  "traceroute <host>|trazar la ruta de red hacia un servidor|traceroute 8.8.8.8|Muestra cada uno de los saltos y ruters por los que pasan los paquetes hasta llegar al servidor destino.\n\n  • Sintaxis: traceroute <dominio_o_ip>|redes"

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
# 3.1. detalle()
# -----------------------------------------------------------------------------
# Muestra la ficha explicativa completa de un comando individual.
#
detalle() {
    IFS='|' read -r cmd desc ej exp cat <<< "$1"

    echo
    echo "  ${B}╭────────────────────────────────────────────────────────────────────╮${R}"
    echo "  ${B}│${R} ${C}Comando:${R}      ${G}$cmd${R}"
    echo "  ${B}│${R} ${C}Categoría:${R}    $cat"
    echo "  ${B}│${R} ${C}Qué hace:${R}     $desc"
    echo "  ${B}│${R} ${C}Ejemplo:${R}      ${Y}$ej${R}"
    echo "  ${B}├────────────────────────────────────────────────────────────────────┤${R}"
    echo "  ${B}│${R} ${C}Explicación Detallada y Sintaxis:${R}"
    echo -e "$exp" | while IFS= read -r line; do
        echo "    $line"
    done
    echo "  ${B}╰────────────────────────────────────────────────────────────────────╯${R}"
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

    # Calcular el ancho dinámico para la columna de comandos según la lista actual
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

        echo "  ${D}• Ver detalle:${R}   Escribe el número de la lista (${G}$num_inicio-$num_fin${R})."
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
        elif [[ "$resp" =~ ^[0-9]+$ ]] && [ "$resp" -ge 1 ] && [ "$resp" -le $total ]; then
            detalle "${items[$((resp-1))]}"
            echo
            read -p "  Presiona Enter para continuar..."
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
