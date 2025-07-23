#!/bin/bash

set -euo pipefail

echo "🧼 Starting Geant4 uninstallation..."

# === Define paths ===
G4_BASE=~/geant4
ZSHRC=~/.zshrc

# === Remove Geant4 directories ===
echo "🗑️ Removing source, build, and install directories..."
rm -rf "$G4_BASE"

# === Remove Geant4 environment entry ===
echo "🧹 Cleaning ~/.zshrc Geant4 sourcing line..."
sed -i '' '/source ~\/geant4\/install\/bin\/geant4.sh/d' "$ZSHRC"

# === Remove Qt@5 environment block ===
echo "🧹 Removing Qt@5 block from ~/.zshrc..."
sed -i '' '/# QT@5/,+4d' "$ZSHRC"

# === Optional: Remove dependencies (only if you want to) ===
# Uncomment to remove Geant4-related Homebrew packages
# echo "🍺 Removing optional Geant4-related Homebrew packages..."
# brew uninstall --ignore-dependencies cmake git qt@5 glew ftgl expat xerces-c \
#   freetype libpng jpeg libtiff gsl fftw libx11 libxmu libxi \
#   open-mpi clhep xquartz

echo "🔁 Reloading ~/.zshrc..."
source "$ZSHRC"

echo "✅ Geant4 has been completely removed from your system."