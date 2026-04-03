# Neovim Config

LazyVim-basierte Config mit Support fuer Python, C++, JavaScript/TypeScript, Java und Rust.

## Voraussetzungen

```bash
# Clipboard support (bereits installiert)
sudo pacman -S xclip

# Fuer die jeweiligen Sprachen braucht Mason die folgenden Tools:
# Python: pip
# C++: cmake, gcc/clang
# JavaScript: npm/node
# Java: JDK 17+
# Rust: rustup/cargo
```

Beim ersten Start installiert Mason automatisch alle LSPs, Formatter und DAP-Adapter.

## Debugger Keybindings (DAP)

| Taste | Aktion |
|---|---|
| `<leader>db` | Breakpoint setzen/entfernen |
| `<leader>dB` | Breakpoint mit Bedingung |
| `<leader>dc` | Continue / Debugging starten |
| `<leader>dC` | Run to Cursor |
| `<leader>di` | Step Into |
| `<leader>do` | Step Over |
| `<leader>dO` | Step Out |
| `<leader>dp` | Pause |
| `<leader>dr` | Toggle REPL |
| `<leader>ds` | Session starten |
| `<leader>dt` | Debugging beenden (Terminate) |
| `<leader>dw` | Widgets anzeigen (Hover) |

## Debugger pro Sprache

### Python (debugpy)

Mason installiert `debugpy` automatisch. Einfach Breakpoint setzen und `<leader>dc` druecken.

```
1. Oeffne eine .py Datei
2. <leader>db  -> Breakpoint setzen
3. <leader>dc  -> Debugging starten (waehle "Launch file")
```

### C++ (codelldb)

Mason installiert `codelldb` automatisch. Projekt muss mit Debug-Symbolen kompiliert sein:

```bash
# Kompilieren mit Debug-Symbolen
g++ -g -o main main.cpp
# oder mit CMake
cmake -DCMAKE_BUILD_TYPE=Debug ..
```

```
1. Kompiliere mit -g Flag
2. Oeffne die .cpp Datei
3. <leader>db  -> Breakpoint setzen
4. <leader>dc  -> Debugging starten
5. Pfad zur kompilierten Binary angeben wenn gefragt
```

### JavaScript / TypeScript (js-debug-adapter)

Mason installiert `js-debug-adapter` automatisch.

```
1. Oeffne eine .js/.ts Datei
2. <leader>db  -> Breakpoint setzen
3. <leader>dc  -> Debugging starten
4. Waehle "Launch file" (Node.js) oder "Launch Chrome" (Browser)
```

### Java (java-debug-adapter + java-test)

Mason installiert `java-debug-adapter` und `java-test` automatisch via jdtls.

```
1. Oeffne ein Java-Projekt (mit pom.xml oder build.gradle)
2. Warte bis jdtls vollstaendig geladen hat (kann beim ersten Mal dauern)
3. <leader>db  -> Breakpoint setzen
4. <leader>dc  -> Debugging starten
```

Wichtig: Java braucht JDK 17+ fuer jdtls.

### Rust (codelldb)

Teilt sich `codelldb` mit C++. Mason installiert es automatisch.

```bash
# Kompilieren im Debug-Modus (Standard bei cargo build)
cargo build
```

```
1. Oeffne eine .rs Datei in einem Cargo-Projekt
2. <leader>db  -> Breakpoint setzen
3. <leader>dc  -> Debugging starten
4. Waehle die Binary oder nutze "cargo test" zum Debuggen von Tests
```

## Clipboard / Yank

`y` kopiert automatisch in die System-Zwischenablage (via `unnamedplus`).
Das heisst: `yy` (Zeile kopieren) oder `y` im Visual Mode kopiert direkt,
und du kannst mit Ctrl+V im Browser einfuegen.

Voraussetzung: `xclip` muss installiert sein (`sudo pacman -S xclip`).
