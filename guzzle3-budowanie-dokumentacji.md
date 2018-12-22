# guzzle3 - budowanie dokumentacji

Klonujemy repozytorium `git clone https://github.com/guzzle/guzzle3.git`

Przechodzimy do katalogu `guzzle3/docs`.

Wywołujemy polecenie `pip install --target=./python --ignore-installed -r requirements.txt`

Budujemy dokumentację w formacie HTML poprzez wywołanie polecenia `make html PYTHONPATH=./python PATH="./python/bin:$PATH"`

Zbudowaną dokumentację możemy otworzyć w domyślnej przeglądarce wywołując polecenie `xdg-open _build/html/docs.html`
