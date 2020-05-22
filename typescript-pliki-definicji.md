# TypeScript - pliki definicji

W aplikacjach, gdzie nie przeszło się w pełni na `typescript` mogą istnieć zmienne globalne np. `MyApp`.
Chcąc ją użyć w typescript otrzymamy błąd - `TS2339: Property 'MyApp' does not exist on type 'Window & typeof globalThis'`.

Musimy utworzyć plik z deklaracją takiej globalnej zmiennej. Tworzymy plik `app.d.ts` (nazwa jest dowolna, wymagane jest tylko rozszerzenie `.d.ts`).
W nim deklarujemy interfejs:

```
interface MyApp {
    foo: () => void,
}
```
A następnie deklarujemy zmienną globalną `MyApp` typu `MyApp` - `declare var MyApp: MyApp;`
Dzięki temu typescript nie będzie zgłaszał błędu, a IDE będzie podpowiadać nam dostępne metody/zmienne.


## pluginy jQuery

Jeśli korzystamy z pluginów jQuery, to raczej nie znajdziemy gotowego pliku deklaracji.
W takim przypadku musimy sami go stworzyć. Wystarczy tylko rozszerzyć interfejs `JQuery`/`JQueryStatic`:

```
interface JQuery {
   foo: <any|InterfejsDlaPluginuFoo>;
}
```

## React i web component

Jeśli w aplikacji React + TS będziemy chcieli wykorzystać web komponent np. `vaadin-upload`, dostaniemy błąd kompilacji: `TS2339: Property 'vaadin-upload' does not exist on type 'JSX.IntrinsicElements'.`. Biblioteka React zna tylko standardowe znaczniki HTML, więc gdy korzystamy z innego elementu otrzymujemy ten błąd. Rozwiązanie polega na utowrzeniu własnego pliku definicji np. `webcomponents.d.ts`. W tym pliku rozszerzamy interfejs `IntrinsicElements` tak jak w przykładzie poniżej.

```
declare namespace JSX {
    interface IntrinsicElements {
        'vaadin-upload': VaadinUploadAttributes;
    }
}

interface VaadinUploadAttributes {
    target: string;
    accept: string;
    'max-files': number;
    'form-data-name': string;
}
```

## Rozszerzenie definicji biblioteki

W projekcie korzystaliśmy z biblioteki `yup` do sprawdzania poprawności danych formularza. Jedno z pól formularza pozwalało na podanie numeru telefonu. Dodaliśmy więc bibliotekę NPM `@availity/phone` do projektu w celu walidacji numeru telefonu. Biblioteka ta nie zawierała jednak pliku definicji dla TS. Otrzymaliśmy więc błąd kompilacji TS `TS2339: Property 'validatePhone' does not exist on type 'StringSchema<string>'.`. Utworzyłem nowy plik definicji `yup.d.ts` i rozszerzyłem interfejs `StringSchema` tak jak w przykładzie poniżej.

```
import { Schema, StringSchema } from 'yup';

declare module 'yup' {
    interface StringSchema<T extends string | null | undefined = string>
        extends Schema<T> {
        validatePhone(
            msg?: string,
            strict?: boolean,
            country?: string,
        ): StringSchema<T>;
    }
}
```
