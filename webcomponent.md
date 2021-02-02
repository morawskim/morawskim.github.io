# WebComponent

Web komponenty mogą korzystać z ShadowDOM przez co możemy je łatwo odizolować od reszty strony.

## CSS

Style zdefiniowane poza Shadow DOM mają wpływ na webcomponent. Dzięki temu definicja np. kroju czcionki jest spójna. Możemy zresetować wszystkie odziedziczone style:

```
:host {
  all: initial;
}
```

Pseudo klasa `:host-context` jest obecnie obsługiwana przez Chrome, ale nie powiniśmy z niej powinniśmy, ponieważ jest oznaczona jako przestarzała funkcja.

## Zdarzenia

Nie wszystkie zdarzenia przekraczają granicę Shadow DOM. Zdarzenia związane z interfejsem użytkownika przekraczają granicę Shadow DOM. Zdarzenia `CustomEvent` domyślnie nie przekroczą granicy web komponentu. Możemy zmienić te zachowanie ustawiając flagę `composed` na wartość `true`. Chcą propagować zdarzenia do elementu `window` niezbędne będzie ustawienie też flagi `bubbles` na wartość `true`. Nie ma za to różnicy przy nasłuchiwaniu na zdarzenia.

Mamy kilka możliwości na poinformowaniu komponentu o akcji w celu aktualizacji wewnętrznego stanu.

Możemy skorzystać z atrybutów. Gdy nasz komponent posiada metodę `attributeChangedCallback` każda zmiana obserwowanego atrybutu (implementując statyczną metodę `observedAttributes` zwracamy atrybuty do obserwacji).

```
class TestAttributes extends HTMLElement {
  static get observedAttributes() {
    return ['foo'];
  }

  connectedCallback() {
    this.update();
  }

  attributeChangedCallback(attributeName, oldValue, newValue) {
    console.log(`Attribute ${attributeName} has changed from ${oldValue} to ${newValue}`);
    this.update();
  }

  update() {
    this.innerHTML = this.foo;
  }

  get foo() {
    return this.getAttribute('foo');
  }

  set foo(val) {
    this.setAttribute('foo', val);
  }
}
customElements.define('test-attributes', TestAttributes);

document.querySelector('#btn').addEventListener('click', e => {
 document.querySelector('test-attributes').foo = document.querySelector('#input').value;
});
```

```
<div>
  <test-attributes foo="bar">web components not supported</test-attributes>
</div>

<label for="input">Attribute value:</label>
<input id="input" type="text" />
<button type="button" id="btn">Update attribute</button>
```

Inną opcją jest zdefiniowanie metody w klasie komponentu.

```
class TestComponent extends HTMLElement {
  doSomething() {
    console.log("Method doSomething on webcomponent was called");
  }
}
customElements.define('test-component', TestComponent);

// pozniej: document.querySelector('test-component').doSomething();

```

Kolejną opcją to publikowanie zdarzenia na obiekcje `window` i podłączenie się do tego zdarzenia w webkomponencie. Dobrą praktyką jest publikowania takiego zdarzenia nie bezpośrednio na obiekcje `window`, ale na elemencie, który odpowiada ze generowanie zdarzenia. Dzięki takiemu rozwiązaniu będziemy w stanie blokować zdarzenia zanim dotrą do `window`.

```
class TestComponent extends HTMLElement {
  connectedCallback() {
    window.addEventListener('testevent', (e) => {
      console.log('Something has happened', e.detail);
    });
  }

}
customElements.define('test-webcomponent', TestComponent);

document.querySelector('#sendEvent').addEventListener('click', e => {
 e.target.dispatchEvent(new CustomEvent('testevent', { composed: true, bubbles: true, detail: "test event!"}));
});
```

```
<test-webcomponent>Hello</test-webcomponent>
<button type="button" id="sendEvent">Send event</button>
```

[DEMO](https://codepen.io/morawskim/pen/dypqaZo?editors=1111)
