# Vagrant

## shared folder i brak VirtualBox Guest Additions

W projekcie chcieliśmy zautomatyzować odtworzenie serwera aplikacyjnego po awarii.
Do tego celu wybraliśmy Ansible. Za pomocą maszyny wirtualnej Vagranta chcieliśmy przetestować cały proces.

Oficjalny obraz Vagranta dla Rocky Linux nie zawierał VirtualBox Guest Additions, przez co nie mogłem korzystać z „shared folder”.
Rozwiązaniem okazało się polecenie `vagrant rsync-auto`, które monitoruje wszystkie pliki z sekcji synced_folder w Vagrancie i automatycznie inicjuje ich transfer na maszynę wirtualną po wykryciu zmian.
