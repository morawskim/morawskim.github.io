# html5 - wyłączenie autocomplete nazwy użytkownika i hasła

W inputach atrybut `autocomplete="off"` powinno zabraniać autouzpełniania przeglądarkom.
Niestety przeglądarki w przypadku inputów z nazwą użytkownika i hasłem podpowiadają zapamiętane dane logowania.
Możemy wyłączyć te zachowanie ustawiając atrybut `autocomplete` na wartość `new-password`.

Dodatkowe informacje:
* https://gist.github.com/runspired/b9fdf1fa74fc9fb4554418dea35718fe
* https://developer.mozilla.org/en-US/docs/Web/Security/Securing_your_site/Turning_off_form_autocompletion

