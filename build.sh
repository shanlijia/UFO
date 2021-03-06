#!/bin/sh
# automatically builds everything you need to start using UFO

# first, you should already have the UFO source code (that's how you're here!)
# first navigate to your ufo directory (cd $somepath$/ufo)

# install dependencies
# you will be asked to enter your password
sudo apt-get update
sudo apt-get install -y subversion
sudo apt-get install -y z3

# get source code for LLVM, Clang, and Compiler Runtime
svn co https://llvm.org/svn/llvm-project/llvm/tags/RELEASE_600/final/
mv final/ llvm-6.0.0/

cd llvm-6.0.0/tools
svn co https://llvm.org/svn/llvm-project/cfe/tags/RELEASE_600/final/
mv final/ clang/

cd ../projects
svn co https://llvm.org/svn/llvm-project/compiler-rt/tags/RELEASE_600/final/ 
mv final/ compiler-rt/ 
cd compiler-rt/lib && rm -r tsan/

# add UFO (UFO is built on top of thread sanitizer or tsan)
cp -r ../../../../tsan/ .

# build LLVM (this will take a couple of hours)
cd ../../../../ && mkdir build && cd build
cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DLLVM_BUILD_TESTS=OFF -DLLVM_INCLUDE_TESTS=OFF \
  -DLLVM_BUILD_EXAMPLES=OFF -DLLVM_INCLUDE_EXAMPLES=OFF -DLLVM_ENABLE_ASSERTIONS=OFF ../llvm-6.0.0/
make -j8

# now, follow the instructions in ufo/README.md to start using UFO!
