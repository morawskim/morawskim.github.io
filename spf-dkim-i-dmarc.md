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
