This is a trivial autotools project which cannot be successfully
cross compiled due to a bug in libtool.

To reproduce the bug, clone the project and run `./build`, or
with Docker:

    docker build -t autofools .
