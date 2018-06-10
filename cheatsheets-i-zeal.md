# cheatsheets i zeal

Tworzymy plik `Gemfile`.

```
# frozen_string_literal: true

source "https://rubygems.org"

gem "cheatset"
```

Wywołujemy polecenie

```
bundle install --binstubs=./bin
```

Klonujemy repozytorium `https://github.com/Kapeli/cheatsheets.git`

```
git clone https://github.com/Kapeli/cheatsheets.git
```

Ściągamy submoduły gita będąc w katalogu cheatsheets.

```
git submodule update --init --recursive
```

Wracamy do głównego katalogu (tam gdzie tworzyliśmy plik Gemfile). I wywołujemy polecenie:

```
find cheatsheets/cheatsheets -name "*.rb" | xargs -n 1 ./bin/cheatset generate
```

Zacznie się proces budowania "ściągawek".

Po zakończeniu w naszym głównym katalogu znajdziemy sporo nowych folderów. Pliki z rozszerzeniem `html` możemy otworzyć w przeglądarce.
Katalogi `*.docset` zaś możemy przekopiować do katalogu docset programu Zeal.

```
./ASCII_Tables.docset
./Ack.docset
./Amethyst.docset
./Android_Codenames_Tags_Build_Numbers.docset
./Android_Emulator.docset
./AppCode_Shortcuts.docset
./Atom.docset
...
```

Gotowe do pobrania ściągawki można pobrać z adresu:
https://kapeli.com/feeds/zzz/cheatsheets/[NAZWA].tgz

np.
https://kapeli.com/feeds/zzz/cheatsheets/Ack.tgz

Więcej informacji:
* https://github.com/Kapeli/cheatsheets
* https://github.com/Kapeli/cheatsheets/blob/master/.travis.yml
* https://github.com/zealdocs/zeal/issues/498
