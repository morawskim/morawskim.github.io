# KVM

## Instalacja

W przypadku systemu Ubuntu instalujemy następujące pakiety - `apt-get -y install qemu-kvm libvirt-bin virt-top  libguestfs-tools virtinst bridge-utils`

W dystrybucji openSuSE instalujemy następujące pakiety `zypper in patterns-openSUSE-kvm_server patterns-server-kvm_tools guestfs-tools`

## Konwersja dysku Virtualbox do formatu qcow2

Ze strony https://developer.microsoft.com/en-us/microsoft-edge/tools/vms/ możemy pobrać obrazy maszyn Windowsa z przeglądarką IE/Edge.
Microsoft jednak nie udostępnia obrazów qcow2. Musimy sobie je sami przygotować. W tych maszynach wirtualnych hasło do konta to "Passw0rd!".
Po pobraniu archiwum z obrazem musimy je rozpakować - `unzip <plik>`.
W wyniku dostaniemy pliki ova, który także musimy rozpakować - `tar xvf <plikOVA>`
Pojawią się dwa pliki - ovf i vmdk.
Możemy przejść do ostatniego kroku jakim jest konwersja obrazu z formatu vmdk do qcow2 - `qemu-img convert -p -f vmdk -O qcow2 '<plikVmdk>' <docelowyPlikQcow2>`. W moim przypadku po około 2 minutach miałem gotowy obraz.

Do odpalenia maszyny z obrazem IE11 możemy skorzystać z polecenia `virt-install --connect qemu:///system --name ie11 --vcpus 2 --memory 2048 --disk path=<SciezkaDoObrazuQcow2> --import --noautoconsole --os-variant <win7|win8|win8.1|wind10|winxp>`

W narzędziu `virt-manger` możemy podłączyć się do maszyny wirtualnej z IE. W celu wyjścia i uwolnienia kursora myszki wciskamy jednocześnie LEWE klawisze `ALT` i `CTRL`.

## os-variant

Kiedy tworzymy nową maszynę wirtualną możemy podać parametr `--os-variant`. Dzięki temu qemu może zoptymalizować ustawienia pod konkretny system operacyjny,
Aby porać listę obsługiwanych wartości instalujemy pakiet `libosinfo` (openSuSE) i wywołujemy polecenie `osinfo-query os`.

## spice-vdagent

Instalując maszynę wirtualną z środowiskiem graficznym warto zainstalować pakiet `spice-vdagent`.
Instalator systemu tumbleweed sam zainstalował ten pakiet. W przypadku innych systemów, być może będziemy musieli ręcznie go zainstalować i uruchomić usługę systemową `spice-vdagentd.service` jeśli nie jest uruchomiona - `systemctl status spice-vdagentd.service`.
Za pomocą tego pakietu współdzielony jest schowek, a także nie ma potrzeby przechwytywania myszy. Możemy także kopiować pliki z systemy gospodarza do gościa. A to wszystko także podłączając się do zdalnego serwera qemu/kvm.

## vagrant libvirt provider

W systemie openSUSE Leap 15.1 podczas instalacji pluginu `vagrant-libvirt` natrafiłem na podobny błąd co w [zgłoszeniu](https://github.com/hashicorp/vagrant/issues/8986). [Podobny problem](https://github.com/hashicorp/vagrant/issues/10019) występuje w wersji 15 i edycji Tumbleweed.

```
"gcc -o conftest -I/opt/vagrant/embedded/include/ruby-2.4.0/x86_64-linux -I/opt/vagrant/embedded/include/ruby-2.4.0/ruby/backward -I/opt/vagrant/embedded/include/ruby-2.4.0 -I.  -I/opt/vagrant/embedded/include   -I/opt/vagrant/embedded/include -I/vagrant-substrate/cache/ruby-2.4.4/include -O3 -fPIC  conftest.c  -L. -L/opt/vagrant/embedded/lib -Wl,-rpath,/opt/vagrant/embedded/lib -L/opt/vagrant/embedded/lib -Wl,-rpath,/opt/vagrant/embedded/lib -L. -L/opt/vagrant/embedded/lib -Wl,-rpath=XORIGIN/../lib:/opt/vagrant/embedded/lib -fstack-protector -rdynamic -Wl,-export-dynamic -L/opt/vagrant/embedded/lib  -Wl,-rpath,/opt/vagrant/embedded/lib     -Wl,-rpath,'/../lib' -Wl,-rpath,'/../lib' -lruby  -lpthread -lrt -lgmp -ldl -lcrypt -lm   -lc "
sh: /opt/vagrant/embedded/lib/libreadline.so.7: no version information available (required by sh)
sh: symbol lookup error: /opt/vagrant/embedded/lib/libreadline.so.7: undefined symbol: PC
checked program was:
/* begin */
1: #include "ruby.h"
2:
3: int main(int argc, char **argv)
4: {
5:   return 0;
6: }
/* end */
```

Użytkownik aspiers ma gotowe [rozwiązanie](https://github.com/hashicorp/vagrant/issues/8986#issuecomment-331713397). W nowszej wersji vagrant zawiera bibliotekę `libreadline` w wersji 7. Musiałem więc dostosować polecenie `sudo mv /opt/vagrant/embedded/lib/libreadline.so.7{,.disabled}`. Następnie ponowiłem próbę instalacji pluginu `vagrant-libvirt`, która tym razem zakończyła się sukcesem (potrzebujemy także pakietu `libvirt-devel`).


## NAT i przekierowanie portów

Maszyny wirtualne podłączone do sieci NAT mogą nawiązywać dowolne wychodzące połączenia sieciowe. Połączenia przychodzące są dozwolone z hosta i od innych maszyn wirtualnych podłączonych do tej samej sieci NAT. Aby móc wystawić porty (np. 80 i 443) musimy stworzyć skrypt, który jest dostępny publicznie na stronie - [Forwarding Incoming Connections](https://wiki.libvirt.org/page/Networking#Forwarding_Incoming_Connections).

```
#!/bin/bash

VIRB_NIC=YOUR_LIBVIRT_NIC_EG_virbr0

if [ "${1}" = "vm-ubuntu-docker" ]; then

   # Update the following variables to fit your setup
   GUEST_IP=
   GUEST_PORT=
   HOST_PORT=

   if [ "${2}" = "stopped" ] || [ "${2}" = "reconnect" ]; then
        /usr/sbin/iptables -D FORWARD -o $VIRB_NIC -p tcp -d $GUEST_IP --dport $GUEST_PORT -j ACCEPT
        /usr/sbin/iptables -t nat -D PREROUTING -p tcp --dport $HOST_PORT -j DNAT --to $GUEST_IP:$GUEST_PORT
   fi
   if [ "${2}" = "start" ] || [ "${2}" = "reconnect" ]; then
        /usr/sbin/iptables -I FORWARD -o $VIRB_NIC -p tcp -d $GUEST_IP --dport $GUEST_PORT -j ACCEPT
        /usr/sbin/iptables -t nat -I PREROUTING -p tcp --dport $HOST_PORT -j DNAT --to $GUEST_IP:$GUEST_PORT
   fi
fi
```

[KVM forward ports to guests VM with UFW on Linux](https://www.cyberciti.biz/faq/kvm-forward-ports-to-guests-vm-with-ufw-on-linux/)

## Zmiana hasła użytkownika w maszynie wirtualnej

W dystrybucji Ubuntu obraz cloud image nie ustawia hasła do konta ubuntu i zamiast tego lepiej wykorzystać logowanie po SSH.
W przypadku jednak problemów z siecią możemy mieć problem z zdalnym zalogowaniem się do systemu. W takim przypadku możemy tymczasowo ustawić hasło do konta ubuntu, a po rozwiązaniu problemu, ponownie zablokować hasło do konta.

Aby wyświetlić wszystkie istniejące maszyny wirtualne korzystamy z polecenia `virsh list`.
Wyciągamy ścieżkę do obrazu dysku maszyny wirtualnej `virsh dumpxml <moja-maszyna-wirtualna> | grep 'source file'`.
Ustawiamy hasło do konta `virt-customize -a <sciezka-do-pliku-obrazu> --password <nazwa-konta-w-maszynie-wirtualnej>:password:<nowe-haslo>.
Możemy zalogować się do maszyny wirtualnej korzystając z nowego hasła. 
Rozwiązujemy problem i blokujemy konto `sudo passwd -l <nazwa-konta-w-maszynie-wirtualnej>`
