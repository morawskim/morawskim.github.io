# vagrant 2.1 fork/exec error

Przy wywołaniu polecenia `vagrant up` dostałem  komunikat z błędem:

```
Exec error: fork/exec /opt/vagrant/embedded/bin/ruby: argument list too long Exec error: fork/exec /opt/vagrant/embedded/bin/ruby: argument list too long Exec error: fork/exec /opt/vagrant/embedded/bin/ruby: argument list too long
```

Postanowiłem użyć `strace` do śledzenia wywołań systemowych `exec`.
```
strace -o strace.log -v -f -e trace=process vagrant up --debug |& tee vagrantup.debug
```

Pod koniec pliku `strace.log` znajdował się wpis:
```
20781 execve("/opt/vagrant/embedded/bin/ruby", ["ruby", "/opt/vagrant/embedded/gems/2.1.2"..., "plugin", "install", "vagrant-hostmanager"], ["VAGRANT_OLD_ENV_VAGRANT_OLD_ENV_"..., "VAGRANT_OLD_ENV_VAGRANT_OLD_ENV_"..., "VAGRANT_OLD_ENV_VAGRANT_OLD_ENV_"..., "GREP_COLOR=1;33", "VAGRANT_OLD_ENV_VAGRANT_OLD_ENV_"..., "VAGRANT_OLD_ENV_VAGRANT_OLD_ENV_"..., ......]) = -1 E2BIG (Argument list too long)
20781 exit(253)   
```

Jeśli nie do wywołania programu `strace` nie dodałbym flagi `-v` (strace w wersji 4.15 zawiera tą flagę) wtedy ta linia wygląda tak:
```
3973  execve("/opt/vagrant/embedded/bin/ruby", ["ruby", "/opt/vagrant/embedded/gems/2.1.2"..., "plugin", "install", "vagrant-hostmanager"], 0xc420968000 /* 6779 vars */) = -1 E2BIG (Argument list too long)
```

Z logu vagranta można też uzyskać informacje o ostatnich akcjach przed wyświetleniem błędu
```
VagrantPlugins::CommandPlugin::Command::Root ["install", "vagrant-hostmanager"]
DEBUG checkpoint_client: plugin check complete
DEBUG checkpoint_client: waiting for checkpoint to complete...
DEBUG checkpoint_client: no information received from checkpoint
DEBUG root: Invoking command class: VagrantPlugins::CommandPlugin::Command::Install ["vagrant-hostmanager"]
 INFO loader: Set :root = ["#<Pathname:/run/user/1000/cdtmp-WjONdn/carcliq/Vagrantfile>"]
DEBUG loader: Populating proc cache for #<Pathname:/run/user/1000/cdtmp-WjONdn/carcliq/Vagrantfile>
DEBUG loader: Load procs for pathname: /run/user/1000/cdtmp-WjONdn/carcliq/Vagrantfile
Exec error: fork/exec /opt/vagrant/embedded/bin/ruby: argument list too long
```

Problem ten dotknął paru użytkowników.
* https://github.com/hashicorp/vagrant/issues/8055
* https://github.com/ByteInternet/hypernode-vagrant/commit/c4218b574b78aa3e98c78cd68ab172255161c930
* https://github.com/lemberg/draft-environment/commit/03644fcdb73ab4c73d98b0828a6b43c5ed32f245
* https://github.com/ByteInternet/hypernode-vagrant/issues/118

W nowszych wersjach vagranta podczas instalacji pluginów wczytywany jest plik `Vagrantfile`. W nim występuje fragment kodu odpowiedzialnego za automatyczną instalację wymaganych pluginów.
Następuje więc zapętlenie.

```
required_plugins = %w( vagrant-hostmanager vagrant-vbguest )
required_plugins.each do |plugin|
    exec "vagrant plugin install #{plugin}" unless Vagrant.has_plugin? plugin
end
```

Rozwiązanie to zamienić ten fragment kody na inny - https://github.com/hashicorp/vagrant/issues/8055#issuecomment-403171757.
Albo ręcznie zainstalować te wymagane pluginy.

## Debugowanie vagranta

1. Pobieramy kod źródłowy vagranta - https://github.com/hashicorp/vagrant.git

2. Przełączamy się na odpowiednią wersję kodu `git checkout -b dev origin/v2.1.2`

3. Instalujemy zależności `bundle install --binstubs=./exec --path=./vendor`

4. Sprawdzamy działanie vagranta `./exec/vagrant -v`

5. Instalujemy plugin `pry-byebug` - `VAGRANT_HOME=/home/marcin/projekty/vagrant/vagrant_home/ ./exec/vagrant plugin install pry-byebug`
Ustawiamy zmienną środowiskową `VAGRANT_HOME`, dzięki temu plugin zostanie zainstalowany lokalnie i nie będzie widoczny dla "globalnego" vagranta.

6. Modyfikujemy jakiś plik np. `Vagrantfile`. W miejscy gdzie chcemy, aby wykonywanie kody zostało wstrzymane wstawiamy:
```
require 'pry-byebug'
binding.pry
```

7. Modyfikujemy plik `bin/vagrant`. Musimy zakomentować/skasować fragment kodu.
W przeciwnym przypadku vagrant nie wczyta pluginów i będziemy mieć błąd że pakiet `pry-byebug` nie istnieje.

```
# Disable plugin loading for commands where plugins are not required. This will
# also disable loading of the Vagrantfile if it available as the environment
# is not required for these commands
argv.each_index do |i|
  arg = argv[i]

  if !arg.start_with?("-")
    if arg == "box" && argv[i+1] == "list"
      opts[:vagrantfile_name] = ""
      ENV['VAGRANT_NO_PLUGINS'] = "1"
    end

    # Do not load plugins when performing plugin operations
     if arg == "plugin"
       ENV['VAGRANT_NO_PLUGINS'] = "1"
       # Only initialize plugins when listing installed plugins
       if argv[i+1] != "list"
         ENV['VAGRANT_DISABLE_PLUGIN_INIT'] = "1"
       end
     end

    break
  end
end
```

8. Proces debugowania rozpoczynamy wydając polecenie `VAGRANT_HOME=/home/marcin/projekty/vagrant/vagrant_home/ ~/projekty/vagrant/exec/vagrant up --debug`
Ustawienie zmiennej środowiskowej jest niezbędne. Inaczej vagrant nie znajdzie `pry-byebug`. Podczas instalacji tego pluginu też ustawialiśmy tą zmienną środowiskową.
