# 📖 ayuda.sh

Guía interactiva de comandos de terminal para principiantes y desarrolladores.

Escribes una palabra, eliges un comando y te explica detalladamente qué hace, cómo se usa, su sintaxis exacta con marcadores explicativos y te da ejemplos reales.

![demo](demo.gif)

## ✨ Características

- **Interactivo**: Menú con categorías, paginación de 15 ítems por página y búsqueda por palabra clave.
- **Explicaciones Claras**: Cada comando incluye sintaxis con marcadores descriptivos (`<nombre_de_archivo.txt>`), ejemplos reales y recomendaciones de uso.
- **Visualmente Amigable**: Diseño limpio en tonos cian/azul con marcos redondeados (`╭───╮`), sin colores alarmantes.
- **Búsqueda Inteligente**: Insensible a mayúsculas/minúsculas y segura contra caracteres especiales de expresión regular.
- **Ligero**: Es un solo script de Bash, sin dependencias externas complejas.
- **Más de 110 Comandos**: Amplio repertorio de comandos de sistema, manipulación de archivos, texto, redes y atajos de teclado.

---

## 📦 Instalación Súper Sencilla (1 solo paso)

Copia y pega este comando en tu terminal para instalarlo automáticamente (descarga el script, otorga permisos, configura el alias `ayuda` y recarga tu sesión):

```bash
curl -sSL https://raw.githubusercontent.com/edelacruzcr/Shell---h/main/ayuda.sh -o ~/.ayuda.sh && chmod +x ~/.ayuda.sh && (grep -q "alias ayuda=" ~/.bashrc 2>/dev/null || echo "alias ayuda='~/.ayuda.sh'" >> ~/.bashrc) && exec bash
```

¡Listo! Ya puedes escribir `ayuda` desde cualquier lugar de tu terminal.

---

## 🔄 Actualización Limpia

Si ya tenías instalado `ayuda` y deseas actualizarlo a la versión más reciente sin afectar nada en tu sistema:

### Opción A: Actualizar vía `curl` (desde GitHub)
```bash
curl -sSL https://raw.githubusercontent.com/edelacruzcr/Shell---h/main/ayuda.sh -o ~/.ayuda.sh && chmod +x ~/.ayuda.sh && exec bash
```

### Opción B: Actualizar desde tu repositorio local
Si clonaste o editaste el código localmente:
```bash
cp ayuda.sh ~/.ayuda.sh && chmod +x ~/.ayuda.sh
```

---

## 🚀 Modo de Uso

```bash
ayuda              # Abre el menú interactivo principal
ayuda borrar       # Busca directamente comandos relacionados con "borrar"
ayuda cat          # Muestra directamente detalles del comando cat
```

### Navegación dentro del menú

- **1 a 6**: Explora una categoría específica.
- **7**: Muestra **TODOS** los comandos registrados.
- **Escribir cualquier palabra** (ej: `copiar`, `proceso`, `red`): Realiza una búsqueda instantánea.
- **Navegación de páginas**: Escribe `n` (siguiente página) o `p` (página anterior) en listas largas.
- **Número de opción** (ej: `3`): Abre la ficha técnica y detallada de ese comando.
- **0** o **q**: Sale del menú.

---

## 📂 Categorías Disponibles

| Categoría | Qué incluye |
|-----------|-------------|
| **Archivos y carpetas** | `pwd`, `cd`, `ls`, `mkdir`, `cp`, `mv`, `rm`, `tar`, `zip`, `chown`, etc. |
| **Ver contenido** | `cat`, `less`, `more`, `head`, `tail`, `wc`, `nl`, `column`, `xxd`, `view`, etc. |
| **Buscar** | `grep`, `find`, `which`, `whereis`, `locate`, `fd`, etc. |
| **Texto y tuberías** | `echo`, `sort`, `uniq`, `cut`, `tr`, `sed`, `awk`, `tee`, `rev`, tuberías (`\|`), etc. |
| **Sistema y procesos** | `sudo`, `history`, `chmod`, `df`, `du`, `free`, `ps`, `top`, `htop`, `kill`, `ping`, etc. |
| **Atajos de teclado** | `Tab`, `Ctrl+R`, `Ctrl+C`, `Ctrl+L`, `Ctrl+U`, `Ctrl+K`, `Alt+B`, `Alt+F`, `!!`, etc. |

---

## 📸 Ejemplo de Ficha de Comando

```text
  ╭────────────────────────────────────────────────────────────────────╮
  │ Comando:      cat <nombre_de_archivo.txt>
  │ Categoría:    ver
  │ Qué hace:     muestra todo el contenido
  │ Ejemplo:      cat notas.txt
  ├────────────────────────────────────────────────────────────────────┤
  │ Explicación Detallada y Sintaxis:
  │   Imprime el contenido completo de uno o varios archivos en la terminal.
  │
  │   • Sintaxis: cat <nombre_de_archivo.txt>
  │   • Qué más puedes hacer con cat:
  │     - cat a.txt b.txt > unificado.txt → Une (concatena) dos archivos en uno solo nuevo.
  │     - cat -n notas.txt                → Muestra el contenido enumerando cada línea.
  │     - cat > nuevo_archivo.txt          → Escribe texto directamente desde la terminal.
  ╰────────────────────────────────────────────────────────────────────╯
```

---

## 🛠️ Añadir tus propios comandos

Edita `ayuda.sh` y busca el array `CMDS=(`. Cada entrada utiliza la siguiente estructura separada por tuberías (`|`):

```bash
"comando|descripción corta|ejemplo|explicación larga y sintaxis|categoría"
```

Ejemplo real:

```bash
"du -sh <carpeta>|calcula el tamaño ocupado por una carpeta|du -sh /var/log|Muestra la cantidad total de espacio en disco que consume una carpeta especificada.\n\n  • Sintaxis: du -sh <nombre_de_carpeta>|sistema"
```

**Reglas a seguir:**
- No uses el carácter `|` dentro de los textos.
- Usa marcadores descriptivos en corchetes angulares (ej: `<nombre_de_archivo.txt>`).
- La categoría debe ser una de las 6 disponibles (`archivos`, `ver`, `buscar`, `texto`, `sistema`, `atajos`).

---

## 📋 Requisitos

- Bash 4.0 o superior (cualquier Linux moderno, macOS con Bash actualizado, WSL en Windows).
- Terminal con soporte para colores ANSI.

---

## 📝 Licencia

MIT. Úsalo, modifícalo y compártelo libremente.
