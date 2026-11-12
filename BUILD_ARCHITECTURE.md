# TicketCore Build Architecture

## Build Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                   TicketCore Source Code                     │
│                   (C++17, Cross-Platform)                    │
└─────────────────────────────────────────────────────────────┘
                              ↓
                    ┌─────────┴─────────┐
                    ↓                   ↓
              Windows Build        Linux/Unix Build
              ────────────         ──────────────
                    ↓                   ↓
          ┌─────────────────┐  ┌──────────────────┐
          │   build.bat     │  │    build.sh      │
          │   (for Windows) │  │  (for Linux/WSL) │
          └─────────────────┘  └──────────────────┘
                    ↓                   ↓
          ┌─────────────────┐  ┌──────────────────┐
          │  CMakeLists.txt │  │  CMakeLists.txt  │
          │ (MSVC/MinGW/GCC)│  │  (GCC/Clang)     │
          └─────────────────┘  └──────────────────┘
                    ↓                   ↓
          ┌─────────────────┐  ┌──────────────────┐
          │ build/           │  │ build/           │
          │ Release/         │  │ ticketcore       │
          │ ticketcore.exe   │  │ (executable)     │
          └─────────────────┘  └──────────────────┘
                    ↓                   ↓
          ┌─────────────────┐  ┌──────────────────┐
          │ Windows App     │  │ Linux/WSL App    │
          │ (with cursor    │  │ (text input mode)│
          │  control)       │  │                  │
          └─────────────────┘  └──────────────────┘
```

## Code Compilation Strategy

```
Platform Detection (Compile-Time)
├── Windows (_WIN32 defined)
│   ├── Include: conio.h, windows.h
│   ├── I/O: _getch() direct character input
│   ├── Screen: system("cls")
│   └── Features: Full cursor control
│
└── Linux/Unix (_WIN32 NOT defined)
    ├── Include: termios.h, unistd.h
    ├── I/O: std::cin, getline() standard input
    ├── Screen: system("clear")
    └── Features: Standard terminal I/O
```

## CMake Build Chain

```
CMakeLists.txt
    ↓
Compiler Detection
    ├─ MSVC (Visual Studio)
    ├─ MinGW (GCC on Windows)
    ├─ GCC (Linux)
    └─ Clang (Linux/macOS)
    ↓
Compilation (all .cpp files)
    ├─ main.cpp
    ├─ Helpers.cpp (platform-specific code)
    ├─ MainMenu.cpp
    ├─ TicketCreator.cpp
    ├─ TicketViewer.cpp
    └─ ExtraPartsTracker.cpp
    ↓
Linking
    ├─ Link system libraries
    ├─ Link filesystem library (stdc++fs)
    └─ Link platform-specific libs (if needed)
    ↓
Output
    ├─ Windows: build/Release/ticketcore.exe
    └─ Linux: build/ticketcore (executable)
```

## File Dependencies

```
main.cpp
    ↓
MainMenu.h/cpp
    ├─ TicketCreator.h/cpp
    │   ├─ Helpers.h/cpp (CROSS-PLATFORM)
    │   └─ ExtraPartsTracker.h/cpp
    │
    ├─ TicketViewer.h/cpp
    │   └─ Helpers.h/cpp (CROSS-PLATFORM)
    │
    └─ ExtraPartsTracker.h/cpp
        └─ Helpers.h/cpp (CROSS-PLATFORM)

CROSS-PLATFORM CODE (Helpers.h/cpp)
├─ Windows Includes: conio.h, windows.h
├─ Linux Includes: termios.h, unistd.h
├─ Platform Detection: #ifdef _WIN32
└─ Universal: iostream, fstream, filesystem, string, chrono
```

## Build System Comparison

```
┌──────────────────┬──────────────────┬──────────────────┐
│     Windows      │    WSL Ubuntu    │   Linux Native   │
├──────────────────┼──────────────────┼──────────────────┤
│ build.bat        │ build.sh         │ build.sh         │
│ CMakeLists.txt   │ CMakeLists.txt   │ CMakeLists.txt   │
│ MSVC/MinGW/GCC   │ GCC/Clang        │ GCC/Clang        │
│ .exe binary      │ Unix binary      │ Unix binary      │
│ Direct I/O       │ Text input mode  │ Text input mode  │
└──────────────────┴──────────────────┴──────────────────┘
```

## Platform-Specific Code Distribution

```
Total Lines of Code: ~3,500

Cross-Platform Common Code: ~85%
├─ Core logic (ticket, viewer, tracker)
├─ File I/O operations
└─ Menu systems

Platform-Specific Code: ~15%
├─ Input handling (promptLine, promptChar, promptMenuChar)
├─ Screen clearing (clearScreen)
└─ Cursor control (setCursorVisibility)

Result: Minimal platform-specific code, maximum reusability
```

## Runtime Behavior

```
WINDOWS
┌─────────────────────────────┐
│  ticketcore.exe             │
│  ├─ Direct key input        │
│  ├─ Full cursor control     │
│  ├─ Native Windows console  │
│  └─ ESC key support         │
└─────────────────────────────┘

LINUX/WSL
┌─────────────────────────────┐
│  ./ticketcore               │
│  ├─ Text input (type + ⏎)   │
│  ├─ Terminal control        │
│  ├─ Standard I/O            │
│  └─ ESC via "esc" text      │
└─────────────────────────────┘

FUNCTIONAL EQUIVALENCE
All features work identically:
✅ Ticket creation
✅ Ticket viewing
✅ Parts tracking
✅ Data persistence
✅ Menu navigation
```

## Version Control

```
Repository Structure
├── Source Code
│   ├── main.cpp
│   ├── Helpers.h/cpp (✨ cross-platform)
│   ├── MainMenu.h/cpp
│   ├── TicketCreator.h/cpp
│   ├── TicketViewer.h/cpp
│   └── ExtraPartsTracker.h/cpp
│
├── Build System (✨ NEW)
│   ├── CMakeLists.txt
│   ├── build.sh
│   └── build.bat
│
├── Documentation (✨ NEW)
│   ├── CROSS_PLATFORM_GUIDE.md
│   ├── README_REFACTORING.md
│   ├── QUICK_REFERENCE.md
│   └── REFACTORING_SUMMARY.md
│
└── .gitignore (✨ NEW)
    └── Excludes: /build/, *.exe, CMakeFiles/, etc.
```

---

This architecture ensures that TicketCore can be built and run on any platform with minimal platform-specific code and maximum code reusability.
