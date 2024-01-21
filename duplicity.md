# Duplicity

`duplicity` tworzy archiwum tar z kopią bezpieczeństwa, szyfruje wynik za pomocą GnuPG i automatycznie przesyła kopię na serwer kopii zapasowych.

Za pomocą polecenie `gpg --gen-key` generujemy klucz, który wykorzystamy do szyfrowania. Wydając polecenie `gpg --list-keys --keyid-format short` uzyskamy identyfikator utworzonego klucza (lub istniejącego).
W moim przypadku identyfikator klucza to `66AE3CFE`. Na wyjściu pojawi się linia podobna do tej `pub   ed25519/66AE3CFE 2021-12-20 [SC] [expires: 2023-12-20]`.
Eksportujemy nasz klucz publiczny - `gpg --output pub.asc --armor --export 66AE3CFE`. Na zdalnej maszynie musimy zaimportować klucz publiczny i oznaczyć go jako zaufany. Możemy to zrobić interaktywnie poleceniami: `gpg --import sciekza/do/klucza` a następnie `gpg --edit-key KEY_ID`. W konsoli gpg wpisujemy polecenie `trust`, aby oznaczyć klucz jako zaufany.
Możemy także wykorzystać moduł ansible [ansible-gpg-key](https://github.com/netson/ansible-gpg-key). W playbook dodajemy zadanie:
```
- name: Add backup gpg key
  gpg_key:
    content: "{{ lookup('file', 'backup/0x66AE3CFE.asc') }}"
    trust: '5'
```

Mając zaimportowany i zaufany klucz publiczny możemy utworzyć kopię zapasową - `/usr/bin/duplicity --verbosity info --encrypt-key 66AE3CFE --full-if-older-than 7D /dir/to/backup file:///path/to/destination`.
Jeśli zaimportowaliśmy klucz publiczny, ale nie oznaczyliśmy go jako zaufany to otrzymamy błąd `There is no assurance this key belongs to the named user`.

W celu przywrócenia kopi zapasowej musimy mieć w systemie klucz prywatny. W przeciwnym przypadku otrzymamy komunikat:
```
===== Begin GnuPG log =====
gpg: encrypted with 256-bit ECDH key, ID CBE36A6CD7980A6D, created 2021-12-20
"Marcin Morawski <marcin@XXXXXXXXXXXX>"
gpg: decryption failed: No secret key
===== End GnuPG log =====
```

Wywołujemy polecenie `duplicity restore --encrypt-key 66AE3CFE file://duplicity-backup/ ./PATH_TO_RESTORE`. W katalogu `PATH_TO_RESTORE` znajdziemy pliki z kopii bezpieczeństwa.

Jeśli podczas przywracania kopi bezpieczeństwa otrzymamy błąd "Błąd 'No space left on device' podczas aktualizacji pliku" to być może próbujemy przywrócić zbyt duży plik.
W takim przypadku musimy ustawić zmienną środowiskową `TMPDIR` na przykład na wartość `$PWD/tmp` (oczywiście musimy mieć niezbędną ilość wolnego miejsca). 
Polecenie możemy poprzedzić zmienną środowiskowa - `TMPDIR=$PWD/tmp  duplicity restore ......`. 

[How To Use Duplicity with GPG to Back Up Data to DigitalOcean Spaces](https://www.digitalocean.com/community/tutorials/how-to-use-duplicity-with-gpg-to-back-up-data-to-digitalocean-spaces)

[duplicity backup - getting started](https://blog.xmatthias.com/duplicity_getting_started/)

[Encrypted backup with Duplicity](https://www.admin-magazine.com/Archive/2016/32/Encrypted-backup-with-Duplicity)

## AWS S3

W systemie Ubuntu instalujemy dodatkowo pakiet `python3-boto3`.

W moim przypadku na serwerze on-premise korzystałem z roli i tymczasowych tokenów AWS. Wyeksportowałem więc zmienne środowiskowe: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` i `AWS_SESSION_TOKEN`.

Do polecenie tworzenia kopi bezpieczeństwa dodajemy flagę `--s3-use-new-style` a jako destination podajemy `boto3+s3://<BUCKET_NAME>`.
