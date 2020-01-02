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
