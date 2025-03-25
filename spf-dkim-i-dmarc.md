# SPF, DKIM i DMARC

SPF, DKIM i DMARC działają wspólnie jako mechanizm uwierzytelniania wiadomości email.

## SPF

SPF - zadaniem tego mechanizmu jest potwierdzenie, że dany serwer pocztowy mógł wysłać wiadomość email w imieniu danej domeny.
W rekordach systemu DNS umieszcza się informację o serwerach pocztowych, które są uprawnione do wysyłania wiadomości email dla danej domeny.

[Generator rekordów SPF od ClouDNS](https://www.cloudns.net/spf-generator/lang/pl/)

Do testowania polityki SPF możemy wykorzystać serwis emkei.cz - [Free online fake mailer](https://emkei.cz/)
Jednak adres IP tej usługi może znajdować się na czarnej liście spamerskiej.

## DKIM

DKIM - zadaniem tego mechanizmu jest potwierdzenie, że dany serwer pocztowy faktycznie wysłał daną wiadomość email.
Niezbędny jest tutaj system DNS, w którym umieszczamy rekord DNS z kluczem publicznym, który jest powiązany z kluczem prywatnym wykorzystywanym przez serwer pocztowy.

## DMARC

DMARC - mechanizm raportowania, który musi działać w parze z SPF lub DKIM.
Serwer pocztowy odbierający wiadomość email może wysłać informację zwrotną do serwera pocztowego nadawcy o przyczynie odrzucenia wiadomości.

## BIMI

BIMI to standard, który umożliwia wyświetlanie logo firmy obok wiadomości e-mail w skrzynkach odbiorczych użytkowników. Dzięki BIMI organizacje mogą zwiększyć rozpoznawalność swojej marki oraz poprawić wiarygodność e-maili, zmniejszając ryzyko phishingu.

W Gmailu wiadomości z poprawnie skonfigurowanym BIMI są oznaczane poprzez wyświetlanie zweryfikowanego logo obok nazwy nadawcy w skrzynce odbiorczej. Dzięki temu odbiorca widzi oficjalne logo firmy zamiast domyślnej ikony.

Aby korzystać z BIMI:

* domena musi mieć certyfikat VMC lub CMC z zewnętrznego urzędu certyfikacji
* musimy mieć skonfigurowany DMARC w swojej domenie
* publiczny serwer WWW musi obsługiwać BIMI

Aby uzyskać certyfikat VMC nasze logo musi byc oficjalnie zastrzeżonym znakiem towarowym.
Celem VMC jest ochrona logo przed nieautoryzowanym użyciem.
Jeśli logo nie jest chronione znakiem towarowym, możemy skonfigurować BIMI, używając logo z certyfikatem CMC.

Przykładową konfigurację rekordu TXT BIMI dla domeny mbank możemy pobrać poleceniem `dig  default._bimi.mbank.pl txt` albo skorzystać z [narzędzia online](https://easydmarc.com/tools/bimi-lookup).

[Gmail - Więcej informacji o zweryfikowanych adresach e-mail](https://support.google.com/mail/answer/13130196)
[Konfigurowanie BIMI](https://support.google.com/a/answer/10911320)

## Gmail

[Jeśli wybierzesz opcję Ulepszone skanowanie wiadomości przed dostarczeniem, gdy Gmail wykryje podejrzaną zawartość, dostarczenie wiadomości zostanie opóźnione, aby Gmail mógł przeprowadzić dodatkową kontrolę bezpieczeństwa tej wiadomości.](https://support.google.com/a/answer/7380368?authuser=1)
