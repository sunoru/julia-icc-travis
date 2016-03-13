# Compile Julia using Intel compilers
[![Build Status](https://travis-ci.org/sunoru/julia-icc-travis.svg?branch=master)](https://travis-ci.org/sunoru/julia-icc-travis)

## Usage
Use install-julia.sh [branch-name] in `before_install`. For example,

`wget -q -O /tmp/install-julia.sh "https://raw.githubusercontent.com/sunoru/julia-icc-travis/master/install-julia.sh"`

`/tmp/install-julia.sh release-0.3`

Use `julia-VERSION` to run julia, e.g. `julia-release-0.3 foo.jl`. The defalt version of julia is 0.4.

You can build multiple versions of julia by call the `install-julia.sh` with different parameters for several times.
Command `julia` indicates the last installed version of julia.
**However it takes too much time so please compile one version every time. **

Use `https://raw.githubusercontent.com/sunoru/julia-icc-travis/master/install-icc.sh` to only install the Intel compilers.
See [https://github.com/nemequ/icc-travis](https://github.com/nemequ/icc-travis) for details.

**Do not forget to use **`. ~/.bashrc` **to load the environmental variables when installation completed.**

## License
To the extent possible under law, the author(s) of this script have waived all copyright and related or neighboring rights to this work.
For details, see the CC0 1.0 Universal Public Domain Dedication for details.
