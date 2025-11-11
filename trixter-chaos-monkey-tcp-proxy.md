# Trixter – Chaos Monkey TCP Proxy

Trixter to lekki, wysokowydajny TCP chaos proxy napisany w Rust.
Powstał jako alternatywa dla Toxiproxy.
Umożliwia też deterministyczne powtarzanie scenariuszy (seed).

Przykład uruchomienia z obrazu kontenera:

```
docker run --network host -it --rm ghcr.io/brk0v/trixter \
--listen 0.0.0.0:8080 \
--upstream 127.0.0.1:8096 \
--api 127.0.0.1:8888

```

Po uruchomieniu zmieniamy konfigurację klienta tak, aby łączył się z `localhost:8080` — proxy będzie forwardować ruch do `127.0.0.1:8096`.


## Skazy (efekty chaosu) — przydatne argumenty

* `--delay-ms 1000` - dodaje opóźnienie (latency) w przesyłaniu danych. 1000 → 1000 milisekund (1 s) opóźnienia

* `--terminate-probability-rate <0..1>` - losowe przerywanie (zamykanie) połączeń TCP z określonym prawdopodobieństwem.

* `--connection-duration-ms 5000` - po podanej liczbie milisekund Trixter wymusi zamknięcie połączenia (TCP RST)

* `--throttle-rate-bytes 1048576` - limit przepustowości w bajtach na sekundę (bytes/s). 1048576 = 1 048 576 B/s ≈ 1 MB/s (ok. 8 Mb/s)
