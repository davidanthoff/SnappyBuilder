using BinaryBuilder

# Collection of sources required to build SnappyBuilder
sources = [
    "https://github.com/google/snappy.git" =>
    "b02bfa754ebf27921d8da3bd2517eab445b84ff9",
]

script = raw"""
cd $WORKSPACE/srcdir/snappy
mkdir build && cd build
cmake ../ -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=${prefix} -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain
make -j${nproc}
make install
"""

# These are the platforms we will build for by default, unless
# further platforms are passed in on the command line
platforms = supported_platforms()

# The products that we will ensure are always built
products = prefix -> [
    LibraryProduct(prefix, "libsnappy", :libsnappy)
]

# Dependencies that must be installed before this package can be built
dependencies = [
]

build_tarballs(ARGS, "Snappy", sources, script, platforms, products, dependencies)
