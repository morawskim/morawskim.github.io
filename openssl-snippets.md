# openssl snippets

## Zaszyfruj i odszyfruj plik za pomocą AES

Szyfrowanie pliku `openssl enc -aes-256-cbc -in fileToEncrypt -out encryptedFile`

Odszyfrowanie pliku `openssl enc -aes-256-cbc -d -in encryptedFile -out decryptedFile`

## Pobieranie certyfikatu SSL

Swego czasu utworzyłem skrypt do pobierania łańcucha certyfikatów SSL dla serwera.
Obecnie jest on publicznie dostępny - [extract-x509-cert](https://gist.github.com/morawskim/b53c0addae9a8ce59cbb82565ce0f290).

Jeśli nasz skrypt ma uprawnienia wykonywania i znajduje się w ścieżce PATH to uruchamiamy go w następujący sposób:
`extract-x509-cert adresIpLubDomenaSerwera:Port ./plikGdzieZapisacLancuchCertyfikatow`

Mając pobrany łańcuch certyfikatów możemy go wykorzystać w poleceniu curl - `curl --cacert ./cert.pem -v 'https://adresIpLubDomenaSerwera:Port'`
