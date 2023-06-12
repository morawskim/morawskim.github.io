# maddy

[maddy](https://github.com/foxcpp/maddy) to serwer pocztowy all-in-one.

Musimy utworzyć rekordy DNS u naszego dostawcy:
 * rekord MX dla domeny
 * rekord A dla naszego serwera pocztowego

 Aby zwiększyć szanse, że maile z naszej domeny nie zostaną oznaczone jako spam powinniśmy dodać dodatkowe rekordy DNS:
 * rekord TXT dla SPF - [generator SPF](https://mxtoolbox.com/SPFRecordGenerator.aspx)
 * rekord TXT dla DKIM

Warto wykonać dodatkowe kroki zgodnie z [instrukcją](https://maddy.email/tutorials/setting-up/), aby zwiększenia bezpieczeństwo serwera.
Wygenerowana wartość dla rekordu DKIM znajduje się w pliku `/data/dkim_keys/<DOMENA>.dns` po pierwszym uruchomieniu serwera.

Dla serwera pocztowego generujemy certyfikat SSL.
Do tego celu użyłem [uacme](https://github.com/ndilieto/uacme).
Jeśli wcześniej nie konfigurowaliśmy uacme to wydajemy polecenie `uacme -v -c ~/.config/uacme new`.
Następnie możemy wygenerować certyfikat SSL `uacme -v -c ~/.config/uacme/ issue <DOMENA>`.
Odrzucamy próbę wygenerowania certyfikatu metodą http i gdy pojawi się metoda dns-01 to ją akceptujemy:

> uacme: challenge=dns-01 ident=mx1.XXXXXXX token=XXXXXXXXXXXXXX key_auth=YYYYYYYYYYYYYYYYY
> uacme: type 'y' followed by a newline to accept challenge, anything else to skip

Tworzymy rekord TXT DNS `_acme-challenge.<DOMENA>` o wartości z pola key_auth - w tym przypadku YYYYYYYYYYYYYYYYY.
Nasz certyfikat i klucz zostaną zapisane w `~/.config/uacme/<DOMENA>/cert.pem` i `~/.config/uacme/private/<DOMENA>/key.pem`.

Tworzymy plik `docker-compose.yml` o zawartości:

```
version: '3.4'
services:
  maddy:
    image: foxcpp/maddy:latest
    ports:
      - "25:25"
      - "143:143"
      - "587:587"
      - "993:993"
    volumes:
      - ./data:/data
    environment:
      MADDY_HOSTNAME: mx1.demo.morawskim.pl
      MADDY_DOMAIN: demo.morawskim.pl
volumes:
  maddydata:
```

W tym samym katalogu tworzymy katalog `data/tls` i kopiujemy certyfikat pod nazwą `fullchain.pem`, a klucz pod nazwą `privkey.pem`.
[Takie nazwy są używane przez domyślną konfigurację maddy](https://github.com/foxcpp/maddy/blob/de756c8dc52b69efa511c8340aa29af76c407f93/maddy.conf.docker#L16)

Do domyślnej [konfiguracji maddy dla Docker](https://github.com/foxcpp/maddy/blob/de756c8dc52b69efa511c8340aa29af76c407f93/maddy.conf.docker) warto dodać linię `openmetrics tcp://0.0.0.0:9749 { }`, aby udostępnić metryki serwera pocztowego (adres IP dostosowujemy do swoich potrzeb).

Uruchamiamy kontener - `docker compose up -d`. 
Następnie podłączamy się pod działający kontener maddy i zakładamy konto dla naszego użytkownika:
```
maddy creds create marcin@<DOMENA> # po wywołaniu tego polecenia zostaniemy spytani o haslo
maddy imap-acct create marcin@<DOMENA>
```

Wysyłamy email z innego konta, w logach maddy powinniśmy mieć wpisy:
>
>maddy-maddy-1  | smtp: incoming message {"msg_id":"83bd4059","sender":"XXXXXXX@gmail.com","src_host":"mail-pg1-f181.google.com","src_ip":"209.85.215.181:46496"}
>maddy-maddy-1  | smtp: RCPT ok  {"msg_id":"83bd4059","rcpt":"marcin@demo.morawskim.pl"}
>maddy-maddy-1  | smtp: accepted {"msg_id":"83bd4059"}


[Open Source Mail Server Maddy Deployment Tutorial](https://lwebapp.com/en/post/maddy-mail-server)

## Testowanie serwera pocztowego

Wykorzystując [usługę online](https://en.internet.nl/test-mail/) możemy przetestować nasz utworzony serwer pocztowy pod kątem wykorzystania dobrych praktyk i zalecanych ustawień bezpieczeństwa.
