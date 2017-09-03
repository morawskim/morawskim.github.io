RPM - towrzenie łat (ang. patch)
================================

Tworzenie łaty z jednego pliku:

``` bash
cp docs/conf.py docs/conf.py.orig
vim docs/conf.py
diff -u docs/conf.py.orig docs/conf.py > ~/rpmbuild/SOURCES/PKGNAME.REASON.patch
```

Tworzenie łaty z zmian w wielu plikach:

``` bash
cp -pr ./ ../PACKAGENAME.orig/
... edytujemy pliki ...
diff -ur ../PACKAGENAME.orig . > ~/rpmbuild/SOURCES/PKGNAME.REASON.patch
```