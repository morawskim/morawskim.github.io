# vagrant package - nominatim

Podczas budowania obrazu maszyny nominatim z danymi dla Polski, pojawił się błąd z brakiem wolnego miejsca przy rozpakowywaniu danych open street map.

Jako bazową maszynę wybrałem Ubuntu 18.04. W obrazie tym główna partycja nie ma wymaganego rozmiaru. Zwiększyłem rozmiar tej partycji do 50GB.

Wpierw musimy uzyskać id naszej maszyny wirtualnej.
Możemy to zrobić za pomocą polecenia `cat .vagrant/machines/default/virtualbox/id`

Mając id maszyny virtualbox, możemy wyciągnąć ścieżkę do plik dysku za pomocą polecenia  `VBoxManage showvminfo ${VBOX_ID} --machinereadable | grep 'SCSI-0-0' | cut -d= -f2`

Aby sklonować dysk, musimy mieć wyłączoną maszynę wirtualną. Czyli wywołujemy polecenie `vagrant halt`.

Klonujemy dysk za pomocą polecenia
`VBoxManage clonemedium disk "$VBOX_DISK_PATH" "cloned.vdi" --format VDI`

Następnie zmieniamy rozmiar dysku za pomocą polecenia
`VBoxManage modifyhd "cloned.vdi" --resize 51200`


Ostatni krok to podłączenie nowego dysku do maszyny wirtualnej.
`VBoxManage storageattach ${VBOX_ID} --storagectl "SCSI" --port 0 --device 0 --type hdd --medium "cloned.vdi"`


W moim przypadku, po ponownym uruchomieniu maszyny vagrant partycja miała już nowy rozmiar.
