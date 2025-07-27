1. move the two scripts in this repo (build_geant4_linux.sh and uninstall_geant4_linux.sh) to your home directory.

2. open .bashrc file in your home directory and comment out any Geant4  related lines.

3. now excute the build/uninstall script:

>chmod +x file_name.sh

4. finally run the build/uninstall script:

>./file_name.sh

5. Discard of this README.md








## Build an example

Copy an example from src to my geant4 folder
>cp -r /home/bacon/geant4/geant4_install/share/Geant4/examples/basic/B1 ~/geant4/B1_tensor/

>cd ~/geant4examples/B1_tensor

Build
>mkdir build && cd build

>cmake .. \
>  -DCMAKE_BUILD_TYPE=Release \

on mac

>  -DGeant4_DIR="$HOME/geant4/install/lib/cmake/Geant4" \
>  -DCMAKE_PREFIX_PATH="$(brew --prefix root):$HOME/geant4/install/lib/cmake/Geant4"

on linux

>  -DGeant4_DIR=/home/bacon/geant4/geant4_install/lib/cmake/Geant4 \
>  -DCMAKE_PREFIX_PATH="/usr/local/Cellar/root/6.36.02;$HOME/geant4/install/lib/Geant4-11.3.1/cmake" \

>// if rebuilding: make clean

>make -j$(sysctl -n hw.ncpu)

>make -j$(nproc)

Check what was enabled during build
>cat /Users/tensor/geant4/build/CMakeCache.txt | grep GEANT4_USE

Confirm Geant4 Build Has Qt, OpenGL, GDML, CADMesh, etc
>$HOME/geant4/install/bin/geant4-config --features

run Interactive session
>./exampleB1

In Geant4 prompt
>/control/execute vis.mac
