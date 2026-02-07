# Ollama

`ollama` - umożliwia uruchamianie lokalnych modeli językowych (LLM) na własnym komputerze.

[Uruchom prywatne AI na zwykłym PC](https://www.youtube.com/watch?v=wTrnXE5LS_4)
[Uruchom prywatne AI na zwykłym PC (cz.2) - A może Ollama nie na Windows a na Ubuntu Server... ??](https://www.youtube.com/watch?v=hRk759LCQkw)
[Uruchom prywatne AI na zwykłym PC (cz.3) - Dorzucamy do Ollama: OpenWebUI + Perplexica + Shell-GPT](https://www.youtube.com/watch?v=VcN_Jad5KLI)

## Docker compose

```
services:
  ollama:
    image: ollama/ollama
    ports:
      - "11434:11434"
    volumes:
      - ./olama-data:/root/.ollama
  openwebui:
    image: ghcr.io/open-webui/open-webui:main
    ports:
      - "3000:8080"
    environment:
      OLLAMA_BASE_URL: http://ollama:11434
    volumes:
      - ./open-webui:/app/backend/data

```

Uruchom stos poleceniem - `docker compose up -d`.
Wchodzimy do kontenera ollama `docker compose exec ollama bash`.
W kontenerze ollama pobieramy model llama3.2:3b: `ollama pull llama3.2:3b`.
[Lista dostępnych modeli do pobrania.](https://ollama.com/search)

Otwieramy przegladarkę i przechodzimy na stronę `localhost:3000`.
Zakładamy konto. Następnie możemy utworzyć czat wykorzystując pobrany model (do wybrania w lewym górnym rogu panelu z widokiem rozmowy).
