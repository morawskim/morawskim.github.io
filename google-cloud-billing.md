# Google Cloud Billing

W ramach projektu chcieliśmy monitorować koszty w Google Cloud.
Dane te są dostępne w Google Cloud Billing, jednak obecnie wygląda na to, że [Google nie oferuje żadnego API umożliwiającego pobranie tych danych bezpośrednio.](https://stackoverflow.com/questions/52470160/api-for-getting-daily-billing-cost-in-gcp#comment91916396_52481857)

Jedynym rozwiązaniem jest [wyeksportowanie danych billingowych do BigQuery i pobieranie ich za pomocą BigQuery API.](https://discuss.google.dev/t/are-there-any-apis-to-get-billing-costs/243842?utm_source=chatgpt.com)

Aby włączyć eksport:

1. Logujemy się do konsoli Google Cloud.
1. Wybieramy projekt, a z menu po lewej stronie przechodzimy do Billing.
1. Będąc na stronie Billing, ponownie z menu po lewej wybieramy Billing Export:
![Billing Export](images/gcloud/billing-export.png)
1. Włączamy eksport danych do BigQuery.

[Exporting Your Google Cloud Billing Data to BigQuery](https://medium.com/google-cloud/exporting-your-google-cloud-billing-data-to-bigquery-296cae9a07f2)
