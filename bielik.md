# Bielik

Bielik to otwarty, bezpłatny i bezpieczny model językowy stworzony w Polsce.
Rozwijany jest przede wszystkim w oparciu o polskojęzyczne zbiory danych.

Modele można pobrać z serwisu [Hugging Face](https://huggingface.co/speakleash/collections)

Ja wybrałem model [speakleash/Bielik-11B-v3.0-Instruct-GGUF](https://huggingface.co/speakleash/Bielik-11B-v3.0-Instruct-GGUF), ponieważ działa z Ollama.

Bielik jest modelem typu [Gated model](https://huggingface.co/docs/hub/models-gated).
Mimo że jest otwarty, aby uzyskać dostęp do plików modelu, należy wyrazić zgodę na udostępnienie autorom swoich danych kontaktowych (nazwy użytkownika i adresu e-mail).

Plik modelu pobieramy poleceniem: `wget --header="Authorization: Bearer <HF_TOKEN>" 'https://huggingface.co/speakleash/Bielik-11B-v3.0-Instruct-GGUF/resolve/main/Bielik-11B-v3.0-Instruct.Q6_K.gguf'`.

W miejsce `<HF_TOKEN>` należy wstawić [swój token dostępu do Hugging Face](https://huggingface.co/settings/tokens).

Po pobraniu pliku, w tym samym katalogu tworzymy plik `Modelfile` o następującej zawartości:

```
FROM ./Bielik-11B-v3.0-Instruct.Q6_K.gguf

TEMPLATE """{{- /* SYSTEM + TOOLS INJECTION */ -}}
{{- if or .System .Tools -}}
<|im_start|>system
{{- if .System }}
{{ .System }}
{{- end }}

{{- if .Tools }}
You are provided with tool signatures that you can use to assist with the user's query.
You do not have to use a tool if you can respond adequately without it.
Do not make assumptions about tool arguments. If required parameters are missing, ask a clarification question.

If you decide to invoke a tool, you MUST respond with ONLY valid JSON in the following format:
{"name":"<tool-name>","arguments":{...}}

Below is a list of tools you can invoke (JSON):
{{ .Tools }}
{{- end }}
<|im_end|>
{{- end }}

{{- /* MESSAGES */ -}}
{{- range $i, $_ := .Messages }}
<|im_start|>{{ .Role }}
{{ .Content }}<|im_end|>
{{- end }}

{{- /* GENERATION PROMPT */ -}}
<|im_start|>assistant"""

PARAMETER stop "<|start_header_id|>"
PARAMETER stop "<|end_header_id|>"
PARAMETER stop "<|eot_id|>"

# Generation
# Creativity level (0.2 (code) – 1.0 (creative))
PARAMETER temperature 0.1

```

Będąc nadal w katalogu, w którym znajdują się plik modelu Bielik oraz Modelfile, wywołujemy polecenie: `ollama create bielik`.

Utworzony model możemy przetestować poleceniem: `ollama run bielik`
