#!/bin/sh

# Setting system dependent vars
BOOST_DIR=/tmp/boost/
BOOST_BUILD_DIR=/tmp/build-boost/
MINGWLIBS_DIR=/tmp/mingwlibs/

# spring's boost dependencies
BOOST_LIBS="test thread system filesystem regex program_options signals"
SPRING_HEADERS="${BOOST_LIBS} format ptr_container spirit algorithm date_time asio"
ASSIMP_HEADERS="math/common_factor smart_ptr"
BOOST_HEADERS="${SPRING_HEADERS} ${ASSIMP_HEADERS}"
BOOST_CONF=./user-config.jam

# x86 or x86_64
MINGW_GPP=/usr/bin/i686-mingw32-g++


BOOST_LIBS_ARG=""
for LIB in $BOOST_LIBS
do
	BOOST_LIBS_ARG="${BOOST_LIBS_ARG} --with-${LIB}"
done


#############################################################################################################

# git clone mingwlibs repo (needed for later uploading)
echo -e "\n---------------------------------------------------"
echo "-- clone git repo"
git clone -l -s .  ${MINGWLIBS_DIR} 


# Setup final structure
echo -e "\n---------------------------------------------------"
echo "-- setup dirs"
mkdir -p ${BOOST_DIR} 2>/dev/null
rm -f ${MINGWLIBS_DIR}lib/libboost* 2>/dev/null
rm -Rf ${MINGWLIBS_DIR}include/boost 2>/dev/null
mkdir -p ${MINGWLIBS_DIR}lib/ 2>/dev/null
mkdir -p ${MINGWLIBS_DIR}include/boost/ 2>/dev/null


# Gentoo related - retrieve boost's tarball
echo -e "\n---------------------------------------------------"
echo "-- fetching boost's tarball"
command -v emerge >/dev/null 2>&1 || { echo >&2 "Gentoo needed. Aborting."; exit 1; } 
emerge boost --fetchonly &>/dev/null
source /etc/make.conf
find ${DISTDIR} -iname "boost_*.tar.*" -print 2>/dev/null | xargs tar -xa -C ${BOOST_DIR} -f


# bootstrap bjam
echo -e "\n---------------------------------------------------"
echo "-- bootstrap bjam"
cd ${BOOST_DIR}/boost_*
./bootstrap.sh || exit 1


# Building bcp - boosts own filtering tool
echo -e "\n---------------------------------------------------"
echo "-- creating bcp"
cd tools/bcp
../../bjam --build-dir=${BOOST_BUILD_DIR} || exit 1
cd ../..
cp $(ls ${BOOST_BUILD_DIR}/boost/*/tools/bcp/*/*/*/bcp) .


# Building the required libraries
echo -e "\n---------------------------------------------------"
echo "-- running bjam"
echo "using gcc : : ${MINGW_GPP} ;" > ${BOOST_CONF}
./bjam \
    -j5 \
    --build-dir="${BOOST_BUILD_DIR}" \
    --stagedir="${MINGWLIBS_DIR}" \
    --user-config=${BOOST_CONF} \
    --debug-building \
    --layout="tagged" \
    ${BOOST_LIBS_ARG} \
    variant=release \
    target-os=windows \
    threadapi=win32 \
    threading=multi \
    link=static \
    toolset=gcc \
|| exit 1


# Copying the headers to MinGW-libs
echo -e "\n---------------------------------------------------"
echo "-- copying headers"
rm -Rf ${BOOST_BUILD_DIR}/filtered
mkdir ${BOOST_BUILD_DIR}/filtered
./bcp ${BOOST_HEADERS} ${BOOST_BUILD_DIR}/filtered
cp -r ${BOOST_BUILD_DIR}/filtered/boost ${MINGWLIBS_DIR}include/


# some config we need
echo -e "\n---------------------------------------------------"
echo "-- adjusting config/user.hpp"
echo "#define BOOST_THREAD_USE_LIB" >> "${MINGWLIBS_DIR}include/boost/config/user.hpp"


# fix names
echo -e "\n---------------------------------------------------"
echo "-- fix some library names"
mv "${MINGWLIBS_DIR}lib/libboost_thread_win32-mt.a" "${MINGWLIBS_DIR}lib/libboost_thread-mt.a"


# push to git repo
echo -e "\n---------------------------------------------------"
echo "-- git push"
cd ${MINGWLIBS_DIR}
git remote add cloud git@github.com:spring/mingwlibs.git
git add --all
git commit -m "boost update"
git push cloud || exit 1


# cleanup
echo -e "\n---------------------------------------------------"
echo "-- cleanup"
rm -rf ${BOOST_BUILD_DIR}
rm -rf ${BOOST_DIR}
rm -rf ${MINGWLIBS_DIR}

exit 0
