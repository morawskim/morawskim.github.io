# ansible

## Zmienne

Zmienne `playbook` mogą być definiowane bezpośrednio w kluczu `vars`, lub wczytane z zewnętrznego pliku przez klucz `vars_files`. Ostania możliwość to interaktywnie pytania o wartości zmiennych używając klucza `vars_prompt`. Wszystkie tak zdefiniowane zmienne mogą być używane w zakresie playbooka, w dowolnym zadaniu lub dołączonych zadaniach.

```
---
- hosts: all
  vars:
    foo: blue
  vars_files:
    - vars.yml
  vars_prompt:
    - name: username
      prompt: "What is your username?"
      private: no
....
```

[Using Variables](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html)

[Understanding variable precedence](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#understanding-variable-precedence)

[Interactive input: prompts](https://docs.ansible.com/ansible/latest/user_guide/playbooks_prompts.html)

## Inventory

Uruchomienie ansible playbook lokalnie - `ansible-playbook --connection=local --inventory 127.0.0.1, playbook.yml`

Innym rozwiązaniem jest w pliku playbook ustawienie hosts i connection. Odpowiednio na wartość `localhost` i `local`. Wtedy wywołanie ansible jest bardzo proste - `ansible-playbook ./playbook.yml`.
```
---
- hosts: localhost
  connection: local
  tasks:
    # ...
```

W inventory Ansible zmienna `ansible_become_pass` przechowuje hasło używane do podniesienia uprawnień użytkownika (np. do root) przy użyciu mechanizmu become (np. sudo). Jest to odpowiednik wpisywania hasła podczas ręcznego wykonywania polecenia sudo w terminalu.

Zmienna `ansible_ssh_pass` przechowuje hasło używane do logowania się na zdalny host za pomocą protokołu SSH, gdy Ansible nie korzysta z klucza SSH.

### Dynamiczne dodawanie hostów przez moduł add_host

Za pomocą `ansible` można tworzyć nowe serwery. Plik inventory jest przetwarzany przed wykonywaniem zadań z playbooka, więc nowo utworzony serwer nie będzie znajdował się w inventory. Dzięki pomocy modułu [add_host](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/add_host_module.html) jesteśmy w stanie dynamicznie dodać utworzony serwer do inventory. Nie zostanie on zapisany - będzie znajdował się wyłącznie w pamięci. Moduł ten pozwala nam za pomocą jednego wywołania playbooka utworzyć i skonfigurować serwer.

```
- name: Add a host with a non-standard port local to your machines
  add_host:
    name: "server_name"
    ansible_ssh_host: "{{ server_ip }}"
    ansiblee_ssh_user: "username"
```

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

### Tworzenie zaszyfrowanego pliku przy użyciu ansible-vault

W celu utworzenia zaszyfrowanego pliku przy użyciu ansible-vault,
tworzymy playbook o nazwie `split_vault.yml` o następującej zawartości:

```
- name: Split vault file
  hosts: localhost
  become: false
  gather_facts: no
  vars:
    vault_output_file: "{{ inventory_dir }}/vault-worker-split.yml"
  vars_files:
    - "{{ inventory_dir }}/vault.yml"
  tasks:
    - name: Create YAML string
      set_fact:
        app_yaml: |
          APP_SECRETS:
            {{ APP_SECRETS | to_yaml | indent(2) }}
    - name: Create app vault file
      expect:
        command: "ansible-vault encrypt --output={{ vault_output_file }}"
        responses:
          "New Vault password": "{{ ANSIBLE_APP_VAULT_PASSWORD }}"
          "Confirm New Vault password": "{{ ANSIBLE_APP_VAULT_PASSWORD }}"
          "Reading plaintext input from stdin": "{{ app_yaml }}\n\x04" # Send Ctrl-D (EOF) to terminate
        timeout: 10
```

Następnie uruchamiamy polecenie `ansible-playbook --ask-vault-password --extra-vars='inventory_dir=/vagrant/inventories/vagrant/' split_vault.yml`
aby wykonać playbook i utworzyć zaszyfrowany plik.

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
