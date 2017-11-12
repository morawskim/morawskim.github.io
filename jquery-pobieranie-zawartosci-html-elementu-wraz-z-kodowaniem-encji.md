# jQuery - pobieranie zawartości HTML elementu wraz z kodowaniem encji

Kiedy budujemy element HTML, musimy uważać na poprawne zakodowanie encji HTML (tzn. &, <, >, ").
Możemy te zadanie rzucić na barki biblioteki jQuery.

```
var $el = $('<bibliography></bibliography>')
    .attr('figures', b.figures)
    .attr('note', b.note)
    .attr('pages', b.pages)
    .attr('plates', b.plates)
    .text(b.id + ':' + b.bibliography);
var html =  $el.wrap('<p>').parent().html();
return $('<div/>').text(html).html();
```

Przykładowy wynik:
```
<bibliography figures="000aaa&quot;aaa'aaaggf&quot;aaa111" note="000aaa&quot;aaa'aaaggf&quot;aaa111" pages="000aaa&quot;aaa'aaaggf&quot;aaa111" plates="000aaa&quot;aaa'aaaggf&quot;aaa111">:000aaa"aaa'aaaggf"aaa111</bibliography>
```
