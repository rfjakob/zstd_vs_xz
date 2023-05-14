zstd vs xz, multithreaded (-T0)
===============================

Looks like zstd is *not* the silver bullet for all cases.
xz is faster *and* better for high compression:

![Result Plot](results.png)

Tested with the silesia corpus from https://sun.aei.polsl.pl//~sdeor/index.php?page=silesia ,
decompressed and tar'ed into silesia.tar.

CPU = Intel(R) Core(TM) i5-3470 CPU @ 3.20GHz, 4 cores

Tested on Fedora 38 which carries the following versions of
zstd and xz:

```
$ zstd --version
*** Zstandard CLI (64-bit) v1.5.5, by Yann Collet ***

$ xz --version
xz (XZ Utils) 5.4.1
liblzma 5.4.1
```

Note that in terms of decompression speed, zstd blows xz out of
the water:

* xz = 59 MiB/s
* zstd = 632 MiB/s
