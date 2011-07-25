# MinGW libraries for the Spring RTS game engine

## README

The files in this package are needed to compile spring with MinGW.


### Notes for users

There are two ways of using/setting-up mingwlibs.

1. The simple one (recommended for new users)

Have them in a folder named mingwlibs where you have extracted
the spring source tarball or git repository. This way,
SCons or CMake will automatically find the libs.
Your directory structure should look like this:

	AI/                 Spring AI source code
	game/               Output binaries go here
	installer/          Scripts to build installer
	rts/                Spring source code
	mingwlibs/          This package!
	mingwlibs/bin/      Executables
	mingwlibs/dll/      Dynamic link libraries
	mingwlibs/include/  Header files
	mingwlibs/jlib/     Java libraries
	mingwlibs/lib/      Native import libraries


2. For multiple spring repositories

This is usefull if you have multiple spring repositories,
and you do not want to maintain mingwlibs separately for each of them,
or if you simple want to keep it away from the spring sources.

Just extract the archive anywhere you want it, eg like this:

	C:\mingwlibs\bin
	C:\mingwlibs\dll
	C:\mingwlibs\include
	C:\mingwlibs\jlib
	C:\mingwlibs\lib

For the spring build-system to find the libs, you have to specify them
in the configure step like this:

_SCons_

	scons configure mingwlibsdir=C:\mingwlibs [other-options...]

_CMake_

	cmake -DMINGWLIBS=C:\mingwlibs [other-options...]


### Notes for maintainers

#### Creating MinGW32 import libraries

Also included is `reimp_new.zip`, this contains `reimp.exe` which has been
used to create MinGW32 import libraries for `DevIL.dll`, `ILU.dll` and `ILUT.dll`:

	reimp DevIL.dll
	reimp ILU.dll
	reimp ILUT.dll

This creates `libdevil.a`, `libilu.a`, `libilut.a` and a number of `.def` files.
You can throw away the `.def` files and move the `lib*.a` files to `lib/`.

`il.h` and `ilu.h` contain constructs which do not compile on certain GCC
configurations so they have been fixed using the following command:

	sed -i 's/(ILvoid)/()/g' mingwlibs/include/IL/{il.h,ilu.h}

Additionally `il.h` specifies `__declspec(dllimport) __attribute__(__stdcall__)`
for its (and ILUs) functions, which causes (at least) GCC 4.3 to look for
undecorated functions in the import library, which it will not find.

This is solved by the following modification:

	--- il.h.orig   2007-04-17 23:00:59.000000000 +0200
	+++ il.h        2007-04-18 13:02:55.000000000 +0200
	@@ -386,7 +386,7 @@
	 // This is from Win32s <wingdi.h> and <winnt.h>
	 #if defined(__LCC__)
	        #define ILAPI __stdcall
	-#elif defined(_WIN32) //changed 20031221 to fix bug 840421
	+#elif defined(_MSC_VER) //changed 20031221 to fix bug 840421
	        #ifdef IL_STATIC_LIB
	                #define ILAPI
	        #else

The original `il.h` and `ilu.h` are included too as `il.h.orig` and `ilu.h.orig`.

`imagehlp.h` had an identical problem so it is included in this package. It
should be picked up automatically because of the order of the include paths,
ie. `mingwlibs/include` takes precedence over `%MINGDIR%/include`.
It can be foudn in from `w32api-3.9` on <http://www.mingw.org>.

#### Cross-Compiling Boost

Download [the latest boost sources archive](http://www.boost.org/users/download/).

The following instructions outline the basic procedure,
and they worked for boost 1.42.0.
Due to the nature of boost, it is very likely these steps will have to be adapted
in-between versions.

_Adjust_ and run <boost_crosscompile.sh>.

You should now have both the static libs and the headers of the new boost
version in your mingwlibs dir, and are only left to do the git magic to commit,
and optionally mention the new version in the list below.

### Current versions of included libraries and binaries

* GNU __AWK__ 3.1.6

	<http://home.claranet.de/xyzzy/home/ltru/gawk-win.htm>

	This version does not depend on any dlls, and does not segfault
	like the official GNU `awk.exe`.

* __7-Zip__ (A) 4.65 2009-02-03

	<http://www.7-zip.org>

* __Dos2Unix__ (ancient, pre 2000)

	<http://www.bastet.com>

* __Boost__ 1.46.0

	<http://www.boost.org>

	compiled by Auswaschbar, stripped down with:

		> ./build/bin/bcp thread filesystem regex format ptr_container spirit algorithm date_time /tmp/boost_stripped

* __Devil__ 1.6.8-rc2 (even though the DLL properties say 1.6.5 ...)

	<http://prdownloads.sourceforge.net/openil/Devil-1.6.8-rc2-win-.zip?download>

* __FreeType__ 2.3.5

	<http://gnuwin32.sourceforge.net/downlinks/freetype-bin-zip.php>

	<http://gnuwin32.sourceforge.net/downlinks/freetype-lib-zip.php>

	(Index: <http://gnuwin32.sourceforge.net/packages/freetype.htm>)

	Note: since v9 downgraded to 2.1.10.2079 again because the particular 2.3.5 that
	was included showed small misaligned fonts (works fine with 2.3.5 on linux.)
	Do not know where I originally downloaded 2.1.10.2079

* __GLEW__

	<http://glew.sourceforge.net>

* __SDL__ 1.2.10

	Use SDL 1.2.10 because SDL 1.2.{9,11,12} break keyboard layout.

	<http://libsdl.org/release/SDL-devel-1.2.10-mingw32.tar.gz>

* __Java__ Development Kit SE 1.6.0 update 10 __headers__ and __import library__:

	<http://java.sun.com/javase/downloads/index.jsp>

	<http://www.inonit.com/cygwin/jni/invocationApi/execute.html>

* __Python__ 2.5.1

	<http://www.python.org/ftp/python/2.5.1/python-2.5.1.msi>

	(got `python25.dll` from `C:\Windows\System32`)

* __Zlib__ 1.2.3

	<http://gnuwin32.sourceforge.net/downlinks/zlib-bin-zip.php>

	<http://gnuwin32.sourceforge.net/downlinks/zlib-lib-zip.php>

	(Index: <http://gnuwin32.sourceforge.net/packages/zlib.htm>)

* __OpenAL Soft__ 1.11

	<http://kcat.strangesoft.net/openal.html>

	irc.freenode.net:6667 #OpenAL

* __Ogg/Vorbis/Vorbisfile__

	`libogg-1.1.4`, `libvorbis-1.2.3`

	compiled with mingw gcc 4.4.1

* Java __Vecmath__ (from Java 3D 1.5)

	<http://vecmath.dev.java.net>

* MS C Run-Time Libraries __MSVCR71.dll__

	<http://msdn.microsoft.com/en-us/library/abx4dbyh(VS.71).aspx>

	on that page, see:
		_What is the difference between msvcrt.dll and msvcr71.dll?_
