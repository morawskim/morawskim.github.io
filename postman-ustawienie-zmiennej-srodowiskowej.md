# Postman - ustawienie zmiennej środowiskowej

W postman przechodzimy na zakładkę "Test" i wpisujemy poniższy skrypt

```
var data = JSON.parse(responseBody);
postman.setEnvironmentVariable("token", data.token);
```

Po wysłaniu żądania zmienna środowiskowa `token` zostanie automatycznie ustawiona.
W innych końcówkach możemy zacząć korzystać z zmiennej `token`.
