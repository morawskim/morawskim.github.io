# packer - budowanie obrazu ubuntu dla vagrant

W celu zbudowania obrazu dla popularnych dystrybucji Linuxa możemy posiłkować się gotowymi szablonami:

https://github.com/upperstream/packer-templates/

https://github.com/chef/bento/

Aby proces był automatyczny i nie wymagał interwencji ze strony użytkownika musimy korzystać z narzędzi do automatycznej instalacji. Informacje dla Ubuntu i Debiana można znaleźć w poniższych linkach:

https://www.debian.org/releases/stable/example-preseed.txt

https://www.debian.org/releases/stretch/amd64/apb.html.en

Pomimo ustawienia w pliku wstępnej konfiguracji ustawień dla lokalizacji i klawiatury, instalator ciągle pytał się o te ustawienia na początku procesu instalacyjnego.
Rozwiązaniem było ustawienie w parametrach rozruchu jądra Linuxa `auto=true`. Sama opcja `auto` nie była wystarczająca.

Dostępne parametry (i wybrane wartości) można podejrzeć wywołując polecenie `sudo debconf-get-selections --installer`. Wymagany jest zainstalowany pakiet `debconf-utils`.

Instalator tworzy także logi w katalogu `/var/log/installer`. Odpowiedzi na zadawane pytania są dostępne w katalogu `/var/log/installer/cdebconf/`.

Do sprawdzania poprawności pliku służy polecenie `sudo debconf-set-selections -c <plik>`.
Niestety w przypadku literówki i podania odpowiedzi na nieistniejące pytanie polecenie te nie wyświetli żadnego ostrzeżenia. Sprawdzana jest tylko czy linia pasuje do formatu `<owner> <question name> <question type> <value>`.

Na końcu procesu przygotowania maszyny, powinniśmy posprzątać nasz system plików.
Podczas rozruchu `systemd` generuje nam numer identyfikacyjny maszyny w pliku `/etc/machine-id`.
Zgodnie z dokumentacją `systemd` wygenerują ID jeśli zawartość tego pliku będzie pusta - `truncate -s 0 /etc/machine-id`.
