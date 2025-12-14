# Modal wyświetlany przy wczytaniu strony

System wyświetlał komunikaty (ang. flash messages), które były dodawane w sytuacji, gdy walidator zwracał błąd.
Domyślnie komunikaty te pojawiały się na górze strony, razem z innymi informacjami systemowymi.

Użytkownicy zgłosili potrzebę, aby ten konkretny komunikat był wyświetlany w formie modala, a nie jako standardowy komunikat na stronie.
Modal ten miał wyświetlać się automatycznie po załadowaniu strony.

Mechanizm Google Tags/Google Analytics pozwala na rejestrację zdarzeń nawet wtedy, gdy biblioteka nie została jeszcze w pełni załadowana.
Osiągane jest to poprzez buforowanie wywołań w globalnej kolejce, a następnie ich odtworzenie po załadowaniu właściwego skryptu.
Na bazie tego rozwiązania zbudowałem własny mechanizm.

Po stronie serwera, dodanie wiadomości do wyświetlenia na starcie strony generowało następujący kod JavaScript:
```
<script type="text/javascript">
    (function (window) {
        window.showOnLoadModalBuffer = window.showOnLoadModalBuffer || [] ;
        window.addShowOnLoadModal = window.zemeModalOnLoad || function(data) {
            window.showOnLoadModalBuffer.push(data);
        };
    })(window);
    window.addShowOnLoadModal({'msg': "Hello!"});
</script>
```

Tworzy on globalny bufor showOnLoadModalBuffer (lub korzysta z już istniejącego).
Definiuje tymczasową funkcję addShowOnLoadModal, która zapisuje dane do bufora, przez co pozwala dodawać komunikaty zanim właściwy skrypt JS zostanie załadowany.

Strona ładowała również dedykowany skrypt JavaScript, którego zadaniem było:
1. Pobranie komunikatów zapisanych w buforze
1. Wyświetlenie ich w formie modala
1. Nadpisanie globalnej funkcji addShowOnLoadModal własną implementacją

```
export class ShowOnLoadModalSingleton {
    constructor(bufferWithMessage, callbackReplaceTemporaryFn) {
        this.displayModals(bufferWithMessage);
        callbackReplaceTemporaryFn();
    }

    static initFromGlobal() {
        const obj = new ShowOnLoadModalSingleton(
            window.showOnLoadModalBuffer,
            () => {
                window.addShowOnLoadModal = obj.addShowOnLoadModal
            }
        )

        return obj;
    }

    displayModals(messages) {
        //.....
    }

    addShowOnLoadModal(data) {
        this.displayModals([data]);
    }
}
```
