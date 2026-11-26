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
project_root="$(cd -- "$script_dir/.." && pwd)"
case "$project_root" in
    *';'*)
        echo "ERROR: CMake cannot build this project from a path containing semicolons." >&2
        exit 1
        ;;
esac

echo "Running CMake..."
cmake -S "$project_root" -B "$project_root/build"

echo "Building project..."
cmake --build "$project_root/build"

echo ""
echo "=== Build Complete ==="
echo "Executable: $project_root/output/bin/ticketcore"