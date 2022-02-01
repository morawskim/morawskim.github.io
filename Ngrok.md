Ngrok
=====

## Tunel TCP

Program ngrok umożliwia nam wystawienie jakiegoś portu lokalnego "na świat". Tym samym pominięcie firewalla.

W celu wystawienia np. portu 3306 (MySQL) musimy wywołać poniższe polecenie:

``` bash
ngrok tcp 3306
```

Jeśli dostaliśmy błąd

```
Tunnel session failed: TCP tunnels are only available after you sign up.
Sign up at: https://ngrok.com/signup

If you have already signed up, make sure your authtoken is installed.
Your authtoken is available on your dashboard: https://dashboard.ngrok.com

ERR_NGROK_302
```

To musimy wpierw zarejestrować się na stronie <https://ngrok.com/signup> i wygenerować token. Utworzony token zapisujemy w pliku ~/.ngrok2/ngrok.yml W najprostszej postaci zawartość tego pliku będzie następująca:

```
authtoken: TOKEN
```

Jeśli wszystko poprawnie skonfigurowaliśmy w konsoli powinniśmy zobaczyć adres do którego musimy się podłączyć

```
Forwarding                    tcp://0.tcp.ngrok.io:16496 -> localhost:3306
```

``` bash
mysql -uUSER -pHASLO -h 0.tcp.ngrok.io -P 16496
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 11
Server version: 10.0.30-MariaDB SLE 12 SP1 package

Copyright (c) 2000, 2016, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]>
```

## API

`ngrok` ma wbudowane [JSON REST API](https://ngrok.com/docs#client-api). Za pomocą tego API jesteśmy w stanie programowo pobrać np. publiczny adres np. `https://eaa7-46-182-99-27.ngrok.io` i zaktualizować adres webhooka w zewnętrznym systemie.

`curl -H'Content-Type: application/json' 127.0.0.1:4040/api/tunnels`
