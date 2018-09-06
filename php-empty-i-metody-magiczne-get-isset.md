# php - empty() i metody magiczne __get/__isset

```
class CarData
{
    protected $properties = [];

    public function __set($key, $value)
    {
        $this->properties[$key] = $value;
    }

    public function __get($key)
    {
        if (isset($this->properties[$key])) {
            return $this->properties[$key];
        } else {
            return null;
        }
    }
}

$registry = new CarData();
$registry->property1 = 'value';
var_dump(empty($registry->property1)); //true
```
W powyższym kodzie dostajemy wartość `true` choć oczekujemy raczej `false`. Wynika to z faktu, że `empty` uzywa metody magicznej `__isset`. Musimy w naszej klasie zaimplementować metodę magiczną `__isset`. Na przykład w taki sposób:

```
public function __isset($key)
{
    if (isset($this->properties[$key])) {
        return (false === empty($this->properties[$key]));
    } else {
        return null;
    }
}
```