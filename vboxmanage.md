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
