# TicketCore - Cross-Platform Setup Guide

This application is now fully compatible with **Windows** and **Linux/WSL Ubuntu**.

## Prerequisites

### Windows
- Visual Studio 2019+ or MinGW-w64
- CMake 3.10+
- Git

### Linux / WSL Ubuntu
```bash
sudo apt-get update
sudo apt-get install -y build-essential cmake git
```

## Building on Linux / WSL Ubuntu

### 1. Clone and navigate to the project
```bash
cd /path/to/TicketCore
```

### 2. Create a build directory
```bash
mkdir build
cd build
```

### 3. Generate build files with CMake
```bash
cmake ..
```

### 4. Build the project
```bash
cmake --build .
```

### 5. Run the application
```bash
./ticketcore
```

## Building on Windows

### Option A: Using Visual Studio
```bash
mkdir build
cd build
cmake .. -G "Visual Studio 16 2019"
cmake --build . --config Release
Release\ticketcore.exe
```

### Option B: Using MinGW
```bash
mkdir build
cd build
cmake .. -G "Unix Makefiles"
cmake --build .
ticketcore.exe
```

## Running the Application

After building, run the executable from the build directory:

### Linux/WSL:
```bash
./ticketcore
```

### Windows:
```bash
ticketcore.exe
```

The application will create an `output` directory in the same location as the executable to store data files.

## Key Changes for Cross-Platform Compatibility

### What was changed:
1. **Removed Windows-only includes**: `windows.h` and `conio.h` are now only included on Windows
2. **Cross-platform console I/O**: Input handling works on both Windows and Linux
   - Windows: Uses `_getch()` for direct character input
   - Linux: Uses `std::cin` and `getline()` for standard input
3. **Platform detection**: Uses `#ifdef _WIN32` for Windows-specific code
4. **Screen clearing**: Uses `cls` on Windows, `clear` on Linux
5. **CMake build system**: Supports both Visual Studio and Unix Makefiles

### Supported features on Linux/WSL:
- ✅ Full ticket creation and viewing
- ✅ Extra parts tracker
- ✅ File I/O for data persistence
- ✅ Menu navigation (use text-based input instead of direct character input)
- ✅ All core functionality preserved

### Known differences on Linux/WSL:
- Menu navigation uses text input (type '1', '2', etc. and press Enter)
- Direct character input is not available (this is a Linux terminal limitation)
- Everything else works identically to Windows

## Troubleshooting

### CMake not found
```bash
sudo apt-get install cmake
```

### Compiler not found
```bash
sudo apt-get install build-essential
```

### Permission denied when running
```bash
chmod +x ./ticketcore
./ticketcore
```

### Cannot find output directory
The application automatically creates the `output` directory on first run.

## Project Structure
```
TicketCore/
├── CMakeLists.txt          # Build configuration
├── main.cpp                # Entry point
├── Helpers.cpp/h           # Cross-platform utilities
├── MainMenu.cpp/h          # Main menu system
├── TicketCreator.cpp/h     # Ticket creation module
├── TicketViewer.cpp/h      # Ticket viewing module
├── ExtraPartsTracker.cpp/h # Parts tracking module
└── output/                 # Data storage (created at runtime)
```
