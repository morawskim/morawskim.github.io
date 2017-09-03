NTP - synchronizacja czasu
==========================

Wymuszenie synchronizacji czasu z serwerem ntp często się przydaje,kiedy korzystamy z maszyny wirtualnej i zapisujemy jej stan. Po ponownym uruchomieniu maszyny data jest z przeszłości. Zamiast czekać, aż usługa ntp zsynchronizuje czas, możemy wymusić synchronizację zegara za pomocą programu ntpdate

``` bash
sudo ntpdate server
sudo ntpdate pool.ntp.org
```