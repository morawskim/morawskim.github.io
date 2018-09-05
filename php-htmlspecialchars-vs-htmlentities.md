# php - htmlspecialchars vs htmlentities

W pewnym przestarzałym oprogramowaniu został znaleziony problem z przekazywaniem znaków dialektycznych do widoku.
Metoda odpowiadająca za kodowanie znaków specjalnych HTML wykorzystywała funkcję PHP `htmlentities`. System ten działał na ZF1. Postanowiłem sprawdzić definicję metody `escape` klasy `Zend_View`.

```
public function escape($var)
{
    if (in_array($this->_escape, array('htmlspecialchars', 'htmlentities'))) {
        return call_user_func($this->_escape, $var, ENT_COMPAT, $this->_encoding);
    }

    if (1 == func_num_args()) {
        return call_user_func($this->_escape, $var);
    }
    $args = func_get_args();
    return call_user_func_array($this->_escape, $args);
}
```

Domyślnie ZF korzysta z funkcji `htmlspecialchars`.
Według dokumentacji:
>This function is identical to htmlspecialchars() in all ways, except with htmlentities(), all characters which have HTML character entity equivalents are translated into these entities.

Przykłady:
```
php > echo htmlspecialchars("Bäull"); 
Bäull

php > echo htmlentities("Bäull"); 
B&auml;ull
```
