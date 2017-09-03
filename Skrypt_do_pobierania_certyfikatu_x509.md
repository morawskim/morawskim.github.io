Skrypt do pobierania certyfikatu x509
=====================================

Jeśli podczas próby połączenia się z serwerem otrzymujemy komunikat, że certyfikat nie został podpisany przez żadną zaufaną organizację. Możemy wyciągnąć certyfikat serwera i potraktować go jako zaufany.

```
...
    Start Time: 1435485776
    Timeout   : 300 (sec)
    Verify return code: 18 (self signed certificate)
```

Wyciągnięciem certyfikatu zajmuje się poniższy skrypt. Wyciąga on tylko certyfikat serwera! Skrypt nie obsługuje łańcucha certyfikatów.

``` bash
#!/bin/sh
#Shell script to extract x509 certificate
#Author: Marcin Morawski <marcin@morawskim.pl>

#Exit immediately if a command exits with a non-zero status.
set -e

#Avoid accidental overwriting of a file
set -o noclobber

#Bin paths, change if these programs are not stored in paths of PATH environment variable
OPENSSL=$(which openssl)
SED=$(which sed)
AWK=$(which awk)
TR=$(which tr)
BASENAME=$(which basename)

if [ $# -eq 0 ]; then
  echo 'Usage: ' `$BASENAME $0` ' host:port ' '[outputfile]' >&2
  exit 1
fi;

HOST="$1"
if [ -z $2 ]; then
  OUTPUT=$(echo $HOST | "$TR" ':/' ':' | "$AWK" -F ':' '{print $1}')
  OUTPUT="$OUTPUT.crt"
else
  OUTPUT="$2"
fi

#disable temporarily exit on error. We want display openssl error message
set +e
OPENSSL_OUTPUT=$($OPENSSL s_client -connect $HOST 2>&1 </dev/null)
if [ $? -ne 0 ]; then
  echo 'openssl failed' >&2
  echo "$OPENSSL_OUTPUT"
  exit 1
fi
#enable again auto exit on command failure
set -e
echo "$OPENSSL_OUTPUT" | $SED -ne '/-----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----/p' > $OUTPUT
```

Sposób użycia:

``` bash
extract_x509_cert.sh IP|NazwaSerwera:Port [gdzieZapiscPlikZCertyfikatem]
#drugi parametr jest opcjonalny. Jeśli go nie podamy to certyfikat zostanie automatycznie zapisany do katalogu roboczego pod nazwą IPLubNazwaSerwera.crt
```

Po zapisaniu certyfikatu możemy się przekonać, czy teraz weryfikacja certyfikatu przebiegła pomyślnie

``` bash
openssl s_client -connect IP:443 -CAfile ./IP.crt
```