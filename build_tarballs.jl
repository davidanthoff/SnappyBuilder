using BinaryBuilder

platforms = [
  BinaryProvider.Linux(:i686, :glibc),
  BinaryProvider.Linux(:x86_64, :glibc),
  BinaryProvider.Linux(:aarch64, :glibc),
  BinaryProvider.Linux(:armv7l, :glibc),
  BinaryProvider.Linux(:powerpc64le, :glibc),
  BinaryProvider.Windows(:i686),
  BinaryProvider.Windows(:x86_64),
  BinaryProvider.MacOS()
]

sources = [
  "https://github.com/google/snappy/archive/1.1.7.tar.gz" =>
"3dfa02e873ff51a11ee02b9ca391807f0c8ea0529a4924afa645fbf97163f9d4",
]

script = raw"""
cd $WORKSPACE/srcdir
cd snappy-1.1.7
cmake -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=/ -DCMAKE_TOOLCHAIN_FILE=/opt/$target.toolchain
make
make install

"""

products = prefix -> [
	LibraryProduct(prefix,"libsnappy")
]

autobuild(pwd(), "SnappyBuilder", platforms, sources, script, products)
