# Docker budowanie obrazu multiplatform

Za pomocą Docker i buildx możemy budować obraz na różne platformy.
Jeśli podczas budowania obrazu otrzymamy komunikat błędu:
>  ERROR: Multiple platforms feature is currently not supported for docker driver. Please switch to a different driver (eg. "docker buildx create --use")

to musimy utworzyć nową instancję poleceniem `docker buildx create --name <nazwa> --bootstrap --use`. Jeśli mamy inną gotową instancje możemy ją wybrać poleceniem `docker buildx use <nazwa>`.

Do zbudowania i opublikowania obrazu dla wielu platform wywołujemy polecenie `docker buildx build --platform linux/amd64,linux/arm64 -t username/imagename . --push`

W pliku Dockerfile możemy korzystać z dodatkowych zmiennych [Automatic platform ARGs in the global scope](https://docs.docker.com/engine/reference/builder/#automatic-platform-args-in-the-global-scope), ale musimy skorzystać z dyrektywy ARG np. `ARG TARGETARCH`.
