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

## Task Definition

[Amazon ECS task definitions](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definitions.html)

### Terraform

```
resource "aws_ecs_task_definition" "nginxdemo" {
  family                   = "nginxdemo"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256 # 1 vCPU = 1024 CPU units
  memory                   = 512 # in MiB
  container_definitions    = jsonencode([{
    name        = "nginxhello"
    image       = "nginxdemos/hello:latest"
    essential   = true
    environment = [
      {name = "VAR", value = "VALUE"}
    ]
    memoryReservation = 60
    portMappings = [{
      protocol      = "tcp"
      containerPort = 80
      hostPort      = 80
    }]
    logConfiguration = {
      logDriver = "awslogs",
      options = {
        awslogs-group = "/ecs/nginxdemo"
        awslogs-region = var.region
        awslogs-stream-prefix = "ecs"
      }
    }
  }])
}
```

### JSON

```
{
  "ipcMode": null,
  "executionRoleArn": "arn:aws:iam::358149850566:role/tf-ECSTaskExecutionRole",
  "containerDefinitions": [
    {
      "dnsSearchDomains": null,
      "environmentFiles": null,
      "logConfiguration": {
        "logDriver": "awslogs",
        "secretOptions": null,
        "options": {
          "awslogs-group": "/ecs/nginxdemo",
          "awslogs-region": "eu-central-1",
          "awslogs-stream-prefix": "ecs"
        }
      },
      "entryPoint": null,
      "portMappings": [
        {
          "hostPort": 80,
          "protocol": "tcp",
          "containerPort": 80
        }
      ],
      "command": null,
      "linuxParameters": null,
      "cpu": 0,
      "environment": [
        {
          "name": "VAR",
          "value": "VALUE"
        }
      ],
      "resourceRequirements": null,
      "ulimits": null,
      "dnsServers": null,
      "mountPoints": [],
      "workingDirectory": null,
      "secrets": null,
      "dockerSecurityOptions": null,
      "memory": null,
      "memoryReservation": 60,
      "volumesFrom": [],
      "stopTimeout": null,
      "image": "nginxdemos/hello:latest",
      "startTimeout": null,
      "firelensConfiguration": null,
      "dependsOn": null,
      "disableNetworking": null,
      "interactive": null,
      "healthCheck": null,
      "essential": true,
      "links": null,
      "hostname": null,
      "extraHosts": null,
      "pseudoTerminal": null,
      "user": null,
      "readonlyRootFilesystem": null,
      "dockerLabels": null,
      "systemControls": null,
      "privileged": null,
      "name": "nginxhello"
    }
  ],
  "placementConstraints": [],
  "memory": "512",
  "taskRoleArn": null,
  "compatibilities": [
    "EC2",
    "FARGATE"
  ],
  "taskDefinitionArn": "arn:aws:ecs:eu-central-1:358149850566:task-definition/nginxdemo:4",
  "family": "nginxdemo",
  "requiresCompatibilities": [
    "FARGATE"
  ],
  "networkMode": "awsvpc",
  "runtimePlatform": null,
  "cpu": "256",
  "revision": 4,
  "status": "ACTIVE",
  "inferenceAccelerators": null,
  "proxyConfiguration": null,
  "volumes": []
}
```
