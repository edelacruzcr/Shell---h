# 📖 ayuda.sh

Guía interactiva de comandos de terminal para principiantes.

Escribes una palabra, eliges un comando y te explica qué hace, cómo se usa y te da un ejemplo real.

![demo](demo.gif)

## ✨ Características

- **Interactivo**: menú con categorías y búsqueda por palabra clave.
- **Explicativo**: cada comando tiene descripción corta, ejemplo y explicación larga.
- **Ligero**: es un solo archivo bash, sin dependencias externas.
- **Fácil de ampliar**: agregar comandos nuevos es copiar y pegar una línea.
- **Coloreado**: los comandos se ven en verde, los títulos en amarillo, etc.

## 📦 Instalación Súper Sencilla (1 solo paso)

Copia y pega este comando en tu terminal para instalarlo automáticamente (descarga el script, le da permisos y añade el alias `ayuda` listo para usar):

```bash
curl -sSL https://raw.githubusercontent.com/edelacruzcr/Shell---h/main/ayuda.sh -o ~/.ayuda.sh && chmod +x ~/.ayuda.sh && (grep -q "alias ayuda=" ~/.bashrc 2>/dev/null || echo "alias ayuda='~/.ayuda.sh'" >> ~/.bashrc) && source ~/.bashrc
```

¡Listo! Ya puedes escribir `ayuda` desde cualquier lugar de tu terminal.

## 🚀 Uso

```bash
ayuda              # abre el menú interactivo
ayuda borrar       # busca directamente la palabra "borrar"
```

### Dentro del menú

- Escribe `1` a `6` para ver una categoría.
- Escribe `7` para ver todos los comandos.
- Escribe cualquier palabra (ej: `copiar`) para buscar.
- Escribe el número de un resultado para ver su detalle.
- Escribe `0` o `q` para salir.

## 📂 Categorías

| Categoría | Qué incluye |
|-----------|-------------|
| Archivos y carpetas | `ls`, `cd`, `cp`, `mv`, `rm`, `mkdir`, `touch` |
| Ver contenido | `cat`, `less`, `head`, `tail`, `wc` |
| Buscar | `grep`, `find` con sus flags más útiles |
| Texto y tuberías | `echo`, redirecciones, tuberías |
| Sistema | `sudo`, `history`, `chmod`, `df`, `free`, `ps`, `kill` |
| Atajos de teclado | `Tab`, `Ctrl+R`, `Ctrl+C`, etc. |

## 🛠️ Añadir tus propios comandos

Edita el script y busca el array `CMDS=(`. Cada línea sigue este formato:

```
"comando|descripción corta|ejemplo|explicación larga|categoría"
```

Ejemplo real:

```bash
"du -sh X|tamaño de carpeta|du -sh Documentos|Muestra cuánto ocupa la carpeta Documentos en total.|sistema"
```

Reglas:

- No uses `|` dentro de los textos.
- La categoría debe ser una de: `archivos`, `ver`, `buscar`, `texto`, `sistema`, `atajos`.
- Si añades una categoría nueva, actualiza el `case` del menú y añade la opción.

## 📸 Captura

```
╔══════════════════════════════════════════════════╗
║   📖  AYUDA INTERACTIVA DE COMANDOS              ║
║   Escribe una opción o una palabra para buscar   ║
╚══════════════════════════════════════════════════╝

CATEGORÍAS:
  1) Archivos y carpetas
  2) Ver contenido de archivos
  3) Buscar
  4) Texto y tuberías
  5) Sistema
  6) Atajos de teclado
  7) Ver TODO

> borrar

Resultados para "borrar":

  1) rm X                   borra un archivo
  2) rm -r X                borra carpeta y todo
  3) rm -i X                borra preguntando
  4) history -d N           borra del historial
  5) history -c             limpia el historial
  6) Ctrl+U                 borrar la línea

Número para ver detalle (Enter para volver): 2

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Comando:      rm -r X
Qué hace:     borra carpeta y todo
Ejemplo:      rm -r Proyectos
Explicación:  Borra la carpeta Proyectos y todo lo que hay dentro. Muy destructivo.
Categoría:    archivos
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## 🤝 Contribuir

¿Quieres añadir comandos, categorías o mejorar las explicaciones?

1. Haz fork del repo.
2. Añade tus comandos al array `CMDS`.
3. Asegúrate de no romper el formato `"cmd|desc|ejemplo|exp|categoria"`.
4. Abre un Pull Request.

## 📋 Requisitos

- Bash 4.0 o superior (cualquier Linux moderno, macOS con bash instalado, WSL en Windows).
- Terminal que soporte colores ANSI (prácticamente todas).

## 📝 Licencia

MIT. Úsalo, modifícalo y compártelo con quien quieras.
