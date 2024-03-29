# YubiKey

[Yubikey Madness](https://felixhammerl.com/2022/08/29/yubikey-madness.html)

[How to use a YubiKey with Fedora Linux](https://fedoramagazine.org/how-to-use-a-yubikey-with-fedora-linux/)

[YubiKey Manager (ykman) CLI and GUI Guide](https://docs.yubico.com/software/yubikey/tools/ykman/webdocs.pdf)

[Using YubiKeys with Fedora](https://docs.fedoraproject.org/en-US/quick-docs/using-yubikeys/)

[Yubico Yubikey Neo Cover](https://www.thingiverse.com/thing:532575)

[YubiKey for SSH, Login, 2FA, GPG and Git Signing](https://ocramius.github.io/blog/yubikey-for-ssh-gpg-git-and-local-login/)

`lsusb -v 2>/dev/null | grep -A2 Yubico | grep "bcdDevice" | awk '{print $2}'` - Wyświetla wersję firmware

## [PIV] Odblokowanie PIN-u

Do odblokowania pinu używamy polecenia `yubico-piv-tool -a unblock-pin`.
Możemy sprawdzić liczbę pozostałych prób PIN-u poleceniem `yubico-piv-tool -a status`

> .....
> PIN tries left: 3

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

Aby dodać kolejny klucz do konta użytkownika wywołujemy polecenie `pamu2fcfg --nouser --pin-verification >> ~/.config/Yubico/u2f_keys`.

W zależności od dystrybucji modyfikacja konfiguracji PAM możemy się trochę różnić.
**Przed wykonaniem kolejnych kroków warto mieć uruchomioną oddzielną sesje z uprawnieniami administracyjnymi, aby móc wycofać zmiany, jeśli coś nie zadziała**
W przypadku openSUSE PAM jest konfigurowany przez program `pam-config`. Musimy skasować dowiązanie symboliczne `/etc/pam.d/common-auth` i skopiować plik `/etc/pam.d/common-auth-pc` pod nazwą `/etc/pam.d/common-auth`. Zgodnie z komentarzem z pliku `common-auth-pc` nie możemy go skasować. Brak dowiązania symbolicznego `common-auth` do `common-auth-pc` wyłącza wykorzystanie mechanizmu `pam-config`.
W pliku `common-auth` dodajemy po linii `auth    required        pam_unix.so     try_first_pass` nową linie `auth    required        pam_u2f.so cue`. Jeśli ta dodawana linia była przed to miałem problem z zalogowaniem się przez KDM.

W nowym oknie terminala próbujemy się zalogować na swoje konto `su - $(whoami)`. Po podaniu hasła, zostaniemy poproszeni o naciśnięcie YubiKey'a.

[openSUSE with Passwordless U2F Login](https://dan.yeaw.me/posts/opensuse-with-passwordless-u2f-login/)

[Set up Yubikey for Passwordless Sudo Authentication](https://dev.to/bashbunni/set-up-yubikey-for-passwordless-sudo-authentication-4h5o)

[Authentication with PAM](https://doc.opensuse.org/documentation/leap/archive/42.2/security/html/book.security/cha.pam.html)

[PAM Configuration Files](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/managing_smart_cards/pam_configuration_files)

## Podpisywanie zatwierdzeń GIT kluczem SSH

Konfigurujemy Git'a do generowania podpisów za pomocą klucza SSH `git config --global gpg.format ssh`

Określamy, który klucz SSH użyć do podpisu (najlepiej korzystać z klucza powiązanego z YubiKey - [Generate an SSH key pair for a FIDO2 hardware security key](https://developers.yubico.com/SSH/Securing_SSH_with_FIDO2.html)) - `git config --global user.signingkey ~/.ssh/klucz.pub`

Po tych zmianach możemy podpisywać zmiany w repozytorium.

Przy weryfikacji podpisów `git log --show-signature` możemy otrzymać komunikat:

> error: gpg.ssh.allowedSignersFile musi być ustawiony i istnieć, aby sprawdzać podpisy ssh

Tworzymy plik `touch ~/.config/git/allowed_signers` i konfigurujemy git `git config gpg.ssh.allowedSignersFile "~/.config/git/allowed_signers"` W projekcie gdzie jest wielu programistów lepszym pomysłem, będzie wersjonowanie tego pliku i ustawienie ścieżki do pliku per projekt.

Następnie dodajemy nasz klucz do pliku z zaufanymi kluczami `echo "$(git config --get user.email) namespaces=\"git\" $(cat ~/.ssh/<MY_KEY>.pub)" >> ~/.config/git/allowed_signers`

Przy następnym wywołaniu polecenia git log powinniśmy otrzymać:
> Good "git" signature for marcin@morawskim.pl with ED25519-SK key SHA256:aM91hUXyi8WnAwAeXdpdKci03XVCdJjnIUjW1OWzwQM

[Sign commits with SSH keys](https://docs.gitlab.com/ee/user/project/repository/signed_commits/ssh.html)

[Securing SSH with FIDO2](https://developers.yubico.com/SSH/Securing_SSH_with_FIDO2.html)
