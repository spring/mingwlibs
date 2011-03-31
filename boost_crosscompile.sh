#!/bin/sh
BOOST_VERSION=1_46_0
BOOST_LIBS="thread system filesystem regex program_options signals"
SPRING_HEADERS="thread system filesystem regex program_options signals format ptr_container spirit algorithm date_time asio"
ASSIMP_HEADERS="math/common_factor smart_ptr"
BOOST_HEADERS="${SPRING_HEADERS} ${ASSIMP_HEADERS}"
BOOST_CONF=./user-config.jam

# Setting system dependent vars
BOOST_BUILD_DIR=/tmp/build-boost
MINGWLIBS_DIR=~/boostlibs/mingwlibs/
# x86 or x86_64
MINGW_GPP=/usr/bin/i686-mingw32-g++
MINGW_RANLIB=i686-mingw32-ranlib

cd boost_${BOOST_VERSION}/

./bootstrap.sh
# Building bcp - boosts own filtering tool
cd tools/bcp
../../bjam --build-dir=${BOOST_BUILD_DIR}
cd ../..
cp $(ls ${BOOST_BUILD_DIR}/boost/*/tools/bcp/*/*/*/bcp) .


# Building the required libraries
echo "using gcc : : ${MINGW_GPP} ;" > ${BOOST_CONF}
./bjam \
    --build-dir="${BOOST_BUILD_DIR}" \
    --user-config=${BOOST_CONF} \
    variant=release \
    target-os=windows \
    threadapi=win32 \
    threading=multi \
    link=static \
    toolset=gcc \
    ${BOOST_LIBS}


# Setup final structure 
mkdir ${MINGWLIBS_DIR}
rm -Rf ${MINGWLIBS_DIR}lib
mkdir ${MINGWLIBS_DIR}lib/
mkdir ${MINGWLIBS_DIR}include/
rm -Rf ${MINGWLIBS_DIR}include/boost
mkdir ${MINGWLIBS_DIR}include/boost/


# Copying the libraries to MinGW-libs
for f in $(find ${BOOST_BUILD_DIR} -iname "*.a"); do
	echo "Copying BOOST_BUILD_DIR/$(basename "$f") to ${MINGWLIBS_DIR}lib/$(basename "$f" | sed -e 's/_win32//' | sed -e 's/\.a/-mt\.a/' )"
	cp "$f" "${MINGWLIBS_DIR}lib/$(basename "$f" | sed -e 's/_win32//' | sed -e 's/\.a/-mt\.a/' )";
done

# Adding symbol tables to the libs (this should not be required anymore in boost 1.43+)
for f in $(ls ${MINGWLIBS_DIR}lib/libboost_*.a); do ${MINGW_RANLIB} "$f"; done


# Copying the headers to MinGW-libs
rm -Rf ${BOOST_BUILD_DIR}/filtered
mkdir ${BOOST_BUILD_DIR}/filtered
./bcp ${BOOST_HEADERS} ${BOOST_BUILD_DIR}/filtered &> /dev/null
cp -r ${BOOST_BUILD_DIR}/filtered/boost ${MINGWLIBS_DIR}include/
