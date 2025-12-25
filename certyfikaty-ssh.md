# Certyfikaty SSH

Certyfikat SSH to rozszerzenie klasycznego klucza SSH, które dodaje tożsamość, ograniczenia i czas ważności, a całość jest podpisana przez zaufany urząd certyfikujący (CA).


[Jak działają certyfikaty SSH❓Czy zastąpią klucze SSH i te przejdą do przeszłości❓](https://www.youtube.com/watch?v=gKoEWWkdIk4)

[If you’re not using SSH certificates you’re doing SSH wrong](https://smallstep.com/blog/use-ssh-certificates/)

[MAN ssh-keygen CERTIFICATES](https://man.openbsd.org/OpenBSD-current/man1/ssh-keygen.1#CERTIFICATES)

## Tworzenie pary klucza urzędu certyfikującego i konfiguracja SSHD

1. Tworzymy parę klucza urzędu certyfikującego SSH: `ssh-keygen -t ed25519 -f ~/ssh_ca -C "Moje CA"`

1. Kopiujemy klucz publiczny urzędu certyfikującego na zdalny system: `scp ~/ssh_ca.pub foo@192.168.100.168:`

1. Logujemy się do zdalnej maszyny `192.168.100.168` na konto `foo` i przenosimy klucz publiczny CA do katalogu `/etc/ssh/ssh_ca.pub`.

1. Edytujemy plik `/etc/ssh/sshd_config` i dodajemy linię `TrustedUserCAKeys /etc/ssh/ssh_ca.pub`.

1. Sprawdzamy poprawność składni pliku konfiguracyjnego: `sshd -t`.

1. Jeśli nie ma błędów, przeładowujemy usługę SSH: `systemctl restart sshd`

1. Kończymy połączenie z serwerem.


## Podpisywanie klucza SSH użytkownika

Użytkownik na swoim komputerze generuje standardową parę klucza SSH: `ssh-keygen -f ssh_key -t ed25519`

Użytkownik przekazuje nam klucz publiczny, a my generujemy certyfikat SSH: `ssh-keygen -s /sciezka/do/ssh_ca -I identyfikatorCertyfikatu -n vagrant -V +52w /sciezka/do/przeslanego/klucza/publicznego/ssh.pub`

Do wyświetlenia szczegółów certyfikatu SSH używamy polecenia: `ssh-keygen -L -f /sciezka/do/certyfikatu-klucza-publicznego/id_ecdsa-cert.pub`

Przykładowy wynik:
```
/home/marcin/.ssh/ssh_key-cert.pub:
        Type: ssh-ed25519-cert-v01@openssh.com user certificate
        Public key: ED25519-CERT SHA256:UjAP0bFWKFbAQKfFvwFyo2w03uRZaBztmNhpzPig9No
        Signing CA: ED25519 SHA256:nUqBM33aBpCq8vEX/6nsKgp7w8SpmNqAM6LwOKL38UI (using ssh-ed25519)
        Key ID: "identyfikatorCertyfikatu"
        Serial: 0
        Valid: from 2025-12-23T16:14:00 to 2026-12-22T16:15:19
        Principals:
                vagrant
        Critical Options: (none)
        Extensions:
                permit-X11-forwarding
                permit-agent-forwarding
                permit-port-forwarding
                permit-pty
                permit-user-rc
```

### Najważniejsze opcje polecenia ssh-keygen związane z certyfikatami SSH

| Opcja | Argument     | Znaczenie                                                  | Przykład                |
| ----- | ------------ | ---------------------------------------------------------- | ----------------------- |
| `-s`  | `ca_key`     | Podpisuje klucz publiczny jako certyfikat (klucz CA)       | `-s /sciezka/do/ssh_ca` |
| `-I`  | `identity`   | ID certyfikatu                                             | `-I jkowlaski2025`      |
| `-n`  | `principals` | Lista kont użytkowników, na które możemy się zalogować.    | `-n admin,deploy`       |
| `-V`  | `validity`   | Okres ważności certyfikatu                                 | `-V +52w`               |
| `-z`  | `serial`     | Numer seryjny certyfikatu                                  | `-z 1000001`            |
| `-O`  | `option`     | Opcje certyfikatu                                          | `-O no-port-forwarding` |


#### Format opcji -V (ważność)

| Format              | Znaczenie                  |
| ------------------- | -------------------------- |
| `+1h`               | ważny przez 1 godzinę      |
| `+1d`               | ważny 1 dzień              |
| `20250601:20250602` | zakres dat                 |
| `always`            | bez limitu                 |


#### Przykłady opcji -O
| Opcja                        | Działanie       |
| ---------------------------- | --------------- |
| `force-command=/bin/bash`    | wymusza komendę |
| `source-address=10.0.0.5`    | ogranicza IP    |
| `no-port-forwarding`         | blokuje porty   |


## KRL (Key Revocation Lists)

1. Tworzymy plik KRL `ssh-keygen -k -f ./ca_krl`

1. Kopiujemy klucz publiczny urzędu certyfikującego na zdalny system: `scp ./ca_krl foo@192.168.100.168:`

1. Logujemy się do zdalnej maszyny `192.168.100.168` na konto `foo` i przenosimy KRL do katalogu `/etc/ssh/ca_krl`.

1. Edytujemy plik `/etc/ssh/sshd_config` i dodajemy linię `RevokedKeys /etc/ssh/ca_krl`.

1. Sprawdzamy poprawność składni pliku konfiguracyjnego: `sshd -t`.

1. Jeśli nie ma błędów, przeładowujemy usługę SSH: `systemctl reload sshd`

1. Kończymy połączenie z serwerem.


### Unieważnienie certyfikatu

Odwołanie po certyfikacie: `ssh-keygen -k -u -f /etc/ssh/ca_krl /vagrant/ssh_key-cert.pub`

Wyświetlenie odwołanych certyfikatów: `ssh-keygen -Q -l -f /etc/ssh/ca_krl`
