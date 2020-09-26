# ansible

## ansible-vault

`ansible-vault` to narzędzie do szyfrowania/deszyfrowania plików. Zaszyfrowany plik tworzymy wywołując polecenie `ansible-vault create filename.yml`. Zawartość pliku powinna być w formacie listy YAML. W przeciwnym przypadku otrzymamy komunikat `ERROR! variable files must contain either a dictionary of variables, or a list of dictionaries.` podczas wykonywania playbook. Zapisujemy dane i wychodzimy z edytora. Wszystkie zaszyfrowane pliki do którego odwołuje się playbook muszą być zaszyfrowane tym samym kluczem, inaczej `ansible-playbook` nie będzie zdolne do odczytania ich.

```
---
var1: value of variable1
```

Następnie w pliku `playbook.yml` dodajemy odwołanie do naszego pliku z zmiennymi:
```
vars_files:
  - filename.yml
```

Podczas uruchamiania `ansible-playbook` musimy dodać argument `--ask-vault-pass` albo `--vault-password-file` jeśli chcemy podać ścieżkę do pliku z hasłem zamiast wpisywać je. Jeśli nie dodamy tego argumentu to otrzymamy błąd `Attempting to decrypt but no vault secrets found`.
Warto do zadania dodać klucz `no_log` z wartością `true`, aby zapobiec logowaniu/pokazywaniu wartości sekretnej zmiennej.

## ansible-doc

Komenda `ansible-doc -l` wyświetla zwięzłą listę modułów z krótkim opisem. Jeśli chcemy wyświetlić bardziej szczegółową dokumentację podajemy nazwę modułu - `ansible-doc debug`. Chcąc uzyskać informację nie o modułach, a o innych elementach to korzystamy z parametru `-t 'TYPE', --type 'TYPE'`. Obsługiwane wartości `TYPE` to `become`, `cache`, `callback`, `cliconf`, `connection`, `httpapi`, `inventory`, `lookup`, `netconf`,  `shell`,  `module`, `strategy` lub `vars`. Korzystając z parametru `-s|--snippet` możemy wyświetlić szkielet kodu do wykorzystania w zadaniu playbook.


## Troubleshooting

Pierwszym krokiem do rozwiązania problemu może być zwiększenie szczegółowości komunikatów. Domyślnie ansible wyświetla niewiele informacji. Mamy 5 poziomów gadatliwości (ang. verbosity). Aby ustawić najwyższy poziom dodajemy argument `-vvvv` do wywołania `ansible-playbook`. Zwiększając poziom wyświetlania szczegółów dane warto zapisać także do pliku, aby łatwiej je analizować. Bufor w terminalu może być zbyt mały do przechowania wszystkich danych. Ustawiamy zmienną środowiskową `ANSIBLE_LOG_PATH` na ścieżkę do pliku, gdzie ansible ma zapisać log. Plik zostanie automatycznie utworzony jeśli nie istnieje. Utworzony plik nie będzie zawierał kodów ANSI.

Za pomocą moduły `debug` możemy zbadać zmienną. Dzięki temu możemy zobaczyć wartość zmiennej. Zarówno typu prostego jak i złożonego - lista, hash.

```
- name: debug variable
  debug:
    var: <VARIABLE_NAME>
```

Ansible oferuje także funkcję debugowania zadania. Ustawiając w playbook strategie `debug` w przypadku wystąpienia błędy podczas wykonywania zadania uruchomiony zostanie tryb interaktywny, w którym możemy podejrzeć argumenty zadania czy też zmodyfikować zmienne. Istnieją także inne metody uruchomienia debuggera. Na poziomie zadania możemy użyć słowa kluczowego `debugger` z wartością `on_failed`. Jednak ta metoda jest dostępna od wersji 2.5.

```
- name: Execute a command
  command: "false"
  debugger: on_failed
```

Obie metody wymagają zmodyfikowania playbooka. Ustawiając zmienną środowiskową `ANSIBLE_ENABLE_TASK_DEBUGGER` na wartość `true` albo `1`, możemy przejść do trybu debugowania w przypadku wystąpienia błędu bez modyfikowania playbooka - `ANSIBLE_ENABLE_TASK_DEBUGGER=1 ansible-playbook playbook.yml`. Wymaga to jednak ansible w wersji 2.5.

[Debugging tasks](https://docs.ansible.com/ansible/latest/user_guide/playbooks_debugger.html)
