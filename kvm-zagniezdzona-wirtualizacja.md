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
