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

## PHP SDK – nadpisanie klienta HTTP

W ramach zadania integrowałem się z dyskiem Google Drive.

SDK Google korzysta z klienta HTTP – GuzzleHttp.
Możemy przekazać własną instancję klienta, jeśli nie chcemy korzystać z domyślnej konfiguracji.
Domyślne ustawienia możemy wyciągnąć, przeglądając metodę `\Google\Client::createDefaultHttpClient`.

W moim przypadku chciałem dodać middleware, który będzie zbierał metryki (m.in. liczbę requestów wysyłanych po metadane przechowywanych plików).

```
$jsonKeyPath = '/sciekza/do/klucza.json';
$client = new \Google\Client();
$client->setAuthConfig(
    json_decode(file_get_contents($jsonKeyPath), true, flags: JSON_THROW_ON_ERROR),
);
$client->addScope(Google\Service\Drive::DRIVE_READONLY);

$stack = \GuzzleHttp\HandlerStack::create();
//$stack->push(); //dodajemy wlasny middleware

$guzzle = new \GuzzleHttp\Client([
    'handler' => $stack,
    'base_uri' => \Google\Client::API_BASE_PATH,
    'http_errors' => false,
]);
$client->setHttpClient($guzzle);

return new \Google\Service\Drive($client);
```

## Powiadomienia o zmianach w katalogach Google Drive

W ramach zadania musiałem pobierać pliki przesyłane przez użytkowników do kilku katalogów w Google Drive.
Do obsługi tych katalogów wykorzystałem dedykowane konto usługi (service account).

Zamiast cyklicznie odpytywać API o nowe lub zmienione pliki, zdecydowałem się wykorzystać mechanizm powiadomień o zmianach i kanał powiadomień (watch).

Po wykryciu zmiany Google wysyła powiadomienie HTTP do naszego endpointu API.
Samo powiadomienie nie zawiera jednak informacji o przesłanym pliku.

Początkowo chciałem utworzyć osobny kanał powiadomień dla każdego monitorowanego katalogu.
Obecnie Google Drive API nie umożliwia jednak subskrybowania zmian dla pojedynczego katalogu - [Changes subscriptions: Allow subscribing to notifications for a single folder](https://issuetracker.google.com/issues/183139209?pli=1)

W związku z tym subskrypcję zmian założyłem na poziomie całego dysku / zasobu dostępnego dla danego konta.
Katalogi są obsługiwane przez oddzielne konto usługi, więc nie otrzymujemy powiadomień z innych katalogów.


Przed utworzeniem kanału powiadomień pobieramy aktualny pageToken, który określa punkt, od którego chcemy śledzić zmiany.

`changes->watch` tworzy kanał powiadomień, za pomocą którego Google informuje nasz endpoint HTTP o dostępności nowych zmian.

```
// pobierany aktualny token z aktualna pozycja zmian
$response = $this->drive->changes->getStartPageToken([
    'supportsAllDrives' => true,
]);
$pageToken =  $response->getStartPageToken();

// zakladamy powiadomienie
$res = $this->drive->changes->watch(
    $pageToken,
    ///...
);
```

Kolejnym problemem było rozróżnienie, którego z monitorowanych katalogów dotyczy dana zmiana.
Ponieważ jedna integracja obsługuje kilka katalogów, samo otrzymanie powiadomienia nie pozwalało nam jednoznacznie określić, do którego katalogu przesłano plik.

Rozwiązałem ten problem poprzez pobranie informacji o rodzicu pliku, a następnie rekurencyjne przejście po strukturze katalogów aż do katalogu nadrzędnego, który jest bezpośrednio monitorowany przez naszą integrację.

Na podstawie identyfikatora pliku, a następnie całej ścieżki katalogów, jesteśmy w stanie określić, do którego z monitorowanych katalogów należy dany plik.
Informacja ta jest następnie wykorzystywana w dalszej logice aplikacji.

```
//...
    private function getFileWithParents(string $fileId): Drive\DriveFile
    {
        $optParams = [
            'fields' => 'id, name, parents',
            'supportsAllDrives' => true,
        ];

        return $this->drive->files->get($fileId, $optParams);
    }
```
