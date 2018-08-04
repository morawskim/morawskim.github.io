# vagrant, virtualbox 5.2 - no provider

Podczas wywołania polecenia `vagrant up` w systemie opensuse leap 15 otrzymałem taki błąd.

```
No usable default provider could be found for your system.

Vagrant relies on interactions with 3rd party systems, known as
"providers", to provide Vagrant with resources to run development
environments. Examples are VirtualBox, VMware, Hyper-V.

The easiest solution to this message is to install VirtualBox, which
is available for free on all major platforms.

If you believe you already have a provider available, make sure it
is properly installed and configured. You can see more details about
why a particular provider isn't working by forcing usage with
`vagrant up --provider=PROVIDER`, which should give you a more specific
error message for that particular provider.
```

W systemie miałem zainstalowany `virtualbox`. Dodatkowo moje konto należało do grupy `vboxusers`.
Wywołałem raz jeszcze vagranta, tym razem z parametrem `--debug`.
Na wyjściu widziałem, że vagrant widzi virtualbox.

Postanowiłem jawnie podać providera do wywołania `vagrant up` - `vagrant up  --provider=virtualbox`.
Tym razem miałem już jasny błąd:

```
The provider 'virtualbox' that was requested to back the machine
'carcliq' is reporting that it isn't usable on this system. The
reason is shown below:

Vagrant has detected that you have a version of VirtualBox installed
that is not supported by this version of Vagrant. Please install one of
the supported versions listed below to use Vagrant:

4.0, 4.1, 4.2, 4.3, 5.0, 5.1
```

Jak się okazało vagrant obsługuje virtualbox od wersji 2.0.1 - https://github.com/hashicorp/vagrant/commit/7d73af5637de41f1e53b8f1ef2ea9baf76842dfb.