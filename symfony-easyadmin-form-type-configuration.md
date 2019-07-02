# symfony easyadmin form type configuration

W projekcie symfony 4, panel administratora był zbudowany w oparciu o bundle easyadmin.
Formularz edycji/dodawania encji zawierał pole wyboru `router`.
Jednak na podstawie roli zalogowanego użytkownika, musiałem ograniczyć ilość pozycji w tym polu.
Choć easyadmin oferuje nam hooki, nie mogłem tego tak zrobić - FormExtension zawsze pobierał konfigurację formularza. Nie otrzymywał mojej zmodyfikowanej struktury.
Musiałem stworzyć usługę implementującą interfejs `TypeConfiguratorInterface`.
Dzięki temu, mogłem zmodyfikować ustawienia formularza i ustawić listę dostępnych ruterów.

``` php
<?php

namespace App\Form\Type\Configurator;

use App\Entity\Router;
use App\Service\RouterProviderService;
use EasyCorp\Bundle\EasyAdminBundle\Form\Type\Configurator\TypeConfiguratorInterface;
use Symfony\Bridge\Doctrine\Form\Type\EntityType;
use Symfony\Component\Form\FormConfigInterface;

class EntityTypeConfigurator implements TypeConfiguratorInterface
{
    /**
     * @var RouterProviderService
     */
    private $routerProvider;

    public function __construct(RouterProviderService $routerProvider)
    {
        $this->routerProvider = $routerProvider;
    }

    /**
     * {@inheritdoc}
     */
    public function configure($name, array $options, array $metadata, FormConfigInterface $parentConfig)
    {
        $options['choices'] = $this->routerProvider->getRoutersForLoggedUser();
        return $options;
    }

    /**
     * {@inheritdoc}
     */
    public function supports($type, array $options, array $metadata)
    {
        $class = $options['class'] ?? null;
        $fieldName = $metadata['fieldName'] ?? null;

        $isEntity = \in_array($type, ['entity', EntityType::class], true);
        $isRouterClass = $class === Router::class;
        $isRouteField = $fieldName === 'router';

        return $isEntity && $isRouteField && $isRouterClass;
    }
}
```

W pliku `services.yml` klasie `App\Form\Type\Configurator\EntityTypeConfigurator` przypisujemy tag `easyadmin.form.type.configurator`.

```
App\Form\Type\Configurator\EntityTypeConfigurator:
        tags:
            - { name: "easyadmin.form.type.configurator" }
```
