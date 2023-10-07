# Stimulus

[Stimulus](https://stimulus.hotwired.dev/) to framework JavaScript dla aplikacji, które budują HTML po stronie serwera.

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
