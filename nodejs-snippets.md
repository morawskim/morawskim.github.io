# nodejs snippets

## Debugowanie kodu nodejs bez resetowania procesu

Jeśli chcemy podłączyć się debuggerem (np. chrome devtools) do uruchomionego procesu nodejs musimy poznać jego identyfikator proces tzw. PID. Możemy to zrobić za pomocą polecenie `ps -ef | grep node`. Mając identyfikator procesu wystarczy, że wyślemy sygnał `USR1` do tego procesu - `kill -usr1 PID`

Jak uruchomimy przeglądarkę chrome i wejdziemy na stronę `chrome://inspect` to zobaczymy naszą aplikację którą możemy debugować.
