using BinaryBuilder

platforms = [
  BinaryProvider.Linux(:x86_64, :glibc)
]

sources = [
    "https://github.com/JuliaLang/openlibm/archive/v0.5.5.tar.gz" =>
    "07dcc5f59e695fb45167c81406b8e201c5ad91ebf24e3e55ae13298670910cfd",
]

script = raw"""
# Install into output
flags="prefix=${DESTDIR}"

# Build ARCH from ${target}
flags="${flags} ARCH=${target%-*-*}"

# Enter the funzone
cd ${WORKSPACE}/srcdir/openlibm-0.5.5

# Build the library
make ${flags} -j${nproc}

# Install the library
make ${flags} install
"""

products = prefix -> [
    LibraryProduct(prefix, "libopenlibm")
]

# Choose which platforms to build for; if we've got an argument use that one,
# otherwise default to just building all of them!
build_platforms = supported_platforms()
if length(ARGS) > 0
    build_platforms = platform_key.(split(ARGS[1], ","))
end
info("Building for $(join(triplet.(build_platforms), ", "))")

autobuild(pwd(), "openlibm", build_platforms, sources, script, products)
