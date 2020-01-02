# KVM - Dostosowanie obrazów cloud

Główne dystrybucje Linuxa oferują obrazy cloud, które możemy dostosować.
Możemy doinstalować dodatkowe pakiety, albo utworzyć nowe konto użytkownika.

Obrazy Ubuntu: https://uec-images.ubuntu.com/releases/
Obrazy CentOS: https://cloud.centos.org/centos/
Obrazy Debian: http://cdimage.debian.org/cdimage/openstack/
Obrazy Fedora: https://alt.fedoraproject.org/cloud/
Obrazy openSUSE: http://download.opensuse.org/repositories/Cloud:/Images:/

Wpierw możemy zwiększyć rozmiar dysku. Wywołujemy polecenie `qemu-img create -f qcow2 -o backing_file=</sciezka/Do/Pobranego/Obrazu> <plikWynikowy.qcow2>`
Tworzy on nowy dysk (wolumen), który rozszerza obraz bazowy.
Następnie powiększamy rozmiar obrazu do np. 20G poprzez polecenie - `qemu-img resize <plikWynikowy.qcow2> 20G`
Możemy sprawdzić, czy faktycznie rozmiar naszego dysku się zmienił wywołując polecenie `qemu-img info <plikWynikowy.qcow2>`. W wyświetlonych informacjach znajdziemy wiersz `virtual size: 20G (21474836480 bytes)`.

Możemy teraz przejść do konfiguracji obrazu, podczas startu maszyny wirtualnej.
Za konfigurację maszyny odpowiada usługa `cloud-init`. Dokumentacja formatu pliku konfiguracyjnego jest dostępna pod adresem https://cloudinit.readthedocs.io/en/latest/.

Musimy utworzyć dwa pliku `user-data` i `meta-data`.
Plik `meta-data` jest prosty. Wystarczy nam poniższa zawartość:

```
{
"instance-id": "iid-local01"
}
```

Plik `user-data` jest bardziej rozbudowany.
```
#cloud-config
hostname: ubuntu-bionic
users:
  - name: marcin
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh-authorized-keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDZpPxCj3WW031TTVkxI520OwqNsXccG5Lg1QC8QBBzO/RnTmyLZHccOOjebhKsrvsKqhdh2VkKBOw5gTPeFAUIE4ucdp+m6Ku8vDPNqEHu2V9JXIiqgyPnuFVN1RtGskCYc4ivFBgLiWdmw8w83xpfM9Vet//+xetDWYIAyUBbMF00K6Jl8UK4dpaQfAcM8YHPZDqxYZfJitRHxa/MeQb3WJwCtV/Yq8ne49LqJAzGuflIsPfQF9VQ0hJt2q4r7vzufy4KvyPQOl40z1r4lKtwFZo1hgBMHxcGWpxS5hRB+5x+clqoGePxB9vTxjfMYh0mMXn7KTb8cVHlSJ5JDnOV marcin@morawskim.pl
```

W systemach Ubuntu do tworzenia pliku `iso` z konfiguracją możemy wykorzystać polecenie `cloud-localds` z pakietu `cloud-image-utils`. W tym przypadku wywołujemy polecenie `cloud-localds <sciezka/Gdzie/Zapisany/Zostanie/Plik/cidata.iso> ./meta-data ./user-data`. W przypadku innych dystrybucji obraz ISO możemy zbudować wywołując polecenie `mkisofs -o <sciezka/Gdzie/Zapisany/Zostanie/Plik/cidata.iso> -V cidata -joliet -rational-rock ./meta-data ./user-data`

Usługa `cloud-init` dokona konfiguracji. Ustawi `hostname` na `ubuntu-bionic`. Założy także linuxowe konto `marcin`, które będzie miało dostęp do `sudo`. Dodatkowo będziemy mogli zalogować się na te konto przez klucz prywatny przypisany do podanego klucza publicznego w plku konfiguracyjnym `user-data`.

Jesteśmy gotowi do uruchomienia nowej maszyny wirtualnej - `virt-install --connect qemu:///system --virt-type kvm --name ubuntu-bionic --memory 800 --vcpus 1 --os-type linux --os-variant ubuntu18.04 --disk path=<plikWynikowy.qcow2>,format=qcow2 --disk  path=<sciezka/Gdzie/Zapisany/Zostanie/Plik/cidata.iso>,device=cdrom --import --network network=default --noautoconsole`

Po utworzeniu maszyny wywołujemy polecenie `virsh -c qemu:///system domifaddr ubuntu-bionic`. Na wyjściu zobaczymy przypisany adres IP do interfejsu sieciowego. Wywołujemy polecenie `ssh marcin@192.168.122.243`, aby połączyć się z maszyną.
