# Agent AI skill

## Przygotowanie maszyny wirtualnej (Vagrant)

Tworzymy plik Vagrantfile o następującej zawartości:

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "bento/ubuntu-24.04"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
end

```

Korzystamy z obrazu bento, ponieważ zawiera dodatki VirtualBox (virtualbox-guest-additions),
dzięki którym działa współdzielony katalog pomiędzy gospodarzem i maszyną wirtualną.

Dzięki temu, pracując z prywatnymi repozytoriami, nie musimy kopiować do maszyny wirtualnej kluczy SSH ani przekazywać kluczy sprzętowych — Git korzysta z plików znajdujących się na hoście.

Instalujemy wymagane pakiety: `sudo apt-get update && sudo apt-get install -y unzip git vim curl`

Następnie instalujemy Junie - `curl -fsSL https://junie.jetbrains.com/install.sh | bash`
A także opencode `curl -fsSL https://opencode.ai/install | bash`.

Instalator umieszcza binaria w katalogu `~/.local/bin`, dlatego dodajemy ten katalog do zmiennej środowiskowej PATH:

```
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

Sprawdzamy wersję Junie - `junie --version`
Przykładowy wynik:

> Junie version: 26.8.17 (2777.8)

Następnie sprawdzamy OpenCode - `opencode --version`
W moim przypadku: 1.18.21.

Pobieramy repozytorium które zawiera skill, który wykorzystamy podczas testów - `git clone https://github.com/morawskim/webpage2kindle.git`

Maszyna wirtualna może komunikować się z gospodarzem poprzez specjalny adres IP `10.0.2.2`.
Ollama w tym przypadku musi być dostępna z poziomu gospodarza na porcie 11434.
Możemy skorzystać z tunelu SSH.

Testujemy połączenie z Ollama na maszynie wirtualnej `curl -v http://10.0.2.2:11434`.
Oczekiwany komunikat:

> Ollama is running

## Konfiguracja OpenCode

Tworzymy katalog konfiguracyjny dla opencode `mkdir -p ~/.config/opencode/`
Następnie tworzymy plik `~/.config/opencode/opencode.jsonc`:

```
{
  "$schema": "https://opencode.ai/config.json",
  "permission": {
    "skill": "allow"
  },
  "provider": {
    "ollama": {
      "name": "ollama",
      "npm": "@ai-sdk/openai-compatible",
      "options": {
        "baseURL": "http://10.0.2.2:11434/v1"
      },
      "models": {
        "qwen3.8:27b": {
            "name": "qwen3.8:27b"
        }
      }
    }
  }
}
```

Startujemy OpenCode `opencode`.
Wybieramy model poleceniem `/model` i wskazujemy model `qwen3.8:27b` z Ollamy.
Następnie wykonujemy skill - `skill("firefox-extension-update")`.
Agent AI przeanalizuje projekt i wprowadzi wymagane zmiany.
Efektem powinien być następujący diff:

```
diff --git a/firefox-extension/manifest.json b/firefox-extension/manifest.json
index 08aa6e6..fddb04e 100644
--- a/firefox-extension/manifest.json
+++ b/firefox-extension/manifest.json
@@ -2,7 +2,7 @@
   "description": "Send body content of webpage to external service for improve readability",
   "manifest_version": 2,
   "name": "webpage2kindle",
-  "version": "1.7.0",
+  "version": "1.7.1",
   "homepage_url": "https://github.com/morawskim/webpage2kindle/tree/main/firefox-extension",
   "icons": {
     "48": "icons/icon-48.png"
diff --git a/symfony-app/templates/homepage.html.twig b/symfony-app/templates/homepage.html.twig
index 784b03c..1d11a6c 100644
--- a/symfony-app/templates/homepage.html.twig
+++ b/symfony-app/templates/homepage.html.twig
@@ -26,7 +26,7 @@
{# the raw tag is only for fix build, this is not part of diff #}
{% raw %}
     <div class="mt-3">
         <a href="{{ path('list_newest_jobs') }}">Newest created jobs</a>
         <br />
-        <a href="{{ asset('firefox-extension-1.7.0.xpi') }}">Download firefox extension</a>
+        <a href="{{ asset('firefox-extension-1.7.1.xpi') }}">Download firefox extension</a>
         <br />
         <a href="javascript:{{ include('bookmark.js.twig')|raw|replace({"\r": '', "\n": ''})}}">Webpage2Kindle Bookmark</a>
     </div>
{% endraw %}
```

## junie

Uruchamiamy Junie `junie` i konfigurujemy połączenie z Ollamą.
W menu wybieramy "Manage custom models and endpoints (LiteLLM, Ollama, LM Studio)".
A następnie "Ollama".
W polu Base URL wpisujemy: `http://10.0.2.2:11434`.

Po zapisaniu konfiguracji Junie będzie korzystał z modeli udostępnianych przez Ollamę.

Sprawdzamy dostępne skills wywołując polecenie `/skills`.
Powinniśmy zobaczyć, że przykładowy skill jest aktywny:

> firefox-extension-update   enabled    Bump the Firefox extension patch version....

Wpisujemy polecenie `update firefox extension`.

Junie odczyta definicję SKILL.md, przeanalizuje kod projektu i wprowadzi odpowiednie zmiany.
W moim przypadku agent zadał dodatkowe pytanie: czy ma jedynie zaktualizować ścieżkę do pliku .xpi, czy również przygotować archiwum, aby użytkownicy nie otrzymywali błędu 404 Not Found.

Po zakończeniu pracy Junie wyświetlił podsumowanie zmian oraz ostrzeżenie, że samo zaktualizowanie odnośnika spowoduje błąd 404, ponieważ plik firefox-extension-1.7.1.xpi nie istnieje jeszcze w repozytorium.
