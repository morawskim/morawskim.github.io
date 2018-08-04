# Jak znaleźć funkcję, która zmieniła atrybut value elementu input

```
var node = document.getElementById("ID");
Object.defineProperty(node, 'value', {
    set: function(val) { console.trace('Something try to set value'); }
});
```

Demo:
http://jsfiddle.net/xpvt214o/548721/
