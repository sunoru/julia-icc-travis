#!/bin/bash

if [ "$(whoami)" != "root" ]; then
    echo "Please run as root"
    exit 1
fi

# Install Intel compilers
wget -q -O /tmp/install-icc.sh \
    "https://raw.githubusercontent.com/sunoru/julia-icc-travis/master/install-icc.sh"
chmod 755 /tmp/install-icc.sh
/tmp/install-icc.sh --components icc,ifort,mkl --dest /opt/intel || exit 1
source /opt/intel/bin/compilervars.sh intel64 && echo "Source completed"
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/intel/ism/bin/intel64

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
echo "USEICC = 1" > Make.user
echo "USEIFC = 1" >> Make.user
echo "USE_INTEL_MKL = 1" >> Make.user
echo "USE_INTEL_MKL_FFT = 1" >> Make.user
echo "USE_INTEL_LIBM = 1" >> Make.user
which icc || exit 1
make -j 3
cat config.log
export PATH=$PAHT:/tmp/julia-source/bin
julia -e 'versioninfo()'
