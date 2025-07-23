#!/bin/bash

set -euo pipefail

echo "📦 Installing Homebrew dependencies..."
brew install python wget git make xerces-c
brew install cmake ninja pkgconf
brew install xquartz qt@5 libx11
brew install cfitsio clhep davix expat fftw freetype ftgl gcc giflib gl2ps glew \
             graphviz gsl jpeg jpeg-turbo libpng libtiff libxi libxmu lz4 mariadb-connector-c \
             nlohmann-json numpy openblas open-mpi openssl pcre pcre2 python sqlite \
             tbb xrootd xxhash xz zstd
# Update and cleanup
brew update && brew upgrade && brew autoremove && brew cleanup && brew doctor

echo "🧼 Cleaning up potential Qt6 conflicts..."
sudo rm -rf /usr/local/include/Qt*
echo "🔗 Forcing link to Homebrew Qt5..."
brew unlink qt || true
brew unlink qt@5 || true
brew link --force qt@5

echo "📁 Creating Geant4 directory tree..."
mkdir -p ~/geant4/src ~/geant4/build ~/geant4/install
cd ~/geant4/src

echo "🔁 Cloning Geant4 v11.3.2..."
git clone --branch v11.3.2 --depth 1 https://gitlab.cern.ch/geant4/geant4.git .
git checkout tags/v11.3.2 -b geant4-11.3.2

echo "⚙️ Configuring CMake build..."
cd ~/geant4/build
cmake ../src \
  -DCMAKE_INSTALL_PREFIX=../install \
  -DGEANT4_BUILD_MULTITHREADED=ON \
  -DGEANT4_USE_OPENGL_X11=ON \
  -DGEANT4_USE_QT=ON \
  -DGEANT4_USE_RAYTRACER_X11=ON \
  -DGEANT4_USE_GDML=ON \
  -DGEANT4_INSTALL_DATA=ON \
  -DGEANT4_USE_SYSTEM_CLHEP=ON \
  -DQt5_DIR="$(brew --prefix qt@5)/lib/cmake/Qt5"
echo "🛠️ Building Geant4 using $(sysctl -n hw.ncpu) threads..."
make -j"$(sysctl -n hw.ncpu)"
echo "📥 Installing to ~/geant4/install..."
make install

# Add environment block to ~/.zshrc if not already present
ZSHRC=~/.zshrc
QT_BLOCK_START="# QT@5"
if ! grep -q "$QT_BLOCK_START" "$ZSHRC"; then
  echo "🔧 Adding Qt@5 environment settings to $ZSHRC"
  cat <<EOF >> "$ZSHRC"

# QT@5
export PATH="/opt/homebrew/opt/qt@5/bin:\$PATH"
export LDFLAGS="-L/opt/homebrew/opt/qt@5/lib \$LDFLAGS"
export CPPFLAGS="-I/opt/homebrew/opt/qt@5/include \$CPPFLAGS"
export PKG_CONFIG_PATH="/opt/homebrew/opt/qt@5/lib/pkgconfig:\$PKG_CONFIG_PATH"
EOF
else
  echo "ℹ️ Qt@5 environment block already exists in $ZSHRC"
fi

# Add Geant4 sourcing line if not already present
GEANT4_ENV="source ~/geant4/install/bin/geant4.sh"
if ! grep -Fxq "$GEANT4_ENV" "$ZSHRC"; then
  echo "$GEANT4_ENV" >> "$ZSHRC"
  echo "✅ Appended Geant4 setup to $ZSHRC"
fi

echo "🔄 Reloading environment from ~/.zshrc..."
source "$ZSHRC"

echo "🎉 Geant4 v11.3.2 build and environment setup complete!"
