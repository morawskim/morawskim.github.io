Dockerfile - Warning: apt-key output should not be parsed (stdout is not a terminal)

Budowałem obraz z dockera z przeglądarką google-chrome i nodejs. Musiałem zaimportować klucz GPG, który podpisuje pakiety deb z nowszą wersją nodejs.
Do importu klucza GPG w systemach Debian użyłem polecenia `sh -c 'curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -'`.
Jednak otrzymywałem błąd `Warning: apt-key output should not be parsed (stdout is not a terminal)`.
Rozwiązaniem tego problemu jest ustawienie wcześniej (w pliku `Dockerfile`) instrukcji ENV - `ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1`
