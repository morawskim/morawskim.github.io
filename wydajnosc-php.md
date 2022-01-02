# Wydajność PHP

## Konfiguracja dla php opcache

[Configure OPcache for Maximum Performance](https://symfony.com/doc/current/performance.html#configure-opcache-for-maximum-performance)

```
opcache.enable=1
; maximum memory that OPcache can use to store compiled PHP files
opcache.memory_consumption=256
; maximum number of files that can be stored in the cache
opcache.max_accelerated_files=20000
opcache.enable_cli=1
opcache.save_comments=1
opcache.interned_strings_buffer=8
;Don’t Check PHP Files Timestamps
opcache.validate_timestamps=0

#Preload for symfony framework
opcache.preload=/path/to/symfony/config/preload.php
; required for opcache.preload:
opcache.preload_user=www-data
```
