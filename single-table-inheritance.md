# Single table inheritance

Zgodnie z definicją tego wzorca do tabeli SQL, dodajemy dodatkowe pole np. `type`, które określa którą klasę PHP utworzyć dla danego wiersza tabeli. Dzięki temu w klasach pochodnych, możemy definiować specyficzne zachowania (metody) dla wybranego typu.

## yii2

Potrzebujemy własnej klasy, która będzie rozszerzać `ActiveQuery`. Nowa klasa będzie dodawać do zapytania SQL warunek na wartość kolumny `type`.

``` php
class EntryQuery extends ActiveQuery
{
    public $type;
    public $tableName;

    public function prepare($builder)
    {
        if ($this->type !== null) {
            $this->andWhere(["$this->tableName.type" => $this->type]);
        }
        return parent::prepare($builder);
    }
}
```

W modelu `ActiveRecord` reprezentujący naszą tabelę musimy nadpisać statyczną metodę `instantiate`.

``` php
class Entry extends ActiveRecord
{
//....
    const TYPE_GALLERY = 'gallery';
    const TYPE_FILES = 'files';
    const TYPE_IMAGE = 'image';
    const TYPE_3D = 'three-dim';
// ....

public static function instantiate($row) {
        switch ($row['type']) {
            case self::TYPE_IMAGE:
                $obj = new Image();
                break;
            case self::TYPE_GALLERY:
                $obj = new Gallery();
                break;
            case self::TYPE_3D:
                $obj = new ThreeDim();
                break;
            default:
                $obj = new static();
                break;
        }

        return $obj;
    }
```

W klasach pochodnych musimy nadpisać metody `init`, `find`, `tableName`, `beforeSave`.
Metody `init` i `beforeSave` ustawiają poprawną wartość dla kolumny `type`.
Metodę `tableName` musimy  nadpisać, bo inaczej framework yii wygeneruje nazwę tabeli z nazwy klasy PHP, która oczywiście nie będzie istnieć w bazie danych.
W metodzie `find` nadpisujemy zwracany obiekt `ActiveQuery`. Dzięki temu mamy pewność, że wszystkie zapytania SQL, stworzone przez ORM automatycznie dostaną warunek na wartość kolumny `type`.


``` php
class Image extends Entry
{
//...
    public function init()
    {
        $this->type = self::TYPE_IMAGE;
        parent::init();
    }

    public static function find()
    {
        return new EntryQuery(get_called_class(), ['type' => self::TYPE_IMAGE, 'tableName' => self::tableName()]);
    }

    public static function tableName()
    {
        return '{{%entry%}}';
    }

    public function beforeSave($insert)
    {
        $this->type = self::TYPE_IMAGE;
        return parent::beforeSave($insert);
    }
// .....
}
```
