#!/bin/bash

set -euo pipefail

# === Paths ===
G4SRC=~/geant4-v11.3.1
G4BUILD=~/geant4/build
G4INSTALL=~/geant4/geant4_install
BASHRC=~/.bashrc

echo "🗑️ Removing Geant4 source: $G4SRC"
rm -rf "$G4SRC"

echo "🗑️ Removing Geant4 build directory: $G4BUILD"
rm -rf "$G4BUILD"

echo "🗑️ Removing Geant4 install directory: $G4INSTALL"
rm -rf "$G4INSTALL"

echo "🧼 Removing Geant4 environment lines from $BASHRC"
sed -i '/geant4.sh/d' "$BASHRC"

echo "🗑️ Removing Geant4 dataset folders (if present)"
rm -rf "$G4INSTALL/share/Geant4/data"
rm -rf ~/Geant4Data

echo "🧼 Cleaning local CMake Geant4 configs"
rm -rf ~/.local/lib/cmake/Geant4*

echo "🧼 Removing CMakeCache.txt files from home"
find ~ -type f -name CMakeCache.txt -exec rm -v {} +

# === APT package cleanup (Geant4-specific only) ===
echo "🧹 Removing Geant4-specific APT packages..."
sudo apt remove --purge -y \
  libxerces-c-dev libexpat1-dev \
  libxmu-dev libxi-dev \
  libglu1-mesa-dev freeglut3-dev mesa-common-dev \
  libhdf5-dev libsqlite3-dev \
  libqt5opengl5-dev qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools \
  libclhep-dev libopenmpi-dev \
  libssl-dev \
  curl wget unzip

# General build tools like cmake/g++ are kept
echo "🧼 Running apt autoremove for leftovers..."
sudo apt autoremove -y

echo "✅ Geant4 and its supporting packages have been safely removed."
echo "⚠️ Restart your shell or run: source ~/.bashrc"