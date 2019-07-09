# php - CSV i znak końca lini MAC

W projekcie korzystałem z funkcji `fgetcsv` do parsowania pliku CSV. Jednak w przypadku plików CSV utworzonych w systemach MAC, natrafiłem na problem z znakiem końca linii. MAC korzysta z `\r` jako znaku nowej lini. Ten znak nie był poprawnie interpretowany przez PHP. W efekcie pierwszy wczytany wiersz zawierał całą zawartość pliku. Rozwiązaniem było ustawienie parametru `auto_detect_line_endings` na wartość `true`.


``` php
$flag = ini_set(‘auto_detect_line_endings’, TRUE);
// parsowanie pliku CSV
ini_set(‘auto_detect_line_endings’, $flag);
```

[https://www.php.net/manual/en/filesystem.configuration.php#ini.auto-detect-line-endings](https://www.php.net/manual/en/filesystem.configuration.php#ini.auto-detect-line-endings)
