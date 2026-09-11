# Gdrive

## Konfiguracja Google Cloud

Aby korzystać z Google Drive API w projekcie Google Cloud, należy najpierw włączyć odpowiednie API.

Logujemy się do [Google Cloud Console](https://console.cloud.google.com).
Następnie wybieramy odpowiedni projekt i z menu po lewej stronie przechodzimy do:
"APIs & Services" -> "Enabled APIs & services".

![enable api menu](/images/gcloud/gdrive/enable-api-menu.png)

Po załadowaniu strony klikamy "Enable APIs and services"

![enable api](/images/gcloud/gdrive/enable-api.png)


W wyszukiwarce wpisujemy "drive".
W wynikach wyszukiwania wybieramy "Google Drive API".
Zostaniemy przekierowani na stronę konfiguracji API, gdzie klikamy przycisk "Enable".

### Service account

Następnie tworzymy Service Account, który będzie wykorzystywany przez aplikację do komunikacji z Google Drive.
W konsoli Google Cloud przechodzimy do sekcji "IAM & Admin" -> "Service Accounts".

![service account menu](/images/gcloud/gdrive/service-account-menu.png)

I klikamy "Create service account".

![service account add](/images/gcloud/gdrive/service-account-create-button.png)

W przypadku integracji z Google Drive nie nadajemy Service Account żadnych dodatkowych uprawnień.
Dostęp do plików i katalogów będzie nadawany bezpośrednio w Google Drive poprzez udostępnienie odpowiedniego zasobu adresowi e-mail Service Account.
Po utworzeniu konta otrzyma ono adres e-mail, który wykorzystamy później do udostępnienia katalogu na Google Drive.
Adres będzie miał format: `<nazwaKontaUslug>>@<projektGCloud>.iam.gserviceaccount.com`

### Utworzenie klucza Service Account

Przechodzimy ponownie do listy Service Accounts.

![service account menu](/images/gcloud/gdrive/service-account-menu.png)

W tabeli powinno znajdować się nowo utworzone konto.
Klikamy trzy kropki znajdujące się przy koncie, a następnie wybieramy Manage keys.

![service accounts list](/images/gcloud/gdrive/service-accounts-list.png)

Zostaniemy przekierowani na stronę zarządzania kluczami, z aktywną zakładką Keys.
Klikamy przycisk "Add key".

![add key to sa](/images/gcloud/gdrive/add-key-to-sa.png)

Następnie wybieramy opcję utworzenia nowego klucza w formacie JSON i pobieramy wygenerowany plik.

Pobrany plik JSON będzie zawierał dane uwierzytelniające Service Account.
Konfigurujemy SDK, aby korzystało z tego pliku podczas wysyłania żądań do Google Drive API.
