# symfony snippets

## Ustawienie domyślnych wartości dla zmiennych środowiskowych

Domyślną wartość dla zmiennej środowiskowej ustawiamy w kluczu `parameters`.
Tworząc parametr `env(VARIABLE_NAME)` i przypisując wartość, utworzyliśmy domyślną wartość dla zmiennej środowiskowej `VARIABLE_NAME`. Jeśli zmienna środowiskowa będzie ustawiona, jej wartość nadpisze domyślną wartość.

## entrypoints.json vs manifest.json

Encore tworzy dwa pliki: `entrypoints.json` i `manifest.json`. Oba pliki są podobne - zawierają powiązanie do wersjonowanej wersji pliku.

Plik `entrypoints.json` jest wykorzystywany przez funkcje Twiga: `encore_entry_script_tags` i `encore_entry_link_tags`. Dzięki tym funkcjom zostaną wygenerowane znaczniki HTML dla plików CSS i JavaScript.

Plik `manifest.json` jest potrzebny tylko do pobrania  nazwy pliku innych zasobów np. obrazki lub czcionki.

## symfony encore i runtime.js

Plik `runtime.js` jest generowany jeśli w konfiguracji encore jawnie wywołamy metodę `enableSingleRuntimeChunk`.

Jeśli w konfiguracji encore wywołaliśmy metodę `enableSingleRuntimeChunk` i mamy wiele plików "wejściowych" (entry files), które wczytują ten sam moduł (np. jquery) to nasze pliki js dostaną ten sam obiekt.

Jeśli wywołamy metodę `disableSingleRuntimeChunk` to nasze pliki js dostaną różne obiekty wczytywanego modułu.

W przypadku aplikacji, które nie są tzw. "single-page app", to najpewniej będziemy chcieli korzystać z `runtime.js`.


## Domyślna wartość dla pola w Doctrine2

``` php
/**
 * @ORM\Column(type="decimal", precision=10, scale=4, options={"default" : 0})
 */
private $avg30;
```

## Twig - zmienna globalna z zmiennej zdefiniowanej w pliku .env

Chciałem w pliku widoku, pobrać token dostępu do API dostawcy usługi mapy.
W pliku `.env` utworzyłem nową zmienną środowiskową `LEAFLET_ACCESS_TOKEN="xxxxx"`

Następnie w pliku `config/packages/twig.yaml` dodawałem zmienną globalną `leaflet_access_token` i jej wartość pobrałem z zmiennej środowiskowej.
```
twig:
    globals:
        leaflet_access_token: '%env(LEAFLET_ACCESS_TOKEN)%'
```

Dzięki temu w pliku widoku, mogłem pobrać i token dostępu za pomocą zmiennej `leaflet_access_token`.

## Twig - zmienna globalna

``` php
<?php

namespace App\DependencyInjection\Compiler;

use App\Twig\CompanyVariable;
use Symfony\Component\DependencyInjection\Compiler\CompilerPassInterface;
use Symfony\Component\DependencyInjection\ContainerBuilder;
use Symfony\Component\DependencyInjection\Reference;

class TwigCompanyVariablePass implements CompilerPassInterface
{
    public function process(ContainerBuilder $container)
    {
        $id = 'twig';
        if ($container->hasDefinition($id)) {
            $container
                ->findDefinition($id)
                ->addMethodCall('addGlobal', array('company', new Reference(CompanyVariable::class)));
        }
    }
}
```

Czasami utworzenie zmiennej globalnej Twiga w oparciu o stałą wartość, nie jest tym czego oczekujemy.
Chcemy skorzystać z usług Symfony. W takim przypadku tworzymy plik `TwigCompanyVariablePass.php` w katalogu `src/DependencyInjection/Compiler`. Ma on za zadanie dodać do Twiga, zmienną globalną `company`. Będzie to instancja klasy `App\Twig\CompanyVariable`. Ta klasa, może korzystać z wstrzykiwania usług z DI Symfony.

## ParamConvert

Adnotacja `ParamConvert` pozwala skonfigurować mapowanie parametry routingu z właściwością encji.
I tak dla poniższego fragmentu. `poiGroup` to nazwa zmiennej w akcji kontrolera.
Klucz w mappingu to nazwa parametru routingu, a wartość to nazwa właściwości encji doctrine.

```
/**
 * @Route("/import/poi/{poiGroupId}", name="import_poi")
 * @ParamConverter("poiGroup", options={"mapping": {"poiGroupId" : "id"}})
 */
public function index(PoiGroup $poiGroup)
```
