# lftp

lftp to klient SFTP/FTP obsługiwany z poziomu wiersza poleceń dla systemów unixowych.

W przypadku protokołu FTP dane uwierzytelniające możemy przechowywać w pliku `~/.netrc`, gdzie każdy wpis powinien mieć format:
`machine ftp.example.com login mylogin password mysecretpassword`

## SFTP

Jeśli podczas łączenia się z serwerem SFTP pojawi się błąd:

> Fatal error: Host key verification failed.

Możemy dodać fingerprint hosta do listy zaufanych hostów za pomocą polecenia:
`ssh-keyscan ftp.example.com >> ~/.ssh/known_hosts`

Jeśli serwer obsługuje jedynie protokół SFTP (bez dostępu do powłoki przez SSH), użycie flagi `-s` w poleceniu ssh-copy-id może rozwiązać problem z kopiowaniem klucza publicznego na zdalny serwer.

Flaga `-s` sprawia, że ssh-copy-id zamiast próbować wykonywać zdalne polecenia na serwerze (co jest domyślnym zachowaniem), używa wyłącznie protokołu SFTP do skopiowania klucza.

W przypadku uwierzytelniania za pomocą hasła, możemy przekazać je do lftp za pomocą zmiennej środowiskowej `LFTP_PASSWORD`.
