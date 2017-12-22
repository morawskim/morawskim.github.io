# PHP profiler bazujący na ticks

Gdy kod działa wolno na produkcji musimy go sprofilować. PHP w wersji 5.4 albo wyżej posiada wbudowany serwer HTTP.
Mając dostęp po ssh do produkcji możemy ściągnąć rozszerzenie xdebug i załadować je dla wbudowanego serwera HTTP PHP. Taki scenariusz tworzyłem - https://github.com/morawskim/vagrant-projects/tree/master/lab/xdebug-remote_debug

W przypadku kiedy nie możemy pobrać xdebug, albo nie mamy dostępu po ssh musimy zmienić koncepcję. Rzadko znaną funkcjonalnością PHP jest konstrukcja `declare` i funkcja `register_tick_function`. Wykorzystując je możemy zbudować prosty profiler kodu. Użytkownik Ocramius opublikował w portalu github.com przykład takiego profilera - https://gist.github.com/Ocramius/5714280. Oryginalny skrypt zapisywał dane do syslog’a. Ja postanowiłem logować do pliku.

``` php
<?php
if (!is_writable(TRICK_PROFILE_FILE_PATH)) {
throw new InvalidArgumentException(sprintf('File "%s" must be writable', TRICK_PROFILE_FILE_PATH));
}
$fp = fopen(TRICK_PROFILE_FILE_PATH, 'w');
register_tick_function(function () use ($fp)
{
/**
* Used for the timer.
* @var float
*/
static $last = null;
/**
* Used to store profiles.
* @var array
*/
static $profile = array();
if (is_null($last)) {
// start time isn't at invoke but when
// the server received request
$last = $_SERVER['REQUEST_TIME_FLOAT'];
// used to divide instances
// process id is used to prevent instances mix due to requests flood
fwrite($fp, '[' . getmypid() . '][' . date('Y-m-d H:i:s', $last)
. substr((string) microtime(), 1, 6) . '] === profiler ===' . PHP_EOL
);
}
/**
* This variable contains main informations about last calls.
* @var array
*/
$backtrace = debug_backtrace();
// if there are only 2 elements we aren't in a user defined code
if (count($backtrace) <= 1) {
return;
}
/**
* This variable contains current function definition attributes like name,
* class, type, file, line and args.
* @var string
*/
$function = $backtrace[1];
$function = isset($function['class'])
? $function['class'] . $function['type'] . $function['function']
: $function['function'];
if (isset($backtrace[2])) {
/**
* This variable contains informations about parent (user defined)
* code that invoked current statement.
* @var string
*/
$parent = $backtrace[2];
$parent = isset($parent['class'])
? $parent['class'] . $parent['type'] . $parent['function']
: $parent['function'];
}
/**
* This variable contains microtimes.
* Used to render time differences.
* @var array
*/
$profile[$function] = isset($profile[$function])
? microtime(true) - $last + $profile[$function]
: microtime(true) - $last;
// output times in the right place
// syntax: [{process id}][{datetime}] {position in stack (hypens)} {function} : {memory} : {seconds}
fwrite($fp, '[' . getmypid() . '][' . date('Y-m-d H:i:s')
. substr((string) microtime(), 1, 6) . '] '
. (count($backtrace) - 2 ? str_repeat('-', count($backtrace) - 2) . ' ' : null) . $function
. ' : ' . memory_get_usage()
. ' : ' . $profile[$function] . PHP_EOL
);
/**
* Used to profile next request.
* @var float
*/
$last = microtime(true);
});

```

``` php
define('TRICK_PROFILE_FILE_PATH', 'profiler.log');
require_once 'profiler.php';
declare(ticks=1);
```

Dla przykładu zmodyfikowałem jedną funkcję drupala, dodając w niej `sleep`. Utworzyłem też ręcznie plik `profiler.log` i nadałem odpowiednie uprawnienia. Plik `profiler.log` zawierał 28606 linii. Wykorzystałem `awk` do wyświetlenia linii, które trwały dłużej niż 3 sekundy.
```
awk '$(NF) >= 3 {print ;}' profile.txt 
```

Otrzymałem nazwę funkcji, którą zmodyfikowałem poprzez dodanie do niej `sleep(6)`
```
[13711][2017-12-22 09:41:17.47426] === profiler ===
[13711][2017-12-22 09:41:24.24507] ------------ taxonomy_help : 16989624 : 6.0001709461212
[13711][2017-12-22 09:41:24.24519] ------------ taxonomy_help : 16989624 : 6.0002207756042
```
