# YubiKey

[Yubikey Madness](https://felixhammerl.com/2022/08/29/yubikey-madness.html)

[How to use a YubiKey with Fedora Linux](https://fedoramagazine.org/how-to-use-a-yubikey-with-fedora-linux/)

[YubiKey Manager (ykman) CLI and GUI Guide](https://docs.yubico.com/software/yubikey/tools/ykman/webdocs.pdf)

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

## PAM U2F

Yubikey dostarcza moduł [PAM U2F](https://developers.yubico.com/pam-u2f/), który umożliwia w łatwy sposób integrację klucza YubiKey z mechanizmem uwierzytelnienia systemów Linux.
W systemie openSUSE instalujemy pakiet pam_u2f. 
Następnie wywołujemy polecenie `pamu2fcfg -u $(whoami) >> ~/.config/Yubico/u2f_keys` - w moim przypadku zostałem jeszcze spytany o PIN odblokowujący FIDO.
W trakcie wywołania tego polecenia YubiKey zacznie migać i w tym momencie dotykamy metalowego styku, aby potwierdzić powiązanie. 
Jeśli tego nie zrobimy otrzymamy błąd:
> error: fido_dev_make_cred (58) FIDO_ERR_ACTION_TIMEOUT

W moim przypadku moduł FIDO2 już miał skonfigurowany PIN. W przypadku braku pinu, być może niezbędne będzie ustawienie go. Za pomocą polecenia `ykman fido info` możemy wyświetlić informacje, czy mamy skonfigurowany PIN.
Wyświetli się "PIN is not set" lub "PIN is set, with 8 attempt(s) remaining.".

W zależności od dystrybucji modyfikacja konfiguracji PAM możemy się trochę różnić.
**Przed wykonaniem kolejnych kroków warto mieć uruchomioną oddzielną sesje z uprawnieniami administracyjnymi, aby móc wycofać zmiany, jeśli coś nie zadziała**
W przypadku openSUSE PAM jest konfigurowany przez program `pam-config`. Musimy skasować dowiązanie symboliczne `/etc/pam.d/common-auth` i skopiować plik `/etc/pam.d/common-auth-pc` pod nazwą `/etc/pam.d/common-auth`. Zgodnie z komentarzem z pliku `common-auth-pc` nie możemy go skasować. Brak dowiązania symbolicznego `common-auth` do `common-auth-pc` wyłącza wykorzystanie mechanizmu `pam-config`.
W pliku `common-auth` dodajemy po linii `auth    required        pam_unix.so     try_first_pass` nową linie `auth    required        pam_u2f.so cue`. Jeśli ta dodawana linia była przed to miałem problem z zalogowaniem się przez KDM.

W nowym oknie terminala próbujemy się zalogować na swoje konto `su - $(whoami)`. Po podaniu hasła, zostaniemy poproszeni o naciśnięcie YubiKey'a.

[openSUSE with Passwordless U2F Login](https://dan.yeaw.me/posts/opensuse-with-passwordless-u2f-login/)

[Set up Yubikey for Passwordless Sudo Authentication](https://dev.to/bashbunni/set-up-yubikey-for-passwordless-sudo-authentication-4h5o)

[Authentication with PAM](https://doc.opensuse.org/documentation/leap/archive/42.2/security/html/book.security/cha.pam.html)

[PAM Configuration Files](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/managing_smart_cards/pam_configuration_files)
