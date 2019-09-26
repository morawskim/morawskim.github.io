# yii2 - walidator po stronie klienta (JavaScript)

Obecnie ciągle rozbudowywana jest logika po stronie klienta. Za pomocą JavaScript implementowana jest walidacja.
Framework `yii2` posiada API na implementacje walidatorów zarówno po stronie serwera jak i klienta.

Zaczynamy standardowo, od utworzenia nowej klasy PHP np. `\app\validators\DateValidator`. W tym przypadku (walidacja daty) klasa ta dziedziczy po `\yii\validators\DateValidator`, zamiast `\yii\validators\Validator`.

Włączamy funkcjonalność weryfikacji po stronie klienta ustawiając publiczny atrybut klasy na wartość true  - `public $enableClientValidation = true;`.

Musimy zaimplementować metodę `clientValidateAttribute`, a także `getClientOptions`. Metoda `clientValidateAttribute`  zwraca kod js, który posłuży do walidacji daty.
Jeśli zwrócimy w tej metodzie wartość `null`, walidator po stronie klienta zostanie wyłączony (nawet jeśli tą funkcję jawnie włączyliśmy).

Metoda walidacji po stronie serwera `validateAttribute`/`validateValue` jest już zaimplementowana w klasie `\yii\validators\DateValidator`. Dlatego w tym przypadku nie musimy jej implementować.

Metoda `clientValidateAttribute` deleguje sprawdzenie daty do funkcji js `dateValidator`. Funkcja ta przyjmuje 3 parametry - `value, messages, options`. Odpowiednio wartość podlegająca walidacji, tablica komunikatów walidacji i dodatkowe opcje walidatora, które są zwracane przez metodę `getClientOptions`.

``` php
public function clientValidateAttribute($model, $attribute, $view)
{
    $options = $this->getClientOptions($model, $attribute);
    return 'dateValidator(value, messages, ' . json_encode($options, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE) . ');';
}
```

```php
public function getClientOptions($model, $attribute)
{
    $options = [];
    $options['message'] = $this->formatMessage($this->message, [
        'attribute' => $model->getAttributeLabel($attribute),
    ]);

    return $options;
}
```

Musimy jeszcze zaimplementować kod walidatora po stronie klienta:
``` javascript
function isValidDate(dateString) {
    //simple date validator - https://stackoverflow.com/a/35413963
    var regEx = /^\d{4}-\d{2}-\d{2}$/;
    if(!dateString.match(regEx)) return false;  // Invalid format
    var d = new Date(dateString);
    if(Number.isNaN(d.getTime())) return false; // Invalid date
    return d.toISOString().slice(0,10) === dateString;
}

function dateValidator(value, messages, options) {
    if (!isValidDate(value)) {
        messages.push(options['message']);
    }
}
```

Finalnie wystarczy, że podłączymy nasz nowy walidator do atrybutu modelu `['date', DateValidator::class, 'format' => 'php:Y-m-d'],` i wszystko będzie gotowe.

https://github.com/morawskim/php-examples/commit/3a8a80eadcbc8d5a87f8e1efa68f696903a513e9


## Asynchroniczny walidator po stronie klienta

W celu zbudowania asynchronicznego walidatora działającego po stronie klienta musimy utworzyć klasę PHP np. `\app\validators\AjaxFakeValidator`, która będzie dziedziczyć po `\yii\validators\Validator`.

Podobnie jak dla wariantu synchronicznego musimy implementujemy metody `clientValidateAttribute` i `getClientOptions`.

``` php
public function clientValidateAttribute($model, $attribute, $view)
{
    $options = $this->getClientOptions($model, $attribute);
    return 'fakeAsyncValidator(value, messages, ' . json_encode($options, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE) . ', deferred);';
}

public function getClientOptions($model, $attribute)
{
    $options = [];
    $options['message'] = $this->formatMessage($this->message, [
        'attribute' => $model->getAttributeLabel($attribute),
    ]);

    return $options;
}
```

Jedyną różnicą jest przekazanie do funkcji walidacyjnej js ` zmiennej `deferred`.
Przechowuje ona listę odroczonych obiektów (obecnie byłby to `Promise`) do asynchronicznego sprawdzania poprawności.

``` javascript
function fakeAsyncValidator(value, messages, options, deferredList) {
    var deferred = $.Deferred();
    setTimeout(function () {
        if (value !== "pass") {
            messages.push(options['message']);
        }
        deferred.resolve();
    }, 1000);
    deferredList.push(deferred);
}
```

W rzeczywistym przykładzie powinniśmy zaimplementować także metodę `validateValue`.

``` php
protected function validateValue($value)
{
    return null;
}
```

https://github.com/morawskim/php-examples/commit/8549a9b7326a2d37caa54681039e5e50ad6c8316

