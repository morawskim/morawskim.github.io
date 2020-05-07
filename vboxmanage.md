# VBoxManage

`VBoxManage` to interfejs wiersza poleceń Oracle VM VirtualBox. Dzięki niemu możemy kontrolować Oracle VM VirtualBox z systemu operacyjnego hosta, który nie posiada interfejsu graficznego. Za pomocą CLI możemy wykonać wszystkie funkcje (i wiele więcej), do których zapewnia graficzny interfejs użytkownika.

[Dokumentacja VBoxManage](https://www.virtualbox.org/manual/ch08.html)

## Skasowanie maszyny

Sprawdzamy, które maszyny są zarejestrowane `VBoxManage list vms`. W wyniku polecenia zobaczymy nazwę maszyny wirtualnej i jej identyfikator. Te dane będą nam potrzebne później. W naszym przykładzie maszyna nazywa się `output-vagrant_source_1588319404698_22932` zaś jej UUID to `1e127764-b5dc-4b45-90af-f780a7d9bb6a`.
```
"output-vagrant_source_1588319404698_22932" {1e127764-b5dc-4b45-90af-f780a7d9bb6a}
```

Wyświetlamy listę działających maszyn `VBoxManage list runningvms`. Wynik polecenia interpretujemy tak samo jak przy poleceniu `list vms`.
```
"output-vagrant_source_1588319404698_22932" {1e127764-b5dc-4b45-90af-f780a7d9bb6a}
```

Wyłączamy działającą maszynę wirtualną `VBoxManage controlvm <UUID/NAME> poweroff`.

Kasujemy maszynę wirtualną wraz ze wszystkimi plikami `VBoxManage unregistervm --delete <UUID/NAME>`.

## Instalacja pakietu rozszerzeń

``` bash
wget https://download.virtualbox.org/virtualbox/6.1.4/Oracle_VM_VirtualBox_Extension_Pack-6.1.4.vbox-extpack
VBoxManage extpack install --replace Oracle_VM_VirtualBox_Extension_Pack-6.1.4.vbox-extpack
```

## Podłączenie do maszyny wirtualnej uruchomionej w trybie headless

Protokół `VRDP` pozwala nam wyświetlić/podłączyć się do maszyny wirtualnej uruchomionej w trybie `headless. Jednak aby korzystać z VRDP musimy mieć zainstalowany pakiet rozszerzeń VirtualBox - [https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads).

Możemy sprawdzić czy opcja VRDP jest włączona w konfiguracji maszyny wirtualnej wywołując polecenie: `VBoxManage showvminfo <uuid> | grep -i vrde`. Jeśli mamy włączoną opcję VRDP dla maszyny to powinniśmy zobaczyć coś podobnego do: `VRDE:                        enabled (Address 127.0.0.1, Ports 5955, MultiConn: off, ReuseSingleConn: off, Authentication type: null)`. Ważny jest numer portu. Będziemy z niego korzystać podczas połączenia.

Jeśli nasza maszyna wirtualna nie ma włączonej opcji VRDP, możemy ją włączyć wywołując polecenie `vboxmanage modifyvm <uuid> --vrde on`. Jeśli maszyna będzie uruchomiona dostaniemy błąd:
```
VBoxManage: error: The machine '<MACHINE_NAME>' is already locked for a session (or being unlocked)
VBoxManage: error: Details: code VBOX_E_INVALID_OBJECT_STATE (0x80bb0007), component MachineWrap, interface IMachine, callee nsISupports
VBoxManage: error: Context: "LockMachine(a->session, LockType_Write)" at line 531 of file VBoxManageModifyVM.cpp
```

Wywołując polecenie `rdesktop localhost:<PORT>` podłączymy się do maszyny wirtualnej - w przypadku Linuxa do konsoli logowania. Jeśli dostaniemy błąd, warto upewnić się, czy mamy zainstalowany pakiet rozszerzeń Virtualbox.
Poleceniem `sudo ss -apn | grep <PORT>` sprawdzimy czy Virtualbox faktycznie nasłuchuje na tym porcie: `tcp    LISTEN     0      5      127.0.0.1:5955               0.0.0.0:*                   users:(("VBoxHeadless",pid=5048,fd=18))`

W przypadku maszyn vagranta, zamiast korzystać z VRDP, możemy zalogować się do maszyny przez protokół SSH. Vagrant domyślnie przekazuje port usługi SSH z maszyny wirtualnej do systemu gospodarza. Wywołujemy polecenie `VBoxManage showvminfo  <uuid> | grep Rule`. Dostaniemy wynik podobny do `NIC 1 Rule(0):   name = ssh, protocol = tcp, host ip = 127.0.0.1, host port = 2222, guest ip = , guest port = 22`. Port 22 na maszynie wirtualnej został zmapowany do portu `2222` na maszynie gospodarza. Wywołując polecenie `ssh -p 2222 vagrant@127.0.0.1`, zostaniemy spytani o hasło. Wpisujemy `vagrant`. Twórcy obrazów `vagrant` przestrzegają konwencji i zawierają konto `vagrant` z hasłem `vagrant`. Te rozwiązanie ma wadę jeśli często odważamy maszyny wirtualne. Do pliku `~/.ssh/known_hosts` klient ssh wpisujemy odciski klucza serwera. Wcześniej czy później dostaniemy błąd o możliwym ataku typu MITM. W takim przypadku musimy skasować informacje o kluczu z tego pliku, albo podczas wywoływania polecenia połączenia się z maszyną vagrant ignorować weryfikację identyfikatora klucza serwera.
