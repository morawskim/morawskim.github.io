# EasyAdminBundle

Bundle [EasyAdminBundle](https://github.com/EasyCorp/EasyAdminBundle) to generator panelu administratora dla aplikacji Symfony. Dostępne możliwości:

* Operacje CRUD na encjach Doctrine (tworzenie, edycja, lista, usuwanie)
* Wyszukiwanie, paginacja i sortowanie kolumn
* Przetłumaczone na dziesiątki języków.

## Form type configuration

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

## Relacja OneToMany nie jest zapisywana do bazy danych

W metodzie dodawania/edycji encji obsługiwanej przez easyadmin, nie zapisywały się przypisania do powiązanej relacji. Do encji chciałem przypisać punkty POI. Jednak podczas zapisu, encja POI nie otrzymywała identyfikatora "centrum handlowego". Problemem okazał się brak opcji `by_reference` w pliku konfiguracyjnym formularza.

```
#...
            form:
                fields:
                    - 'name'
                    - { property: 'description', type: 'textarea' }
                    - { property: 'street', type: 'text' }
                    - { property: 'city', type: 'text' }
                    - { property: 'postal_code', type: 'text' }
                    - { property: 'lat', type: 'number', type_options: {scale: 6} }
                    - { property: 'lon', type: 'number', type_options: {scale: 6} }
                    - { property: 'website', type: 'url' }
                    - { property: 'pois', type: 'easyadmin_autocomplete', type_options: {by_reference: false} }
#....
```

[https://github.com/EasyCorp/EasyAdminBundle/issues/860](https://github.com/EasyCorp/EasyAdminBundle/issues/860)

[https://stackoverflow.com/questions/48304399/q-symfony4-easyadmin-onetomany-not-saving-in-db](https://stackoverflow.com/questions/48304399/q-symfony4-easyadmin-onetomany-not-saving-in-db)

[https://github.com/EasyCorp/EasyAdminBundle/issues/2015](https://github.com/EasyCorp/EasyAdminBundle/issues/2015)

[https://github.com/doctrine/orm/issues/4142](https://github.com/doctrine/orm/issues/4142)
