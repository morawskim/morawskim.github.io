# JavaScript - toJSON

W języku PHP mamy interfejs [\JsonSerializable](https://www.php.net/manual/en/class.jsonserializable.php)
Obiekty implementujące ten interfejs mogą modyfikować swoją JSON reprezentację, kiedy są kodowane przez funkcję `json_encode`. Interfejs ten wymusza implementację metody `jsonSerialize`.

``` php
<?php
class Foo implements JsonSerializable {
    private $fullName;
    private $birthday;

    public function __construct($fullName, DateTimeImmutable $birthday)
    {
        $this->fullName = $fullName;
        $this->birthday = $birthday;
    }

    public function jsonSerialize()
    {
        return ['fullName' => $this->fullName, 'birthday' => $this->birthday->format('Y-m-d')];
    }
}

$foo = new Foo('Jan Kowalski', DateTimeImmutable::createFromFormat('Y-m-d', '1984-05-14'));
echo json_encode($foo, JSON_PRETTY_PRINT);
```
Wynik:
``` javascript
{
    "fullName": "Jan Kowalski",
    "birthday": "1984-05-14"
}
```

Podobne rozwiązanie istnieje w języku JavaScript.
Obiekt musi implementować metodę `toJSON`.
W takim przypadku zmienia się zachowanie wywołania `JSON.stringify` i zamiast serializować przekazany obiekt, wartość zwracana przez metodę `toJSON` podlega serializacji.

``` javascript
const obj = {
    fullName: "Jan Kowalski",
    birthDate: new Date(1344376800000),
    toJSON(key) {
        return {
            "fullName": this.fullName,
            "birthDate": `${this.birthDate.getFullYear()}-${this.birthDate.getMonth()}-${this.birthDate.getDate()}`
        };
    }
};
console.log(JSON.stringify(obj));

class Foo {
    constructor(fullName, birthDate) {
        this.fullName = fullName;
        this.birthDate = birthDate;
    }

    toJSON(key) {
        return {
            "fullName": this.fullName,
            "birthDate": `${this.birthDate.getFullYear()}-${this.birthDate.getMonth()}-${this.birthDate.getDate()}`
        };
    }
}

const foo = new Foo("Adrian Kowalski", new Date(1344376800000));
console.log(JSON.stringify(foo));
```

``` javascript
{"fullName":"Jan Kowalski","birthDate":"2012-7-8"}
{"fullName":"Adrian Kowalski","birthDate":"2012-7-8"}
```

https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/JSON/stringify#toJSON_behavior
