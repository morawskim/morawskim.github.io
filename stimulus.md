# Stimulus

[Stimulus](https://stimulus.hotwired.dev/) to framework JavaScript dla aplikacji, które budują HTML po stronie serwera.

Aby nasłuchiwać na zdarzenia elementu window lub document, musimy dodać `@window` albo `@document` do typu zdarzenia np. `resize@window`. 
Podobnie jeśli jeden kontroler publikuje zdarzenie, a drugi kontroler, który nie jest przodkiem i chce nasłuchiwać na te zdarzenie musi zawierać sufix `@window` np. `app:new-task@window`.

Za pomocą właściwości statycznej classes ([CSS Classes](https://stimulus.hotwired.dev/reference/css-classes)) możemy nazwy klas CSS trzymać w pliku HTML, a nie JavaScript.

## Demo Todo app

[Demo](https://codepen.io/morawskim/pen/qBLLOgv)

Rozpoczęcie pracy z Stimulus jest bardzo proste. Tworzymy plik HTML:

```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Todo app</title>
    <meta name="viewport" content="width=device-width">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
</head>
<body>

</body>
</html>
```

Następnie dodajemy Stimulus. 
Dzięki obsłudze [importmap](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/script/type/importmap) w przeglądarkach obecnie nie musimy instalować i konfigurować Webpack.
W pliku `index.html` dodajemy skrypt z ustawionym typem na wartość "importmap".

```
<script type="importmap">
{
    "imports": {
        "@hotwired/stimulus": "https://cdn.jsdelivr.net/npm/stimulus@3.2.2/+esm"
    }
}
</script>
```

Możemy zaimportować z pakietu "@hotwired/stimulus" klasę Controller i Application.
Tworzymy nasze kontrolery i rejestrujemy je w aplikacji tworząc kolejny znacznik script w pliku `index.html`.

```
<script type="module">
    import {Controller, Application} from '@hotwired/stimulus';
    class TaskFormController extends Controller {
        static targets = ['input'];

        addTask(event) {
            this.dispatch("new-task", { prefix: 'app', detail: {name:  this.inputTarget.value}});
            this.inputTarget.value = '';
        }
    }

    class TaskListController extends Controller {
        connect() {
        }

        appendTask(event) {
            const li = document.createElement("li");
            li.appendChild(document.createTextNode(event.detail.name));
            this.element.appendChild(li)
        }
    }

    const application = Application.start();
    application.register("task-form", TaskFormController)
    application.register("task-list", TaskListController)
</script>
```

Następnie dodajemy kod HTML formularza i listy zadań.

```
<div class="container">
    <div class="mb-3" data-controller="task-form">
        <label for="newTaskTxt" class="form-label">Task</label>
        <input
                data-task-form-target="input"
                data-action="keydown.enter->task-form#addTask"
                type="text" class="form-control" id="newTaskTxt"
        >
        <button
                data-action="task-form#addTask"
                type="button" class="btn btn-primary mt-1"
        >Add task</button>
    </div>

    <ul data-controller="task-list" data-action="app:new-task@window->task-list#appendTask"></ul>
</div>
```

## Lazy load

[Demo](https://playcode.io/1626964)

Symfony utrzymuje pakiet [symfony/stimulus-bundle](https://github.com/symfony/stimulus-bundle), który zawiera kasę JavaScript do [wczytywania kontrolerów Stimulus na żądanie](https://github.com/symfony/stimulus-bundle/blob/2.x/assets/src/loader.ts).

Nawet jeśli nie korzystamy z Symfony, ani Webpack to możemy zmigrować te rozwiązanie na czysty JavaScript, moduły ECMAScript i importmap.
W pliku HTML musimy mieć definicję importmap np.

```
<script type="importmap">
{
    "imports": {
        "@hotwired/stimulus": "https://cdn.jsdelivr.net/npm/stimulus@3.2.2/+esm",
         "@app/controllers/": "./controllers/"
    }
}
</script>
```

Następnie w katalogu `controllers` tworzymy nasze kontrolery np. `controllers/foo.js`.
Tworzymy plik `controller/lazyControllerLoader.js` i wrzucamy z drobnymi zmianami kodu z bundle Symfony.
Jedyna zmiana na zastosowanie słowa kluczowego `import` do dynamicznego ładowania modułów ECMAScript i pozbycie się typowania TypeScript.

```
// code from https://github.com/symfony/stimulus-bundle/blob/d7681325aceb02c3203d74f248bb621b9040c75c/assets/src/loader.ts

const controllerAttribute = 'data-controller';

class StimulusLazyControllerHandler {
    application;
    lazyControllers;

    constructor(application, lazyControllers) {
        this.application = application;
        this.lazyControllers = lazyControllers;
    }

    start() {
        this.lazyLoadExistingControllers(document.documentElement);
        this.lazyLoadNewControllers(document.documentElement);
    }

    lazyLoadExistingControllers(element) {
        this.queryControllerNamesWithin(element).forEach((controllerName) => this.loadLazyController(controllerName));
    }

    async loadLazyController(name) {
        if (canRegisterController(name, this.application)) {
            if (this.lazyControllers[name] === undefined) {
                return;
            }

            // change for import module
            const controllerModule = await import(`@app/controllers/${name}.js`);

            registerController(name, controllerModule.default, this.application);
        }
    }

    lazyLoadNewControllers(element) {
        new MutationObserver((mutationsList) => {
            for (const { attributeName, target, type } of mutationsList) {
                switch (type) {
                    case 'attributes': {
                        if (
                            attributeName === controllerAttribute &&
                            (target).getAttribute(controllerAttribute)
                    ) {
                            extractControllerNamesFrom(target).forEach((controllerName) =>
                                this.loadLazyController(controllerName)
                            );
                        }

                        break;
                    }

                    case 'childList': {
                        this.lazyLoadExistingControllers(target);
                    }
                }
            }
        }).observe(element, {
            attributeFilter: [controllerAttribute],
            subtree: true,
            childList: true,
        });
    }

    queryControllerNamesWithin(element) {
        return Array.from(element.querySelectorAll(`[${controllerAttribute}]`))
            .map(extractControllerNamesFrom)
            .flat();
    }
}

function registerController(name, controller, application) {
    if (canRegisterController(name, application)) {
        console.log("register", name);
        application.register(name, controller);
    }
}

function extractControllerNamesFrom(element) {
    const controllerNameValue = element.getAttribute(controllerAttribute);

    if (!controllerNameValue) {
        return [];
    }

    return controllerNameValue.split(/\s+/).filter((content) => content.length);
}

function canRegisterController(name, application) {
    // @ts-ignore
    return !application.router.modulesByIdentifier.has(name);
}

export default StimulusLazyControllerHandler;
```

Następnie startujemy aplikację Stimulus i rejestrujemy klasę do wczytywania kontrolerów na żądanie.

```
<script type="module">
    import {Application} from '@hotwired/stimulus';
    import StimulusLazyControllerHandler from '@app/controllers/lazyControllerLoader.js';

    const application = Application.start();
    const lazyControllerHandler = new StimulusLazyControllerHandler(
        application,
        {"foo": 1, "load-content": 1}
    );
    lazyControllerHandler.start();
</script>
```
