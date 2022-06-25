# AWS Kontenery

## ECR

W usłudze ECR możemy przechowywać obrazy kontenerów. Nazwa repozytorium w AWS można porównać do nazwy obrazu dockera.
Aby zobaczyć istniejące repozytoria na naszym koncie AWS wywołujemy polecenie `aws ecr describe-repositories | jq '.repositories[].repositoryName'`.
Znając nazwę repozytorium możemy pobrać listę dostępnych tagów obrazu wywołując polecenie `aws ecr list-images --repository-name <REPOSITORY_NAME> | jq '.imageIds[].imageTag'`

Korzystając z dockera możemy przesłać obraz do ECR. Wywołujemy polecenie `aws ecr describe-repositories | jq '.repositories[].repositoryUri'` aby poznać adres URI do publikowania obrazów kontenerów.
Znając adres możemy się zalogować wywołując polecenie `aws ecr get-login-password | docker login --username AWS --password-stdin <REPOSITORY_URI>`. Powinniśmy otrzymać wiadomość "Login Succeeded".
Następnie możemy wykorzystując standardowe polecenia dockera (tag, pull, push) przesłać obraz kontenera.

## ECS i ALB

W panelu zarządzania usługą ECS musimy utworzyć usługę (ang. Service) i wybrać istniejący ALB.
Tworząc ALB tworzymy także Target Group. Jeśli nasze zadania uruchamiamy w Farget (serverless) to jako „target type” wybieramy "IP".
Dzięki temu nasze zadania ECS zostaną zarejestrowane automatycznie w Target Group i będziemy mogli się do nich połączyć przez adres ALB.

[Creating an Application Load Balancer](https://docs.aws.amazon.com/AmazonECS/latest/userguide/create-application-load-balancer.html)
