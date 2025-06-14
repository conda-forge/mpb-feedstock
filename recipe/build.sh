#!/bin/bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* .

if [[ ! -z "$mpi" && "$mpi" != "nompi" ]]; then
    # We don't actually compile parallel MPB here (--enable-parallel) because
    # the Python MPB interface in Pymeep isn't compatible with parallel MPB.
    # However, since the parallel Python interface uses parallel HDF5, we
    # need to build MPB against parallel HDF5, which just requires the MPI
    # compiler wrappers.
    export CC=mpicc
    export CXX=mpicxx
fi

./configure --prefix="${PREFIX}" --enable-shared --with-libctl=no --with-hermitian-eps --disable-dependency-tracking

make
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
make check
fi
make install

rm ${PREFIX}/lib/libmpb.a
