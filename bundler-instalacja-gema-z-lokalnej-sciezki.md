# Bundler - instalacja gem'a z lokalnej ścieżki

Pracując równolegle nad aplikacją i biblioteką chcemy przetestować zmiany biblioteki w aplikacji.
Jednak nie chcemy komitować ciągle kodu. Wtedy możemy zainstalować pakiet gem z lokalnej ścieżki.

W pliku `Gemfile` zmieniamy ustawiania pakietu `rocketchat`.

`gem "rocketchat", path: "/path/to/rocketchat"`

Wywołując komendę `bundle install` gem `rocketchat` zostanie zainstalowany z lokalnej ścieżki, a nie z repozytorium rubygems.

## Bundle config local

Choć metoda powyżej działa, ma poważną wadę.
Jeśli przypadkowo skomitujemy zmianę, to inni użytkownicy będą mieć problem z zainstalowaniem zależności.
Dobrą praktyką jest więc używanie `bundle config local`.

Jeśli w ramach projektu chcemy zainstalować gem `rocketchat` z lokalnej ścieżki to wywołujemy polecenie:
`bundle config local.rocketchat /path/to/rocketchat`

Później kasujemy taki wpis z konfiguracji bundler komendą `bundle config --delete local.YOUR_GEM_NAME`
