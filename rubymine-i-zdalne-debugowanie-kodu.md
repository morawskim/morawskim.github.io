# RubyMine i zdalne debugowanie kodu

W pliku `Vagrantfile` skonfigurowałem przekierowanie portu:
``` ruby
...
node.vm.network "forwarded_port", guest: 1234, host: 1234
...
```

W systemie openSuSE należy doinstalować pakiety `valgrind-devel` i `ruby-devel` .
Dzięki nim, będziemy mogli zainstalować gemy `ruby-debug-ide` i `debase` w systemie.

W RubyMine dodajemy nową konfigurację `Run/Debug Configuration`.
Wybieramy "Ruby remote debug".
Uzupełniamy pola w następujący sposób:
Remote host: Adres ip zdalnej maszyny. Maszyna vagranta działała w NAT i tylko przekierowaliśmy port.
Wpisujemy więc 127.0.0.1

Remote port: 1234

Remote root folder: Ścieżka na maszynie vagranta, gdzie znajduje się kod naszej aplikacji

Local port: 26162

Local root folder: Ścieżka do kodu na lokalnej maszynie


Łączymy się z zdalną maszyną. I odpalamy poniższe polecenie (zakładam że utworzyliśmy binstubs):
```
cd /sciezka/do/applikacji/na/zdalnej/maszynie
./bin/rdebug-ide --host 0.0.0.0 --port 1234 --dispatcher-port 26162 -- $COMMAND$
```

Wracamy do RubyMine i rozpoczynamy debugowanie.
