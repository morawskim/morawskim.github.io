# node debugger

`node` posiada wbudowany debugger. Możemy z niego skorzystać zamiast z Chrome DevTools.
W przypadku serwerów, gdzie nie możemy utworzyć tunelu ssh (`ssh -L 9221:localhost:9229 user@remote.example.com`) do debuggera może to być jedyne wyjście.
Domyślnie debugger nasłuchuje na porcie `9229` i można się do niego podłączyć tylko z lokalnej maszyny.
Aby nasłuchiwać na innym porcie lub innym interfejsie korzystamy z parametru `--inspect=[host:port]`.

Różnica między parametrem `--inspect` a pod poleceniem `inspect` jest taka, że w tym drugim przypadku uruchamiany jest proces potomny, który wykonuje skrypt użytkownika przekazany jako argument. Zaś główny proces uruchamia konsolowy debuggera.


Wywołujemy polecenie `node inspect  ./src/index.js`

```
< Debugger listening on ws://127.0.0.1:9229/5ca7addf-9690-46a7-90e2-3468706ce7d0
< For help see https://nodejs.org/en/docs/inspector
< Debugger attached.
[...]
debug>
```

Pojawi się znak zachęty `debug>`.
Polecenie `help` wyświetla dostępne polecenia debuggera.
```
help
run, restart, r       Run the application or reconnect
kill                  Kill a running application or disconnect

cont, c               Resume execution
next, n               Continue to next line in current file
step, s               Step into, potentially entering a function
out, o                Step out, leaving the current function
backtrace, bt         Print the current backtrace
list                  Print the source around the current line where execution
                      is currently paused
....
```

Możemy ustawić breakpoint za pomocą polecenia `setBreakpoint`.
Polecenie te obsługuje wiele form wejściowych (zgodnie z dokumentacją):
```
setBreakpoint(), sb() - Set breakpoint on current line
setBreakpoint(line), sb(line) - Set breakpoint on specific line
setBreakpoint('fn()'), sb(...) - Set breakpoint on a first statement in functions body
setBreakpoint('script.js', 1), sb(...) - Set breakpoint on first line of script.js
```

Za pomocą polecenia `exec` możemy sprawdzać aktualną wartość zmiennej `exec <zmienna>`.
Zaś polecenie `repl` umożliwia zdalne wywołanie kodu.

Wciąż możemy korzystać z graficznego debuggera Chrome DevTools. Wystarczy uruchomić przeglądarkę chrome i przejść na adres `chrome://inspect/#devices`.


Więcej informacji:

https://nodejs.org/en/docs/guides/debugging-getting-started/

https://nodejs.org/dist/latest-v10.x/docs/api/debugger.html
