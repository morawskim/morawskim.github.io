# Sonata/admin-bundle

Bundle `sonata-project/admin-bundle` pozwala nam szybko utworzyć panel administratora. Warto na początku wykonać kilka kroków.

Aby zmienić tytuł panelu administratora w pliku `config/packages/sonata_admin.yaml` zmieniamy klucz `title`. Dodatkowo wyłączamy funkcję globalnej wyszukiwarki ustawiając klucz `search` na wartość `false`.
```
sonata_admin:
    title: 'My Admin'
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

Na końcu w celu generowania przyjaznych nazw encji (np. w breadcrumb) nadpisujemy metodę `toString`.
```
public function toString($object)
{
    return $object instanceof Account
        ? $object->getUsername()
        : 'Person account';
}
```
