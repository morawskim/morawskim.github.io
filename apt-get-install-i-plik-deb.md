# apt-get install i plik deb

System zarządzania pakietów `apt-get` nie umożliwia zainstalowanie pakietu z pliku deb.

Żeby zainstalwoać pakiet `deb` możemy skorzystać z polecenia `apt install /tmp/google-chrome-stable_current_amd64.deb`.

Alternatywne podejście to wywołanie dwóch poleceń `dpkg -i /tmp/google-chrome-stable_current_amd64.deb` a następnie zainstalowanie brakujących zależności `apt-get -fy install`. Flaga `-f` oznacza `--fix-broken`.
Te polecenie możemy zapisać w ramach jednego polecenia `(dpkg -i /tmp/google-chrome-stable_current_amd64.deb || apt-get -fy install)`. W plikach `Dockerfile` często korzystamy z tej możliwości.

Efekt obu metod jest taki sam - zainstalowanie pakietu `/tmp/google-chrome-stable_current_amd64.deb` z dodatkowymi zależnościami.
