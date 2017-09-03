Grep podswietlenie frazy i wyświetlenie całego pliku
====================================================

Domyślnie grep nie wyświetli linii, które nie pasują do wzorca. W przypadku, gdy chcemy podświetlić frazę i wyświetlić cały plik możemy skorzystać z poniższego polecenia. Efektem będzie wyświetlenie pełnej zawartości pliku "file.log" i podświetlenie frazy "clientId".

``` bash
grep -E -i 'clientId|$' --color=always file.log
```