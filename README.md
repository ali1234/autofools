This is a trivial autotools project which cannot be successfully
cross compiled due to a bug in libtool.

To reproduce the bug, clone the project and run `./build`, or
with Docker:

    docker build -t autofools .

--

Description of the bug:

1. Indirect dependencies

When a program uses libraries, they are called dependencies. The program must be linked to any libraries it uses.
If a library itself depends on another library, then the other library is an *indirect* dependency of the program.

For example:

    exe depends on libbar
    libbar depends on libfoo

Then libfoo is an indirect dependency of exe.

2. Over-linking

exe should *not* be linked to libfoo. This is called *over-linking*. It is possible that a newer version of libbar
will not depend on libfoo, which could cause the program to malfunction if it is directly linked against libfoo. `ld`
still needs to indirect dependencies when linking, it just doesn't store the link in the resulting binary.

3. Sysroot

A sysroot is the place where the toolchain searches for libraries and includes. When you do a native local build
this is normally set to `/`. The toolchain will then search in $sysroot/usr/lib, $sysroot/usr/include etc. Any
paths specified have the sysroot prefixed to them, so that for example, when a C file says `#include <stdio.h>`, the 
toolchain knows to adapt the path to the sysroot.

4. The problem

When libtool builds the library libbar, it inserts a runtime path pointing to the location of libfoo. When it links
exe, the path to libbar is specified manually because it is to be linked. However the path to libfoo is not specified
because it should *not* be linked. `ld` still needs it to check the binary, so it looks at the rpath of libbar to
find libfoo. Because a sysroot is in use, the rpath is prefixed with the sysroot. This leads to `ld` failing to find
libfoo, which by default is an error and causes the build to fail.

5. Workarounds

One possible workaround is to specify `-Wl,--unresolved-symbols=ignore-in-shared-libs`. This will cause `ld` to ignore
the symbols in libbar. It will then not even attempt to search for libfoo and the build will succeed. However, doing
this causes other problems, and it is therefore not an acceptable workaround for the general case.

Another workaround is to `over-link` everything. libtool has an option (located inside the generated script itself)
called `link_all_deplibs`. This is usually set to "no" but, for example, in Yocto it is set to "unknown" which gives
the same behavior as setting it to "yes". This causes exe to be linked directly against libbar and libfoo, which means
the absolute locations are on the command line, where they don't get prefixed with the sysroot because they are relative.

Another workaround is to symlink the build directory inside the sysroot, so that any path in $build also exists at
$sysroot/$build. This requires modifying the compiler sysroot and may create a symlink cycle if the sysroot is
inside the build directory, as is the case with this repo.


