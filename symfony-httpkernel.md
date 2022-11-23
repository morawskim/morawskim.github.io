# Symfony HttpKernel

## Controller attributes

### Symfony < 6.2

Wykorzystując bundle `FrameworkExtraBundle` możemy skonfigurować obsługę żądania HTTP przy akcji kontrolera. w PHP8 możemy utworzyć własny atrybut i oznaczyć nim akcję kontrolera. Następnie takie metadane możemy ustawić jako atrybut klasy Request.

Bundle `request-input-bundle` zawiera przykład takiej implementacji.
Klasa [InputMetadataFactory](https://github.com/sfmok/request-input-bundle/blob/760014373362aa743ee5f8aab7f1bb633806aff7/src/Metadata/InputMetadataFactory.php) wyciąga metadane z akcji kontrolera i za pomocą listenera [ReadInputListener](https://github.com/sfmok/request-input-bundle/blob/760014373362aa743ee5f8aab7f1bb633806aff7/src/EventListener/ReadInputListener.php#L18) metadane są dodawane do obiektu Request podczas obsługi zdarzenia `KernelEvents::CONTROLLER`.

Argument `$controller` może przyjmować różne wartości. Aby obsłużyć wszystkie/większość przypadków możemy zaczerpnąć także trochę informacji z kodu Symfony.

Fragment metody [\Symfony\Component\HttpKernel\ControllerMetadata\ArgumentMetadataFactory::createArgumentMetadata](https://github.com/symfony/http-kernel/blob/ab9677e6ece7018d4cb8490ad49b164c0910d54a/ControllerMetadata/ArgumentMetadataFactory.php#L24) (implementacja interfejsu `\Symfony\Component\HttpKernel\Controller\ArgumentResolverInterface`). 
Klasa ta otrzymuje zmienną `$controller`, która w większości przypadków jest tą samą zmienną co w utworzonym listenerze.

``` php
if (\is_array($controller)) {
    $reflection = new \ReflectionMethod($controller[0], $controller[1]);
    $class = $reflection->class;
} elseif (\is_object($controller) && !$controller instanceof \Closure) {
    $reflection = new \ReflectionMethod($controller, '__invoke');
    $class = $reflection->class;
} else {
    $reflection = new \ReflectionFunction($controller);
    if ($class = str_contains($reflection->name, '{closure}') ? null : $reflection->getClosureScopeClass()) {
        $class = $class->name;
    }
}
```

Fragment metody [\Symfony\Component\HttpKernel\HttpKernel::handleRaw](https://github.com/symfony/symfony/blob/0edb107227e224aefec7908511bf5e94c4d09355/src/Symfony/Component/HttpKernel/HttpKernel.php#L135), który przedstawia proces odnajdowania kontrolera do obsługi żądania HTTP.

``` php
// load controller
if (false === $controller = $this->resolver->getController($request)) {
    throw new NotFoundHttpException(sprintf('Unable to find the controller for path "%s". The route is wrongly configured.', $request->getPathInfo()));
}

$event = new ControllerEvent($this, $controller, $request, $type);
$this->dispatcher->dispatch($event, KernelEvents::CONTROLLER);
$controller = $event->getController();

// controller arguments
$arguments = $this->argumentResolver->getArguments($request, $controller);
```

### Symfony 6.2+

W przypadku Symfony 6.2+ dodano nowe zdarzenie w procesie obsługi requesta [[HttpKernel] Add ControllerEvent::getAttributes() to handle attributes on controllers #46001](https://github.com/symfony/symfony/pull/46001), które ma finalnie zastąpić pakiet FrameworkExtraBundle [[RFC] Abandon FrameworkExtraBundle #44705](https://github.com/symfony/symfony/issues/44705).
