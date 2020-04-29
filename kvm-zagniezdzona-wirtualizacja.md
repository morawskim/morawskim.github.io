# KVM - Zagnieżdżona wirtualizacja

Poniższy opis dotyczy procesorów Intel. W przypadku procesorów AMD zamiast modułu jądra `kvm_intel` podajemy `kvm_amd`.

Domyślnie zagnieżdżona wirtualizacja nie powinna być włączona, ale możemy się upewnić wywołując polecenie `cat /sys/module/kvm_intel/parameters/nested`
Jeśli dostaniemy wartość `N` oznacza to, że zagnieżdżona wirtualizacja nie jest obsługiwana i możemy ją włączyć.

Tworzymy plik `/etc/modprobe.d/kvm.conf` o zawartości:
```
options kvm_intel nested=1
```

Po ponownym uruchomieniu systemu zagnieżdżona wirtualizacja powinna być obsługiwana.
Potwierdzamy to poleceniem `cat /sys/module/kvm_intel/parameters/nested`.
Teraz powinniśmy dostać wartość `Y`.

Aby sprzętowa wirtualizacja była dostępna na maszynie wirtualnej musimy także skonfigurować flagi procesora maszyny wirtualnej.
Dla procesorów intel wymagane jest rozszerzenie `vmx`. Dla amd jest to `svm`.

W przypadku istniejącej maszyny wirtualnej musimy zmodyfikować plik XML z definicją maszyny.
Wywołujemy polecenie `virsh edit <nazwa>`
Szukamy elementu `<cpu>`.
I dodajemy znacznik `<feature policy='require' name='vmx'/>` tak, aby element `cpu` był rodzicem.
Ponownie uruchamiamy maszynę gościa.
Na maszynie gościa wywołując polecenie `cat /proc/cpuinfo` powinniśmy mieć dostępne flagi `vmx` i `ept` w przypadku procesora `intel`.
Zaś w przypadku amd będzie to `svm` i `npt`.
Jeśli widzimy te flagi procesora, to nasza zagnieżdżona wirtualizacja działa.

Jeśli nie tworzyliśmy jeszcze maszyny wirtualnej możemy do polecenia `virt-install` dodać parametr `--cpu MODEL[,+feature][,-feature][,match=MATCH][,vendor=VENDOR]`.
Podręcznik man opisuje ten parametr w taki sposób:
>Configure the CPU model and CPU features exposed to the guest. The only required value is MODEL , which is a valid CPU model as listed in libvirt's cpu_map.xml file.
>Specific CPU features can be specified in a number of ways: using one of libvirt's feature policy values force, require, optional, disable, or forbid, or with the shorthand '+feature' and '-feature', which equal 'force=feature' and 'disable=feature' respectively
>
>Some examples:
>--cpu core2duo,+x2apic,disable=vmx

Obsługiwane modele procesorów gości architektury `x86_64` możemy wyświetlić poleceniem `virsh cpu-models x86_64` (lub `cat /usr/share/libvirt/cpu_map.xml`).
Możemy także jako model podać `host-passthrough`.

## vagrant

`Vagrant` to narzędzie do tworzenia maszyny wirtualnej najczęściej w środowisku developerskim. Vagrant skraca czas potrzebny do konfiguracji środowiska i pomaga w rozwiązaniu problemu "u mnie działa". Jeśli do wirtualizacji korzystamy z KVM, możemy uruchomić w maszynie wirtualnej stworzonej przez `vagrant` kolejną maszynę wirtualną. Korzystam z tej funkcji w celu budowania obrazów vagrant dla virtualbox.

Tworzymy plik `Vagrantfile`. Musimy skorzystać z obrazu, który działa z libvirt.
``` ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "morawskim/Ubuntu-18.04-amd64-minimal"
  config.vm.box_version = "0.1.0.2020-04-26"
  config.vm.provider :libvirt do |libvirt|
      libvirt.cpus = 2
      libvirt.memory = 2048
      libvirt.nested = true
      libvirt.cpu_feature :name => 'vmx', :policy => 'require'
  end

  # Disable default synced folder
  config.vm.synced_folder ".", "/vagrant", disabled: true
end
```

W systemie openSUSE 15.1 z zainstalowanym pluginem vagrant-libvirt w wersji 0.0.45 powyższy Vagrantfile działa bez żadnej modyfikacji. Na systemie ubuntu 18.04 z pluginem vagrant-libvirt w wersji 0.0.43 otrzymamy błąd
```
Error while creating domain: Error saving the server: Call to virDomainDefineXML failed: XML error: CPU feature 'vmx' specified more than once (VagrantPlugins::ProviderLibvirt::Errors::FogCreateServerError)
```
W takim przypadku w naszym pliku `Vagrantfile` musimy zakomentować linię `libvirt.cpu_feature :name => 'vmx', :policy => 'require'`. I ponowić próbę.

Wywołujemy polecenie `vagrant up`, a następnie `vagrant ssh`.
W maszynie wirtualnej możemy upewnić się, że nasz procesor wspiera sprzętową wirtualizację wywołując polecenie `cat /proc/cpuinfo | grep -E 'vmx|svm'`. Jeśli widzimy jedną z tych flag, oznacza to, że zagnieżdżona wirtualizacja działa.

W maszynie wirtualnej vagrant, instaluje pakiet z nagłówkami jądra Linux <code>sudo apt-get install linux-headers-`uname -r`</code>. Są one potrzebne do zbudowania modułów jądra niezbędnych dla `virtualbox`. Instalujemy więc `virtualbox` - `sudo apt-get install virtualbox`. Jeśli nie zainstalujemy odpowiedniego pakietu linux-headers, to nie będziemy w stanie uruchomić usługi `virtualbox`,  z powodu braku modułów jądra.
Po instalacji usługa `virtualbox` będzie uruchomiona.
