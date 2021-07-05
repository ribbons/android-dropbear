Android Dropbear Builds
=======================

![Build status](https://github.com/ribbons/android-dropbear/workflows/Build/badge.svg)

Build script and configuration to cross-compile
[Dropbear](https://matt.ucc.asn.au/dropbear/dropbear.html) for Android.

I've tested the built `dropbearkey` binary and use the `dbclient` binary
regularly.  The `dropbear` server binary builds successfully but is untested
and I suspect would benefit from some adjustment of server related options to
tune it for the Android environment - pull requests welcomed.


Precompiled Binaries
--------------------

armv7a, aarch64, i686 and x86_64 Android binaries compiled under GitHub Actions
are available as release assets from this repository.


Manual Build
------------

* Ensure that the Android NDK is located at `$ANDROID_NDK_HOME` or
  `$ANDROID_HOME/ndk-bundle`.
* Run `./build`
