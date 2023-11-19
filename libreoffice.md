# LibreOffice

## Konwertowanie dokumentów (usługa)

Za pomocą LibreOffice możemy konwertować dokument do innego formatu np. PDF - `libreoffice --headless --convert-to pdf myfile.odf`. Jednak w takim przypadku za każdym razem wczytujemy LibreOffice do pamięci co znacząco wydłuża cały proces.

Rozwiązaniem jest użycie pakietu Python [unoserver](https://github.com/unoconv/unoserver/).
