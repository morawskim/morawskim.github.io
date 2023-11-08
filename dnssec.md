# DNSSEC

DNSSEC to rozszerzenie protokołu DNS, które wprowadza podpisy kryptograficzne rekordów DNS.

Dodając do wywołania dig `+dnssec` jesteśmy w stanie zweryfikować, czy domena obsługuje DNSSEC - `dig +dnssec sigok.verteiltesysteme.net`.
W odpowiedzi zobaczymy rekord RRSIG, a w sekcji flag `ad`.
Możemy także wykorzystać [narzędzie online](https://dnssec-analyzer.verisignlabs.com/)

>; <<>> DiG 9.18.19 <<>> +dnssec sigok.verteiltesysteme.net @1.1.1.1
>;; global options: +cmd                                                                                                                                                                   >
>;; Got answer:                                                                                                                                                                            >
>;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 21808                                                                                                                                 >
>;; flags: qr rd ra ad; QUERY: 1, ANSWER: 4, AUTHORITY: 0, ADDITIONAL: 1
>
;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags: do; udp: 1232
;; QUESTION SECTION:
;sigok.verteiltesysteme.net.    IN      A
>
;; ANSWER SECTION:
sigok.verteiltesysteme.net. 1799 IN     CNAME   sigok.rsa2048-sha256.ippacket.stream.
sigok.verteiltesysteme.net. 1799 IN     RRSIG   CNAME 13 3 1799 20231109000000 20231019000000 47187 verteiltesysteme.net. YgFpVte3F0JSNFUuoUYLOu7YqF+kCceczC4hxHFNtMVT8LlpinWe83Qr R+P2YKIj6
J7UOLJ5I/yVb0f7n8hboA==
sigok.rsa2048-sha256.ippacket.stream. 60 IN A   195.201.14.36
sigok.rsa2048-sha256.ippacket.stream. 60 IN RRSIG A 8 4 60 20231110030002 20230930030002 46436 rsa2048-sha256.ippacket.stream. sn2ocxLQydTfVvHpCYs4G5hU+nKIPXUX8vHeLzSIeU/HGthLJNWBwDEH um2v
vWngPZLqVgLsT6fXfyzwV0gf5MjYmi4EId/zCti/ZglJoct02GBv OnwsXsacZSPJRZn5717/p4Mrwmc0ILG9mI+5JJwVbTOQwHFtewFyKs4r J44XVOEkyfYVvCJePcJNQs67dFuuhfik0zxMe2Q65CSI/gA+Je1sAs/1 uzllUEHNURg7rI6WjfhY+xW5HmvGlVkT6aUtO2IhpzpurZQStI9mURHr fnLDjXy182RqcbzN3WVg+1OKhKezQOaHxgVEZ9lTRy4rSmqRC8PT4My8 TBOJoA==

Jeśli nie widzimy flagi "ad", być może serwer DNS z którego korzystamy nie obsługuje DNSSEC.
Jeśli wywołując polecenie `dig +short sigfail.verteiltesysteme.net` otrzymamy adres IP domeny np. "195.201.14.36" oznacza to, że serwer DNS nie obsługuje DNSSEC.

Wybierając serwer DNS CloudFlare `dig +short sigfail.verteiltesysteme.net @1.1.1.1` nie otrzymamy adresu IP domeny, a w pełniej odpowiedzi otrzymamy błąd "EDE: 6 (DNSSEC Bogus): (failed to verify sigfail.rsa2048-sha256.ippacket.stream. A: using DNSKEY ids = [46436])"

## SSHFP

Klucz publiczny SSH do serwera, możemy opublikować w rekordzie SSHFP.
W konfiguracji klienta SSH musimy mieć włączoną opcję "VerifyHostKeyDNS" np.

```
Host *
  VerifyHostKeyDNS yes
```

Jeśli do polecenia ssh dodamy flagę -v to w logach powinniśmy znaleźć wpisy, które potiwerdzają użycie rekordów SSHFP.

>(...)
debug1: Server host key: ssh-ed25519 SHA256:D/chF9JcMvMwi2RIC+oKqZ9T5d6SG1HaxQCMFDMEMwE
debug1: found 6 secure fingerprints in DNS
debug1: verify_host_key_dns: matched SSHFP type 4 fptype 1
debug1: verify_host_key_dns: matched SSHFP type 4 fptype 2
debug1: matching host key fingerprint found in DNS
(...)

### Troubleshooting

Jeśli w logach przy połączeniu z zdalnym serwerem widzimy "debug1: found 6 insecure fingerprints in DNS" to w pliku `/etc/resolv.conf` dodajemy `options trust-ad`.
Ta opcja zgodnie z [podręcznikiem](https://man7.org/linux/man-pages/man5/resolv.conf.5.html) jest niezbędna, aby aplikacje zaufały fladze ad w odpowiedzi serwera DNS.

> Without this option, the AD bit is not
set in queries, and it is always removed from
responses before they are returned to the
application.  This means that applications can
trust the AD bit in responses if the trust-ad
option has been set correctly.

### Generowanie rekordów SSHFP

Wywołujemy polecenie `ssh-keygen -r <ZDALNY_HOST>`.
W przypadku, gdy otrzymamy komunikat "no keys found" możemy wywołać polecenie dla każdego rodzaju klucza (rsa, ecdsa i ed25519) `ssh-keyscan -t <TYP_KLUCZ_RSA_ECDSDA> <ZDALNY_HOST> |  sed -r 's/^[^ ]+ //' | ssh-keygen -r <ZDALNY_HOST> -f /dev/stdin`
