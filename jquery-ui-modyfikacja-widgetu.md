# JQuery UI - modyfikacja widgetu

W jednym z projektu musieliśmy zmienić działanie widgetu autocomplete biblioteki jQueryUI.
Utworzyłem nowy widget `autocompleteLimit`, który rozszerza działanie `autocomplete`.
Dodałem do konfiguracji jeden parametr `maxLength`, a także nadpisałem metodę `search`.

Metoda ta sprawdza, czy wpisana fraza jest krótsza niż `maxLength`. Jeśli tak to wywoływana jest metoda nadrzędną.
W przeciwnym przypadku nie zostaną zaproponowane żadne dane.

```
// Rozszerzamy widget jqueryui autocomplete.
$.widget("ui.autocompleteLimit", $.ui.autocomplete, {
    options: {
        maxLength: 50
    },

    search: function( value, event ) {
        value = value != null ? value : this._value();

        if ( this.options.maxLength && value.length > this.options.maxLength ) {
            return this.close( event );
        }

        return this._superApply(arguments);
    }
});
```

Więcej informacji https://learn.jquery.com/jquery-ui/widget-factory/extending-widgets/
