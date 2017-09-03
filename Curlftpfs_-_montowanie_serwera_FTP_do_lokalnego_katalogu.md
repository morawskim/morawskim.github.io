Curlftpfs - montowanie serwera FTP do lokalnego katalogu
========================================================

Coraz zadziej używa się serwera FTP. Jednak ciągle można go spotkać na współdzielonym hostingu. W takim przypadku możemy podmontować zdalny sewrer FTP jako lokalny katalog. Login i hasło do konta ftp możemy zapisać w pliku

``` bash
~/.netrc
```

Np.

```
machine ADRES_SERWERA_FTP
login LOGIN_KONTA_FTP
password HASLO_DO_KONTA_FTP
```

Po dodaniu takiego wpisu w .netrc nie musimy podawać loginu i hasła podczas wywoływania curlftpfs.

``` bash
curlftpfs -ouid=1000 ftp://SERWER_FTP KATALOG_GDZIE_ZAMONTOWAC
```

Gdzie uid=1000 to id naszego konta na linuxie.