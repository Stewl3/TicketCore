# 🚀 TicketCore - Getting Started on WSL Ubuntu

## The Absolute Quickest Way to Get Running

### Step 1: Install Dependencies (One-time setup)
```bash
sudo apt-get update
sudo apt-get install -y build-essential cmake
```

### Step 2: Check Prerequisites (Optional but recommended)
```bash
cd /path/to/TicketCore
chmod +x check_prerequisites.sh
./check_prerequisites.sh
```

This will verify you have everything needed. If anything shows ❌, install it using the suggested commands.

If either script reports `/bin/bash^M: bad interpreter`, it has Windows line endings.
From the project directory, remove Windows line endings and any UTF-8 byte-order mark:
```bash
sed -i '1s/^\xEF\xBB\xBF//; s/\r$//' build.sh check_prerequisites.sh
```

### Step 3: Build the Application
```bash
chmod +x build.sh
./build.sh
```

### Step 4: Run It!
```bash
./build/ticketcore
```

**That's it! Your app is now running on Linux! 🎉**

---

## What to Do Next

### Test the Application
1. Press `1` to select "Ticket Creator"
2. Enter a ticket number (e.g., 123)
3. Follow the prompts to create a ticket
4. Exit and press `2` to view your ticket
5. Verify everything works!

### Menu Navigation
- Type a number (1, 2, 3, etc.) and press **Enter**
- To exit/escape, type **esc** and press **Enter**
- Type **Y** or **N** for yes/no questions

---

## Common Commands

| What | Command |
|------|---------|
| **Build** | `./build.sh` |
| **Run** | `./build/ticketcore` |
| **Rebuild** | `./build.sh` (reuses the existing build directory) |

---

## If Something Goes Wrong

### "command not found: cmake"
```bash
sudo apt-get install cmake
```

### "command not found: g++"
```bash
sudo apt-get install build-essential
```

### "Permission denied: build.sh"
```bash
chmod +x build.sh
```

### Project path contains semicolons
CMake can fail when the project path contains `;`. Copy or clone the project into
a directory without semicolons, such as `~/TicketCore`, and build it there.

### Build fails with error
Check you have:
- ✅ CMake installed: `cmake --version`
- ✅ Compiler installed: `g++ --version`
- ✅ C++17 support: Most GCC/Clang versions support this

---

## Platform Differences You'll Notice

### Input Style
**Windows**: Press `1` (immediate, no Enter needed)
**Linux**: Type `1` and press **Enter**

### That's Literally the Only Difference!

Everything else works the same:
- ✅ Create tickets
- ✅ View tickets
- ✅ Track extra parts
- ✅ Save and load data
- ✅ All menus work identically

---

## File Storage

Your data is stored in:
```
build/output/
├── Tickets/
│   └── [date].txt (ticket data)
└── ExtraParts.txt (parts inventory)
```

You can share these files between Windows and Linux - they're fully compatible!

---

## Need More Details?

### Quick Reference
- See: [QUICK_REFERENCE.md](QUICK_REFERENCE.md)

### Complete Setup Guide
- See: [CROSS_PLATFORM_GUIDE.md](CROSS_PLATFORM_GUIDE.md)

### Understanding the Changes
- See: [README_REFACTORING.md](README_REFACTORING.md)

### Documentation Index
- See: [INDEX.md](INDEX.md)

---

## Success Checklist

After running the app, verify:
- [ ] Application started successfully
- [ ] Main menu displays
- [ ] Can create a ticket
- [ ] Can view tickets
- [ ] Can use parts tracker
- [ ] Data persists after restart

If all check marks ✅, you're good to go!

---

## You're All Set! 🎉

Your TicketCore application is now running on WSL Ubuntu, with identical functionality to the Windows version.

**Happy tracking! 🚀**

---

*For additional help, refer to [CROSS_PLATFORM_GUIDE.md](CROSS_PLATFORM_GUIDE.md) or [QUICK_REFERENCE.md](QUICK_REFERENCE.md)*
