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



### Current versions of included libraries and binaries

* GNU __AWK__ 3.1.6

	<http://home.claranet.de/xyzzy/home/ltru/gawk-win.htm>

	This version does not depend on any dlls, and does not segfault
	like the official GNU awk.exe

* __7-Zip__ (A) 4.65 2009-02-03

	<http://www.7-zip.org>

* __Dos2Unix__ (ancient, pre 2000)

	<http://www.bastet.com>

* __Boost__ 1.39.0

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

* __GLEW__ 1.5.4

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


### ChangeLog

* Version _20.2_, 22. March 2010
	- add `7za.exe`
	- add `dos2unix.exe`
	- add `vecmat.jar` and `vecmath-src.jar`

* Version _20.1_, 2. March 2010
	- Replaced OpenAL from Creative with OpenAL Soft 1.11 to fix
	  the volume escalation bug, and for air-absorption support

* Version _20_, 23. January 2010
	- updated OpenAL to fix bugs on win7
	- updated ogg/vorbis

* Version _19.2_, 05. August 2009
	- added missing libraries for new mingw (shared libd, mingwm10)
	- updated `ogg.dll` (1.1.4) and `vorbis.dll`/`vorbisfile.dll` (1.2.3)

* Version _19.1_, 01. August 2009
	- removed wx includes
	- added boost::signals library

* Version _19_, 15. May 2009
	- removed wxWindows-dlls

* Version _18_, 10. May 2009
	- replaced `awk.exe` with a non segfaulting one,
	  that does not depend on extra DLLs
	- removed `junction.exe`, as we found out it is not needed

* Version _17_, 8. May 2009
	- added `junction.exe`, a script for making junctions on NTFS,
	  comparable to symlinks on unix
	- added libboost_program_options
	- updated boost to 1.39.0 to make compiling with TDM MinGW >= 4.4.0 work
	- replaced awk.exe with a non segfaultign one

* Version _16_, February 2009
	- `ogg.dll` 1.1.3, `vorbis.dll`/`vorbisfile.dll` 1.2.0, hopefully fix some bugs
	- restored older versions of DevIL / IL / ILU (newer ones required msvcp*)

* Version _15_, 13. March 2009
	- removed lots of the static (import?) libraries
	- make directory structure so it works with cmake `Find_Module()` (hopefully without breaking scons)

* Version _14_, 11. March 2009
	- Boost 1.38 (build by Auswaschbar, stripped down with bcp)

* Version _13_, 26. January 2009
	- `OpenAL32.dll` + include (from creative)

* Version _12_
	- added lib for interfacing with the Java VM
	- added `awk.exe` (GNU Awk 3.1.6), which is used by some AI Interfaces

* Version _11_
	- updated boost to 1.35.0 to make compiling with gcc >= 4.3.0 work.

* Version _10_, 8 December 2007
	- Ogg/Vorbis/vorbisfile compiled with MinGW, not MSVC
	- New `glew32.dll`, now compiled with MinGW

* Version _9_, 26 November 2007
	- Added wxWidgets 2.8
	- Downgraded FreeType to 2.1.10.2079 (from v7) because of scaling/alignment issues with 2.3.5
	- Upgraded boost to 1.34

* Version _8_, 21 November 2007
	- Added Ogg
	- Added Vorbis
	- Added Vorbisfile
	- Removed Python 2.4
	- Updated FreeType to 2.3.5
	- Updated GLEW to 1.4.0
	- Updated SDL to 1.2.12
	- Updated Python to 2.5.1
	- Updated Zlib to 1.2.3

