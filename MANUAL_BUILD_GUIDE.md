# Manual Build Instructions (No Script Needed)

If the `build.sh` script is still causing issues, you can build manually by running these commands one at a time.

## Prerequisites (One-time)
```bash
sudo apt-get update
sudo apt-get install -y build-essential cmake
```

## Build Steps

### Step 1: Navigate to Project
```bash
cd /path/to/TicketCore
```

### Step 2: Create Build Directory
```bash
mkdir -p build
cd build
```

### Step 3: Run CMake
```bash
cmake ..
```

Expected output: Should show configuration details ending with `-- Build files have been written to: /path/to/build`

### Step 4: Build
```bash
cmake --build .
```

Expected output: Will show compilation progress, ending with `Built target ticketcore`

### Step 5: Run the Application
```bash
./ticketcore
```

**Done! Your app should now be running! 🎉**

---

## Troubleshooting Each Step

### Step 3 Issues (cmake .. fails)

**"cmake: command not found"**
```bash
sudo apt-get install cmake
```

**"Could not find a package configuration file"**
This usually means CMakeLists.txt is missing or in the wrong location. Make sure you're in the TicketCore directory when you run `cmake ..`

### Step 4 Issues (cmake --build . fails)

**"No targets specified"**
Make sure you ran `cmake ..` successfully first (see Step 3)

**"error: could not compile"**
This usually means you're missing a compiler. Install it:
```bash
sudo apt-get install build-essential
```

### Step 5 Issues (./ticketcore fails)

**"No such file or directory"**
The build didn't complete successfully. Check for errors in Step 4.

**Application crashes on startup**
This is usually fine - the app creates an `output/` directory on first run:
```bash
mkdir -p output
./ticketcore
```

---

## Complete Fresh Build (Copy & Paste)

If you want to start completely fresh, run this entire block at once:

```bash
cd /path/to/TicketCore && \
rm -rf build && \
mkdir -p build && \
cd build && \
cmake .. && \
cmake --build . && \
./ticketcore
```

---

## What Each Step Does

| Step | Command | Purpose |
|------|---------|---------|
| 1 | `mkdir -p build` | Creates build directory |
| 2 | `cd build` | Enters build directory |
| 3 | `cmake ..` | Generates Makefiles |
| 4 | `cmake --build .` | Compiles the code |
| 5 | `./ticketcore` | Runs the application |

---

## If You're Still Stuck

1. Run the prerequisite checker:
```bash
chmod +x check_prerequisites.sh
./check_prerequisites.sh
```

2. Read the troubleshooting guide:
```bash
cat TROUBLESHOOT_BUILD_SCRIPT.md
```

3. Check your WSL/Linux distribution:
```bash
uname -a
lsb_release -a
```

4. Verify CMake can find the source:
```bash
cd /path/to/TicketCore/build
cmake --debug-output ..
```

This will show detailed debug information about what CMake is doing.

---

## Next Steps After Successful Build

1. **Run the app**: `./ticketcore`
2. **Create a ticket**: Follow the menu prompts
3. **Verify it saved**: Exit and re-run, your ticket should still be there
4. **Celebrate!** 🎉 Your cross-platform build is working!

