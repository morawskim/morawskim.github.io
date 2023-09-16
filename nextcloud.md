# Nextcloud

## Automatyczne kasowanie starych wersji plików

Modyfikując plik i synchronizując go z chmurą, Nextcloud tworzy nową wersję pliku. Przechowywanie wielu wersji pliku po długim okresie czasu może zajmować sporo miejsca.
Możemy skonfigurować Nextcloud, aby kasował przestarzałe wersje po X dniach.

Tworzymy nowy plik konfiguracyjny `MOJA_NAZWA.config.php` w katalogu `config` o zawartości:
```php
<?php
$CONFIG = [
    'versions_retention_obligation' => 'auto, 5',
];
```

Korzystając z konfiguracji jak powyżej pliki będą automatycznie kasowane po okresie 5 dni.
Możemy ręcznie wywołać proces kasowania plików wywołując polecenie `./occ versions:expire`

[Controlling file versions and aging](https://docs.nextcloud.com/server/27/admin_manual/configuration_files/file_versioning.html)
