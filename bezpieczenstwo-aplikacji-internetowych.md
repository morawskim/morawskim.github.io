# Bezpieczeństwo aplikacji internetowych

Bezpieczeństwo informacyjne opiera się na trójkącie CIA:
* poufność (ang. confidentiality)
* integralność (ang. integrity)
* dostępność (ang. availability)

Często przytacza się ponadto wymgów zapewnienia:
* niezaprzeczalności (ang. non-repudiation)
* rozliczalności (ang. accountability)

## Porady

* Aplikacja powinna regenerować identyfikator sesji przy każdej zmianie poziomu uprawnień.

* Warto rozważyć zmianę nazwy identyfikatora sesji na bardziej generyczną np. sessionid

* Ciasteczko identyfikatora sesji powinno mieć ustawione flagi HttpOnly i Secure

* Implementując mechanizm Remember me (zapamiętaj mnie) w oparciu o ciasteczko powiniśmy generować nowe ciasteczko "zapamiętaj mnie"

* Pierwszą możliwą do wykorzystania techniką obejścia weryfikacji rozszerzenia wgrywanego pliku jest zastosowanie techniki Null Byte Injection.
Ten sposób ekspoitacji polega na dodaniu do nazwy plików takich ciągów znaków jak %00 lub \x00 (np. shell.php%00.txt).
Interpretery języków skryptowych mogą w takich przypadkach zakończyć przetwarzanie ciągu znaków po napotkaniu ciągu reprezentującego null byte.
Dzięki temu na serwerze utworzony zostanie plik z zamierzonym przez atakującym rozszerzeniem.

* Generując tokeny warto nie tylko ograniczyć jego ważność, ale również ustawić limity - ograniczyć liczbę zapytań, jakie można wykonać z wykorzystaniem jednego tokena.

## XML XXE

W PHP domyślnie wyłączona jest opcja zastępowania encji, co zwiększa bezpieczeństwo przed atakami XML XXE.
Możemy wyłączyć tą opcję ustawiając flagę [LIBXML_NOENT](https://www.php.net/manual/en/libxml.constants.php#constant.libxml-noent).
W dokumentacji PHP mamy informację, że włączenie tej opcji naraża nas na ataki XML XXE
> Enabling entity substitution may facilitate XML External Entity (XXE) attacks.

Przykładowy plik XML, który odczytuje dane z pliku `/etc/passwd`.
```
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE foo [
<!ENTITY x SYSTEM "file:///etc/passwd" >
]>
<root>
    <foo>&x;</foo>
</root>
```

Przykładowy plik PHP podatny na XML XXE:
```
<?php

$xmlFile = file_get_contents('php://stdin');
$xml = simplexml_load_string($xmlFile, options: LIBXML_NOENT);
print_r($xml->foo);
```

## JWT

* Zgodnie z specyfikacją token JWT nie musi posiadać podpisu. Taki niepodpisany token ma w nagłówku poniższy dokument JSON:

```
{
  "alg": "none",
  "typ": "JWT"
}
```

Choć wydaje się to mało prawdopodobne, to jednak zdażyło się, że biblioteki obsługujące JWT były podatne na ten atak - [Critical vulnerabilities in JSON Web Token libraries](https://auth0.com/blog/critical-vulnerabilities-in-json-web-token-libraries/)

* Powiniśmy ograniczyć liczbę obsługiwanych algorytmów podpisów.

* Standard JWT umożliwia umieszczenie struktury JWK zawierającej klucz publiczny w nagłówku JWT. Klucz ten następnie jest wykorzystywany do weryfikacji podpisu. Atakujący może usunąć oryginalny podpis, dodać swój klucz publiczny w nagłówku,a następnie podpisać token swoim kluczem prywatnym.

* Korzystając z bibliotek JWT powiniśmy uważać na metody "decode" i "verify". Odkodowanie tokenu JWT, to nie to samo co jego weryfikacja.

## WebSocket

* Protokół WebSocket w żaden sposób nie implementuje bezpośrednio mechanizmu uwierzytelnienia, to na aplikacji leży ciężar weryfikacji tożsamości klienta.

* WebSocket jest jedynie protokołem wymiany danych. Informacje przesyłane tym protokołem nie powinny być traktowane jako zaufane.

* Dobrą praktyką jest ograniczenie liczby nawiązanych połączeń po stronie serwera dla jednego klienta. Ochroni to nas przed nadmiernym wyczerpaniem zasobów.

## Cookie SameSite

Flaga SameSite może przyjmować jedną z trzech wartości: Lax, Strict lub None.
Wartość None powinniśmy zastosować wtedy, gdy chcemy by przeglądarka obsługiwała ciasteczko "w standardowy sposób" (tak jak przed narzuceniem polityki SameSite Lax).

W przypadku polityki Strict kwestią decydującą o tym, czy ciasteczko zostanie wysłane czy nie, jest pochodzenie zapytania.
Może być ono typu cross-site - wtedy ciasteczko nie zostanie wysłane, lub same-site - w takim przypadku ciasteczko zostanie dołączone.

Dla Lax alorytm podejmowania decyzji został rozszerzony.
Jeśli wygenerowane zapytanie będzie skutkowało top-level navigation (brak zmiany domeny w pasku adresu)
oraz zostanie przesłane z użyciem tzw. bezpiecznej metody HTTP, ciasteczko zostanie wysłane.
Jeżeli użyta została metoda spoza listy bezpiecznych metod lub zapytanie nie będzie skutkowało top-level navigation, przeglądarka go nie dołaczy.

## Uwierzytelnianie i autoryzacja

Podstawą procesu uwierzytelniania jest przekazane przez użytkonkika danych uwierzytelniających,
które następnie są weryfikowane po stronie serwera.
Aplikacja z którą się komunikujemy musi wykorzystywać bezpieczny kanał komunikacji (najczęściej HTTPS).

Po zalogowaniu się do systemu powiniśmy wygenerować nowy identyfiaktor sesji (atak Session Fixation).

Dostępne rodzaje uwierzytelniania:

* formularz logowania i ciasteczko HTTP

* HTTP Basic Authentication

* OpenID Connect

* Klucze API

* Certyfikaty X509

* Kerberos/NTLM


Dobrą praktyką z perspektywy bezpieczeństwa jest wymuszanie na użytkownikach ponownego uwierzytelnienia w przypadku wykonywania krytycznych operacji jak na przykład:

* zmiana hsała lub adresu email użytkownika

* zmiana ustawień wpływających na bezpieczeństwo aplikacji w panelu administracyjnym


System powinen być audytowalny, czyli dawać możliwość ustalenia, kto, kiedy oraz co wykonał w systemie.
Funkcje odpowiedzialne za uwierzytelnianie użytkownika powinny więc gromadzić informacje (log) o tym, jaki użytkownik uzyskał dostęp do systemu i w jakim czasie.
Dodatkowo system może powinien gromadzić dodatkowe informacje na temat środowiska, w jakim pracuje użytkownik, ktory uzyskał dostęp do systemu.
Takimi danymi mogą być adres IP użytkownika oraz informacje o jego przeglądarce.

### Hydra

Hydra to narzędzie do łamania haseł, które automatycznie przeprowadza ataki słownikowe na różne protokoły i usługi sieciowe, aby odgadnąć hasła do kont użytkowników.

Prosty skrypt logowania do przetestowania narzędzia:
```
<?php

if (!empty($_POST) && (($_POST['login'] ?? '') === 'admin') && (($_POST['password'] ?? '') === '123456')) {
    echo "Hello admin!";
} else {
    echo "Wrong password";
}
```

Plik zapisujemy pod nazwą `login.php` i odpalamy wbudowany serwer HTTP w PHP - `php -S 127.0.0.1:5000 -t .`
Tworzymy także plik `plikZhaslami.txt` w którym umieszczamy najpopularniejsze hasła:
```
foo
bar
baz
12345
123456
```

Rozpoczynamy atak poleceniem `hydra -l admin -P plikZhaslami.txt -s 5000 '127.0.0.1' http-post-form '/login.php:login=^USER^&password=^PASS^:Wrong password'`

Przełącznik `-l` służy do zdefiniowania nazwy użytkownika jaka ma być wykorzystywana do prób logowania.

Przełącznik `-P` służy do wskazania ścieżki do pliku ze słownikiem haseł, jakie mają zostać wykorzystane do ataku.

Przełącznikiem `-s` możemy określić port, jeśli usługa działa na niestandardowym porcie.

Następnie podajemy adres IP lub domene.

`http-post-form` to wybrana metoda ataku.

Ostatni parametr jest rozdzielony znakiem dwukropka.
`/login.php` to adres zasobu, pod ktorym aplikacja przyjmuje żądania uwierzytelnienia.
Następnie przekazujemy informację o parametrach, jakie są przesyłane w poprawnym zapytaniu,
czyli login i password, wskazujemy też miejsca, w których Hydra ma wstawić wykorzystywany do ataku login oraz hasło - odpowiednio `^USER^` oraz `^PASS^`.
Ostatnia część parametru definuje ciąg znaków, który dla Hydry oznaczać będzie, że dana para login-hasło nie pozwoliła na poprawne uwierzytelenie się.

```
Hydra v9.5 (c) 2023 by van Hauser/THC & David Maciejak - Please do not use in military or secret service organizations, or for illegal purposes (this is non-binding, these *** ignore laws and ethics anyway).

Hydra (https://github.com/vanhauser-thc/thc-hydra) starting at 2024-11-03 19:00:55
[DATA] max 5 tasks per 1 server, overall 5 tasks, 5 login tries (l:1/p:5), ~1 try per task
[DATA] attacking http-post-form://127.0.0.1:5000/login.php:login=^USER^&password=^PASS^:Wrong password
[5000][http-post-form] host: 127.0.0.1   login: admin   password: 123456
1 of 1 target successfully completed, 1 valid password found
Hydra (https://github.com/vanhauser-thc/thc-hydra) finished at 2024-11-03 19:00:55
```

## Path Traversal

* Można się spotkać z innymi określeniami tej podatności "Directory Traversal" lub "dot dot slash attack".

* Udana próba wykorzystania tej podatności skutkuje możliwością odczytania zawartości katalogów oraz plików, do których atakujący nie powinien mieć dostępu (np. pliki konfiguracyjne).

* Ochrona przed tym atakiem sprowadza się do odpowiedniej walidacji danych wejściowych do aplikacji.

## SQL Injection

* SQL Injection to podatności aplikacji webowych, dzięki której napastki może wstrzyknąć własny fragment zapytania SQL.

* Stacked queries powinny być wyłączone - sterownik powinien umożliwić wykonanie tylko jednego zapytania SQL. Nie powinno być dozwolone wykonanie wielu zapytań SQL oddzielonych średnikiem.

* Należy wyłączyć potencjalnie niebezpieczne procedury (jak np. zapis plików na dysku, czy wykonywanie poleceń systemu operacyjnego) w bazie danych.
