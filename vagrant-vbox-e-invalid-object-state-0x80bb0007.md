# vagrant VBOX_E_INVALID_OBJECT_STATE (0x80bb0007)

Korzystałem z vagranta do tworzenia maszyn wirtualnych. Po miesiącu maszyna virtualbox zawiesiła się i nie było z nią kontaktu. Nie mogłem się z nią połączyć przez polecenie `vagrant ssh`.

Nie mając innego wyjścia postanowiłem wyłączyć maszynę - `vagrant halt`.
Jednak proces wymuszenia wyłączenia maszyny też się nie powiódł.
Moja maszyna virtualbox została zablokowana.

Próbując ponownie uruchomić maszynę `vagrant up` otrzymałem błąd:
```
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Clearing any previously set forwarded ports...
#<Thread:0x0000559e2ece8f20@/usr/share/rubygems-integration/all/gems/vagrant-2.0.2/lib/vagrant/batch_action.rb:71 run> terminated with exception (report_on_exception is true):
Traceback (most recent call last):
        77: from /usr/share/rubygems-integration/all/gems/vagrant-2.0.2/lib/vagrant/batch_action.rb:82:in `block (2 levels) in run'
        76: from /usr/share/rubygems-integration/all/gems/vagrant-2.0.2/lib/vagrant/machine.rb:188:in `action'
        75: from /usr/share/rubygems-integration/all/gems/vagrant-2.0.2/lib/vagrant/machine.rb:188:in `call'
        74: from /usr/share/rubygems-integration/all/gems/vagrant-2.0.2/lib/vagrant/environment.rb:592:in `lock'
        73: from /usr/share/rubygems-integration/all/gems/vagrant-2.0.2/lib/vagrant/machine.rb:202:in `block in action'
        72: from /usr/share/rubygems-integration/all/gems/vagrant-2.0.2/lib/vagrant/machine.rb:227:in `action_raw'
       .....
         9: from /usr/share/rubygems-integration/all/gems/vagrant-2.0.2/lib/vagrant/action/warden.rb:34:in `call'
         8: from /usr/share/rubygems-integration/all/gems/vagrant-2.0.2/plugins/providers/virtualbox/action/set_name.rb:19:in `call'
         7: from /usr/share/rubygems-integration/all/gems/vagrant-2.0.2/lib/vagrant/action/warden.rb:34:in `call'
         6: from /usr/share/rubygems-integration/all/gems/vagrant-2.0.2/plugins/providers/virtualbox/action/clear_forwarded_ports.rb:12:in `call'
         5: from /usr/share/rubygems-integration/all/gems/vagrant-2.0.2/plugins/providers/virtualbox/driver/version_5_0.rb:20:in `clear_forwarded_ports'
         4: from /usr/share/rubygems-integration/all/gems/vagrant-2.0.2/lib/vagrant/util/retryable.rb:17:in `retryable'
         3: from /usr/share/rubygems-integration/all/gems/vagrant-2.0.2/plugins/providers/virtualbox/driver/version_5_0.rb:26:in `block in clear_forwarded_ports'
         2: from /usr/share/rubygems-integration/all/gems/vagrant-2.0.2/plugins/providers/virtualbox/driver/base.rb:372:in `execute'
         1: from /usr/share/rubygems-integration/all/gems/vagrant-2.0.2/lib/vagrant/util/retryable.rb:17:in `retryable'
/usr/share/rubygems-integration/all/gems/vagrant-2.0.2/plugins/providers/virtualbox/driver/base.rb:414:in `block in execute': There was an error while executing `VBoxManage`, a CLI used by Vagrant (Vagrant::Errors::VBoxManageError)
for controlling VirtualBox. The command and stderr is shown below.

Command: ["modifyvm", "e34114d1-0572-4ab8-862e-226c8acf4a62", "--natpf1", "delete", "ssh"]

Stderr: VBoxManage: error: The machine 'vagrant-files_default_1563979297382_50431' is already locked for a session (or being unlocked)
VBoxManage: error: Details: code VBOX_E_INVALID_OBJECT_STATE (0x80bb0007), component MachineWrap, interface IMachine, callee nsISupports
VBoxManage: error: Context: "LockMachine(a->session, LockType_Write)" at line 529 of file VBoxManageModifyVM.cpp
There was an error while executing `VBoxManage`, a CLI used by Vagrant
for controlling VirtualBox. The command and stderr is shown below.
```

Za pomocą polecenia `vboxmanage startvm <uuid> --type emergencystop` odblokowałem maszynę i mogłem już ją normalnie uruchomić (`vagrant up`). Parametr `<uuid>` wyświetla vagrant `Command: ["modifyvm", "e34114d1-0572-4ab8-862e-226c8acf4a62", "--natpf1", "delete", "ssh"]`
