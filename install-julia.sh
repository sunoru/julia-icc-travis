#!/bin/bash

#if [ "$(whoami)" != "root" ]; then
#    echo "Please run as root"
#    exit 1
#fi

if [ ! "$(grep 'intel' ~/.bashrc)" ]; then
    # Install Intel compilers
    wget -q -O /tmp/install-icc.sh \
        "https://raw.githubusercontent.com/sunoru/julia-icc-travis/master/install-icc.sh"
    chmod 755 /tmp/install-icc.sh
    sudo /tmp/install-icc.sh --components icc,ifort,mkl --dest /opt/intel --tmpdir /root/tmp || exit 1
fi
. ~/.bashrc && echo "Source completed"

# Get the source of Julia and compile it.
JULIA_VERSION="release-0.4"
if [ $# == 1 ]; then
    JULIA_VERSION=$1
fi
if [ -e $HOME/julia-$JULIA_VERSION ]; then
    echo "This version has already been installed"
    exit 1
fi
cd $HOME
git clone --depth 1 --branch $JULIA_VERSION https://github.com/JuliaLang/julia.git julia-$JULIA_VERSION || exit 1
cd julia-$JULIA_VERSION
PREFIX=$(pwd)/installed
echo "Build Julia of version $JULIA_VERSION"
echo "USEICC = 1" > Make.user
echo "USEIFC = 1" >> Make.user
echo "USE_INTEL_MKL = 1" >> Make.user
echo "USE_INTEL_MKL_FFT = 1" >> Make.user
echo "USE_INTEL_LIBM = 1" >> Make.user
echo "prefix = $PREFIX" >> Make.user
which icc || exit 1
make -j 3
echo "Make completed"
sudo bash -c ". /home/travis/.bashrc && make install" && echo "Successfully installed"
sudo ln -s $PREFIX/bin/julia /usr/local/bin/julia-$JULIA_VERSION
sudo rm -f /usr/local/bin/julia
sudo ln -s $PREFIX/bin/julia /usr/local/bin/julia
julia-$JULIA_VERSION -e 'versioninfo()' || exit 1
