# Golang i Prometheus

Instalujemy pakiet klienta Prometheus'a - `go get github.com/prometheus/client_golang`

W pliku go definiujemy nową metrykę:

```
var appUp = prometheus.NewGaugeVec(prometheus.GaugeOpts{
	Name: "app_up",
	Help: "Description of my metric",
}, []string{"Version"})
```

Dodajemy metrykę do rejestru `prometheus.MustRegister(appUp)`

Następnie w innym miejscu możemy ustawić wartość dla metryki:
`appUp.With(prometheus.Labels{"Version": "1.2.3"}).Set(1)`

W przypadku, kiedy chcemy publikować metryki, ale nie możemy zmodyfikować kodu możemy utworzyć własny Collector.
W takim przypadku musimy utworzyć nowy typ, który będzie implementował interfejs `prometheus.Collector`.

W metodzie `Describe` przesyłamy na kanał na kanał definicję metryki:

```
prometheus.NewDesc(
	prometheus.BuildFQName("", "", "app_up"),
	"Minimal price which has been seen",
	[]string{"product"},
	nil,
)
```

W metodzie `Collect` przekazujemy do kanału wartości metryk - `metrics <- prometheus.MustNewConstMetric(m.appUp, prometheus.GaugeValue, 1, "1.2.3")`

W przypadku wystąpienia błędu, na kanał wysyłamy specjalny obiekt: `metrics <- prometheus.NewInvalidMetric(m.appUp, errors.New("my error message"))`. W takim przypadku, gdy wejdziemy na stronę metryk otrzymamy 500 z odpowiedzią:

> error collecting metric Desc{fqName: "app_up", help: "Description of my metric", constLabels: {}, variableLabels: {Version}}: my error message

Możemy wykorzystać wbudowany handler do wyświetlania metryk:

```
http.Handle("/metrics", promhttp.Handler())
err := http.ListenAndServe(":8080", nil)
```

## systemd service

Tworzymy nowy plik jednostki usługi w katalogu `/etc/systemd/system/` np. `my_exporter.service`.
Zakładamy że nazwa użytkownika i grupa "myusername" istnieją, a katalog domowy tego użytkownika to "/home/myusername".
Jeśli plik `/etc/sysconfig/my_exporter` istnieje to będziemy mieli dostęp do ustawionych zmiennych środowiskowych z tego pliku.

```
[Unit]
Description=my exporter
After=network.target
StartLimitIntervalSec=0
[Service]
Type=simple
Restart=always
RestartSec=1
WorkingDirectory=/home/myusername
EnvironmentFile=-/etc/sysconfig/my_exporter
ExecStart=/home/myusername/my_exporter
User=myusername
Group=myusername

[Install]
WantedBy=multi-user.target
```

Po utworzeniu pliku przeładowujemy konfigurację systemd - `sudo systemctl daemon-reload`
