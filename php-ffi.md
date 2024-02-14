# PHP i FFI

[Rozszerzenie FFI](https://www.php.net/manual/en/book.ffi.php) pozwala nam wywołać funkcje współdzielonej biblioteki C.
W moim przypadku wykorzystałem bibliotekę libnotify do wyświetlania powiadomień na pulpicie.

Domyślnie FFI działa tylko w konsoli (wynika to z bezpieczeństwa). 
PHP musi być zbudowany z obsługą FFI. W większości dystrybucji te wymaganie jest spełnione i wystarczy tylko zainstalować pakiet np. `php8-ffi`.

Musimy utworzyć plik nagłówkowy, który definiuje typy i funkcje biblioteki C, z których będziemy korzystać w skrypcie PHP.
W przypadku biblioteki libnotify, która wykorzystuje glib musimy zdefiniować także typy, które są pośrednio wykorzystywane przez libnotify.
Jest to żmudna praca, ale wywołując skrypt PHP będziemy otrzymywać błędy mówiące o tym, które typy nie zostały jeszcze zdefiniowane.
Możemy także posiłkować się plikami nagłówkowymi dostarczanymi z tymi bibliotekami (wymaga to dostępu do kodu źródłowego, albo instalacji deweloperskich pakietów tych bibliotek np. libnotify-devel).

Przykład skryptu PHP, który wyświetla powiadomienie poprzez bibliotekę libnotify jest dostępny [online](https://github.com/morawskim/php-examples/tree/04a94f441719f0ce812c841bf3d795a642f1e28e/ffi).

![php-ffi-notification.png](./images/php-ffi-notification.png)

```
<?php
$ffi = FFI::load(__DIR__ . '/ffi-libnotify.h');

if (!$ffi->notify_init("ffitest")) {
    throw new RuntimeException('Unable to initialize libnotify');
}

if (!$ffi->notify_is_initted()) {
    throw new RuntimeException('Libnotify has not been initialized');
}

$appName = $ffi->notify_get_app_name();

$notification = $ffi->notify_notification_new("summary", "long body", "terminal");
$ffi->notify_notification_show($notification, null);
$ffi->notify_uninit();

```