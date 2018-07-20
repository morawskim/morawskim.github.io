# Zmiana domyślnego programu do otwierania plików

Wpierw określamy mime-type pliku

```
xdg-mime query filetype [SCIEZKA_DO_PLIKU]
text/markdown
```

Do pliku `$HOME/.config/mimeapps.list` w sekcji `[Default Applications]` dopisujemy (jeśli nie ma to tworzymy plik i sekcje):

```
text/markdown=org.kde.kate.desktop
```
Dzięki temu pliki `md` będą otwierane w programie kate. Jeśli chcemy otwierać takie pliki innym programem musimy podać nazwę pliku `desktop` danego programu. Pliki te instalowane są w `/usr/share/applications`.
Po przelogowaniu nasze zmiany są widoczne:

```
xdg-mime query default text/markdown
org.kde.kate.desktop
```
