# ngrok - tunel do strony

Program ngrok pozwala wystawić dowolny port "na świat" - [Ngrok](Ngrok.md).
Prócz tego możemy udostępnić stronę, aby odbierać powiadomienia np. z systemu płatności.

Aby wystawić stronę `api.bacca.test` musimy wywołać poniższe polecenie:

``` bash
ngrok http -host-header=api.bacca.test 80
```
