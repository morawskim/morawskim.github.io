# Symfony DependencyInjection

## Autoconfiguring Tags

Kiedy mamy włączoną opcję `autoconfigure` niektóre tagi są automatycznie przypisywane do usługi. Mechanizm ten przypisuje tag jeśli usługa implementuje odpowiedni interfejs. Możemy także automatycznie przypisywać własny tag do usługi. W aplikacji Symfony w metodzie `build` klasy Kernela wywołujemy metodę `registerForAutoconfiguration` na kontenerze:

```
protected function build(ContainerBuilder $container)
{
    $container->registerForAutoconfiguration(CustomInterface::class)
        ->addTag('app.custom_tag')
    ;
}
```

W przypadku Symfony bundle metodę `registerForAutoconfiguration` wywołujemy w metodzie `load` klasy rozszerzenia.

Następnie tworzymy Compiler Pass, który pobierze wszystkie usługi z przypisanym tagiem.

```
public function process(ContainerBuilder $container)
{
    // always first check if the primary service is defined
    if (!$container->has(TransportChain::class)) {
        return;
    }

    $definition = $container->findDefinition(TransportChain::class);

    // find all service IDs with the app.mail_transport tag
    $taggedServices = $container->findTaggedServiceIds('app.mail_transport');

    foreach ($taggedServices as $id => $tags) {
        // add the transport service to the TransportChain service
        $definition->addMethodCall('addTransport', [new Reference($id)]);
    }
}
```

[How to Work with Service Tags](https://symfony.com/doc/4.4/service_container/tags.html)
