#!/bin/bash
# Prerequisite checker for TicketCore

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     TicketCore Prerequisites Check (WSL/Linux)             ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Check CMake
echo "Checking CMake..."
if command -v cmake &> /dev/null; then
    CMAKE_VERSION=$(cmake --version | head -n 1)
    echo "  ✅ $CMAKE_VERSION"
else
    echo "  ❌ CMake NOT FOUND"
    echo "     Install with: sudo apt-get install cmake"
fi

echo ""

# Check GCC
echo "Checking GCC compiler..."
if command -v g++ &> /dev/null; then
    GCC_VERSION=$(g++ --version | head -n 1)
    echo "  ✅ $GCC_VERSION"
else
    echo "  ❌ GCC NOT FOUND"
fi

echo ""

# Check Clang
echo "Checking Clang compiler..."
if command -v clang++ &> /dev/null; then
    CLANG_VERSION=$(clang++ --version | head -n 1)
    echo "  ✅ $CLANG_VERSION"
else
    echo "  ⚠️  Clang not found (but GCC is sufficient)"
fi

echo ""

# Check build-essential
echo "Checking build-essential..."
if dpkg -l | grep build-essential &> /dev/null; then
    echo "  ✅ build-essential is installed"
else
    echo "  ❌ build-essential NOT FOUND"
    echo "     Install with: sudo apt-get install build-essential"
fi

echo ""

# Summary
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                    Summary                                  ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

if command -v cmake &> /dev/null && (command -v g++ &> /dev/null || command -v clang++ &> /dev/null); then
    echo "✅ All prerequisites are met! You can proceed with:"
    echo "   chmod +x build.sh"
    echo "   ./build.sh"
else
    echo "❌ Missing prerequisites detected. Install with:"
    echo "   sudo apt-get update"
    echo "   sudo apt-get install -y build-essential cmake"
fi

echo ""
