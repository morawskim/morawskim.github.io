Bash - podstawianie (parameter substitution)
============================================

Ustawienie domyślnej wartości zmiennej

``` bash
port=${$1:-80}
```

Znajdź i zamień

``` bash
${varName/Pattern/Replacement}

#np
file='php7-php-config.patch'
new_name=${file/php7-/php70v-}
#new_name = php70v-php-config.patch
```