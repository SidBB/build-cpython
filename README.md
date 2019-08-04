# build-cpython

Tools to build cpython with statically linked openssl.

## Build System

For RHEL/CentOS 6.x:

- `yum install git wget`
- `yum groupinstall "Development tools"`
- `yum groupinstall "Additional development"`

For RHEL/CentOS 7.x:

- `yum install git wget`
- `yum groupinstall "Development tools"`
- `yum install zlib zlib-devel`

## Usage

Execute `build-linux.sh`. The script downloads the necessary source code to a workspace directory under `/tmp` and builds all the components. 

If the build is successful, the full path to the resulting distributable package is printed at the end.

At the end of successful builds, the temporary workspace directories are deleted. To skip cleaning them up, run `export SKIP_CLEANUP=1` before running the build script.

## Details

This currently builds:

- CPython 3.6.9
- OpenSSL 1.1.1c

When building Python modules `_ssl` and `_hashlib`, OpenSSL libraries are statically linked to avoid runtime dependency on target systems.

The patch used to force static linking of OpenSSL is a modified version of this gist:

https://gist.github.com/rkitover/93d89a679705875c59275fb0a8f22b45

