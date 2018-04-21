# composer require - aktualizacja pakietu do określonej wersji

Jeśli chcemy zaktualizować także zależności to dodajemy argument `--update-with-dependencies`.

```
composer require -vvv kartik-v/bootstrap-fileinput:4.4.7

....
Dependency resolution completed in 0.003 seconds
- Removing kartik-v/bootstrap-fileinput (dev-chrome62 f78df0e)
- Installing kartik-v/bootstrap-fileinput (v4.4.7)
Reading /home/marcin/.cache/composer/files/kartik-v/bootstrap-fileinput/d3043f76f6b67736480e647ddfe111f4d5a35df3.zip from cache
Loading from cache
Extracting archive
Executing command (CWD): unzip '/home/marcin/projekty/temple-of-hatshepsut/vendor/kartik-v/bootstrap-fileinput/38c3f311f802423b1992a71fa8ffc806' -d '/home/marcin/projekty/temple-of-hatshepsut/vendor/composer/ce40ecba' && chmod -R u+w '/home/marcin/projekty/temple-of-hatshepsut/vendor/composer/ce40ecba'

REASON: Required by the root package: Install command rule (install kartik-v/bootstrap-fileinput v4.4.7)

Reading /home/marcin/projekty/temple-of-hatshepsut/vendor/composer/installed.json
Writing lock file
Generating autoload files
....
```

