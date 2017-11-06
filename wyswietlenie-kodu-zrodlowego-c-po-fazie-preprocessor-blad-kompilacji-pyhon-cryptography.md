# Wyświetlenie kodu źródłowego C po fazie preprocessor (Błąd kompilacji pyhon-cryptography)

Podczas instalacji mitmproxy w wersji 0.18.2 (przez pip) w środowisku virtualenv python 2.7 otrzymałem błąd kompilacji

```
gcc -pthread -fno-strict-aliasing -fmessage-length=0 -grecord-gcc-switches -O2 -Wall -D_FORTIFY_SOURCE=2 -fstack-protector -funwind-tables -fasynchronous-unwind-tables -g -DNDEBUG -fmessage-length=0 -grecord-gcc-switches -O2 -Wall -D_FORTIFY_SOURCE=2 -fstack-protector -funwind-tables -fasynchronous-unwind-tables -g -DOPENSSL_LOAD_CONF -fwrapv -fPIC -I/usr/include/python2.7 -c build/temp.linux-x86_64-2.7/_openssl.c -o build/temp.linux-x86_64-2.7/build/temp.linux-x86_64-2.7/_openssl.o
    In file included from /usr/include/openssl/x509.h:595:0,
                     from /usr/include/openssl/engine.h:96,
                     from build/temp.linux-x86_64-2.7/_openssl.c:565:
    build/temp.linux-x86_64-2.7/_openssl.c:2747:19: error: expected identifier or ‘(’ before numeric constant
     static const long X509_V_ERR_HOSTNAME_MISMATCH = 0;
                       ^
    build/temp.linux-x86_64-2.7/_openssl.c:2748:19: error: expected identifier or ‘(’ before numeric constant
     static const long X509_V_ERR_EMAIL_MISMATCH = 0;
                       ^
    build/temp.linux-x86_64-2.7/_openssl.c:2749:19: error: expected identifier or ‘(’ before numeric constant
     static const long X509_V_ERR_IP_ADDRESS_MISMATCH = 0;
                       ^
    error: command 'gcc' failed with exit status 1
```

Wywołałem polecenie pip install jeszcze raz, ale tym razem z parametrem `--no-clean`.
``` bash
pip install --no-clean mitmproxy==0.18.2
```

Na wyjściu można było dostrzec katalog roboczy. W moim przypadku był to `/tmp/pip-build-yw5VFQ/cryptography`.
W tym katalog był plik, który powodował błąd kompilacji `build/temp.linux-x86_64-2.7/_openssl.c`.
Otworzyłem ten plik i przeskoczyłem do lini 2747 zgodnie z komunikatem. W podanym miejscu nie znalazłem żadnego błędu.
Mając polecenie gcc, które powoduje błąd kompilacji postanowiłem zobaczyć jak wygląda plik źródłowy po fazie preproccess.
Usunąłem argument `-o` i dodałem flagę `-E` (na końcu).

```
gcc -pthread -fno-strict-aliasing -fmessage-length=0 -grecord-gcc-switches -O2 -Wall -D_FORTIFY_SOURCE=2 -fstack-protector -funwind-tables -fasynchronous-unwind-tables -g -DNDEBUG -fmessage-length=0 -grecord-gcc-switches -O2 -Wall -D_FORTIFY_SOURCE=2 -fstack-protector -funwind-tables -fasynchronous-unwind-tables -g -DOPENSSL_LOAD_CONF -fwrapv -fPIC -I/usr/include/python2.7 -c build/temp.linux-x86_64-2.7/_openssl.c -E
```

Na stdout wyświetlił się plik. Zaciekawił mnie poniższy kod.
```
# 2740 "build/temp.linux-x86_64-2.7/_openssl.c"
static const long Cryptography_HAS_102_VERIFICATION_ERROR_CODES = 0;
static const long X509_V_ERR_SUITE_B_INVALID_VERSION = 0;
static const long X509_V_ERR_SUITE_B_INVALID_ALGORITHM = 0;
static const long X509_V_ERR_SUITE_B_INVALID_CURVE = 0;
static const long X509_V_ERR_SUITE_B_INVALID_SIGNATURE_ALGORITHM = 0;
static const long X509_V_ERR_SUITE_B_LOS_NOT_ALLOWED = 0;
static const long X509_V_ERR_SUITE_B_CANNOT_SIGN_P_384_WITH_P_256 = 0;
static const long 62 = 0;
static const long 63 = 0;
static const long 64 = 0;
```

Jak się okazało nasze stałe:
```
static const long X509_V_ERR_HOSTNAME_MISMATCH = 0;
static const long X509_V_ERR_EMAIL_MISMATCH = 0;
static const long X509_V_ERR_IP_ADDRESS_MISMATCH = 0;
```
zostały zastąpione przez makra z `/usr/include/openssl/x509_vfy.h`.
Ten plik należy do pakietu libressl-devel w wersji 2.5.3.
```
$rpm -qf /usr/include/openssl/x509_vfy.h 
libressl-devel-2.5.3-5.3.1.x86_64
```

Błąd kompilacji z libressl był już znany  programistom (https://github.com/pyca/cryptography/commit/8bb9cc629b33e80a8544d7a3a2a55f96549a0259#diff-0d2ba1e53e12a01935959a6ad049f7f4).
Nowsze wersje kompilują się z libressl 2.5.3.

Ja nie mogłem skorzystać z nowszych wydań.
Postanowiłem skopiować plik `/usr/include/openssl/x509_vfy.h` do tymczasowego katalog.
A następnie skasować te marka które powodowały błąd kompilacji.
Finalnie ustawiłem zmienną środowiskową `CFLAGS`, aby dodać katalog  z zmodyfikowanym plikiem  `openssl/x509_vfy.h`.

```
CFLAGS="-I/run/user/1000/cdtmp-yziz1T/include" pip install mitmproxy==0.18.2
```

Instalacja zakończyła się sukcesem, choć rozwiązanie nie jest idealne.

