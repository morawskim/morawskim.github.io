# Meta Llama 

Tworzymy plik Dockerfile

```
FROM ubuntu:22.04

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y software-properties-common build-essential libopenblas-dev ninja-build pkg-config cmake-data clang \
    git git-lfs curl wget zip unzip

# Install python3 and required packages.
RUN apt-get install -y python3 python3-pip python-is-python3 && \
    python -m pip install --upgrade pip pytest cmake scikit-build setuptools fastapi uvicorn sse-starlette pydantic-settings sentencepiece numpy

# Install rustup
RUN wget -O /tmp/rustup.rs https://sh.rustup.rs && sh /tmp/rustup.rs -y && . "$HOME/.cargo/env" && rustup target add wasm32-wasi

#Install WasmEdge with an LLM inference backend.
RUN curl -sSf https://raw.githubusercontent.com/WasmEdge/WasmEdge/master/utils/install_v2.sh | bash
```

Następnie tworzymy plik docker-compose.yml:

```
services:
  llma:
    build:
      context: ./
    volumes:
        - ./:/llma
    command: bash
    tty: true
```

[Prosimy o dostęp do modeli Meta](https://llama.meta.com/llama-downloads/).
Zakładamy konto na [huggingface](https://huggingface.co/join) i prosimy o dostęp do [modeli Meta (w tym przypadku wersji 2)](https://huggingface.co/meta-llama)
Na stronie [sprawdzamy do których modeli mamy dostęp](https://huggingface.co/settings/gated-repos).
Tworzymy [access token do huggingface](https://huggingface.co/settings/tokens).

Pobieramy repozytorium z modelem `git clone https://huggingface.co/meta-llama/Llama-2-7b-chat/`.
Git spyta się nas o dane uwierzytelniające. Jako username podajemy adres email podany przy rejestracji do huggingface, a hasło to wygenerowany token.

Zamiast pobierać model i go budować możemy skorzystać z już przekonwertowanego modelu: `curl -LO https://huggingface.co/second-state/Llama-2-7B-Chat-GGUF/resolve/main/Llama-2-7b-chat-hf-Q5_K_M.gguf`
Pobieramy Simple text completion - `curl -LO https://github.com/LlamaEdge/LlamaEdge/releases/latest/download/llama-simple.wasm`

Możemy zapytać nasz model np. o rok wydania PHP
Wchodzimy do kontenera llma - `docker compose exec llma bash`. Przechodzimy do katalogu `cd /llma` i wywołujemy polecenie:

```
wasmedge --dir .:. \
  --nn-preload default:GGML:AUTO:Llama-2-7b-chat-hf-Q5_K_M.gguf \
  llama-simple.wasm \
  --prompt "In which year PHP was released? "
```
