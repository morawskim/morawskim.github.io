# Symfony/JsonStreamer

Obecnie komponent JsonStreamer jest w fazie rozwojowej. Stabilna wersja powinna pojawiś się wraz z premierą Symfony 7.3.

Instalacja `composer require symfony/json-streamer:7.3.x-dev`

Komponent **JsonStreamer** to nowy komponent, który umożliwia strumieniowe dekodowanie i kodowanie danych JSON.
Przydatny szczególnie w przypadku dużych plików lub długotrwałych operacji, gdzie ważna jest oszczędność pamięci.
Komponent ten jest następcą komponentu o nazwie **JsonEncoder** (zmiana nazwy została zatwierdzona w [tym pull requeście](https://github.com/symfony/symfony/pull/59863)).

JsonStreamer jest aktualnie w fazie rozwojowej, a jego oficjalna premiera planowana jest wraz z wydaniem Symfony 7.3.

Instalacja wersji deweloperskiej: `composer require symfony/json-streamer:7.3.x-dev`

[A brand-new way to serialize data in Symfony](https://live.symfony.com/account/replay/video/1050)

```
<?php

use Symfony\Component\JsonStreamer\JsonStreamWriter;
use Symfony\Component\TypeInfo\Type;

require_once __DIR__ . '/vendor/autoload.php';

class User {
    public string $username;
    public string $email;
    public string $role;

    public function __construct($username, $email, $role)
    {
        $this->username = $username;
        $this->email = $email;
        $this->role = $role;
    }
}

$type = Type::list(Type::object(User::class));
$jsonEncode = JsonStreamWriter::create();
$json = $jsonEncode->write(createALotsOfUsers(), $type);
echo (string) $json;

function createALotsOfUsers(): iterable
{
    $roles = ['ROLE_USER', 'ROLE_ADMIN'];
    for ($i = 0; $i < 100; ++$i) {
        yield new User(sprintf('user%d', $i), sprintf('user%d@example.com', $i), $roles[array_rand($roles, 1)]);
    }
}

```
