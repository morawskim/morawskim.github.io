# OAuth

## client credentials flow (Keycloak i JetBrains HTTP CLient)

Korzystając z Keycloak i klienta HTTP wbudowanego w np. PhpStorm możemy uzyskać token dla konta serwisowego, który umożliwi nam wywoływanie API. 
W przykładach poniżej musimy zastąpić:

* `CLIENT_ID` nazwą konta z keycloak
* `CLIENT_SECRET` sekretnym kluczem wygenerowanym dla konta
* `put-here-your-realm` nazwą realm, w którym istnieje nasze konto

`CLIENT_ID` i `CLIENT_SECRET` możemy podać zarówno w nagłówku HTTP `Authorization` jak w pierwszym przykładzie, albo w body zadania HTTP jak w drugim przypadku.

Wygenerowany token zostanie zapisany w zmiennej `access_token` i możemy go wykorzystać do autoryzacji wywołań API za pomocą standardowego zapisu `{{access_token}}`.

```
POST https://mykeycloak.domain.com/auth/realms/put-here-your-realm/protocol/openid-connect/token
Authorization: Basic CLIENT_ID CLIENT_SECRET
Content-Type: application/x-www-form-urlencoded

grant_type=client_credentials

{% raw %}
{# the raw tag is only for fix build, this is not part of http client file #}
> {% client.global.set('access_token', response.body.access_token) %}
{% endraw %}
```

```
POST https://mykeycloak.domain.com/auth/realms/put-here-your-realm/protocol/openid-connect/token
Content-Type: application/x-www-form-urlencoded

grant_type=client_credentials&client_id=CLIENT_ID&client_secret=CLIENT_SECRET

{% raw %}
{# the raw tag is only for fix build, this is not part of http client file #}
> {% client.global.set('access_token', response.body.access_token) %}
{% endraw %}
```
