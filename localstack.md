# localstack

## Konfiguracja

Do pliku `docker-compose.yml` dodajemy usługę localstack:

```
services:
  # ....
  localstack:
    container_name: "${LOCALSTACK_DOCKER_NAME:-localstack-main}"
    image: localstack/localstack:3.5
    ports:
      - "127.0.0.1:4566:4566"            # LocalStack Gateway
      - "127.0.0.1:4510-4559:4510-4559"  # external services port range
    environment:
      # LocalStack configuration: https://docs.localstack.cloud/references/configuration/
      - DEBUG=${DEBUG:-0}
    volumes:
      - "${LOCALSTACK_VOLUME_DIR:-./volume}:/var/lib/localstack"
      - "/var/run/docker.sock:/var/run/docker.sock"
```

Konfigurujemy narzędzie aws-cli ([niezbędna jest wersja >=2.13](https://github.com/aws/aws-cli/issues/1270#issuecomment-1626070761)).
Do pliku "~/.aws/config" dodajemy nowy profil "localstack":
```
[profile localstack]
endpoint_url=http://localhost:4566/
region=us-east-1
output=json
```

Następnie w pliku "~/.aws/credentials" konfiguruje access key i secret access key.

```
[localstack]
aws_access_key_id=test
aws_secret_access_key=test
```

Możemy teraz wywoływać polecenia AWS z wykorzystaniem profilu localstack - `aws s3 ls --profile localstack`
