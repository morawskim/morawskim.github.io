# apache2 - dyrektywy zwiększające bezpieczeństwo serwera HTTP

Do pliku `httpd.conf` dodajemy:
```
ServerTokens Prod
ServerSignature Off
TraceEnable Off
Options all -Indexes
Header always unset X-Powered-By
```

Do modyfikacji nagłówków (dyrektywa `Header`) wymagany jest włączony moduł `headers`.
