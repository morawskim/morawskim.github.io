PHP/SOAP - Can't load WSDL
==========================

Podczas prac nad jednym z projektów otrzymywałem błąd PHP, że nie można pobrać dokumentu WSDL z zdalnego serwera. Na początku myślałem, że jest to problem z certyfikatem SSL. Po wyciągnięciu go i skonfigurowaniu SoapClient w PHP ciągle otrzymywałem ten błąd. Certyfikat były poprawnie utworzony, ponieważ przez program curl się pobierał.

Dopiero wejście na ten adres WSDL w przeglądarce firefox spowodowało wyświetlenie poniższego błędu:

```
An error occurred during a connection to devapps01.biz.masterlink.com.pl:9193. SSL received a weak ephemeral Diffie-Hellman key in Server Key Exchange handshake message. Error code: SSL_ERROR_WEAK_SERVER_EPHEMERAL_DH_KEY
```

Postanowiłem odtworzyć ten błąd PHP. Dodałem opcję konfiguracyjną PHP:

``` php
ini_set('soap.wsdl_cache_enabled', 0);
```

Utworzyłem kontekst SSL, taki sam jaki przekazywałem do \\SoapClient.

``` php
$steamContext = stream_context_create([
        'ssl' => [
             //set some SSL/TLS specific options
                        #'verify_peer'       => false,
                        #'verify_peer_name'  => false,
                        #'allow_self_signed' => true,
            "cafile" => __DIR__ . '/mlauthservicesdev.pem',
        ],
    ]);

$f = file_get_contents('https://devapps01.biz.masterlink.com.pl:9193/AuthorizationServices/AuthorizationServices?wsdl', false, $steamContext);
echo $f;
```

Otrzymałem taki komunikat:

```
SSL operation failed with code 1. OpenSSL Error messages:
error:14082174:SSL routines:ssl3_check_cert_and_algorithm:dh key too small in /vagrant/test.php on line 23
```

Miałem, więc potwierdzenie dlaczego rozszerzenie PHP/SOAP nie chce pobrać WSDL. Dodałem parametr do kotekstu ssl:

``` php
'ciphers' => 'DEFAULT:!DH',
```

Wtedy WSDL się pobrał i rozszerzenie Soap nie wyświetlało już błedu.