# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "libusb"
version = v"1.0.22"

# Collection of sources required to build libusb
sources = [
    "https://github.com/libusb/libusb.git" =>
    "0034b2afdcdb1614e78edaa2a9e22d5936aeae5d",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd libusb/
./bootstrap.sh 
./configure --prefix=$prefix --host=$target --disable-udev
make -j${nproc}
make install

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, :glibc),
    Linux(:x86_64, :glibc),
    Linux(:aarch64, :glibc),
    Linux(:armv7l, :glibc, :eabihf),
    Linux(:powerpc64le, :glibc),
    Linux(:i686, :musl),
    Linux(:x86_64, :musl),
    Linux(:aarch64, :musl),
    Linux(:armv7l, :musl, :eabihf),
    MacOS(:x86_64),
    Windows(:i686),
    Windows(:x86_64)
]

platforms = expand_gcc_versions(platforms)

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libusb", :libusb)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
