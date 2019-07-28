# gitlab-ci i kaniko - budowanie obrazów dockera

`kaniko` umożliwia nam budowanie obrazów dockera w kontenerze.
Dzięki temu nie musimy odpalać oddzielnego `gitlab-runner`, który uruchamiałby obraz `docker-in-docker` w trybie uprzywilejowanym (privileged). Jak to przedstawia dokumentacja [https://gitlab.com/help/ci/docker/using_docker_build.md#use-docker-in-docker-executor](https://gitlab.com/help/ci/docker/using_docker_build.md#use-docker-in-docker-executor).

Korzystając z `kaniko` w GitLab CI/CD musimy pamiętać o:

* powinniśmy korzystać z obrazu `gcr.io/kaniko-project/executor:debug`. Ten obraz posiada powłokę, a GitLab Ci/CD wymaga powłoki.
* `entrypoint` musi zostać nadpisany.
* Plik `config.json` musi zawierać dane autoryzacyjne do rejestru kontenerów

Przykładowy job dla gitlab-ci

```
build:
  stage: build
  image:
    name: gcr.io/kaniko-project/executor:debug
    entrypoint: [""]
  script:
    - echo "{\"auths\":{\"$CI_REGISTRY\":{\"username\":\"$CI_REGISTRY_USER\",\"password\":\"$CI_REGISTRY_PASSWORD\"}}}" > /kaniko/.docker/config.json
    - /kaniko/executor --context $CI_PROJECT_DIR --dockerfile $CI_PROJECT_DIR/Dockerfile --destination $CI_REGISTRY_IMAGE:$CI_COMMIT_TAG
  only:
    - tags
```

[https://gitlab.com/help/ci/docker/using_kaniko.md](https://gitlab.com/help/ci/docker/using_kaniko.md)

[https://github.com/GoogleContainerTools/kaniko](https://github.com/GoogleContainerTools/kaniko)
