# YubiKey

[Yubikey Madness](https://felixhammerl.com/2022/08/29/yubikey-madness.html)

## OATH

`ykman oath accounts add <ACCOUNT_NAME> <SECRET>` - Dodaje konto z nazwą <ACCOUNT_NAME> i tajnym kluczem <SECRET>

`ykman oath accounts code <ACCOUNT_NAME>` - Pobiera kod OTP dla konta <ACCOUNT_NAME>

`ykman oath accounts list` - Lista wszystkich kont przechowywanych na YubiKey

## SSH

Generujemy klucz prywatny, a następnie certyfikat.

```
ykman piv keys generate --algorithm ECCP256 --pin-policy ALWAYS 9a pubkey.pem
ykman piv certificates generate --subject "CN=marcin" --hash-algorithm SHA512 9a pathToPubkeyGeneratedAbove
```

Eksportujemy klucz publiczny SSH - `ssh-keygen -D /usr/lib64/opensc-pkcs11.so -e > ~/ssh/id_rsa.pub`

Do pliku `~/.ssh/config` dodajemy wpis dla hosta `foo`

```
Host foo
  PKCS11Provider /usr/lib64/opensc-pkcs11.so
  IdentitiesOnly yes
```

Klucz SSH możemy dodać do agenta SSH, aby nie podawać ciągle pinów
```
ssh-add -s /usr/lib64/opensc-pkcs11.so
ssh-add -L
```

[Yubikey as an SSH key](https://gist.github.com/jamesog/ad6613195f180c909724c7edbfda762e)

## OpenPGP card not available

W dystrybucji openSUSE Tumbleweed wywołując polecenie `gpg --card-status` otrzymywałem błąd:
```
gpg: selecting openpgp failed: No such device
gpg: OpenPGP card not available: No such device
```

Szukając rozwiązania w internecie natrafiłem na wpis [GnuPG and PC/SC conflicts](https://ludovicrousseau.blogspot.com/2019/06/gnupg-and-pcsc-conflicts.html), który rozwiązał mój problem. Skorzystałem z drugiego rozwiązania, ponieważ w mojej dystrybucji usługa pcscd działała i nie chciałem się jej pozbywać.

Plik `~/.gnupg/scdaemon.conf` powinien zawierać linie:
```
disable-ccid
```

[Step by step guide on how to set up Yubikey with GPG subkeys](https://www.barrage.net/blog/technology/yubikey-and-gpg)

[Developers Guide to GPG and YubiKey](https://developer.okta.com/blog/2021/07/07/developers-guide-to-gpg)
