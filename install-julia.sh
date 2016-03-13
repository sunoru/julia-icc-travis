#!/bin/bash

#if [ "$(whoami)" != "root" ]; then
#    echo "Please run as root"
#    exit 1
#fi

# Install Intel compilers
wget -q -O /tmp/install-icc.sh \
    "https://raw.githubusercontent.com/sunoru/julia-icc-travis/master/install-icc.sh"
chmod 755 /tmp/install-icc.sh
sudo /tmp/install-icc.sh --components icc,ifort,mkl --dest /opt/intel --tmpdir /root/tmp || exit 1
. /home/travis/.bashrc && echo "Source completed"

cat ~/.bashrc
echo $PATH
echo $LD_LIBRARY_PATH

# Get the source of Julia and compile it.
JULIA_VERSION="release-0.4"
if [ $# == 1 ]; then
    JULIA_VERSION=$1
fi
cd $HOME
git clone https://github.com/JuliaLang/julia.git --depth 1 --branch $JULIA_VERSION || exit 1
mv julia julia-source
cd julia-source
echo "Build Julia of version $JULIA_VERSION"
echo "USEICC = 1" > Make.user
echo "USEIFC = 1" >> Make.user
echo "USE_INTEL_MKL = 1" >> Make.user
echo "USE_INTEL_MKL_FFT = 1" >> Make.user
echo "USE_INTEL_LIBM = 1" >> Make.user
which icc || exit 1
make -j 3
echo "Make completed"
sudo make install && echo "Successfully installed"
julia -e 'versioninfo()' || exit 1
