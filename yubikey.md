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
