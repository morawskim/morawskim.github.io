Cross compiling - cmake i pkg-config
====================================

W przypadku kiedy w regułach cmake korzystamy z makr pkg\*, to musimy odpowiednio zmodyfikować nasze środowisko.

``` cmake
...
find_package(PkgConfig)
pkg_check_modules(CURL REQUIRED libcurl)
...
```

Musimy zamontować główny system plików zdalnego systemu. W tym przykładzie do katalogu /mnt. Ustawiamy też kilka zmiennych środowiskowych, które poinformują program pkg-config, gdzie szukać plików nagłówkowych i plików obiektowych bibliotek docelowego środowiska.

``` bash
#Ustawiamy wartość na katalog gdzie zamontowaliśmy główny system plików systemu na który kompilujemy program
SYSROOT=/mnt

#Resetujemy ta zmienna, bo chcemy aby pod uwagę były brane tylko biblioteki z środowiska na które kompilujemy
export PKG_CONFIG_DIR=

#Replaces the default pkg-config search directory, usually /usr/lib/pkgconfig
export PKG_CONFIG_LIBDIR=${SYSROOT}/usr/lib/arm-linux-gnueabihf/pkgconfig:${SYSROOT}/usr/lib/pkgconfig:${SYSROOT}/usr/share/pkgconfig

#Modify -I and -L to use the directories located in target sysroot.  this option is useful when cross-compiling packages that use pkg-config to  determine
#CFLAGS  and  LDFLAGS.  -I  and  -L  are  modified  to  point  to  the  new  system  root. this means that a -I/usr/include/libfoo will become -I/var/tar-
#get/usr/include/libfoo with a PKG_CONFIG_SYSROOT_DIR equal to /var/target (same rule apply to -L)
export PKG_CONFIG_SYSROOT_DIR=${SYSROOT}
```