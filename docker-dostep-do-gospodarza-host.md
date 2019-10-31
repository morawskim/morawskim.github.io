# docker - dostęp do gospodarza (host)

W niektórych systemach operacyjnych docker obsługuje specjalną nazwę domeny `host.docker.internal`, która wskazuje na maszynę gospodarza. Jednak docker for linux nie obsługuje tej funkcji - https://github.com/docker/for-linux/issues/264

W wątku tym pojawiło się wiele rozwiązań tego problemu.
Najlepszym rozwiązaniem jest użycie adresu IP `172.17.0.1`, ponieważ nie wymaga żadnej konfiguracji. Przez ten adres możemy połączyć się z maszyną gospodarza.
