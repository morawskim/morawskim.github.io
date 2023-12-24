# Problemy podczas aktualizacji Symfony

## Symfony 7

W wersji 6.4 interfejs [ContainerAwareInterface został oznaczony jako deprecated](https://github.com/symfony/dependency-injection/blob/50b32f96f7e8f43b1ec4904df3be04438c0e4c13/ContainerAwareInterface.php#L19). Obecnie powinniśmy korzystać z ServiceLocator. W przypadku RabbitMqBundle problem polegał na tym że ServiceLocator implementuje interfejs `Psr\Container\ContainerInterface`, zaś "publiczny kontener usług" implementuje `Symfony\Component\DependencyInjection\ContainerInterface`, który rozszerza interfejs z PSR.
W takim przypadku rozwiązaniem może być utworzenie CompilerPass i [przekazanie publicznego kontenera](https://github.com/php-amqplib/RabbitMqBundle/pull/721).

```
<?php

namespace OldSound\RabbitMqBundle\DependencyInjection\Compiler;

use OldSound\RabbitMqBundle\Command\BaseRabbitMqCommand;
use Symfony\Component\DependencyInjection\Compiler\CompilerPassInterface;
use Symfony\Component\DependencyInjection\ContainerBuilder;
use Symfony\Component\DependencyInjection\Reference;

class ServiceContainerPass implements CompilerPassInterface
{
    public function process(ContainerBuilder $container): void
    {
        foreach ($container->findTaggedServiceIds('console.command') as $id => $attributes) {
            $command = $container->findDefinition($id);
            if (is_a($command->getClass(), BaseRabbitMqCommand::class, true)) {
                $command->addMethodCall('setContainer', [new Reference('service_container')]);
            }
        }
    }
}

```

[[DI] Replace container injection by explicit service locators #20658](https://github.com/symfony/symfony/issues/20658)

## Symfony 6

W wersji 5.3 metoda `KernelEvent::isMasterRequest()` i stała `HttpKernelInterface::MASTER_REQUEST` zostały oznaczone jako deprecated.
Aby dostosować kod do nowszych wersji Symfony musimy sprawdzić czy metoda `isMainRequest` istnieje - `method_exists(KernelEvent::class, 'isMainRequest')`.

[[HttpFoundation][HttpKernel] Rename master request to main request #40536](https://github.com/symfony/symfony/pull/40536)
