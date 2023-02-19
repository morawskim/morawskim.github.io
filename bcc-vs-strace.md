# bcc vs strace

[BCC](https://github.com/iovisor/bcc) to zestaw narzędzi między innymi do analizy operacji IO, czy sieciowych.
Choć można go uruchomić w [kontenerze](https://github.com/iovisor/bcc/blob/47502c2350b5de01dbcd35170e5542f2bc91118f/QUICKSTART.md) to w przypadku dystrybucji openSUSE ciągle pojawiały się problemy (musimy mieć zainstalowany pakiet `kernel-default-devel`).

Uruchamiając kontener bcc
```
docker run -it --rm \
  --privileged \
  -v /usr/lib/modules:/lib/modules:ro \
  -v /usr/src:/usr/src:ro \
  -v /etc/localtime:/etc/localtime:ro \
  -v /usr/src:/src:ro \
  --workdir /usr/share/bcc/tools \
  --network container:id-jakiegos-kontenera \
  zlim/bcc
```

Otrzymywałem błędy:
```
#....
./arch/x86/include/asm/bug.h:28:2: note: expanded from macro '_BUG_FLAGS'
        asm_inline volatile("1:\t" ins "\n"                             \
        ^
include/linux/compiler_types.h:292:24: note: expanded from macro 'asm_inline'
#define asm_inline asm __inline
                       ^
fatal error: too many errors emitted, stopping now [-ferror-limit=]
3 warnings and 20 errors generated.
Traceback (most recent call last):
  File "./tcpconnect", line 219, in <module>
    b = BPF(text=bpf_text)
  File "/usr/lib/python2.7/dist-packages/bcc/__init__.py", line 325, in __init__
    raise Exception("Failed to compile BPF text")
Exception: Failed to compile BPF tex
```

Obraz dostępny w docker hub był ostatnio aktualizowany ponad 4 lata temu.
Obecnie nowe obrazy przygotowane pod kilka dystrybucji są publikowane w [repozytorium ghcr.io](https://github.com/iovisor/bcc/pkgs/container/bcc) - `skopeo list-tags docker://ghcr.io/iovisor/bcc`.

Zainstalowałem więc pakiety `bcc-tools bcc-examples` na hoście i po wywołaniu z uprawnieniami administratora polecenia `/usr/share/bcc/tools/tcpconnect` mogłem zaobserwować nawiązywane połączenia TCP z kontenerów:

```
21091   caddy        4  192.168.160.4    192.168.160.3    9000
21255   php-fpm      4  192.168.160.3    172.17.0.1       9000
21255   php-fpm      4  192.168.160.3    192.168.160.2    8080
20881   tproxy       4  192.168.160.2    192.168.160.6    5672
21091   caddy        4  192.168.160.4    192.168.160.3    9000
21254   php-fpm      4  192.168.160.3    172.17.0.1       9000
28943   XXXXXXXXXXX  4  192.168.160.7    XXX.XX.XXX.X     443
21470   php          4  192.168.160.9    XXX.XXX.XXX.XXX  443
```

Podobny efekt można osiągnąć instalując strace na kontenerze. Co może być niezbędne, gdy nie możemy instalować dodatkowych pakietów na hoście. Kontener jednak musi działać z dodatkowych uprawnieniem `SYS_PTRACE`.

```
version: '3.4'
services:
  php:
    # ...
    cap_add:
      - SYS_PTRACE
```

W przypadku, gdy chcemy wyświetlić wywołania systemowe procesu PHP-FPM, który posiada kilka potomnych procesów musimy wielokrotnie dodać parametr `-p` przy wywołaniu strace. Dodatkowo dodajemy flagę `-f`, aby automatycznie monitorować nowo utworzone procesy PHP-FPM. Wyświetlamy działające procesy na kontenerze poleceniem `ps -ef` i mając ich PID uruchamiamy polecenie strace - `strace -f -p PID1 -p PID2 -p PID3 ...`.
Do śledzenia nawiązywanych połączeń TCP możemy użyć `strace -p PID1 -e trace=connect`.
Zobaczymy wynik podobny do poniższego:

```
[pid     7] connect(6, {sa_family=AF_INET, sin_port=htons(9000), sin_addr=inet_addr("172.17.0.1")}, 16) = -1 EINPROGRESS (Operation now in progress)
[pid     7] connect(8, {sa_family=AF_UNIX, sun_path="/var/run/nscd/socket"}, 110) = -1 ENOENT (No such file or directory)
[pid     7] connect(8, {sa_family=AF_UNIX, sun_path="/var/run/nscd/socket"}, 110) = -1 ENOENT (No such file or directory)
[pid     7] connect(8, {sa_family=AF_INET, sin_port=htons(53), sin_addr=inet_addr("127.0.0.11")}, 16) = 0
[pid     7] connect(8, {sa_family=AF_INET, sin_port=htons(8080), sin_addr=inet_addr("192.168.160.8")}, 16) = -1 EINPROGRESS (Operation now in progress)
[pid     8] connect(6, {sa_family=AF_INET, sin_port=htons(9000), sin_addr=inet_addr("172.17.0.1")}, 16) = -1 EINPROGRESS (Operation now in progress)
```

Przykładowy wiersz z `tcpconnect` powiązany z wynikiem strace wygląda tak:
> 31829   php-fpm      4  192.168.160.2    192.168.160.8    8080

Za pomocą polecenia `docker top <NAZWA_LUB_ID_KONTENERA>` możemy wyświetlić procesy działające w kontenerze, ale ich PID będzie inny niż w kontenerze.

```
UID                 PID                 PPID                C                   STIME               TTY                 TIME                CMD
33                  31502               31458               0                   14:52               ?                   00:00:00            php-fpm: master process (/usr/local/etc/php-fpm.conf)
33                  31829               31502               0                   14:52               ?                   00:00:02            php-fpm: pool www
33                  31830               31502               0                   14:52               ?                   00:00:01            php-fpm: pool www
root                31938               31458               0                   14:52               pts/0               00:00:00            bash
33                  890                 31502               0                   14:57               ?                   00:00:01            php-fpm: pool www
root                1745                31938               0                   15:05               pts/0               00:00:01            strace -f -p
```
