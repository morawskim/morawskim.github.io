Fetchmail - przykładowy plik konfiguracyjny (GMAIL)
===================================================

Plik zapisać pod nazwą .fetchmailrc

```
#włącza/wyłącza tryb usługi. Program będzie automatycznie pobierać wiadomości email co określony okres (w sekundach).
#set daemon interval

#Do   error  logging  through  sys‐log(3).
#set syslog
#set no syslog

#Name of a file to append error and status messages to.
#Wartość tego parametru można przekazać jako argument polecenia fetchmail - "-L"
#set logfile

#schemat poll serwerImapLubPop3 protocol IMAP|POP3
poll imap.gmail.com protocol IMAP
  #Parametr nazwaKontaLinux określa nazwę lokalną użytkownika, do którego zostaje dostarczona wiadomość
  user nazwauzytkownika@gmail.com is nazwaKontaLinux here
  password "haslo"

  #zachowuje wiadomości na serwerze.  Opcja nokeep spowoduje że pobrane wiadomości email zostaną skasowane.
  keep

  #wymusza bezpieczne połączenie
  ssl

  #wymusza "dokładniejsze" sprawdzenie certufikatów podczas nawiązywania bezpiecznego połaczenia
  sslcertck

  #This option lets fetchmail use a Message or Local Delivery Agent (MDA or LDA) directly, rather than forward via SMTP or LMTP.
  #mda "/usr/bin/procmail -f %F -d %T"

  #Limit  the  number  of messages accepted from a given server in a single poll.  By default there is no limit.
  #fetchlimit
```

``` bash
fetchmail -v
```

| Przydane argumenty polecenia fetchmail |
|----------------------------------------|
| -d                                     |
| -f                                     |
| -v                                     |
| -N                                     |
| -L filename                            |
| --syslog                               |

