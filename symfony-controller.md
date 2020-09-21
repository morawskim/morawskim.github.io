# Symfony Controller

## Controller as service

Rozszerzenia do Symfony (bundles) czasami dostarczają nam kontrolery jako usługi. Nie musimy samemu tworzyć akcji kontrolera, możemy skorzystać z domyślnej implementacji. Korzystając z bundle `WebProfilerBundle` w pliku `config/routes/dev/web_profiler.yaml` znajdziemy konfigurację do dołączenia konfiguracji ruterów:

```
web_profiler_profiler:
    resource: '@WebProfilerBundle/Resources/config/routing/profiler.xml'
    prefix: /_profiler
```

Gdy kontroler definiuje tylko jedną akcję wykorzystując metodę `__invoke` (jak np. w bundle `NelmioApiDocBundle`) konfiguracja jest następująca:

```
app.swagger_ui:
    path: /api/doc
    methods: GET
    defaults: { _controller: nelmio_api_doc.controller.swagger_ui }
```

W przypadku kontrolera z wieloma akcjami konfiguracja jest następująca:

```
hello:
    path:     /hello
    controller: App\Controller\HelloController::index
    methods: GET
```

[How to Define Controllers as Services](https://symfony.com/doc/4.4/controller/service.html)
