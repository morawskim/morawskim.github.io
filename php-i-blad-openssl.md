# PHP i błąd OpenSSL (unexpected eof while reading)

Przy łączeniu się z API przez SOAP otrzymałem błąd

> Warning: SoapClient::SoapClient(): SSL operation failed with code 1. OpenSSL Error messages:
> error:0A000126:SSL routines::unexpected eof while reading

Projekt wykorzystywał PHP 7.4 i OpenSSL 3.
Szukając informacji o błędzie trafiłem na [zgłoszenie w PHP: OpenSSL 3: Support of SSL_OP_IGNORE_UNEXPECTED_EOF context option #8369](https://github.com/php/php-src/issues/8369).

Problem można odtworzyć wywołując polecenie `php -derror_reporting=-1 -r "echo file_get_contents('https://chromedriver.storage.googleapis.com/LATEST_RELEASE', false, stream_context_create());"`
> [15-Feb-2024 12:02:28 Europe/Warsaw] PHP Warning:  file_get_contents(): SSL operation failed with code 1. OpenSSL Error messages:
> error:0A000126:SSL routines::unexpected eof while reading in Command line code on line 1

Ignorując błędy możemy pozbyć się tych komunikatów z ostrzeżeniami `php -derror_reporting=0 -r "echo file_get_contents('https://chromedriver.storage.googleapis.com/LATEST_RELEASE', false, stream_context_create());"`

Z zgłoszeniem powiązany jest komit [Fix bug #79589: ssl3_read_n:unexpected eof while reading](https://github.com/php/php-src/commit/74f75db0c3665677ec006cd379fd561feacffdc6).
Fix jest dostępny dla PHP 8.1.7+.

Opis tego komitu najlepiej opisuje rozwiązanie problemu:
> Fix bug #79589: ssl3_read_n:unexpected eof while reading
>
> The unexpected EOF failure was introduced in OpenSSL 3.0 to prevent
> truncation attack. However there are many non complaint servers and
> it is causing break for many users including potential majority
> of those where the truncation attack is not applicable. For that reason
> we try to keep behavior consitent with older OpenSSL versions which is
> also the path chosen by some other languages and web servers.
