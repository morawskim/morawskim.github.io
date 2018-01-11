# quilt - zarządzanie łatami (patches)

1. Przechodzimy do katalogu gdzie jest nasz plik spec.
``` bash
cd ~/rpmbuild/SPECS
```

2. Pobieramy pliki źródłowe potrzebne do zbudowania pakietu.
``` bash
rpmdev-spectool -R -g ./asdf.spec
```

3. Przechodzimy do katalogu, gdzie zapisały się pobrany kod źródłowy.
``` bash
cd ~/rpmbuild/SOURCES
quilt setup ../SPECS/asdf.spec
```

4. Przechodzimy do nowego katalogu z rozpakowanym kodem źródłowym. I tworzymy łatę.
``` bash
cd asdf-0.4.0/
quilt new change-install-dir.patch
```

5. Informujemy quilt, że chcemy zmodyfikować plik lib/utils.sh. I go modyfikujemy.
``` bash
quilt add lib/utils.sh
quilt edit lib/utils.sh
```

6. Możemy wyświetlić różnicę (diff) między oryginalnym plikiem a zmodyfikowanym.
``` bash
quilt diff
Index: asdf-0.4.0/lib/utils.sh
===================================================================
--- asdf-0.4.0.orig/lib/utils.sh
+++ asdf-0.4.0/lib/utils.sh
@@ -16,6 +16,14 @@ asdf_dir() {
   echo $ASDF_DIR
 }
 
+asdf_install_dir() {
+  if [ -z $ASDF_INSTALL_DIR ]; then
+    export ASDF_INSTALL_DIR=$(echo $(asdf_dir)/installs)
+  fi
+
+  echo $ASDF_INSTALL_DIR
+}
+
.......
```

7. Jeśli skończyliśmy modyfikować plik to generujemy plik patch.
``` bash
quilt refresh
```

W katalogu `patches/` pojawi się plik `change-install-dir.patch`.
