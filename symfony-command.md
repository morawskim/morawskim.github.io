# Symfony Command

## Test integracyjny (Symfony)

Jeśli naszą aplikację budujemy w oparciu o framework Symfony, to możemy łatwo dokonać testu integracyjnego. Wszystkie zależności, które wymaga nasza komenda zostaną pobrane z kontenera DI. Tworząc test dziedziczymy po klasie `Symfony\Bundle\FrameworkBundle\Test\KernelTestCase` zamiast `\PHPUnit\Framework\TestCase`. [W dokumentacji](https://symfony.com/doc/current/console.html#testing-commands) mamy sekcję na temat testowania poleceń w frameworku Symfony. Tworzymy nasz kernel symfony. Przekazujemy go jako parametr do aplikacji konsolowej. Następnie wyszukujemy naszą komendę i przekazujemy ją do klasy `CommandTester`. Wywołujemy metodę `execute` przekazując wymagane argumenty i parametry. Na końcu weryfikujemy, czy nasze polecenie działa zgodnie z założeniami.

``` php
use Symfony\Bundle\FrameworkBundle\Console\Application;
use Symfony\Bundle\FrameworkBundle\Test\KernelTestCase;
use Symfony\Component\Console\Tester\CommandTester;
// ...

public function testExecute()
{
    $kernel = static::createKernel();
    $application = new Application($kernel);

    $command = $application->find('app:create-user');
    $commandTester = new CommandTester($command);
    $commandTester->execute([
        'username' => 'Wouter'
    ]);

    // the output of the command in the console
    $output = $commandTester->getDisplay();
    $this->assertStringContainsString('Username: Wouter', $output);

    // ...
}
```

## Test jednostkowy

Jeśli chcemy przetestować nasze polecenie w izolacji musimy utworzyć atrapy wszystkich zależności.
W przykładzie poniżej tworzymy instancję klasy `SyncCommand`, przekazując jej atrapę usługi `Foo`.
Tworzę instancję klasy `\Symfony\Component\Console\Tester\CommandTester` przekazując jej obiekt polecenia `$command`.
Wywołując metodę `execute` przekazuje jej argumenty (mogę także parametry) i oczekuje, że moja komenda `SyncCommand` rzuci wyjątkiem `\LogicException`.

``` php
public function testPeriodMax30Days(): void
{
   $command = new SyncCommand(
        $this->createMock(Foo::class)
    );
    $this->expectException(\LogicException::class);

    $commandTester = new CommandTester($command);
    $commandTester->execute([
        // pass arguments to the helper
        'since' => '2020-05-01',
        'to' => '2020-05-31',
    ]);
}
```
