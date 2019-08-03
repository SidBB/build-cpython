#!/bin/bash

set -e
set -x

MYDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

DOWNLOAD_URL_OPENSSL="https://github.com/openssl/openssl/archive/OpenSSL_1_1_1c.tar.gz"
DOWNLOAD_URL_CPYTHON="https://github.com/python/cpython/archive/v3.6.9.tar.gz"

WORKSPACE_ROOT="/tmp"
OUTPUT_DIRNAME="python_$(uname -s)_$(uname -m)"
OUTPUT_FILENAME="python_$(uname -s)_$(uname -m).tgz"

#--------------------------------------
# Initialize workspace
#--------------------------------------

WORKSPACE="$WORKSPACE_ROOT/pybuild"

if [[ -d $WORKSPACE ]]; then
	rm -rf $WORKSPACE
fi

PREFIX_DIR_OPENSSL="$WORKSPACE/build_openssl"
PREFIX_DIR_CPYTHON="$WORKSPACE/build_cpython"

mkdir -p $PREFIX_DIR_OPENSSL
mkdir -p $PREFIX_DIR_CPYTHON

#--------------------------------------
# Download source code
#--------------------------------------

cd $PREFIX_DIR_OPENSSL
wget $DOWNLOAD_URL_OPENSSL
tar -xzvf *.tar.gz
rm -f *.tar.gz

SOURCE_DIR_OPENSSL=$(find $PREFIX_DIR_OPENSSL -mindepth 1 -maxdepth 1 -type d | head -n 1)

cd $PREFIX_DIR_CPYTHON
wget ${DOWNLOAD_URL_CPYTHON}
tar -xzvf *.tar.gz
rm -f *.tar.gz

SOURCE_DIR_CPYTHON=$(find $PREFIX_DIR_CPYTHON -mindepth 1 -maxdepth 1 -type d | head -n 1)

#--------------------------------------
# Build openssl
#--------------------------------------

cd $SOURCE_DIR_OPENSSL
./config --prefix=$PREFIX_DIR_OPENSSL --openssldir=$PREFIX_DIR_OPENSSL
make
make install_sw

#--------------------------------------
# Build cpython
#--------------------------------------

cd $SOURCE_DIR_CPYTHON

# Apply patch to force static linking of custom openssl
cp setup.py setup.py.bak
patch setup.py $MYDIR/setup.py.patch
export OPENSSL_ROOT=$PREFIX_DIR_OPENSSL

./configure --prefix=$WORKSPACE_ROOT/$OUTPUT_DIRNAME
make
make install

cd $WORKSPACE_ROOT
tar -czvf $WORKSPACE_ROOT/$OUTPUT_FILENAME $OUTPUT_DIRNAME


#--------------------------------------
# Clean up
#--------------------------------------

if [[ -z $SKIP_CLEANUP ]]; then
	rm -rf $WORKSPACE
	rm -rf $WORKSPACE_ROOT/$OUTPUT_DIRNAME
fi

set +e
set +x

echo "--------------------------------------"
echo "Created:"
echo $WORKSPACE_ROOT/$OUTPUT_FILENAME
echo "--------------------------------------"

