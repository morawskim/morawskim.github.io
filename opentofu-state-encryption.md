# Opentofu – szyfrowanie pliku stanu

OpenTofu w wersji 1.7 [wprowadziło obsługę szyfrowania stanu](https://opentofu.org/blog/opentofu-1-7-0/).
Od wielu lat czekaliśmy na implementację szyfrowania pliku stanu w Terraformie – zobacz [Encrypt State on save/load #29272](https://github.com/hashicorp/terraform/issues/29272).

## Już istniejący projekt z niezaszyfrowanym stanem

Do pliku `.tf` (np. `main.tf`) dodajemy deklarację zmiennej `passphrase`:

```
variable "passphrase" {
   type = string
   sensitive = true
}
```

Następnie konfigurujemy blok `terraform`:

```
terraform {
  # ......
  encryption {
    method "unencrypted" "migrate" {}
    key_provider "pbkdf2" "mykey" {
      passphrase = var.passphrase
    }

    method "aes_gcm" "new_method" {
      keys = key_provider.pbkdf2.mykey
    }

    state {
      method = method.aes_gcm.new_method
#       enforced = true
       fallback {
         method = method.unencrypted.migrate
       }
    }
  }
}
```

Hasło do zaszyfrowania pliku stanu musi mieć co najmniej 16 znaków.
Uruchamiamy polecenie: `TF_VAR_passphrase=mypassword tofu apply`.
Plik z stanem zostanie zaszyfrowany.

Następnie modyfikujemy blok `terraform -> encryption -> state`, **odkomentowując opcję `enforced`**, a **zakomentowując blok `fallback`**, aby wymusić szyfrowanie.

Szczegóły w [dokumentacji OpenTofu](https://opentofu.org/docs/language/state/encryption/#pre-existing-project).
