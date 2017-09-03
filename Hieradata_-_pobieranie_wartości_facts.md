Hieradata - pobieranie wartości facts
=====================================

Zawartość pliku yaml

```
---
vagrant_boxes:
    ubuntu:
        name: 'ubuntu/trusty64'
        box_provider: 'virtualbox'
        version: ~
    opensuse:
        name: "opensuse/openSUSE-%{::operatingsystemrelease}-x86_64"
        box_provider: 'virtualbox'
        version: ~
```

Polecenie do wyświetlenie wartości klucza vagrant_boxes z ustawieniem dodatkowych zmiennych.

``` bash
hiera  -c /home/marcin/projekty/puppet_configuration/hiera.yaml vagrant_boxes  ::operatingsystemrelease=13.2
{"ubuntu"=>{"name"=>"ubuntu/trusty64", "box_provider"=>"virtualbox", "version"=>nil}, "opensuse"=>{"name"=>"opensuse/openSUSE-13.2-x86_64", "box_provider"=>"virtualbox", "version"=>nil}}
```

Jeśli w hieradata zmienimy odwołanie z ::operatingsystemrelease na operatingsystemrelease, to możemy korzystać z poniższego polecenia do testów

``` bash
hiera --yaml <(facter --yaml) -c /home/marcin/projekty/puppet_configuration/hiera.yaml vagrant_boxes
```