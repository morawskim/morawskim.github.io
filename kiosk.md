# kiosk

Tworzymy plik Vagrantfile.

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"

  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = true
    # Customize the amount of memory on the VM:
    vb.memory = "1024"
  end

  # config.vm.provision "shell", inline: <<-SHELL
  #    apt-get update
  #    apt-get install -y apache2
  # SHELL
end
```

Uruchamiamy maszynę wirtualną (`vagrant up`), a następnie logujemy się po SSH (`vagrant ssh`).

Będąc na maszynie wirtualnej aktualizujemy metadane dostępnych repozytoriów `sudo apt-get -y update`.

Instalujemy niezbędne pakiety `sudo apt-get -y --no-install-recommends install xorg openbox lightdm lightdm-gtk-greeter chromium-browser unclutter`

Włączamy autologowanie dla konta vagrant - `echo -e "[Seat:*]\nautologin-user=vagrant" | sudo tee /etc/lightdm/lightdm.conf`
Obecnie przy pierwszym uruchomieniu, musimy zalogować się na to konto.
W pliku `/var/log/lightdm/lightdm.log` mamy:

>[+1.01s] DEBUG: Session pid=813: Started with service 'lightdm', username 'ubuntu'
[+1.03s] DEBUG: Session pid=813: Got 1 message(s) from PAM
[+1.03s] DEBUG: Prompt greeter with 1 message(s)

Tworzymy katalog konfiguracyjny openbox - `mkdir -p ~/.config/openbox`

Uruchamiamy przeglądarkę chromium w trybie kiosk po zalogowaniu się do systemu

```
cat <<EOT >> ~/.config/openbox/autostart
chromium --kiosk https://google.com
EOT
```
