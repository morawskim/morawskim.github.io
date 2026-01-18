# prometheus - metric_relabel_configs

Monitorując klaster Kubernetes korzystałem z metryk udostępnianych przez kube-state-metrics, które dostarczają szczegółowych informacji o stanie obiektów klastra (Joby, CronJoby, Pody, Deploymenty itd.).

Domyślnie kube-state-metrics eksportuje bardzo dużą liczbę metryk, z których nie wszystkie były mi potrzebne.
W moim przypadku zależało mi wyłącznie na metrykach dotyczących Jobów i CronJobów, czyli takich, których nazwa zaczyna się od:

* `kube_job_*`
* `kube_cronjob_*`

Nie chciałem zapisywać pozostałych metryk w Prometheusie, aby:

* ograniczyć liczbę przechowywanych metryk
* zmniejszyć zużycie zasobów
* obniżyć koszty związane z Grafana Cloud

Do tego celu wykorzystałem mechanizm `metric_relabel_configs` w konfiguracji Prometheusa, który pozwala filtrować metryki po scrape, ale przed zapisaniem ich do bazy danych.
Dzięki temu Prometheus zapisuje wyłącznie interesujące mnie metryki, a cała reszta jest ignorowana (dropowana).

```
- job_name: kube-state-metrics
  # The HTTP resource path on which to fetch metrics from targets.
  metrics_path: /metrics
  # Configures the protocol scheme used for requests.
  scheme: http
  # List of labeled statically configured targets for this job.
  static_configs:
    - targets: [ "kube-state-metrics.kube-state-metrics:8080" ]
  metric_relabel_configs:
    - source_labels: [ __name__ ]
      regex: "kube_(cronjob|job)_.*"
      action: keep
```

[Configuration - metric_relabel_configs](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#metric_relabel_configs)
