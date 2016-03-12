#!/bin/bash

# Install Intel compilers
wget -q -O /tmp/install-icc.sh \
    "https://raw.githubusercontent.com/sunoru/julia-icc-travis/master/install-icc.sh"
sudo bash /tmp/install-icc.sh --components icc,ifort,mkl --dest ${HOME}/intel || exit 1
source ${HOME}/intel/compilers_and_libraries_2016/linux/bin/compilervars.sh intel64 && echo "Source completed"

# Get the source of Julia and compile it.
JULIA_VERSION="release-0.4"
if [ $# == 1 ]; then
    JULIA_VERSION=$1
fi
echo "Build Julia of version $JULIA_VERSION"
wget -q -O /tmp/julia.zip "https://github.com/JuliaLang/julia/archive/$JULIA_VERSION.zip"
unzip -qq /tmp/julia.zip -d /tmp
mv /tmp/julia-${JULIA_VERSION//\//-} /tmp/julia-source
cd /tmp/julia-source
echo "USEICC = 1\nUSEIFC = 1\nUSE_INTEL_MKL = 1\nUSE_INTEL_MKL_FFT = 1\nUSE_INTEL_LIBM = 1\n$(shell echo "Make.user")" > Make.user
which icc || exit 1
# make -j 3
export PATH=$PAHT:/tmp/julia-source/bin
julia -e 'versioninfo()'
