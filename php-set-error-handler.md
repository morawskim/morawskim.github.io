# PHP set_error_handler

W projekcie korzystaliśmy z oficjalnego SDK dla platformy Shoper.
W przypadku jednego sklepu otrzymywaliśmy w logach błędy "HTTP request failed".
Biblioteka do wykonywania połączeń HTTP wykorzystywała funkcję PHP `file_get_contents` z [tłumieniem błędów](https://github.com/dreamcommerce/shop-appstore-lib/blob/79e94235d4144149fbd912015a5350e3cba0c628/src/DreamCommerce/ShopAppstoreLib/Http.php#L383).
Aby zalogować dokładniejszy błąd napisałem własny error handler.
Handler otrzyma także tłumione błędy. Jeśli chcemy je zignorować musimy skorzystać z warunku `!(error_reporting() & $errno)`
Poziom `E_USER_WARNING` dodałem z powodu testów jednostkowych - funkcja trigger_error umożliwia zgłaszanie błędów tylko z rodziny `E_USER_*`


```
$original = set_error_handler(static function ($errno, $errstr, $errfile, $errline) {
    throw new ErrorException(
        $errstr,
        0,
        $errno,
        $errfile.
        $errline
    );
}, E_WARNING | E_USER_WARNING);

try {
    return $this->doRequest($processedUrl, $ctx, $responseHeaders, $methodName);
} finally {
    set_error_handler($original);
}
```

Fragment testu jednostkowego, który sprawdza czy handler został przywrócony do oryginalnej implementacji prezentuje się następująco.

```
set_error_handler($originalErrorHandler = set_error_handler('var_dump'));
$responseHeaders = [];

$sut->exposeSendRequest(
    'https://example.com',
    stream_context_create([]),
    $responseHeaders,
    'GET'
);
set_error_handler($currentErrorHandler = set_error_handler('var_dump'));
$this->assertSame($originalErrorHandler, $currentErrorHandler);
```

W PHP obecnie nie ma funkcji [get_error_handler](https://bugs.php.net/bug.php?id=54033).
Rozwiązanie oparłem o [How can I retrieve the current error handler?](https://stackoverflow.com/questions/12378644/how-can-i-retrieve-the-current-error-handler).
