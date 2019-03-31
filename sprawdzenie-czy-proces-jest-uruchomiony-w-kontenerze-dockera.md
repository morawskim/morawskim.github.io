# Sprawdzenie czy proces jest uruchomiony w kontenerze docker'a

Istnieje pakiet npm, który sprawdza czy proces jest uruchomiony w kontenerze docker'a - https://github.com/sindresorhus/is-docker

Jest to bardzo prosty pakiet. Sprawdza on dwa warunki.
Pierwszy to czy plik `/.dockerenv` istnieje.
Drugi sprawdza czy w pliku `'/proc/self/cgroup` istnieje ciąg znaków `docker`.
