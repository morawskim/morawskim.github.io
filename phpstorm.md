# PHPStorm

## Skróty klawiaturowe

| Skrót  | Opis  |
|---|---|
| `ALT + F12` | otwarcie terminala |
| `Shift+Alt+Ins`  | Włączenie trybu zaznaczania kolumnowego  |
| `Ctrl+Shift+F12` | Ukrywa (albo przywraca) wszystkie pozostałe okna, więc edytor zajmuje całą dostępną przestrzeń  |
| `Ctrl+Shift+[up/down/left/right]` | Zmiana rozmiaru okna |
| `Shift + Esc` | Ukrywa aktywne okno narzędziowe |
| `Ctrl + Shift + I` | Szybki podgląd źródeł klas, interfejsów, metod itp. |
| `Ctrl + [up/left/right/down]` | Przewijanie kodu w panelu edytora bez przesuwania pozycji kursora |
| `Ctrl + Numpad +/-` | Zwijanie/Rozwijanie bloku kodu |
| `Ctrl + Shift + M` | Przejdź do nawiasu |
| `Ctrl + F12` | Przejdź do określonej metody, pola, właściwości w bieżącym dokumencie |
| ``Ctrl + ` `` | Przełącz między różnymi schematami kolorów, układami klawiatury i wyglądem |
| `CTRL + ALT + SHIFT + [DOWN | UP]` | Przejdź do następnej/poprzedniej zmiany w edytorze |
| `CTRL + SHIFT + [F7]` | Zaznacz użycia np. zmiennej w pliku. Wciskając klawisz `[F3]` przejdziemy do następnego użycia. |
| `CTRL + SHIFT + Q` | Otwórz nową konsolę z bazą danych |

[PHP STORM – SKRÓTY KTÓRE WARTO ZNAĆ](https://totylkokod.pl/baza-wiedzy/php-storm-skroty-ktore-warto-znac/)
[Editor Tips and Tricks in IntelliJ IDEA](https://blog.jetbrains.com/idea/2020/08/editor-tips-and-tricks-in-intellij-idea/)
[10 places you don’t need to use the mouse in IntelliJ IDEA](https://blog.jetbrains.com/idea/2021/08/10-places-you-don-t-need-to-use-the-mouse-in-intellij-idea/)

## Pluginy

* .ignore
* CSV
* Kubernetes
* One Dark theme
* PHP Annotations
* Php Inspections (EA Extended)
* PHP Toolbox
* PHPUnit Enhancement
* Symfony Support
* Terraform and HCL
* Json Helper
* GitLive
* String Manipulation
* GitToolBox
* yamllint
* [Tailwind CSS](https://plugins.jetbrains.com/plugin/15321-tailwind-css) ([Wymaga skonfigurowania interpretatora Node.js w JetBrains](https://www.jetbrains.com/help/webstorm/tailwind-css.html#ws_css_tailwind_before_you_start))

## Porady

W MongoDB do uwierzytelnienia prócz użytkownika i hasła musimy także podać nazwę bazy danych.
Możemy to zrobić w connection URL: `mongodb://localhost:27017/local?authSource=admin`.
Parametr `authSource` to nazwa bazy danych do uwierzytelnienia.
[Connect to MongoDB](https://www.jetbrains.com/help/phpstorm/mongodb.html)

## Http Client

### OAuth2 i klient HTTP

[Od wersji 2023.3 wbudowany klient HTTP obsługuje autoryzację poprzez protokół OAuth2.](https://youtrack.jetbrains.com/issue/IDEA-239311/Support-OAuth-authorization)
[Zaś w IntelliJ IDEA 2024.1 EAP 5](https://blog.jetbrains.com/idea/2024/02/intellij-idea-2024-1-eap-5/#http-client-improvements) dodano wsparcie dla PKCE.
W pliku z ustawieniami dla danego środowiska dodajemy konfigurację.

```
{
  "dev": {
    "Security": {
      "Auth": {
        "MOJA_NAZWA": {
          "Type": "OAuth2",
          "Auth URL": "https://auth.example.com/auth/realms/<moj-realm>/protocol/openid-connect/auth",
          "Token URL": "https://auth.example.com/auth/realms/<moj-realm>/protocol/openid-connect/token",
          "Grant Type": "Authorization Code",
          "Client ID": "moja-aplikacja",
          "Scope": "openid",
          "Redirect URL": "http://localhost:8888",
          "PKCE":true
        }
      }
    }
  }
}
```

W plikach `.http` możemy wykorzystać token korzystając z składni `{{$auth.token("MOJA_NAZWA")}}` np `Authorization: Bearer {{$auth.token("MOJA_NAZWA")}}`

### Multipart/form-data
```
### multipart request
POST https://httpbin.org/post
Accept: application/json, text/plain, */*
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7s2KUwjCtiHdKS0w

------WebKitFormBoundary7s2KUwjCtiHdKS0w
Content-Disposition: form-data; name="subject"

subject
------WebKitFormBoundary7s2KUwjCtiHdKS0w
Content-Disposition: form-data; name="attachments[0][name]"

foo-image
------WebKitFormBoundary7s2KUwjCtiHdKS0w
Content-Disposition: form-data; name="attachments[0][file]"; filename="image.jpeg"
Content-Type: image/jpeg

< ./image.jpeg
------WebKitFormBoundary7s2KUwjCtiHdKS0w
Content-Disposition: form-data; name="attachments[0][mimetype]"

image/jpeg
------WebKitFormBoundary7s2KUwjCtiHdKS0w
Content-Disposition: form-data; name="name"

foo
------WebKitFormBoundary7s2KUwjCtiHdKS0w--
```

## AI Assistant

Instalujemy plugin [JetBrains AI Assistant](https://plugins.jetbrains.com/plugin/22282-jetbrains-ai-assistant), a także [JetBrains Junie](https://plugins.jetbrains.com/plugin/26104-jetbrains-junie).
