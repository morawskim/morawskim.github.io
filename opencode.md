# OpenCode

## Opencode in docker container wont start TUI

Po pobraniu obrazu Dockera `ghcr.io/anomalyco/opencode` napotkałem te same problemy, które zostały opisane w zgłoszeniach:

[TUI fails on Alpine Linux (musl) in 1.14.50: getcontext symbol not found](https://github.com/anomalyco/opencode/issues/27589)

[Opencode in docker container wont start opencode TUI](https://github.com/anomalyco/opencode/issues/28314)

Istnieje otwarty PR rozwiązujący ten problem: [fix(opencode): preload libucontext in Docker image](https://github.com/anomalyco/opencode/pull/29223)

Do czasu połączenia zmian z główną gałęzią projektu można samodzielnie zbudować obraz kontenera zawierający poprawkę.

Klonujemy repozytorium - `git clone https://github.com/anomalyco/opencode.git`
Przechodzimy do nowego katalogu - `cd opencode`.

Edytujemy plik `packages/opencode/Dockerfile`, wprowadzając zmiany analogiczne do tych z PR:

```
diff --git a/packages/opencode/Dockerfile b/packages/opencode/Dockerfile
index f92b48a6d..6b3e13b57 100644
--- a/packages/opencode/Dockerfile
+++ b/packages/opencode/Dockerfile
@@ -4,7 +4,8 @@ FROM alpine AS base
 # On ephemeral containers, the cache is not useful
 ARG BUN_RUNTIME_TRANSPILER_CACHE_PATH=0
 ENV BUN_RUNTIME_TRANSPILER_CACHE_PATH=${BUN_RUNTIME_TRANSPILER_CACHE_PATH}
-RUN apk add libgcc libstdc++ ripgrep
+RUN apk add libgcc libstdc++ libucontext ripgrep
+ENV LD_PRELOAD=/usr/lib/libucontext.so.1

 FROM base AS build-amd64
 COPY dist/opencode-linux-x64-baseline-musl/bin/opencode /usr/local/bin/opencode
```
Następnie uruchamiamy: `docker run --rm -it -v $PWD:/tmp/opencode -w/tmp/opencode oven/bun bash -c 'apt update -y && apt install -y git && bun install && bun i node-gyp && git config --global --add safe.directory /tmp/opencode && ./packages/opencode/script/build.ts'`

Polecenie wygeneruje binaria OpenCode dla różnych architektur i platform w katalogu `packages/opencode/dist/`.

Przechodzimy do katalogu `packages/opencode` i budujemy obraz `docker build -t opencode .`.

Gotowy obraz można uruchomić poleceniem: `docker run --rm -it opencode`.
Po zastosowaniu powyższej poprawki interfejs TUI OpenCode powinien uruchomić się poprawnie.

Obraz `ghcr.io/anomalyco/opencode:1.17.6` działa już bez problemu.
