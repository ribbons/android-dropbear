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

There is a JAR release asset containing all of the binaries (renamed to
lib*name*.so to allow them to be executed from within an Android app).  This is
also [available as a package](https://central.sonatype.com/artifact/com.nerdoftheherd/android-dropbear)
for ease of use as a dependency in Android Studio.


Manual Build
------------

* Ensure that the Android NDK is located at `$ANDROID_NDK_HOME` or
  `$ANDROID_HOME/ndk-bundle`.
* Run `./build`


Example Usage
-------------

From an Android app with the published package added as a dependency:

``` kotlin
val libDir = context.applicationInfo.nativeLibraryDir

val args = ArrayList<String>()
args.add("$libDir/libdbclient.so")
args.add("test@example.com")

val builder = ProcessBuilder(args)
val dbclient = builder.start()

val result = dbclient.waitFor()
val stdout = dbclient.inputStream.bufferedReader().use(BufferedReader::readText)
val stderr = dbclient.errorStream.bufferedReader().use(BufferedReader::readText)

Log.d(TAG, "Exit code: $result")
Log.d(TAG, "Standard out: $stdout")
Log.d(TAG, "Standard error: $stderr")
```

For a full example, you can check out the source of my
[Rsync for Tasker](https://github.com/ribbons/TaskerRsync) app.
