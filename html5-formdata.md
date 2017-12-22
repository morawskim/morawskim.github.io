# HTML5 FormData

Za pomocą obiektu FormData można przesłać dane z formularza do serwera za pomocą `XMLHttpRequest`.
Umożliwia to przesłanie wielu plików wraz z danymi.

```
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width">
        <title>FormData Example</title>
    </head>
    <body>
        <form id="form">
            <input type="text" value="" name="field1" id="field1"/>
            <input type="file"  name="file" id="file"/>
            <input type="submit" value="Send" />
        </form>

        <script src="https://code.jquery.com/jquery-2.2.4.min.js"></script>
        <script type="text/javascript" charset="utf-8">
            $(document).ready(function(){
                $('#form').submit(function(e) {
                    e.preventDefault();
                    var fd = new FormData(document.getElementById('form'));
                    $.ajax({
                        url: 'http://httpbin.org/post',
                        data: fd,
                        processData: false,
                        contentType: false,
                        type: 'POST',
                        success: function(data){
                            alert(JSON.stringify(data));
                        }
                    });
                    alert("sending");
                    return false;
                });
            });
        </script>
    </body>
</html>
```