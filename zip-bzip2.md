zip - bzip2
===========

Otrzymałem archiwum zip. Próbowałem je rozpakować, ale było ono puste.

Wydałem polecenie, aby przekonać się jaki jest typ pliku
``` bash
file biz_archive.zip 
biz_archive.zip: bzip2 compressed data, block size = 900k
```

Sprawdziłem jeszcze mime type pliku
``` bash
file -i biz_archive.zip 
biz_archive.zip: application/x-bzip2; charset=binary
```

Mając mimetype pliku postanowiłem poszukać bazę mimetype, aby dowiedzieć się jakie jest akceptowalne rozszerzenie pliku.
``` bash
ag -C 4 'application/x-bzip2'
application/x-bzip.xml
49-  <comment xml:lang="zh_TW">Bzip 封存檔</comment>
50-  <generic-icon name="package-x-generic"/>
51-  <glob pattern="*.bz2"/>
52-  <glob pattern="*.bz"/>
53:  <alias type="application/x-bzip2"/>
54-</mime-type>
55-

aliases
45-application/wordperfect application/vnd.wordperfect
46-application/wwf application/x-wwf
47-application/x-123 application/vnd.lotus-1-2-3
48-application/x-annodex application/annodex
49:application/x-bzip2 application/x-bzip
50-application/x-cdr application/vnd.corel-draw
51-application/x-chm application/vnd.ms-htmlhelp
52-application/x-coreldraw application/vnd.corel-draw
53-application/x-dbase application/x-dbf

packages/freedesktop.org.xml
6971-      <match value="BZh" type="string" offset="0"/>
6972-    </magic>
6973-    <glob pattern="*.bz2"/>
6974-    <glob pattern="*.bz"/>
6975:    <alias type="application/x-bzip2"/>
6976-  </mime-type>
6977-  <mime-type type="application/x-bzip-compressed-tar">
6978-    <comment>Tar archive (bzip-compressed)</comment>
6979-    <comment xml:lang="ar">أرشيف Tar (مضغوط-bzip)</comment>
```

Plik ten powinien mieć rozszerzenie bz2.
Dodałem te rozszerzenie. Rozpakowałem plik. Otrzymałem plik "biz_archive.zip". Rozpakowałem i ten plik `biz_archive.zip`.
Sprawdziłem typ rozpakowanego pliku:
``` bash
file biz_archive.zip
biz_archive.zip: POSIX tar archive
```
Zmieniłem, więc rozszerzenie na tar. Rozpakowałem ten plik i zobaczyłem zawartośc archiwum.

Gdyby plik miał rozszerzenie tar.bz2 to nie byłoby żadnego problemu.