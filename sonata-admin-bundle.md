# Sonata/admin-bundle

Bundle `sonata-project/admin-bundle` pozwala nam szybko utworzyć panel administratora.
Prócz dokumentacji istnieje prezentacja [Building great admin panels with Symfony and SonataAdminBundle](https://speakerdeck.com/victoriaq/building-great-admin-panels-with-symfony-and-sonataadminbundle).
Warto na początku wykonać kilka kroków.

Aby zmienić tytuł panelu administratora w pliku `config/packages/sonata_admin.yaml` zmieniamy klucz `title`.
Dodatkowo wyłączamy funkcję globalnej wyszukiwarki ustawiając klucz `search` na wartość `false`.
```
sonata_admin:
    title: 'My Admin'
    #title_logo: 'path/to/logo.jpg'
    search: false
    # .....
```

Możemy łączyć pozycje z menu po lewej stronie w grupy. Standardowo wszystkie elementy panelu administratora należą do grupy `default`. W pliku `config/packages/sonata_admin.yaml` możemy definiować kolejne grupy. W przykładzie poniżej utworzyłem grupę `account`. Ta nazwa jest ważną, ponieważ będziemy z niej korzystać przy definicji usług panelu administracyjnego.

```
sonata_admin:
    # ....
    dashboard:
        blocks:
            - { type: sonata.admin.block.admin_list, position: left }
        groups:
            account:
                label: Accounts
                label_catalogue: ~
```

W konfiguracji kontenera usług (`config/services.yaml`) mając deklarację [usługi administracyjnej](https://symfony.com/doc/current/bundles/SonataAdminBundle/getting_started/creating_an_admin.html#step-3-register-the-admin-class) dodajemy atrybut `group` do klucza `tags` z wartością naszej wcześniej utworzonej grupy.

```
admin.person:
    class: App\Admin\PersonAdmin
    arguments:
        - ~
        - App\User\Entity\Person
        - ~
    tags:
        - { name: sonata.admin, manager_type: orm, label: Person, group: account }
```

W klasie dziedziczonej po `\Sonata\AdminBundle\Admin\AbstractAdmin` warto wyłączyć możliwość sortowania na widoku listy. Musimy jednak to zrobić dla każdego pola oddzielnie.

```
protected function configureListFields(ListMapper $listMapper)
{
    # ....
    $listMapper->add('email', null, ['sortable' => false]);
    #....
}
```

Aby ustawić domyślne sortowanie nadpisujemy metodę `configureDefaultSortValues`.

```
protected function configureDefaultSortValues(array &$sortValues)
{
    $sortValues['_sort_by'] = 'id';
    $sortValues['_sort_order'] = 'DESC';
}
```

Dostępne filtry na liście konfigurujemy nadpisując metodę `configureDatagridFilters`
```
protected function configureDatagridFilters(DatagridMapper $datagridMapper)
{
    $datagridMapper->add('username', null, [
        'advanced_filter' => false
    ]);
}
```

Warto wyłączyć także akcje których nie potrzebujemy jak np. `export`.
```
protected function configureRoutes(RouteCollection $collection)
{
    # wszystkie dostępnę akcje
    $collection->remove('list');
    $collection->remove('edit');
    $collection->remove('show');
    $collection->remove('delete');
    $collection->remove('create');
    $collection->remove('batch');
    $collection->remove('export');
}
```

Jeśli nie skasujemy akcji `delete` a także wyświetlamy link do kasowania encji na liście, to nawet z wyłączonym routerem `batch` pojawi się na liście dodatkowa kolumna `batch`. Aby się jej pozbyć musimy nadpisać metodę `configureBatchActions`.

```
protected function configureBatchActions($actions)
{
    unset($actions['delete']);

    return $actions;
}
```

Na końcu w celu generowania przyjaznych nazw encji (np. w breadcrumb) nadpisujemy metodę `toString`.
```
public function toString($object)
{
    return $object instanceof Account
        ? $object->getUsername()
        : 'Person account';
}
```

## Filtry

Wszystkie filtry, które możemy zastosować na stronie listy implementują interfejs `\Sonata\AdminBundle\Filter\FilterInterface`. W [dokumentacji](https://sonata-project.org/bundles/doctrine-orm-admin/master/doc/reference/filter_field_definition.html) znajdziemy także przykładowe użycie.
W przypadku encji, które korzystają z [Inheritance Mapping](https://www.doctrine-project.org/projects/doctrine-orm/en/2.8/reference/inheritance-mapping.html) niezbędny jest filtr `ClassFilter`. Doctrine uniemożliwia nam za pomocą DQL utworzenia warunku WHERE na kolumnie oznaczonej adnotacją `DiscriminatorColumn`. Musimy w takim przypadku korzystać z operatora `INSTANCE OF` (https://github.com/doctrine/orm/issues/4986).

```
$datagridMapper
            ->add('type', ClassFilter::class, ['sub_classes' => $this->getSubClasses()]);
```

Dodatkowo jeśli korzystamy z filtru `ModelAutocompleteFilter` otrzymamy błąd [Bug: Method "get-autocomplete-items" with subclass](https://github.com/sonata-project/SonataAdminBundle/issues/3428).
Rozwiązanie polega na przekazaniu parametru `subclass`. Dodatkowo w konfiguracji usługi panelu administratora musimy wywołać metodę `setSubClasses`, aby ustawić [dziedziczenie](https://symfony.com/doc/current/bundles/SonataAdminBundle/reference/advanced_configuration.html#inherited-classes).

```
$datagridMapper->add('category', ModelAutocompleteFilter::class, [
    'advanced_filter' => false,
], null, ['property' => 'name', 'req_params' => ['subclass' => OfferTypeEnum::PRODUCT]]);
```

```
admin.offer:
    class: App\Admin\OfferAdmin
    arguments:
        - ~
        - App\Offer\Entity\Offer
        - App\Admin\Controller\OfferController
    calls:
        - method: setSubClasses
          arguments:
              - !php/const App\Offer\Enum\OfferTypeEnum::JOB_OFFER: App\Offer\Entity\Job
                !php/const App\Offer\Enum\OfferTypeEnum::PRODUCT: App\Offer\Entity\Product
                !php/const App\Offer\Enum\OfferTypeEnum::SERVICE: App\Offer\Entity\Service
    tags:
        - { name: sonata.admin, manager_type: orm, label: Offer, group: offer }

```

## Szablony

Szablony widoków możemy łatwo podmienić. W pliku konfiguracyjnym `config/packages/sonata_admin.yaml` wystarczy, że w kluczu `templates` ustawimy odpowiednią ścieżkę do naszego pliku szablonu twig jak w przykładzie poniżej. Modyfikując szablon `layout` możemy dodać skrypty JavaScript i arkusze styli CSS z encore.

```
sonata_admin:
    templates:
        layout: 'SonataAdminBundle/standard_layout.html.twig'
```

Aby nadpisać szablon pól formularza musimy edytować inną konfigurację.

```
sonata_doctrine_orm_admin:
    templates:
        form: ['path/to/theme/form_admin_fields.html.twig']
```

Nasz plik widoku powinien także zawierać standardową instrukcję dziedziczenia szablonu:
```
{% raw %}
{# the raw tag is only for fix build, this is not part of twig file #}
{% extends '@SonataDoctrineORMAdmin/Form/form_admin_fields.html.twig' %}
{% endraw %}
```

Jeśli nie chcemy tworzyć specyficznego szablonu, możemy w klasie admina, nadpisać metodę `getFormTheme`:

```
public function getFormTheme(): array
{
    return ['path/to/theme/form_admin_fields.html.twig'];
}
```

## Własny typ pola

Wykorzystując value object w encji np. money warto zdefiniować nowy typ pola formularza.
W pliku `config/packages/sonata_doctrine_orm_admin.yaml` definiujemy pole `money` i podajemy ścieżkę do pliku widoku.

```
sonata_doctrine_orm_admin:
  templates:
    types:
      show:
        money: 'SonataAdminBundle/fieldtypes/show_money.html.twig'
```

Plik widoku powinien rozszerzać widok `@SonataAdmin/CRUD/base_show_field.html.twig`.

```
{% raw %}
{# the raw tag is only for fix build, this is not part of twig file #}
{% extends '@SonataAdmin/CRUD/base_show_field.html.twig' %}

{% block field %}
    {% if value %}
        {{ value | money_localized_format }}
    {% endif %}
{% endblock %}
{% endraw %}
```

W metodzie `configureShowFields` możemy skorzystać z pola `money`.

```
protected function configureShowFields(ShowMapper $showMapper)
{
    $showMapper
        ->add('id')
        ->add('category', null, [
            'associated_property' => 'name',
        ])
        // ......
        ->add('price', 'money')
        // ......
}
```

[Create your own field type](https://symfony.com/doc/current/bundles/SonataAdminBundle/reference/field_types.html#create-your-own-field-type)

## Sonata Extension

Rozszerzenie panelu administratora pozwala nam dodać lub zmienić funkcjonalność dla różnych instancji Admina.
Tworzymy klasę która dziedziczy po `\Sonata\AdminBundle\Admin\AbstractAdminExtension`. Klasa ta implementuje interfejs `\Sonata\AdminBundle\Admin\AdminExtensionInterface`, dzięki temu nie musimy tworzyć pustych metod.
Następnie rejestrujemy usługę rozszerzenie panelu administratora w pliku `config/services.yaml`:

```
admin.sales_channel.extension:
    class: App\Admin\Extension\SalesChannelExtension
    tags:
        - { name: sonata.admin.extension, global: true }
```

W moim przypadku zaimplementowałem metodę `alterObject`, która na podstawie przekazywanej encji ustawiała kontekst działania aplikacji (amerykański albo polski). Dzięki temu walidatory na encji wymuszały, aby dane były zgodnie z wybranym kontekstem.

[Extensions](https://symfony.com/doc/current/bundles/SonataAdminBundle/reference/extensions.html)

## Link w menu do zewnętrznego serwisu

Menu w sonancie bazuje na bundle `KnpMenuBundle`. W projekcie musiałem dodać link w menu, który przekieruje użytkownika do zewnętrznego serwisu. Możemy to zrobić definiując ruter w pliku `config/routes/routes.yaml`.

```
# ...
external.somewhere:
    schemes: [https]
    path: /some/path
    host: "example.com"
```

Następnie w pliku `config/packages/sonata.yaml` dodajemy pozycję w menu i ustawiamy parametr `route` na wartość utworzonego rutera. Dzięki parametrom `on_top` nasza pozycja w menu nie będzie zagnieżdżona w drzewie - [Show menu item without treeview](https://symfony.com/bundles/SonataAdminBundle/master/cookbook/recipe_knp_menu.html#show-menu-item-without-treeview).

```
sonata_admin:
    # ...
    dashboard:
        groups:
            # ...
            external_link:
                label: 'External'
                on_top: true
                icon: '<i class="fa fa-globe"></i>'
                items:
                    - label: ''
                      route: external.somewhere
```

## Własna akcja kontrolera

Domyślnie panele administratora Sonaty wykorzystują kontroler `\Sonata\AdminBundle\Controller\CRUDController`. Podczas definiowania usługi panelu określamy z jakiego kontrolera chcemy korzystać. Nie stoi jednak nic na przeszkodzie podłączyć całkowicie niezależny kontroler, który nie będzie korzystał z CRUDController. W tym przypadku jest to kontroler z akcją do aktualizacji parametrów konfiguracyjnych aplikacji.

Pierwszy krok to utworzenie klasy kontrolera tak jak to standardowo robimy w Symfony.
Widok twig powinien rozszerzać szablon `@SonataAdmin/standard_layout.html.twig`. Dodatkowo jeśli chcemy wyświetlić formularz musimy skonfigurować form_theme. Poniższy fragment to przykład prostego widoku.

```
{% raw %}
{# the raw tag is only for fix build, this is not part of twig file #}
{% extends '@SonataAdmin/standard_layout.html.twig' %}
{% form_theme form '@SonataDoctrineORMAdmin/Form/form_admin_fields.html.twig' %}

{% block sonata_admin_content %}
    {% block notice %}
        {% include ['@SonataCore/FlashMessage/render.html.twig', '@SonataTwig/FlashMessage/render.html.twig'] %}
    {% endblock notice %}

    {{ form_start(form) }}
        {{ form_rest(form) }}
        <input type="submit" value="{{ 'btn_update'|trans({}, 'SonataAdminBundle') }}" class="btn btn-primary" />
    {{ form_end(form) }}
{% endblock %}
{% endraw %}
```

Chcąc podłączyć akcję kontrolera do istniejącego menu stwarza pewne problemy.
Sonata dostarcza klasę `AddDependencyCallsCompilerPass`, która na podstawie konfiguracji automatycznie dodaje pozycję panelu admina do menu. Jeśli ręcznie dodamy choć jedną pozycję, to znikną nam wszystkie domyślne linki do paneli administracyjnych w danej grupie. Musimy je ręcznie wymienić.

Możemy wyświetlić listę paneli przypisanych do danej grupy menu wyświetlając zawartość zmiennej `$groupDefaults[$resolvedGroupName]['items'];` odpowiedniej grupy w klasie [AddDependencyCallsCompilerPass](https://github.com/sonata-project/SonataAdminBundle/blob/3.x/src/DependencyInjection/Compiler/AddDependencyCallsCompilerPass.php#L180)

```
sonata_admin:
    # ...
    dashboard:
        groups:
            CMS:
                label: CMS
                icon: '<i class="fa fa-edit"></i>'
                items:
                    - label: 'Settings'
                      route: admin.settings
                    - admin.static_content
                    # ...
```

[Creating a Custom Admin Action](https://symfony.com/bundles/SonataAdminBundle/current/cookbook/recipe_custom_action.html)
