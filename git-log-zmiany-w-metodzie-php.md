# git log - zmiany w metodzie PHP

Aby zobaczyć zmiany w metodzie `public function index` pliku `SettingsController.php` wywołujemy polecenie

```
git log -L '/public function index/','/^    }/':SettingsController.php
```

Git  przeszuka historię i pokaże nam każdą zmianę, która była wykonana w tej metodzie. Wyświetli je w formie listy komitów.