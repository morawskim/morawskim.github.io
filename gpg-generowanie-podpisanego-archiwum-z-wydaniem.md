# GPG - generowanie podpisanego archiwum z wydaniem

Tworzymy i przechodzimy do katalogu tymczasowego gdzie będziemy przechowywać bazę kluczy GPG.
Wszystkie tymczasowe pliki możemy bezpiecznie skasować na końcu za pomocą polecenia `shred`.

Ustawiamy i eksportujemy zmienną środowiskową `GNUPGHOME` na aktualny katalog roboczy - `export GNUPGHOME=$PWD`

Sprawdzamy czy zmienna środowiskowa się ustawiła - `echo $GNUPGHOME`

Upewniamy się, czy program `gpg` poprawnie interpretuje utworzoną zmienną środowiskową.
Wywołujemy polecenie wyświetlenia wszystkich kluczy publicznych `gpg --list-keys`
Wynik powinien być pusty. A `gpg` powinien utworzyć pliki z bazą kluczy publicznych i prywatnych.

Tworzymy nową parę klucza - `gpg --generate-key`
Odpowiadamy na pytania.

Ponownie sprawdzamy dostępne klucze w bazie - `gpg --list-keys`
Tym razem wyświetli się nasz nowo utworzony klucz:

```
pub   rsa2048 2019-08-23 [SC] [wygasa: 2021-08-22]
      9A15C8BE071D9757BA421115B346D3D53916CAE1
uid           [    absolutne   ] Marcin M <marcin@morawskim.pl>
sub   rsa2048 2019-08-23 [E] [wygasa: 2021-08-22]
```

Eksportujemy nasz klucz publiczny do pliku `pubkey.asc` - `gpg --armor --export 9A15C8BE071D9757BA421115B346D3D53916CAE1 > pubkey.asc`

Eksportujemy nasz klucz prywatny do pliku `seckey.asc` - `gpg --armor --export-secret-keys 9A15C8BE071D9757BA421115B346D3D53916CAE1 > seckey.asc`
Dzięki temu będziemy mogli go zaimportować na innej maszynie, albo po skasowaniu katalogu tymczasowego gpg.
Plik `seckey.asc` zawiera zarówno nasz klucz publiczny jak i prywatny. Wystarczy, zaimportować tylko ten plik.

Poprawność importu klucza prywatnego można zweryfikowac poleceniem `gpg --list-secret-keys`
```
---------------------------------------
sec   rsa2048 2019-08-23 [SC] [wygasa: 2021-08-22]
      9A15C8BE071D9757BA421115B346D3D53916CAE1
uid           [    nieznane   ] Marcin M <marcin@morawskim.pl>
ssb   rsa2048 2019-08-23 [E] [wygasa: 2021-08-22]
```

Generujemy podpis dla pliku - `gpg --armor --output <sciezka/do/pliku/podpisu> --detach-sign <sciezka/do/archiwum>`
Możemy pominąć parametr `--output` wtedy plik podpisu zostanie zapisany w tym samym katalogu co plik do podpisu z dodatkowym rozszerzeniem asc.

Finalnie możemy zweryfikować podpis mając nasz podpis i plik za pomocą polecenia -
`gpg --verify <sciezka/do/pliku/podpisu> <sciezka/do/archiwum>`
W przypadku pominięcia argumentu `<sciezka/do/archiwum>` gpg przyjmie że plik nazywa się tak samo jak plik podpisu bez rozszerzenia `asc`.

W przypadku niepoprawnego podpisu dostaniemy błąd:
```
gpg: Podpisano w pią, 23 sie 2019, 20:50:05 CEST
gpg:                przy użyciu klucza RSA 9A15C8BE071D9757BA421115B346D3D53916CAE1
gpg: NIEPOPRAWNY podpis złożony przez ,,Marcin M <marcin@morawskim.pl>'' [absolutne]
```

Aby zweryfikować podpis pliku złożony przez inną osobę, musimy zaimportować klucz publiczny danej osoby - `gpg --import <sciezka/do/publickey.asc`
Samo polecenie weryfikacji się nie zmienia.
W przypadku, gdy klucz publiczny nie jest przez nas traktowany jako zaufany dostaniemy taką informację:
```
gpg: Podpisano w pią, 23 sie 2019, 20:50:05 CEST
gpg:                przy użyciu klucza RSA 9A15C8BE071D9757BA421115B346D3D53916CAE1
gpg: Poprawny podpis złożony przez ,,Marcin M <marcin@morawskim.pl>'' [nieznany]
gpg: OSTRZEŻENIE: Ten klucz nie jest poświadczony zaufanym podpisem!
gpg:              Nie ma pewności co do tożsamości osoby która złożyła podpis.
Odcisk klucza głównego: 9A15 C8BE 071D 9757 BA42  1115 B346 D3D5 3916 CAE1
```

Musimy ręcznie zweryfikować czy klucz, który został wykorzystany do podpisania jest poprawny (zaufany).
