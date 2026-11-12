# Troubleshooting: "no such file or directory" Error

## Problem
When you run `./build.sh`, you get:
```
bash: ./build.sh: No such file or directory
```

## Root Cause
The script was created on Windows with **Windows line endings (CRLF)** instead of **Unix line endings (LF)**. WSL/Linux cannot execute scripts with Windows line endings.

## Solution (Choose One)

### Option 1: Fix Line Endings (Recommended)
The quickest fix - use `sed` to convert the line endings:

```bash
sed -i 's/\r$//' build.sh
./build.sh
```

**That's it!** The script should now work.

### Option 2: Install dos2unix Tool
If you prefer using a dedicated tool:

```bash
sudo apt-get install dos2unix
dos2unix build.sh
./build.sh
```

### Option 3: Re-download the Script
If the above doesn't work, you can create a fresh script:

```bash
cat > build.sh << 'EOF'
#!/bin/bash
# Build script for TicketCore on Linux/WSL

set -e

echo "=== TicketCore Build Script (Linux/WSL) ==="
echo ""

# Check if cmake is installed
if ! command -v cmake &> /dev/null; then
    echo "ERROR: CMake is not installed."
    echo "Install it with: sudo apt-get install cmake"
    exit 1
fi

# Check if compiler is available
if ! command -v g++ &> /dev/null && ! command -v clang++ &> /dev/null; then
    echo "ERROR: C++ compiler not found."
    echo "Install it with: sudo apt-get install build-essential"
    exit 1
fi

echo "Creating build directory..."
rm -rf build
mkdir -p build
cd build

echo "Running CMake..."
cmake ..

echo "Building project..."
cmake --build .

echo ""
echo "=== Build Complete ==="
echo "To run the application, execute:"
echo "  ./ticketcore"
echo ""
EOF
chmod +x build.sh
./build.sh
```

## How to Prevent This in the Future

When working with scripts created on Windows in WSL:

1. Always check line endings: `file build.sh`
   - Should show: `build.sh: Bourne-Again shell script, ASCII text`
   - Bad: `build.sh: Bourne-Again shell script, ASCII text, with CRLF line terminators`

2. Always run `chmod +x` after getting a script: `chmod +x build.sh`

3. If you're editing scripts in VSCode, set it to use Unix line endings:
   - Click "CRLF" in the bottom right corner
   - Select "LF"

## Still Having Issues?

Run this diagnostic to check your setup:

```bash
chmod +x check_prerequisites.sh
./check_prerequisites.sh
```

This will verify:
- ✅ CMake is installed
- ✅ GCC compiler is installed  
- ✅ build-essential is installed

If any show ❌, the script will tell you exactly what to install.

## Full Setup From Scratch

If everything is broken, here's a complete fresh start:

```bash
# Install everything
sudo apt-get update
sudo apt-get install -y build-essential cmake

# Go to TicketCore directory
cd /path/to/TicketCore

# Create fresh build script with correct line endings
cat > build.sh << 'EOF'
#!/bin/bash
set -e
rm -rf build
mkdir -p build
cd build
cmake ..
cmake --build .
EOF

# Make it executable
chmod +x build.sh

# Run it
./build.sh

# Run the app
./build/ticketcore
```

## TL;DR Quick Fix

```bash
sed -i 's/\r$//' build.sh
chmod +x build.sh
./build.sh
```

If that doesn't work, you're missing build tools. Install them:
```bash
sudo apt-get install -y build-essential cmake
```

Then try the build again.
