# KDE - domyślne aplikacje

Najczęściej jeden plik można otworzyć w wielu programach. W środowisku KDE do otarcia plików `application/pdf` służy GIMP. Wynika to z reguły zdefiniowanej w pliku `/usr/share/applications/mimeinfo.cache`.

```
application/pdf=gimp.desktop;okularApplication_pdf.desktop;pdfchain.desktop;draw.desktop;
```

Możemy nadpisać tą regułę w pliku `~/.config/mimeapps.list`. Składnia jest taka sama.

Więcej informacji: https://wiki.archlinux.org/index.php/default_applications
