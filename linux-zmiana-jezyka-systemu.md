# linux - zmiana języka systemu

## systemd/timedatectl

```
sudo localectl set-locale LANG=pl_PL.UTF-8
```

Listę dostępnych lokalizacji można wyświetlić poleceniem:
```
localectl list-locales
```

## brak systemd
W przypadku braku działania procesu systemd (np. w kontenerze) musimy ręcznie edytować plik `/etc/locale.conf`.
Wystarczy, że ten plik będzie mieć jedną linię:
```
LANG=pl_PL.UTF-8
```

## nadpisanie ustawień regionalnych dla pojedynczego programu
Kiedy program wyświetla błąd po polsku, może być ciężko znaleźć rozwiązanie w internecie.
Warto więc w takich przypadkach nadpisać zmienną środowiskową `LANG` i wyświetlać komunikaty po angielsku.

```
LANG=C /sciezka/do/programu
```
Albo
```
LANG=en_US.UTF-8 /sciezka/do/programu
```
