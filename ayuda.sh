#!/bin/bash
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
#  PENSADO PARA
#  ------------
#  Personas que están aprendiendo a usar la terminal y necesitan un
#  recordatorio rápido sin tener que buscar en Google.
#
#  USO
#  ---
#    ./ayuda.sh                → abre el menú interactivo
#    ./ayuda.sh borrar         → busca directamente "borrar"
#
#  INSTALACIÓN RÁPIDA (UN SOLO COMANDO)
#  ------------------------------------
#  curl -sSL https://raw.githubusercontent.com/edelacruzcr/Shell---h/main/ayuda.sh -o ~/.ayuda.sh && chmod +x ~/.ayuda.sh && (grep -q "alias ayuda=" ~/.bashrc 2>/dev/null || echo "alias ayuda='~/.ayuda.sh'" >> ~/.bashrc) && source ~/.bashrc
#
#  AUTOR
#  -----
#  edelacruzcr (https://github.com/edelacruzcr/Shell---h)
#
#  LICENCIA
#  --------
#  MIT - úsalo, modifícalo y compártelo libremente.
#
# =============================================================================


# =============================================================================
# 1. COLORES
# =============================================================================
# Códigos ANSI para dar color al texto en la terminal.
# Si tu terminal no soporta colores, pon todo a "" (vacío) y listo.
#
# Estructura: $'\033[<código>m'
#   - 1;32  → verde brillante
#   - 1;33  → amarillo brillante
#   - 1;36  → cian brillante
#   - 1;35  → magenta brillante
#   - 0     → reset (vuelve al color normal)
#
G=$'\033[1;32m'   # Verde  → comandos
Y=$'\033[1;33m'   # Amarillo → títulos y cabeceras
C=$'\033[1;36m'   # Cian   → nombres de comando en las listas
M=$'\033[1;35m'   # Magenta → separadores
R=$'\033[0m'      # Reset  → vuelve al color por defecto


# =============================================================================
# 2. BASE DE DATOS DE COMANDOS
# =============================================================================
# Cada comando es UNA línea con 5 campos separados por el carácter "|".
#
# Formato:
#   "comando|descripción corta|ejemplo|explicación larga|categoría"
#
# Reglas:
#   - NO uses el carácter "|" dentro de ningún campo.
#   - La categoría debe ser UNA de estas:
#       archivos  → archivos y carpetas
#       ver       → ver contenido de archivos
#       buscar    → buscar cosas
#       texto     → texto, variables y tuberías
#       sistema   → sistema, procesos, permisos
#       atajos    → atajos de teclado
#
# Para añadir un comando nuevo, copia una línea y adáptala.
#
CMDS=(

  # ---------------------------------------------------------------------------
  # CATEGORÍA: archivos
  # ---------------------------------------------------------------------------
  "pwd|muestra en qué carpeta estás|pwd|Imprime la ruta completa de la carpeta en la que estás trabajando.\n\n  • Sintaxis: pwd\n  • Argumentos: No requiere argumentos.\n  • Uso: Muestra el directorio de trabajo actual (Current Working Directory).|archivos"
  "cd X|entra a la carpeta X|cd Documentos|Cambia tu ubicación actual al directorio especificado en X.\n\n  • Sintaxis: cd <carpeta>\n  • Argumentos:\n    - X : Ruta o nombre del directorio de destino (ej: cd Documentos o cd /var/log).\n  • Tip: Puedes usar rutas relativas o absolutas.|archivos"
  "cd ..|sube un nivel|cd ..|Sube un nivel en la jerarquía de directorios (va a la carpeta padre).\n\n  • Sintaxis: cd ..\n  • Argumentos:\n    - .. : Símbolo en Linux que representa el directorio padre superior.|archivos"
  "cd ~|va a tu carpeta personal|cd ~|Navega directamente a tu directorio personal (Home).\n\n  • Sintaxis: cd ~ (o simplemente cd)\n  • Argumentos:\n    - ~ : Atajo que representa la ruta de tu usuario (/home/tu_usuario).|archivos"
  "cd -|vuelve a la anterior|cd -|Regresa a la carpeta previa en la que estabas antes del último cd.\n\n  • Sintaxis: cd -\n  • Argumentos:\n    - - : Representa el directorio anterior (\$OLDPWD).|archivos"
  "ls|lista archivos y carpetas|ls|Muestra una lista simple con los nombres de archivos y carpetas.\n\n  • Sintaxis: ls [carpeta]\n  • Argumentos:\n    - [carpeta] : (Opcional) Ruta de la carpeta a listar. Si se omite, usa la actual.|archivos"
  "ls -lah|lista todo con detalles|ls -lah|Lista detallada de todo el contenido del directorio.\n\n  • Sintaxis: ls -lah [carpeta]\n  • Opciones / Flags:\n    - -l : Formato largo (muestra permisos, dueño, tamaño y fecha).\n    - -a : (all) Muestra archivos ocultos (los que empiezan por '.').\n    - -h : (human-readable) Muestra tamaños en KB, MB, GB.|archivos"
  "mkdir X|crea una carpeta|mkdir Proyectos|Crea una carpeta nueva en el directorio actual.\n\n  • Sintaxis: mkdir <nombre_carpeta>\n  • Argumentos:\n    - X : Nombre de la nueva carpeta a crear.|archivos"
  "mkdir -p X/Y|crea toda la ruta|mkdir -p a/b/c|Crea una estructura completa de carpetas anidadas.\n\n  • Sintaxis: mkdir -p <ruta/anidada>\n  • Opciones / Flags:\n    - -p : (parents) Crea carpetas intermedias si no existen sin dar error.\n  • Argumentos:\n    - X/Y : Ruta anidada a crear (ej: proyectos/2026/fotos).|archivos"
  "touch X|crea archivo vacío|touch notas.txt|Crea un archivo vacío o actualiza la fecha de modificación si ya existe.\n\n  • Sintaxis: touch <archivo>\n  • Argumentos:\n    - X : Nombre del archivo a crear o actualizar.|archivos"
  "cp A B|copia A a B|cp notas.txt copia.txt|Copia un archivo individual de la ruta origen (A) al destino (B).\n\n  • Sintaxis: cp <origen> <destino>\n  • Argumentos:\n    - A : Archivo origen a copiar.\n    - B : Nombre del archivo copia o directorio destino.|archivos"
  "cp -r A B|copia carpeta|cp -r Documentos Backup|Copia un directorio completo con todo su contenido.\n\n  • Sintaxis: cp -r <carpeta_origen> <carpeta_destino>\n  • Opciones / Flags:\n    - -r : (recursive) Copia recursiva de carpetas y subcarpetas.\n  • Argumentos:\n    - A : Carpeta origen.\n    - B : Nombre de la carpeta destino.|archivos"
  "mv A B|mueve o renombra|mv viejo.txt nuevo.txt|Mueve o renombra un archivo o carpeta.\n\n  • Sintaxis: mv <origen> <destino>\n  • Argumentos:\n    - A : Archivo o carpeta a mover/renombrar.\n    - B : Nuevo nombre o directorio de destino.|archivos"
  "rm X|borra un archivo|rm notas.txt|Elimina un archivo de forma permanente.\n\n  • Sintaxis: rm <archivo>\n  • Argumentos:\n    - X : Nombre del archivo a eliminar.\n  • CUIDADO: El borrado es definitivo (no hay papelera).|archivos"
  "rm -r X|borra carpeta y todo|rm -r Proyectos|Elimina una carpeta y todo su contenido de forma recursiva.\n\n  • Sintaxis: rm -r <carpeta>\n  • Opciones / Flags:\n    - -r : (recursive) Elimina la carpeta y subcarpetas.\n  • Argumentos:\n    - X : Nombre de la carpeta a borrar.|archivos"
  "rm -i X|borra preguntando|rm -i notas.txt|Elimina pidiendo confirmación antes de borrar cada archivo.\n\n  • Sintaxis: rm -i <archivo>\n  • Opciones / Flags:\n    - -i : (interactive) Pide confirmación (y/n).\n  • Argumentos:\n    - X : Archivo a borrar.|archivos"

  # ---------------------------------------------------------------------------
  # CATEGORÍA: ver
  # ---------------------------------------------------------------------------
  "cat F|muestra todo el archivo|cat notas.txt|Imprime todo el contenido de un archivo en la terminal.\n\n  • Sintaxis: cat <archivo>\n  • Argumentos:\n    - F : Archivo a leer.\n  • Nota: Recomendado para archivos cortos.|ver"
  "less F|abre por páginas|less notas.txt|Visualizador interactivo para leer archivos página por página.\n\n  • Sintaxis: less <archivo>\n  • Argumentos:\n    - F : Archivo a leer.\n  • Controles: Flechas para navegar, / para buscar texto, q para salir.|ver"
  "head F|primeras 10 líneas|head notas.txt|Muestra las primeras 10 líneas de un archivo.\n\n  • Sintaxis: head <archivo>\n  • Argumentos:\n    - F : Archivo a visualizar.|ver"
  "head -n 5 F|primeras 5 líneas|head -n 5 notas.txt|Muestra una cantidad específica de líneas iniciales.\n\n  • Sintaxis: head -n <número> <archivo>\n  • Opciones / Flags:\n    - -n <N> : Especifica el número de líneas a mostrar.\n  • Argumentos:\n    - F : Archivo a visualizar.|ver"
  "tail F|últimas 10 líneas|tail notas.txt|Muestra las últimas 10 líneas de un archivo.\n\n  • Sintaxis: tail <archivo>\n  • Argumentos:\n    - F : Archivo a visualizar.|ver"
  "tail -f F|sigue en vivo|tail -f log.txt|Monitorea en tiempo real las nuevas líneas que se añaden al archivo.\n\n  • Sintaxis: tail -f <archivo_log>\n  • Opciones / Flags:\n    - -f : (follow) Mantiene el archivo abierto y muestra datos nuevos.\n  • Argumentos:\n    - F : Archivo de log. (Presiona Ctrl+C para salir).|ver"
  "wc -l F|cuenta líneas|wc -l notas.txt|Cuenta la cantidad total de líneas de un archivo.\n\n  • Sintaxis: wc -l <archivo>\n  • Opciones / Flags:\n    - -l : (lines) Muestra solo el conteo de líneas.\n  • Argumentos:\n    - F : Archivo a analizar.|ver"

  # ---------------------------------------------------------------------------
  # CATEGORÍA: buscar
  # ---------------------------------------------------------------------------
  "grep X F|busca texto en archivo|grep error log.txt|Busca coincidencias de un texto en un archivo.\n\n  • Sintaxis: grep <texto> <archivo>\n  • Argumentos:\n    - X : Texto o palabra a buscar.\n    - F : Archivo donde se buscará.|buscar"
  "grep -i X F|sin distinguir mayús|grep -i error log.txt|Busca texto ignorando mayúsculas y minúsculas.\n\n  • Sintaxis: grep -i <texto> <archivo>\n  • Opciones / Flags:\n    - -i : (ignore-case) No distingue mayúsculas/minúsculas (encuentra 'Error', 'ERROR', 'error').\n  • Argumentos:\n    - X : Texto a buscar.\n    - F : Archivo objetivo.|buscar"
  "grep -r X .|busca en todo|grep -r TODO .|Busca texto recursivamente en todos los archivos de un directorio.\n\n  • Sintaxis: grep -r <texto> <directorio>\n  • Opciones / Flags:\n    - -r : (recursive) Revisa subdirectorios.\n  • Argumentos:\n    - X : Texto a buscar.\n    - . : Directorio inicial ('.' es el actual).|buscar"
  "grep -n X F|con nº de línea|grep -n error log.txt|Muestra el número de línea exacto de cada coincidencia.\n\n  • Sintaxis: grep -n <texto> <archivo>\n  • Opciones / Flags:\n    - -n : Muestra número de línea.\n  • Argumentos:\n    - X : Texto a buscar.\n    - F : Archivo objetivo.|buscar"
  "grep -v X F|lo que NO tiene|grep -v error log.txt|Filtra e imprime las líneas que NO contienen el texto.\n\n  • Sintaxis: grep -v <texto> <archivo>\n  • Opciones / Flags:\n    - -v : Invierte la búsqueda.\n  • Argumentos:\n    - X : Texto a excluir.\n    - F : Archivo a analizar.|buscar"
  "grep -c X F|solo cuenta|grep -c error log.txt|Muestra la cantidad de líneas coincidentes sin imprimir el contenido.\n\n  • Sintaxis: grep -c <texto> <archivo>\n  • Opciones / Flags:\n    - -c : Cuenta coincidencias.\n  • Argumentos:\n    - X : Texto a contar.\n    - F : Archivo objetivo.|buscar"
  "find . -name X|busca archivos|find . -name '*.txt'|Busca archivos o carpetas por nombre.\n\n  • Sintaxis: find <directorio> -name <patrón>\n  • Opciones / Flags:\n    - -name : Patrón de nombre (admite comodines como '*.txt').\n  • Argumentos:\n    - . : Directorio de inicio.\n    - X : Nombre o patrón buscado.|buscar"
  "find . -type f|solo archivos|find . -type f|Filtra la búsqueda para devolver solo archivos.\n\n  • Sintaxis: find <directorio> -type f\n  • Opciones / Flags:\n    - -type f : Solo archivos regulares.\n  • Argumentos:\n    - . : Directorio de inicio.|buscar"
  "find . -type d|solo carpetas|find . -type d|Filtra la búsqueda para devolver solo carpetas.\n\n  • Sintaxis: find <directorio> -type d\n  • Opciones / Flags:\n    - -type d : Solo directorios/carpetas.\n  • Argumentos:\n    - . : Directorio de inicio.|buscar"
  "find . -size +10M|por tamaño|find . -size +10M|Busca elementos filtrados por su tamaño en disco.\n\n  • Sintaxis: find <directorio> -size <criterio>\n  • Opciones / Flags:\n    - -size : Tamaño (usar + o - y k/M/G).\n  • Argumentos:\n    - . : Directorio de inicio.\n    - +10M : Mayores a 10 Megabytes.|buscar"
  "find . -mtime -7|últimos 7 días|find . -mtime -7|Busca elementos modificados recientemente por días.\n\n  • Sintaxis: find <directorio> -mtime <días>\n  • Opciones / Flags:\n    - -mtime : Días desde modificación (-7 = últimos 7 días).\n  • Argumentos:\n    - . : Directorio de inicio.|buscar"

  # ---------------------------------------------------------------------------
  # CATEGORÍA: texto
  # ---------------------------------------------------------------------------
  "echo texto|imprime texto|echo hola|Imprime una cadena de texto en pantalla.\n\n  • Sintaxis: echo <texto>\n  • Argumentos:\n    - texto : El texto o palabras a imprimir.|texto"
  "echo VAR|valor de variable|echo \$USER|Muestra el valor contenido en una variable de entorno.\n\n  • Sintaxis: echo \$<VARIABLE>\n  • Argumentos:\n    - \$VAR : Variable a consultar (ej: \$USER, \$HOME, \$PATH).|texto"
  "echo X > F|guarda en archivo|echo hola > notas.txt|Escribe texto en un archivo (sobrescribiendo todo).\n\n  • Sintaxis: echo <texto> > <archivo>\n  • Operadores:\n    - > : Sobrescribe el archivo.\n  • Argumentos:\n    - X : Texto a escribir.\n    - F : Archivo destino.|texto"
  "echo X >> F|añade al final|echo adios >> notas.txt|Añade texto al final de un archivo (sin borrar nada).\n\n  • Sintaxis: echo <texto> >> <archivo>\n  • Operadores:\n    - >> : Concatena al final del archivo.\n  • Argumentos:\n    - X : Texto a añadir.\n    - F : Archivo destino.|texto"
  "cmd1 | cmd2|tubería|ls | grep txt|Conecta la salida de un comando con la entrada de otro.\n\n  • Sintaxis: <comando1> | <comando2>\n  • Operadores:\n    - | : Tubería (pipe). La salida de cmd1 pasa a cmd2.\n  • Ejemplo: ls | grep txt|texto"
  "cmd < F|entrada desde archivo|sort < numeros.txt|Redirecciona un archivo para que sea la entrada de un comando.\n\n  • Sintaxis: <comando> < <archivo>\n  • Operadores:\n    - < : Entrada desde archivo.\n  • Argumentos:\n    - F : Archivo de entrada.|texto"

  # ---------------------------------------------------------------------------
  # CATEGORÍA: sistema
  # ---------------------------------------------------------------------------
  "sudo cmd|como administrador|sudo apt update|Ejecuta un comando con permisos de administrador (root).\n\n  • Sintaxis: sudo <comando>\n  • Argumentos:\n    - cmd : Comando a ejecutar como root.|sistema"
  "sudo -i|shell como root|sudo -i|Inicia una terminal completa como administrador.\n\n  • Sintaxis: sudo -i\n  • Opciones / Flags:\n    - -i : Inicia sesión como superusuario (escribe 'exit' para salir).|sistema"
  "history|ver historial|history|Muestra la lista numerada de comandos ejecutados anteriormente.\n\n  • Sintaxis: history\n  • Argumentos: No requiere argumentos.|sistema"
  "history -d N|borra del historial|history -d 42|Elimina una línea específica del historial por su número.\n\n  • Sintaxis: history -d <número>\n  • Opciones / Flags:\n    - -d : Elimina la posición indicada.\n  • Argumentos:\n    - N : Número de línea del comando.|sistema"
  "history -c|limpia el historial|history -c|Borra todo el historial guardado en la sesión actual.\n\n  • Sintaxis: history -c\n  • Opciones / Flags:\n    - -c : Vacía el historial de la sesión.|sistema"
  "chmod +x F|hacer ejecutable|chmod +x script.sh|Añade permiso de ejecución a un archivo.\n\n  • Sintaxis: chmod +x <archivo>\n  • Parámetros:\n    - +x : Otorga permiso de ejecución.\n  • Argumentos:\n    - F : Archivo a modificar.|sistema"
  "chmod 755 F|permisos estándar|chmod 755 script.sh|Establece permisos numéricos octales (dueño todo, otros lectura/ejecución).\n\n  • Sintaxis: chmod <modo_octal> <archivo>\n  • Desglose:\n    - 7 : lectura, escritura y ejecución para el dueño.\n    - 5 : lectura y ejecución para grupo y otros.\n  • Argumentos:\n    - F : Archivo objetivo.|sistema"
  "df -h|espacio en disco|df -h|Muestra el espacio en disco de las particiones.\n\n  • Sintaxis: df -h\n  • Opciones / Flags:\n    - -h : (human-readable) Muestra el espacio en MB/GB.|sistema"
  "du -sh X|tamaño de carpeta|du -sh Documentos|Muestra el tamaño total acumulado de una carpeta o archivo.\n\n  • Sintaxis: du -sh <carpeta>\n  • Opciones / Flags:\n    - -s : Resumen del total de la carpeta.\n    - -h : Muestra en formato legible (MB/GB).\n  • Argumentos:\n    - X : Carpeta a consultar.|sistema"
  "free -h|memoria RAM|free -h|Muestra el estado de la memoria RAM y SWAP.\n\n  • Sintaxis: free -h\n  • Opciones / Flags:\n    - -h : Muestra valores en formato legible (MB/GB).|sistema"
  "ps aux|procesos activos|ps aux|Muestra un listado de todos los procesos en ejecución.\n\n  • Sintaxis: ps aux\n  • Opciones / Flags:\n    - a : Procesos de todos los usuarios.\n    - u : Muestra usuario y detalles.\n    - x : Procesos sin terminal.|sistema"
  "ps aux | grep X|busca proceso|ps aux | grep firefox|Busca un proceso específico por su nombre.\n\n  • Sintaxis: ps aux | grep <nombre>\n  • Argumentos:\n    - X : Nombre del proceso a buscar.|sistema"
  "top|monitor en vivo|top|Monitor interactivo de procesos y consumo de CPU/RAM en tiempo real.\n\n  • Sintaxis: top\n  • Teclas: 'q' para salir, 'M' ordenar por RAM, 'P' por CPU.|sistema"
  "kill -9 N|matar proceso|kill -9 1234|Fuerza la terminación inmediata de un proceso.\n\n  • Sintaxis: kill -9 <PID>\n  • Opciones / Flags:\n    - -9 : Terminación forzada inmediata (SIGKILL).\n  • Argumentos:\n    - N : PID del proceso.|sistema"
  "uptime|carga y tiempo|uptime|Muestra tiempo encendido y carga promedio del sistema.\n\n  • Sintaxis: uptime|sistema"

  # ---------------------------------------------------------------------------
  # CATEGORÍA: atajos
  # ---------------------------------------------------------------------------
  "Tab|autocompletar|Tab|Autocompleta nombres de comandos, archivos o carpetas.\n\n  • Uso: Escribe el inicio de la palabra y pulsa Tab.|atajos"
  "Tab Tab|ver opciones|Tab Tab|Muestra todas las opciones posibles cuando hay varias coincidencias.\n\n  • Uso: Pulsa Tab dos veces seguidas.|atajos"
  "Ctrl+R|buscar historial|Ctrl+R|Búsqueda interactiva en el historial de comandos.\n\n  • Uso: Pulsa Ctrl+R y escribe una palabra para buscar comandos antiguos.|atajos"
  "Ctrl+C|cancelar comando|Ctrl+C|Interrumpe y cancela el comando ejecutándose actualmente.|atajos"
  "Ctrl+L|limpiar pantalla|Ctrl+L|Limpia la terminal (igual que el comando clear).\n\n  • Uso: Pulsa Ctrl+L.|atajos"
  "Ctrl+U|borrar la línea|Ctrl+U|Borra el texto desde el cursor hasta el inicio de la línea.|atajos"
  "Ctrl+W|borrar palabra|Ctrl+W|Borra la última palabra antes del cursor.|atajos"
  "Ctrl+A|inicio de línea|Ctrl+A|Mueve el cursor al principio de la línea.|atajos"
  "Ctrl+E|fin de línea|Ctrl+E|Mueve el cursor al final de la línea.|atajos"
  "Ctrl+Shift+C|copiar|Ctrl+Shift+C|Copia el texto seleccionado en la terminal.|atajos"
  "Ctrl+Shift+V|pegar|Ctrl+Shift+V|Pega el texto seleccionado en la terminal.|atajos"
  "Flecha arriba|comandos previos|Flecha arriba|Navega hacia atrás en el historial de comandos.|atajos"
  "!!|repetir el último|!!|Repite el último comando ejecutado.\n\n  • Ejemplo típico: sudo !!|atajos"
  "!n|repetir el número n|!42|Ejecuta el comando número 'n' del historial.\n\n  • Sintaxis: !<número>|atajos"
  "Ctrl+D|cerrar sesión|Ctrl+D|Cierra la sesión actual de la terminal.|atajos"
)


# =============================================================================
# 3. FUNCIONES
# =============================================================================

# -----------------------------------------------------------------------------
# 3.1. detalle()
# -----------------------------------------------------------------------------
# Muestra la ficha completa de un comando: nombre, qué hace, ejemplo,
# explicación detallada con argumentos/opciones y categoría.
#
# Recibe como argumento la cadena completa con los 5 campos separados por "|".
#
detalle() {
    # Trocea la cadena en las 5 variables usando "|" como separador.
    IFS='|' read -r cmd desc ej exp cat <<< "$1"

    echo
    echo "  ${M}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${R}"
    echo "  ${G}Comando:${R}      ${C}$cmd${R}"
    echo "  ${G}Categoría:${R}    $cat"
    echo "  ${G}Qué hace:${R}     $desc"
    echo "  ${G}Ejemplo:${R}      ${Y}$ej${R}"
    echo "  ${M}────────────────────────────────────────────────────────────────────${R}"
    echo "  ${G}Explicación y Uso de Argumentos/Opciones:${R}"
    echo -e "$exp" | while IFS= read -r line; do
        echo "    $line"
    done
    echo "  ${M}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${R}"
}


# -----------------------------------------------------------------------------
# 3.2. listar()
# -----------------------------------------------------------------------------
# Muestra los comandos de una categoría (o todos si el filtro está vacío)
# en una lista numerada. Después deja elegir un número para ver el detalle.
#
# Argumentos:
#   $1 → nombre de la categoría a filtrar (vacío = todas)
#   $2 → título a mostrar
#
listar() {
    local filtro="$1"
    local titulo="$2"
    local entries=()      # aquí guardamos solo los que coinciden
    local n=1             # contador visible

    # Recorre todos los comandos y se queda con los de la categoría pedida.
    for entry in "${CMDS[@]}"; do
        IFS='|' read -r cmd desc ej exp cat <<< "$entry"
        if [ -z "$filtro" ] || [ "$cat" = "$filtro" ]; then
            entries+=("$entry")
        fi
    done

    # Si no hay nada, avisa y sale.
    if [ ${#entries[@]} -eq 0 ]; then
        echo "  No hay comandos en esta categoría."
        read -p "  Enter para volver..."
        return
    fi

    # Pinta la lista numerada.
    echo
    echo "  ${Y}$titulo${R}"
    echo
    for entry in "${entries[@]}"; do
        IFS='|' read -r cmd desc ej exp cat <<< "$entry"
        printf "  ${G}%2d)${R} ${C}%-22s${R} %s\n" "$n" "$cmd" "$desc"
        n=$((n+1))
    done

    # Pide un número para ver el detalle.
    echo
    read -p "  Número para ver detalle (Enter para volver): " num

    # Valida que sea un número y que esté dentro del rango.
    if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le ${#entries[@]} ]; then
        detalle "${entries[$((num-1))]}"
        read -p "  Enter para continuar..."
    fi
}


# -----------------------------------------------------------------------------
# 3.3. buscar()
# -----------------------------------------------------------------------------
# Busca una palabra en TODOS los campos de TODOS los comandos y muestra
# los resultados en una lista numerada.
#
# Argumento:
#   $1 → palabra o expresión a buscar
#
buscar() {
    local q="$1"
    local entries=()
    local n=1

    # Recorre todos los comandos y guarda los que contengan la palabra.
    for entry in "${CMDS[@]}"; do
        IFS='|' read -r cmd desc ej exp cat <<< "$entry"
        if [[ "$cmd $desc $exp $cat" =~ $q ]]; then
            entries+=("$entry")
        fi
    done

    # Si no hay resultados, avisa.
    if [ ${#entries[@]} -eq 0 ]; then
        echo
        echo "  No encontré nada para: $q"
        read -p "  Enter para volver..."
        return
    fi

    # Muestra los resultados.
    echo
    echo "  ${Y}Resultados para \"$q\":${R}"
    echo
    for entry in "${entries[@]}"; do
        IFS='|' read -r cmd desc ej exp cat <<< "$entry"
        printf "  ${G}%2d)${R} ${C}%-22s${R} %s\n" "$n" "$cmd" "$desc"
        n=$((n+1))
    done

    # Pide un número para ver el detalle.
    echo
    read -p "  Número para ver detalle (Enter para volver): " num

    if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 1 ] && [ "$num" -le ${#entries[@]} ]; then
        detalle "${entries[$((num-1))]}"
        read -p "  Enter para continuar..."
    fi
}


# -----------------------------------------------------------------------------
# 3.4. menu()
# -----------------------------------------------------------------------------
# Bucle principal. Muestra el menú y espera la opción del usuario.
# Según lo que escriba, llama a una función u otra.
#
menu() {
    while true; do
        clear

        # ------- cabecera -------
        echo
        echo "  ${C}╔══════════════════════════════════════════════════╗${R}"
        echo "  ${C}║          AYUDA INTERACTIVA DE COMANDOS             ║${R}"
        echo "  ${C}║   Escribe una opción o una palabra para buscar   ║${R}"
        echo "  ${C}╚══════════════════════════════════════════════════╝${R}"
        echo

        # ------- categorías -------
        echo "  ${Y}CATEGORÍAS:${R}"
        echo "    1) Archivos y carpetas"
        echo "    2) Ver contenido de archivos"
        echo "    3) Buscar"
        echo "    4) Texto y tuberías"
        echo "    5) Sistema"
        echo "    6) Atajos de teclado"
        echo "    7) Ver TODO"
        echo

        # ------- ayuda -------
        echo "  ${Y}BUSCAR:${R}"
        echo "    Escribe cualquier palabra y pulsa Enter."
        echo "    Ejemplos: borrar, copiar, buscar, proceso, red, grep..."
        echo

        # ------- salir -------
        echo "  ${Y}SALIR:${R}"
        echo "    0 o q"
        echo

        # ------- pedir opción -------
        read -p "  > " opcion

        # ------- decidir qué hacer -------
        case "$opcion" in
            1) listar "archivos" "ARCHIVOS Y CARPETAS" ;;
            2) listar "ver"      "VER CONTENIDO DE ARCHIVOS" ;;
            3) listar "buscar"   "BUSCAR" ;;
            4) listar "texto"    "TEXTO Y TUBERÍAS" ;;
            5) listar "sistema"  "SISTEMA" ;;
            6) listar "atajos"   "ATAJOS DE TECLADO" ;;
            7) listar ""         "TODOS LOS COMANDOS" ;;
            0|q|Q|salir|exit) clear; exit 0 ;;
            "") ;;                                  # Enter sin nada: no hace nada
            *) buscar "$opcion" ;;                  # cualquier otra cosa: busca
        esac
    done
}


# =============================================================================
# 4. PUNTO DE ENTRADA
# =============================================================================
# Si el script se llama con un argumento, busca directamente eso y luego
# muestra el menú. Si no, entra directo al menú.
#
if [ -n "$1" ]; then
    buscar "$1"
    read -p "  Enter para ir al menú..."
fi

menu
