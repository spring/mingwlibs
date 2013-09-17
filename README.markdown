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

This is useful  if you have multiple spring repositories,
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

#### Cross-Compiling Boost

Download [the latest boost sources archive](http://www.boost.org/users/download/).

Due to the nature of boost, it is very likely these steps will have to be adapted
in-between versions.

_Adjust_ and run boost_crosscompile.sh.

You should now have both the static libs and the headers of the new boost
version in your mingwlibs dir, and are only left to do the git magic to commit,
and optionally mention the new version in the list below.

### Current versions of included libraries and binaries

* GNU __md5sum__ (PCP patchlevel 2) 1.22

	<http://etree.org/md5com.html>

	This version has been modified as follows:

	1. Only ever use binary mode
	2. Be more liberal about line endings in files used by `--check`
	3. Built-in Win32 file wildcard matching (globbing)

	Source code changes are available from [Bruce](mailto:bruce@gridpoint.com)
	upon request.

* GNU __AWK__ 3.1.6

	<http://home.claranet.de/xyzzy/home/ltru/gawk-win.htm>

	This version does not depend on any dlls, and does not segfault
	like the official GNU `awk.exe`.

* __7-Zip__ (A) 4.65 2009-02-03

	<http://www.7-zip.org>

* __Boost__ (see boost_crosscompile.sh for the used version)

	<http://www.boost.org>

* __Curl__ 7.24.0
	<http://curl.haxx.se/>

* __Devil__ 1.7.8

	<http://prdownloads.sourceforge.net/openil/Devil-1.6.8-rc2-win-.zip?download>

* __FreeType__ 2.3.5

	<http://gnuwin32.sourceforge.net/downlinks/freetype-bin-zip.php>

	<http://gnuwin32.sourceforge.net/downlinks/freetype-lib-zip.php>

	(Index: <http://gnuwin32.sourceforge.net/packages/freetype.htm>)

	Note: since v9 downgraded to 2.1.10.2079 again because the particular 2.3.5 that
	was included showed small misaligned fonts (works fine with 2.3.5 on linux.)
	Do not know where I originally downloaded 2.1.10.2079

* __GLEW__ 1.5.8.0

	<http://glew.sourceforge.net>

* __SDL__ 1.2.10

	Use SDL 1.2.10 because SDL 1.2.{9,11,12} break keyboard layout.

	<http://libsdl.org/release/SDL-devel-1.2.10-mingw32.tar.gz>

* __Java__ Development Kit SE 1.6.0 update 10 __headers__ and __import library__:

	<http://java.sun.com/javase/downloads/index.jsp>

	<http://www.inonit.com/cygwin/jni/invocationApi/execute.html>

* __pandoc__ 1.8.1.2

	<http://johnmacfarlane.net/pandoc/>

* __Zlib__ 1.2.7

	compiled with https://github.com/abma/pr-downloader/blob/73acf328d6f9b68a9b9ffe33eb2db3c1a7ab45df/scripts/crosscompile.sh

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
