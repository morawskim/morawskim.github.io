# terraformer

Za pomocą `terraformer` możemy wygenerować pliki `tf` z istniejącej infrastruktury.
W tym przykładzie pobierzemy dane z chmury AWS

Pobieramy narzędzie ze strony projektu [GitHub](https://github.com/GoogleCloudPlatform/terraformer/releases/) dla naszej platformy.
Następnie tworzymy katalog, w którym tworzymy plik `main.tf` z zawartością:

```
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.70.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

```

Wywołujemy polecenie `terraform init`, który pobierze niezbędne pluginy.
Kopiujemy/Przenosimy do katalogu plik wykonywalny `terraformer` i nadajemy uprawnienia wykonywania.

Następnie możemy już wygenerować pliki tf wywołując polecenie `./terraformer-aws-linux-amd64 import aws --regions=eu-central-1 --resources ecr`. Polecenie te utworzy katalog `generated/aws/ecs/` w którym będą znajdować się wygenerowane pliki zasobów. Lista obsługiwanych zasobów AWS jest dostępna w dokumentacji terraformer.

Niektóre zasoby AWS są globalne, więc parametr `regions` nie ma znaczenia.
Obecnie chcąc pobrać wszystkie wspierane zasoby z AWS musimy je podać po przecinku np. `--resources ecr,esc`.
W przypadku mieszania usług globalnych i regionalnych możemy mieć pewne braki w wygenerowanych plikach. Lepiej w takim przypadku podzielić je na dwa polecenia.

[AWS terraformer](https://github.com/GoogleCloudPlatform/terraformer/blob/master/docs/aws.md)
