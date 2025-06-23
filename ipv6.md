# IPv6

[https://test-ipv6.com](https://test-ipv6.com) to serwis diagnostyczny, przeznaczony do wszechstronnego testowania obsługi IPv6 po stronie użytkownika końcowego.

Serwis [https://ip6only.me](https://ip6only.me) to narzędzie online służące do sprawdzania, czy połączenie internetowe korzysta z protokołu IPv6.

[https://www.google.com/intl/en/ipv6/statistics.html](https://www.google.com/intl/en/ipv6/statistics.html) prezentuje statystyki dotyczące globalnego rozwoju i wdrażania protokołu IPv6.

## PHP

Funkcje PHP [gethostbynamel](https://www.php.net/manual/en/function.gethostbynamel.php) oraz [gethostbyname](https://www.php.net/manual/en/function.gethostbyname.php) zwracają adres IPv4 odpowiadający danej nazwie hosta.

Jeśli dany host obsługuje wyłącznie adres IPv6, można skorzystać z funkcji `dns_get_record()` z flagą `DNS_AAAA`, np. `dns_get_record("ip6only.me", \DNS_AAAA)`.

[[HttpClient] Add IPv6 support to NativeHttpClient #59068](https://github.com/symfony/symfony/pull/59068/files)
