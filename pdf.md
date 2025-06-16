# PDF

## Konwersja PDF (pierwsza strona) do pliku PNG

`convert -density 150 input.pdf[0] -quality 90 output.png`

## Zdejmowanie hasła z pliku PDF

`qpdf --password=<your-password> --decrypt /path/to/secured.pdf out.pdf`

## Zaszyfruj i odszyfruj plik za pomocą openssl

### PBKDF2

`openssl enc -aes-256-cbc -pbkdf2 --pass pass:'mysecretpassword' -in fileToEncrypt -out encryptedFile` vs `openssl aes-256-cbc -d  -pbkdf2 -in ./encryptedFile -out ./decryptedFile`
