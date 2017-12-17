using BinaryBuilder

# These are the platforms built inside the wizard
platforms = [
    BinaryProvider.Linux(:i686, :glibc),
  BinaryProvider.Linux(:x86_64, :glibc),
  BinaryProvider.Linux(:aarch64, :glibc),
  BinaryProvider.Linux(:armv7l, :glibc),
  BinaryProvider.Linux(:powerpc64le, :glibc),
  BinaryProvider.MacOS(),
  BinaryProvider.Windows(:i686),
  BinaryProvider.Windows(:x86_64)
]


# If the user passed in a platform (or a few, comma-separated) on the
# command-line, use that instead of our default platforms
if length(ARGS) > 0
    platforms = platform_key.(split(ARGS[1], ","))
end
info("Building for $(join(triplet.(platforms), ", "))")

# Collection of sources required to build SnappyBuilder
sources = [
    "https://github.com/google/snappy.git" =>
    "b02bfa754ebf27921d8da3bd2517eab445b84ff9",
]

script = raw"""
cd $WORKSPACE/srcdir
cd snappy
mkdir build && cd build
cmake ../ -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=/ -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain
make
make install

"""

products = prefix -> [
    LibraryProduct(prefix,"libsnappy")
]


# Build the given platforms using the given sources
hashes = autobuild(pwd(), "SnappyBuilder", platforms, sources, script, products)

