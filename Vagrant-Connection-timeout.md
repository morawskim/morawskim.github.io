Vagrant - Connection timeout
============================

Na opensuse 13.2 miałem problem z uruchamianiem maszyn wirtualnych przez vagranta. Problem dotyczył tylko nowszych dystrybucji (openSUSE 42.2 i wyższe). Na openSUSE 42.2 mogłem odpalić 42.2 jak i 42.3.

Dostawałem taki komunikat z błędem:
``` bash
  default: Warning: Connection timeout. Retrying...
Timed out while waiting for the machine to boot. This means that
Vagrant was unable to communicate with the guest machine within                                                                            
the configured ("config.vm.boot_timeout" value) time period.                                                                               

If you look above, you should be able to see the error(s) that
Vagrant had when attempting to connect to the machine. These errors
are usually good hints as to what may be wrong.

If you're using a custom box, make sure that networking is properly
working and you're able to connect to the machine. It is a common
problem that networking isn't setup properly in these boxes.
Verify that authentication configurations are also setup properly,
as well.

If the box appears to be booting properly, you may want to increase
the timeout ("config.vm.boot_timeout") value.
```

Zalogowałem się do maszyny lokalnie. Sprawdziłem czy usługa ssh jest uruchomiona.
Zalogowałem się po ssh na interfejscie localhost. Zauważyłem że intrfejs sieciowy eth0 nie jest skonfigurowany.
Zerknąłem w ustawienia sieci w virtualbox. Zauważyłem że dla intefejsu NAT nie jest zaznaczony checkbox "Kabel podłączony" (w ustawieniach zaawansowanych).
Zaznaczyłem checkbox i wyłączyłem maszynę. Następnie spróbowałem ją uruchomić przez vagrant. Maszyna się uruchomiła.

Postanowiłem zacząc od początku. Usunałem maszynę. Tym razem jednak ustawiłem zmieną środowiskową VAGRANT_LOG
``` bash
VAGRANT_LOG=debug vagrant up |& tee vagrant_up.log
```

Log był bardzo długi, ale można było w nim zobaczyć linję:
```
...
cableconnected1="off"
...
```

Zacząłem szukać informacji w internecie na temat tego parametru.
Znalazłem dwa problemy:
* https://github.com/mitchellh/vagrant/issues/7648
* https://www.virtualbox.org/ticket/15705

Okazało się że w przypadku virtualbox 5.1 inaczej wygląda sekcja konfiguracji interfejsu sieciowego w porównaniu do virtualbox 5.0.
Pojaiwło się także rozwiązanie. Należy jawnie ustawić opcję cableconnected1:
``` ruby
config.vm.provider 'virtualbox' do |vb|
  vb.customize ['modifyvm', :id, '--cableconnected1', 'on']
end
```

Dodałem ten kod do pliku Vagrantfile. Maszyna się uruchomiła i mogłem się zalogować przez vagrant ssh.
