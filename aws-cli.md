# aws-cli

Dla wersji pierwszej narzędzia aws-cli dostępna jest powłoka [aws-shell](https://github.com/awslabs/aws-shell).
Podpowiada ono polecenia, parametry a także dynamiczne wartości takie jak nazwy utworzonych maszyn wirtualnych.

Wersja druga aws-cli posada wbudowaną obsługę trybu auto-prompt. Musimy jednak włączyć ten tryb.
Jedną z opcji jest ustawienie zmiennej środowiskowej `AWS_CLI_AUTO_PROMPT` na wartość `on`.
Drugą opcją jest przekazanie flagi `--cli-auto-prompt` do polecenia aws.
Trzecia opcja to wywołanie polecenia `aws configure set cli_auto_prompt on`, które zmodyfikuje plik konfiguracyjny aws i włączy obsługę trybu auto-prompt.

Niektóre dystrybucje ciągle nie oferują pakietu aws-cli w wersji 2.
W takim przypadku możemy użyć obrazu kontenera `amazon/aws-cli`, albo zainstalować pakiet przez pip.

[Using the official AWS CLI version 2 Docker image](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-docker.html)

[Improved CLI auto-prompt mode](https://github.com/aws/aws-cli/issues/5664)
