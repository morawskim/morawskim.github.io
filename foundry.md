# Foundry i Symfony 3

Foundry wymaga Symfony 4. Jednak bardzo łatwo możemy wykorzystać Foundry w projekcie z Symfony 3.
Wystarczy utworzyć trait i dołączać go do klas testów.

```
<?php

namespace Tests\Traits;

use Symfony\Bundle\FrameworkBundle\Test\KernelTestCase;
use Zenstruck\Foundry\Factory;
use Zenstruck\Foundry\Test\LazyManagerRegistry;
use Zenstruck\Foundry\Test\TestState;

/**
 * Foundry requires Symfony 4.
 * But can also work with Symfony 3 with some small changes in their trait,
 * After upgrading to Symfony 4, you can replace references.
 *
 * @see \Zenstruck\Foundry\Test\Factories
 */
trait FoundryForSymfony3Trait
{
    /**
     * @internal
     * @before
     */
    public static function _setUpFactories(): void
    {
        if (!\is_subclass_of(static::class, KernelTestCase::class)) {
            TestState::bootFoundry();

            return;
        }

        $kernel = static::createKernel();
        $kernel->boot();

        TestState::bootFromContainer($kernel->getContainer());
        Factory::configuration()->setManagerRegistry(
            new LazyManagerRegistry(static function() {
                if (null === self::$kernel) {
                    static::bootKernel();
                }

                return TestState::initializeChainManagerRegistry(static::$kernel->getContainer());
            })
        );

        $kernel->shutdown();
    }

    /**
     * @internal
     * @after
     */
    public static function _tearDownFactories(): void
    {
        TestState::shutdownFoundry();
    }
}

```
