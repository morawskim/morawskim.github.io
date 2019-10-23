# nexus

## Przesłanie pliku do repozytorium RAW

`curl -v -u <nexus_username>:<user_password> --upload-file <sciezka/do/pliku/do/przeslania> http://nexus.example.com/repository/<repo_name>/<path>/<nazwaPlikuPodJakimBedzieWidocznyWRepo>`


## OLowDiskSpaceException

Aby `nexus` się uruchomił wymagane jest co najmniej 4096MB wolnego miejsca. Ja testowo odpaliłem kontener z nexusem na testowej maszynie wirtualnej, gdzie miałem tylko 937MB wolnego miejsca i otrzymałem błąd:

```
Caused by: com.orientechnologies.orient.core.exception.OLowDiskSpaceException: Error occurred while executing a write operation to database 'OSystem' due to limited free space on the disk (937 MB). The database is now working in read-only mode. Please close the database (or stop OrientDB), make room on your hard drive and then reopen the database. The minimal required space is 4096 MB. Required space is now set to 4096MB (you can change it by setting parameter storage.diskCache.diskFreeSpaceLimit) .
```
