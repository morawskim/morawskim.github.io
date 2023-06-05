# KVM, qemu i x86-64-v2

Podczas budowania aplikacji w języku Go na serwerze wirtualnym, na którym działał agent GitLab CI/CD otrzymałem błąd:

> Fatal glibc error: CPU does not support x86-64-v2
error building image: error building stage: failed to execute command: waiting for process to exit: exit status 127

Sporo przydatnych informacji odnośnie tego problemu jest w zgłoszeniu [Bug 2060839 - Consider deprecating CPU models like "kvm64" / "qemu64" on RHEL 9 ](https://bugzilla.redhat.com/show_bug.cgi?id=2060839). 


O zalecanych ustawieniach CPU dla maszyny wirtualnej, plusach i minusach wybranego rozwiązania można przeczytać na stronie [Recommendations for KVM CPU model configuration on x86 hosts](https://www.qemu.org/docs/master/system/i386/cpu.html#recommendations-for-kvm-cpu-model-configuration-on-x86-hosts).

Warto wywołac polecenie `/lib64/ld-linux-x86-64.so.2 --help`, aby zobaczyć wspierane wersje architektury x86-64.

Na moim komputerze otrzymałem wynik:

```
Subdirectories of glibc-hwcaps directories, in priority order:
  x86-64-v4
  x86-64-v3 (supported, searched)
  x86-64-v2 (supported, searched)
```

Zaś na maszyniw wirtualnej:

```
Subdirectories of glibc-hwcaps directories, in priority order:
  x86-64-v4
  x86-64-v3
  x86-64-v2

Legacy HWCAP subdirectories under library search path directories:
  x86_64 (AT_PLATFORM; supported, searched)
  tls (supported, searched)
  avx512_1
  x86_64 (supported, searched)

```

W konfiguracji maszyny wirtualnej wybrana była domyśna wartośc modelu procesora czyli "qemu64". Zmieniłem ją na "host-passthrough". Po zmianie i zresetowaniu maszyny wirtualnej wynik komendy `/lib64/ld-linux-x86-64.so.2 --help` prezentował się tak, a sam build przeszedł bez problemów:

```
Subdirectories of glibc-hwcaps directories, in priority order:
  x86-64-v4 (supported, searched)
  x86-64-v3 (supported, searched)
  x86-64-v2 (supported, searched)
```
