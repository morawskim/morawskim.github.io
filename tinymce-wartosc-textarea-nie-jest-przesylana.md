# TinyMCE: wartość textarea nie jest przesyłana

Aby synchronizować bufor TinyMCE z textarea musimy przypisać funkcję do `setup`.

``` javascript
tinymce.init({
    selector: "textarea",
    setup: function (editor) {
        editor.on('change', function () {
            editor.save();
        });
    }
});
```

Możemy także ręcznie pobrać zawartośc edytora i przypisać ją do zmiennej `content`.
``` javascript
var content = tinyMCE.get('bibliography-title').getContent();
```
