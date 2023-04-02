# Docker - debugowanie kontenerów distroless

Korzystając z obrazów distroless utrudniony jest proces debugowania. Nie możemy w uruchomionych kontenerach odpalić powłoki, nie mamy także oprogramowania do zarządzania pakietami.
W takim przypadku możemy uruchomić dodatkowy kontener, który będzie współdzielił przestrzenie PID i network - `docker run --rm -it --pid container:<CONTAINER_ID_OR_NAME> --network container:<CONTAINER_ID_OR_NAME> ubuntu bash`.
W nowo uruchomionym kontenerze możemy zainstalować dodatkowe oprogramowanie np. procps czy iproute2.
Wywołując polecenie `ps -ef` jesteśmy w stanie wyświetlić listę działających procesów, która zawiera także procesy z kontenera distroless:
```
UID        PID  PPID  C STIME TTY          TIME CMD
root         1     0  0 06:37 ?        00:00:00 tproxy -l 0.0.0.0 -p 8080 -r rabbitmq:5672 -d 500ms
root        21     0  0 07:50 pts/0    00:00:00 bash
root       251    21  0 07:51 pts/0    00:00:00 ps -ef
```

Możemy podejrzeć także listę połączeń sieciowych - `ss -apn`. W moim przypadku w wyniku dostałem
> tcp  LISTEN  0  4096  *:8080  *:*  users:(("tproxy",pid=1,fd=3))

W systemie hosta, możemy także wyświetlić identyfikator procesu działającego w kontenerze - `docker inspect -f '{{.State.Pid}}' <CONTAINER_ID_OR_NAME>`. W moim przypadku otrzymałem wartość "10548".
Następnie mogę potwierdzić poprawność danych poprzez wywołanie polecenia na hoście `ps -f -p 10548`. Otrzymam podstawowe dane dotyczące głównego procesu działającego w kontenerze w innej przestrzeni PID.

Bardziej interesującym przypadkiem jest wykorzystanie narzędzia nsenter do podejrzenia konfiguracji sieci w kontenerze.
Korzystając z nsenter nie musimy mieć zainstalowanego pakietu `iproute2` na działającym kontenerze.
Wywołujemy polecenie `sudo nsenter -—target <PID> -n ip addr ss -apn` zobaczymy na którym porcie i interfejsie nasłuchuje nasza usługa.

[Container security fundamentals part 2: Isolation & namespaces](https://securitylabs.datadoghq.com/articles/container-security-fundamentals-part-2/)

[Docker: How To Debug Distroless And Slim Containers](https://iximiuz.com/en/posts/docker-debug-slim-containers/)
