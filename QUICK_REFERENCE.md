# TicketCore - Quick Reference

## One-Line Build Commands

### Linux/WSL
```bash
chmod +x build.sh && ./build.sh && ./build/ticketcore
```

### Windows
```cmd
build.bat && cd build && Release\ticketcore.exe
```

## Manual Build (if not using scripts)

### Linux/WSL
```bash
mkdir build && cd build
cmake ..
cmake --build .
./ticketcore
```

### Windows (Visual Studio)
```cmd
mkdir build && cd build
cmake .. -G "Visual Studio 16 2019"
cmake --build . --config Release
Release\ticketcore.exe
```

### Windows (MinGW)
```cmd
mkdir build && cd build
cmake .. -G "Unix Makefiles"
cmake --build .
ticketcore.exe
```

## Cross-Platform Compatibility Checklist

- [x] Windows includes (windows.h, conio.h) conditionally compiled
- [x] Console I/O works on Windows and Linux
- [x] Screen clearing works cross-platform
- [x] File I/O uses C++ filesystem (C++17)
- [x] CMake build system configured
- [x] No platform-specific dependencies
- [x] All core features work identically

## Testing Checklist

After building, verify:
1. [ ] Application starts
2. [ ] Main menu displays
3. [ ] Can create a ticket
4. [ ] Can view tickets
5. [ ] Can use extra parts tracker
6. [ ] Data persists after restart
7. [ ] Output directory exists and contains files

## File Locations

| File | Purpose |
|------|---------|
| `CMakeLists.txt` | Build configuration |
| `build.sh` | Linux/WSL build script |
| `build.bat` | Windows build script |
| `Helpers.cpp/.h` | Cross-platform utilities |
| `main.cpp` | Entry point |
| `output/` | Data storage (created at runtime) |

## Environment Setup (WSL Ubuntu)

```bash
# Install required tools
sudo apt-get update
sudo apt-get install -y build-essential cmake git

# Clone the repo (if needed)
git clone <repo-url>
cd TicketCore

# Build and run
chmod +x build.sh
./build.sh
./build/ticketcore
```

## Compiler Support

| Compiler | Windows | Linux | macOS |
|----------|---------|-------|-------|
| MSVC | ✅ | - | - |
| MinGW | ✅ | - | - |
| GCC | ✅ | ✅ | ✅ |
| Clang | ✅ | ✅ | ✅ |

## Key Code Changes

### Before (Windows-only)
```cpp
#include <windows.h>
#include <conio.h>

void promptLine(const string &prompt, string &out) {
    int ch = _getch();  // Windows only!
    // ...
}
```

### After (Cross-platform)
```cpp
#ifdef _WIN32
    #include <conio.h>
    int ch = _getch();
#else
    std::getline(std::cin, out);
#endif
```

## Common Issues & Solutions

```bash
# Issue: "Permission denied" on Linux
# Solution:
chmod +x build.sh
chmod +x ./build/ticketcore

# Issue: "no such file or directory" when running ./build.sh
# Cause: Windows line endings (CRLF) instead of Unix (LF)
# Solution:
dos2unix build.sh
# OR if dos2unix not installed, use sed:
sed -i 's/\r$//' build.sh
# Then try again:
./build.sh

# Issue: "cmake: command not found"
# Solution:
sudo apt-get install cmake

# Issue: "g++: command not found"
# Solution:
sudo apt-get install build-essential

# Issue: Check what prerequisites are installed
# Solution:
chmod +x check_prerequisites.sh
./check_prerequisites.sh
```

---

**Last Updated**: 2026
**Status**: Production Ready ✅
