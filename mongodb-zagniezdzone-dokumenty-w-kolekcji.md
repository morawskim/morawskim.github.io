# MongoDB zagnieżdżone dokumenty w kolekcji

W ramach zadania wideo rejestracji musiałem zapisać konfigurację nagrywarek DVR, podłączonych do niej kamer i powiązanie kamery do stacji pakującej.
Dodatkowo proces nagrywania pakowania był uzależniony od konfiguracji flagi operatora, która włączała funkcję wideo rejestracji procesu pakowania.

Wymaganiem niefunkcjonalnym było pobieranie maksymalnie jednym zapytaniem wszystkich niezbędnych danych do rozpoczęcia procesu nagrywania podczas procesu pakowania.
W projekcie wykorzystywana była baza MongoDB, więc zdecydowałem się na rozwiązanie oparte o zagnieżdżone dokumenty.


Struktura przykładowego dokumentu przedstawia się następująco:

```
{
  "dvr": [
    {
      "id": "225268e6-a77d-3ce8-bdfc-4061dcc18213",
      "name": "Et enim vero maiores.",
      "model": "HIKVISION",
      "ip": "eedb:dbf1:72c4:aa7f:6774:cf96:f873:4661",
      "port": 47699,
      "login": "kennedy.gary",
      "password": "Q)RFs!4J&og7lf$p",
      "camera": [
        {
          "id": "5ee043d4-885e-3049-96b3-961d162a7fea",
          "name": "Recusandae accusantium molestiae magni non rerum quasi quas.",
          "channel": "41",
          "dvr": "225268e6-a77d-3ce8-bdfc-4061dcc18213"
        }
      ]
    }
  ]
}
```

Taki dokument był przechowywany na poziomie kolekcji operatora, który także zawierał konfigurację procesu wideo rejestracji.
Przygotowałem fixture, który generował dane dla 50 operatorów. Dla każdego z nich wygenerowałem 10 DVR i podłączyłem 32 kamery do każdego DVR. 
W sumie dało to nam 16 000 kamer. Import się powiódł - nie przekroczyliśmy żadnych limitów bazy.

Zagnieżdżona struktura danych wymagała wykorzystania specyficznych operatorów do aktualizacji danych przechowywanych w tablicy - [Array Update Operators](https://www.mongodb.com/docs/manual/reference/operator/update-array/).

Do dodawania kamery do DVR wykorzystałam operator `$push`. Zmienna `$id` przechowuje wygenerowany UUID w wersji 4, a `$cameraFormRequest` to dane dodawanej kamery.

```
$this->collection->updateOne(
    ['video_recording.dvr.id' => $cameraFormRequest->getDvr()->id],
    [
        '$push'        => [
            'video_recording.dvr.$.camera' => [
                'id' => $id,
                'name' => $cameraFormRequest->name,
                'channel' => $cameraFormRequest->channel,
                'dvr' => $cameraFormRequest->getDvr()->id,
            ],
        ],
    ]
);
```

Akcja usuwania/odłączania kamery od DVR wymagał zastosowania operatora `$pull` i opcji [arrayFilters](https://www.mongodb.com/docs/manual/reference/operator/update/positional-filtered/), aby wybrać odpowiedni DVR.

```
$this->collection->updateOne(
    ['video_recording.dvr.camera.id' => $cameraDetails->id],
    [
        '$pull' => [
            'video_recording.dvr.$[d].camera' => ['id' => $cameraDetails->id],
        ],
    ],
    ['arrayFilters' => [
        ['d.id' => $cameraDetails->dvrId]
    ]]
);
```

Edycja danych kamery używała także parametru `arrayFilters`, ale także musiałem aktualizować odpowiedni element tablicy kamery.

```
$this->collection->updateOne(
    ['video_recording.dvr.camera.id' => $id],
    [
        '$set' => [
            'video_recording.dvr.$[d].camera.$.name' => $cameraFormRequest->name,
            'video_recording.dvr.$[d].camera.$.channel' => $cameraFormRequest->channel,
        ],
    ],
    ['arrayFilters' => [
        ['d.id' => $cameraFormRequest->getDvr()->id]
    ]]
);
```
        
Do pobrania szczegółów kamery wykorzystałem pipeline i etapy `$unwind` i `$replaceRoot`.
Dzięki przechowywaniu danych jako osadzone obiekty mogłem przy pobieraniu danych kamery wyciągnąć dane o DVR i operatorze, bez zbędnych dodatkowych zapytań do bazy (wykorzystywane na liście kamer).
Pipeline do pobrania listy kamer był bardzo zbliżony.

```
$cursor = $this->collection->aggregate([
    ['$match' => ['video_recording.dvr.camera.id' => $id]],
    ['$unwind' => '$video_recording.dvr'],
    ['$unwind' => '$video_recording.dvr.camera'],
    ['$match' => ['video_recording.dvr.camera.id' => $id]],
    ['$replaceRoot' => ['newRoot' => ['$mergeObjects' => [
        ['operator_id' => '$_id', 'operator_name' => '$company'],
        ['dvr_id' => '$video_recording.dvr.id', 'dvr_name' => '$video_recording.dvr.name'],
        '$video_recording.dvr.camera'
    ]]]],
    ['$limit' => 1],
], ['typeMap' => ['root' => 'array', 'document' => 'array', 'array' => 'array']]);
        
```
