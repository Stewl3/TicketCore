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

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
case "$script_dir" in
    *';'*)
        echo "ERROR: CMake cannot build this project from a path containing semicolons." >&2
        echo "Copy or clone the project to a directory without semicolons, such as ~/TicketCore." >&2
        exit 1
        ;;
esac

echo "Running CMake..."
cmake -S "$script_dir" -B "$script_dir/build"

echo "Building project..."
cmake --build "$script_dir/build"

echo ""
echo "=== Build Complete ==="
echo "To run the application, execute:"
echo "  ./build/ticketcore"
echo ""