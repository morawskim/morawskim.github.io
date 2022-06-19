# AWS Kontenery

## ECR

W usłudze ECR możemy przechowywać obrazy kontenerów. Nazwa repozytorium w AWS można porównać do nazwy obrazu dockera.
Aby zobaczyć istniejące repozytoria na naszym koncie AWS wywołujemy polecenie `aws ecr describe-repositories | jq '.repositories[].repositoryName'`.
Znając nazwę repozytorium możemy pobrać listę dostępnych tagów obrazu wywołując polecenie `aws ecr list-images --repository-name <REPOSITORY_NAME> | jq '.imageIds[].imageTag'`

Korzystając z dockera możemy przesłać obraz do ECR. Wywołujemy polecenie `aws ecr describe-repositories | jq '.repositories[].repositoryUri'` aby poznać adres URI do publikowania obrazów kontenerów.
Znając adres możemy się zalogować wywołując polecenie `aws ecr get-login-password | docker login --username AWS --password-stdin <REPOSITORY_URI>`. Powinniśmy otrzymać wiadomość "Login Succeeded".
Następnie możemy wykorzystując standardowe polecenia dockera (tag, pull, push) przesłać obraz kontenera.
