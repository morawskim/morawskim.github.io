# OpenClaw

Tworzymy plik Dockerfile lub korzystamy z gotowego obrazu:

```
FROM node:25

ENV NODE_ENV=production
RUN npm install -g openclaw mcporter

USER node
CMD ["openclaw", "gateway", "run", "--allow-unconfigured"]
EXPOSE 18789

```

Tworzymy plik docker-compose.yml:

```
services:
  nodejs:
    image: openclaw
    environment:
        - MCPORTER_CONFIG=/home/node/mcporter.json
    env_file: .env
    working_dir: /home/node
    volumes:
         - ./openclaw:/home/node/.openclaw
         - ./mcporter.json:/home/node/mcporter.json
    ports:
      - "18789:18789"

```

Tworzymy plik konfiguracyjny `mcporter.json`.

Zmienna środowiskowa `MCPORTER_CONFIG` powinna wskazywać na ten plik.
Przykładowa konfiguracja (Bitbucket MCP):

```
{
  "mcpServers": {
    "bitbucket": {
        "command": "/usr/local/bin/bitbucket-mcp",
        "args": ["mcp"],
        "transportType": "stdio",
        "disabled": false,
        "timeout": 60
      }
  }
}

```

Startujemy kontenery: `docker compose up -d`

Konfigurujemy OpenClaw: `docker compose exec nodejs openclaw onboard`.
W trakcie konfiguracji kontener może zostać zatrzymany - w takim przypadku należy uruchomić go ponownie i jeszcze raz wykonać powyższe polecenie.

Następnie parujemy przeglądarkę. Wyświetlamy token i adres URL kokpitu: `docker compose exec nodejs openclaw dashboard --no-open`

Otwieramy podany adres URL w przeglądarce i parujemy urządzenie.
Wchodzimy do kontenera `docker compose exec nodejs bash`.
Wyświetlamy oczekujące urządzenia `openclaw devices list`.
Przykład:

```
Pending (1)
┌──────────────────────────────────────┬─
│ Request                              │
├──────────────────────────────────────┼─
│ 21f8d260-e8e9-4257-bb90-e1f19fa60b03 │
```

Akceptujemy żądanie: `openclaw devices approve <Request>`

Po zatwierdzeniu urządzenia powinniśmy zobaczyć panel OpenClaw w przeglądarce.

![openclaw](images/openclaw/openclaw.png)

Podgląd logów OpenClaw: `docker compose exec nodejs openclaw logs --follow`

Aby przetestować integrację MCP, uruchom w kontenerze: `mcporter call bitbucket`.

## Ollama — lokalny model i długi prompt

Po uruchomieniu modelu w Ollama odpowiedzi generowały się szybko (`ollama run model`).
Jednak po podłączeniu modelu do OpenClaw zauważyłem znacznie dłuższy czas oczekiwania na odpowiedź.

Po podłączeniu proxy okazało się, że do modelu przekazywany jest bardzo długi prompt.
Postanowiłem więc dla tego konkretnego dostawcy wyłączyć przekazywanie informacji o dostępnych narzędziach, ponieważ polecenie `/context list` w czacie OpenClaw pokazywało, że dodanie definicji narzędzi może zajmować nawet:

>Tool list (system prompt text): 0 chars (~0 tok)
Tool schemas (JSON): 31,415 chars (~7,854 tok) (counts toward context; not shown as text)
Tools: read, edit, write, apply_patch, exec, process, canvas, nodes, cron, message, tts, gateway, agents_list, update_plan, sessions_list, sessions_history, sessions_send, sessions_spawn, sessions_yield, subagents, session_status, web_search, web_fetch, browser, file_fetch, dir_list, dir_fetch, file_write, memory_search, memory_get

Wprowadziłem zmiany konfiguracyjne w pliku `openclaw.json`

```
{
  # ....
  "tools": {
    "profile": "full",
    "byProvider": {
      "ollama": {
        "profile": "minimal"
      }
    }
  },
  "models": {
    "mode": "merge",
    "providers": {
      "ollama": {
        # .....
      }
    }
  }
}
```

Po wprowadzeniu zmian w konfiguracji OpenClaw i wyłączeniu większości narzędzi dla dostawcy ollama, ponowne wywołanie polecenia `/context list` zwracało już następujący rezultat:

>Tool list (system prompt text): 0 chars (~0 tok)
Tool schemas (JSON): 89 chars (~23 tok) (counts toward context; not shown as text)
Tools: session_status

## Bonjour/mDNS bug

Po aktualizacji OpenClaw do 2026.04.24 gateway przestał działać.

W logach pojawiały się błędy związane z usługą Bonjour/mDNS:

> bonjour: watchdog detected non-announced service; attempting re-advertise (gateway fqdn=0b8228731f8f (OpenClaw)._openclaw-gw._tcp.local. host=openclaw.local. port=18789 state=probing) nodejs-1 | 2026-05-12T08:42:20.566+00:00 [plugins] bonjour: restarting advertiser (service stuck in probing for 8090ms (gateway fqdn=0b8228731f8f (OpenClaw)._openclaw-gw._tcp.local. host=openclaw.local. port=18789 state=probing)) nodejs-1 | 2026-05-12T08:42:20.577+00:00 [plugins] bonjour: advertised gateway fqdn=0b8228731f8f (OpenClaw)._openclaw-gw._tcp.local. host=openclaw.local. port=18789 state=unannounced nodejs-1 | 2026-05-12T08:42:20.579+00:00 [openclaw] Unhandled promise rejection: CIAO PROBING CANCELLED nodejs-1 | 2026-05-12T08:42:20.583+00:00 [openclaw] wrote stability bundle: /home/node/.openclaw/logs/stability/openclaw-stability-2026-05-12T08-42-20-581Z-14-unhandled_rejection.json

Problem był już zgłoszony przez użytkowników:

[Do not upgrade to 2026.4.24](https://www.reddit.com/r/openclaw/comments/1sw1s30/do_not_upgrade_to_2026424/)

[v2026.4.24 multiple instabilities — postinstall pruning, bonjour crash loop, WhatsApp startup probe](https://github.com/openclaw/openclaw/issues/72784)

Rozwiązanie to wyłączenie Bonjour/mDNS poprzez ustawienie zmiennej środowiskowej `OPENCLAW_DISABLE_BONJOUR=1`.

W pliku `docker-compose.yml` należy dodać zmienną do usługi OpenClaw:

```
services:
  nodejs:
    # ...
    environment:
        - OPENCLAW_DISABLE_BONJOUR=1
```
