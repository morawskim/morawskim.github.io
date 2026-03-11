# Ollama Kimi K2.5 (multifile GGUF)

Ollama obecnie nie obsługuje modeli, które zostały podzielone na wiele plików GGUF - [Allow importing multi-file GGUF models](https://github.com/ollama/ollama/issues/5245)

Model [Kimi-K2.5-GGUF](https://huggingface.co/unsloth/Kimi-K2.5-GGUF/tree/main/Q4_K_M) jest dostarczany nawet w 13 plikach GGUF.

Obecnie możemy scalić te pliki GGUF do jednego za pomocą narzędzia `llama-gguf-split`.

Za pomocą polecenia `wget https://github.com/ggml-org/llama.cpp/releases/download/b8198/llama-b8198-bin-ubuntu-x64.tar.gz` pobieramy archiwum ze skompilowanymi narzędziami `llama.cpp`.

Pobrane archiwum rozpakowujemy poleceniem: `tar xvzf llama-b8198-bin-ubuntu-x64.tar.gz`

Pobieramy wszystkie 13 plików modelu przy użyciu skryptu bash: `for i in {1..13}; do wget -c "$(printf "https://huggingface.co/unsloth/Kimi-K2.5-GGUF/resolve/main/Q4_K_M/Kimi-K2.5-Q4_K_M-%05d-of-00013.gguf" "$i")"; done`

Po pobraniu wszystkich plików GGUF wywołujemy polecenie scalające je w jeden plik: `./llama-b8198/llama-gguf-split --merge Kimi-K2.5-Q4_K_M-00001-of-00013.gguf Kimi-K2.5-Q4_K_M.gguf`

Następnie tworzymy plik `Modelfile` o zawartości:

```
FROM ./Kimi-K2.5-Q4_K_M.gguf
```

Tworzymy model w Ollama poleceniem: `ollama create Kimi-K2 -f Modelfile`

Jeśli mamy wystarczającą ilość pamięci, możemy uruchomić model poleceniem: `ollama run Kimi-K2`

W moim przypadku nie miałem wystarczającej ilości pamięci.

## Linki

[How to Run a One Trillion-Parameter LLM Locally: An AMD Ryzen™ AI Max+ Cluster Guide](https://www.amd.com/en/developer/resources/technical-articles/2026/how-to-run-a-one-trillion-parameter-llm-locally-an-amd.html)
