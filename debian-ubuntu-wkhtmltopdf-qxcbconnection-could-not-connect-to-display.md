# debian/ubuntu wkhtmltopdf - QXcbConnection: Could not connect to display

W systemach debian lub pochodnych np. ubuntu 16.04.3 LTS (Xenial Xerus) podczas generowania pliku pdf przez program `wkhtmltopdf` otrzymamy błąd:

```
/usr/bin/wkhtmltopdf -d 96 --footer-font-size 9 --footer-left "2018-02-14 13:28" --footer-right "[page]/[topage]" -T 5 -B 10 -L 5 -R 5 temp/15186113125a842b704241a0.35174178.html temp/15186113125a842b704241a0.35174178.pdf

QXcbConnection: Could not connect to display 
Aborted (core dumped)
```

W tych systemach biblioteka QT nie jest odpowiednio zmodyfikowana [1].
Musimy zainstalować program `xvfb-run`. Tworzy on "fejkowy" serwer X.

```
sudo apt-get install xvfb-run
xvfb-run /usr/bin/wkhtmltopdf -d 96 --footer-font-size 9 --footer-left "2018-02-14 13:28" --footer-right "[page]/[topage]" -T 5 -B 10 -L 5 -R 5 temp/15186113125a842b704241a0.35174178.html temp/15186113125a842b704241a0.35174178.pdf
```


[1]: https://github.com/wkhtmltopdf/wkhtmltopdf/issues/2037
