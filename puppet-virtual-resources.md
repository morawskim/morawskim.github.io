# puppet - virtual resources

Korzystam z `virtual resource` do zarządzania kontami użytkowników w systemach Linux.
Instalując oprogramowanie `docker` chcę, aby pewni użytkownicy systemowi mogli zarządzać dokerem.
Tworzę więc manifest, w którym przechowuje wszystkie konta użytkowników, które mogą występować.
Konfiguracja jednego z kont wygląda następująco:
```
@sensi::user {'marcin':
  ssh_authorized_keys => {marcin => lookup('ssh_keys')['marcin.morawski@sensilabs.pl']},
  groups              => [adm, sudo],
}
```

W klasie, która instaluje pakiet dokera, dodaje parametr `Array $users_to_manage_docker = []`.
Dzięki temu mogę konfigurować klasę i przekazać do niej listę użytkowników którzy mają zostać dodani do grupy `docker`. Aby przypisać grupę do wirtualnego zasobu użytkownika korzystamy z operatora `spaceship`:
```
$users_to_manage_docker.each |String $user| {
  User<| title == $user |> { groups +> "docker", require +> Package['docker.io'] }
}
```

Musimy zrobić to w pętli, ponieważ obecnie puppet nie obsługuje tablicy:
>The right operand (search key) must be a string, boolean, number, resource reference, or undef. The behavior of arrays and hashes in the right operand is undefined in this version of Puppet.

W pliku manifestu wprowadzam zmiany, aby mieć zainstalowaną usługę docker, a także linuxowe konto `marcin` z przypisaną grupę `docker`:
```
# ...
class {'sensi::docker':
  users_to_manage_docker => ['marcin']
}
# ...
# Uzytkownik marcin zostanie utworzony w systemie i przypisany do grupy docker
realize Sensi::User['marcin']
```

[Virtual resources](https://puppet.com/docs/puppet/6.10/lang_virtual.html)
[Resource collectors](https://puppet.com/docs/puppet/6.10/lang_collectors.html)
[Przykład](https://github.com/morawskim/provision-dev-servers/commit/782f30181d971ecbde75c2644f03f3c051cbefd5)
