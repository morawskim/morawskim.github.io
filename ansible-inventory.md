# ansible-inventory

`ansible-inventory` to narzędzie do sprawdzania i eksploracji hostów, które Ansible widzi w plikach statycznych lub dynamicznym inventory.

Przykładowy plik inventory w formacie YAML z 3 serwerami i dwiema grupami "grupa1" i "grupa2":

```
all:
  hosts:
    prod:
      ansible_host: 1.2.3.4
    db:
      ansible_host: 9.8.7.6
    demo:
      ansible_host: 5.6.7.8
grupa1:
  hosts:
    prod:
    db:
grupa2:
  hosts:demo:

```

Jeśli ustawimy zmienną `ansible_connection` na wartość `local`, Ansible będzie wywoływać polecenia na lokalnej maszynie zamiast próbować nawiązać połączenie SSH.

W katalogu, w którym trzymamy plik inventory, możemy utworzyć dwa foldery o nazwach group_vars i host_vars, zawierające nasze pliki z zmiennymi.
Na przykład:
* group_vars/grupa1.yml – zawiera wszystkie zmienne dla serwerów z grupy grupa1.
* host_vars/demo.yml – zawiera wszystkie zmienne dla serwera demo.

## Przydatne polecenia

Wyświetlenie wszystkich zdefiniowanych grup i serwerów: `ansible-inventory -i ./sciezka/do/pliku/inventory.yml --list`.

Wyświetlenie zmiennych przypisanych do konkretnego hosta: `ansible-inventory -i ./sciezka/do/pliku/inventory.yml --host demo`.

Sprawdzenie połączenia z grupą lub pojedynczym serwerem: `ansible -i ./sciezka/do/pliku/inventory.yml <TARGET_GRUPA_ALBO_HOST> -m ping`.

Ograniczenie uruchomienia playbooka do konkretnego hosta: `ansible-playbook -i ./sciezka/do/pliku/inventory.yml --limit demo --list-hosts playbooks/ping.yml`

Testowy playbook:

```
- name: Check connection/inventory
  hosts: "all"
  tasks:
  - name: ping
    ansible.builtin.ping:

```
