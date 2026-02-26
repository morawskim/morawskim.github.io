# awesome-prometheus-alerts

Repozytorium [samber/awesome-prometheus-alerts](https://github.com/samber/awesome-prometheus-alerts) zawiera gotowe zestawy reguł alertów dla Prometheusa.

Jeśli chcemy wprowadzić zmiany, klonujemy repozytorium, a następnie modyfikujemy plik `_data/rules.yml`.
To na jego podstawie generowane są końcowe pliki z regułami alertów.

Aktualne kroki potrzebne do zbudowania zestawu reguł są zdefiniowane w [pipeline CI](https://github.com/samber/awesome-prometheus-alerts/blob/0693ed168e05fc8e66a5c4558804846289f74c6d/.github/workflows/dist.yml).

Na podstawie pipeline wyodrębniamy polecenia i tworzymy z nich skrypt bash, np. `script.sh`:

```
set -euo pipefail
shopt -s inherit_errexit
IFS=$'\n\t'

cat _data/rules.yml | yq -I 0 -o json > _data/rules.json

rm -rf dist/rules

for service in $(cat _data/rules.json | jq -r '.groups[].services[] | @base64'); do
  subdir=dist/rules/$(echo ${service} | base64 --decode | jq -r '.name | ascii_downcase | split(" ") | join("-")')
  mkdir -p "${subdir}"

  # groupName=$(echo "{% assign groupName = name | split: ' ' %}{% capture groupNameCamelcase %}{% for word in groupName %}{{ word | capitalize }} {% endfor %}{% endcapture %} {{ groupNameCamelcase | remove: ' ' | remove: '-' }}" | liquid $(echo ${service} | base64 --decode | jq -r '.name | ascii_downcase | split(" ") | join("-")'))

  for exporter in $(echo ${service} | base64 --decode | jq -r '.exporters[] | @base64'); do
    exporterName=$(echo ${exporter} | base64 --decode | jq -r '.slug')
    cat dist/template.yml | liquid "$(echo ${exporter} | base64 --decode)" > ${subdir}/${exporterName}.yml
    echo ${subdir}/${exporterName}.yml
  done
done

rm _data/rules.json

```

Do zbudowania reguł używamy kontenera z Ruby 3.4: `docker run -v$PWD:/app -w/app -it --rm ruby:3.4 bash`
W kontenerze instalujemy pakiety gem `gem install liquid -v 5.5.1 && gem install liquid-cli`
Instalujemy yq - `wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/local/bin/yq && chmod +x /usr/local/bin/yq`
A także pakiet jq - `apt update -y && apt install -y jq`
Uruchamiamy skrypt `bash script.sh`
Po zakończeniu działania skryptu wychodzimy z kontenera.

W katalogu `dist/` powinny znajdować się wygenerowane, zmodyfikowane pliki z regułami alertów.
