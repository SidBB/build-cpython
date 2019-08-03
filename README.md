# build-cpython

Tools to build cpython with statically linked openssl.

## Usage

Clone this repository and execute `build-<platform>.sh`. If the build is successful, the full path to the resulting distributable package is printed at the end.

To skip cleaning up the temporary build directories, run `export SKIP_CLEANUP=1` before running the build script.

## Details

This currently builds:

- CPython 3.6.9
- OpenSSL 1.1.1c

When building Python modules, OpenSSL libraries are statically linked to avoid runtime dependency on target systems.

The patch used to force static linking of OpenSSL is adapted from this gist:

https://gist.github.com/rkitover/93d89a679705875c59275fb0a8f22b45

