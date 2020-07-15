# React - snippets

## Przekazanie komponentu React w dół do komponentu potomnego jako prop w TypeScript

Deklarujemy interfejs `ContainerProps` w którym jedna z właściwości będzie typu `React.ReactNode` np:
```
interface ContainerProps {
  element: React.ReactNode;
}
```

Następnie definiujemy komponent np. `Container`:
```
export const Container: React.FC<ContainerProps> = props => {
  return (
    <div className="">
      Passed react component:
      <br />
      {props.element}
    </div>
  );
};
```

Finalnie możemy przekazać do naszego komponentu `Container` w prop `element` inny komponent:
```
<Container element={<PassComponent />} />
<Container element={<span>Passed</span>} />
```

[Demo online](https://codesandbox.io/s/react-pass-component-to-other-component-q6fff)

## ReactDOM.createPortal

Za pomocą portali możemy wyrenderować potomny komponent w innym węźle DOM, który istnieje poza hierarchią komponentu nadrzędnego. Komponent nadrzędny może przechwycić zdarzenia pochodzące z potomnych komponentów niezależnie od tego, czy został zaimplementowany przy użyciu portali.

[Demo online](https://codesandbox.io/s/6yx5o1qpz)

## create-react-app, proxy i ngrok

Aby skonfigurować serwer developerski, aby przekazywał wszystkie nieznane żądania do serwera API, dodajemy pole `proxy` w pliku `package.json` np. `"proxy": "http://192.168.0.109:8080"`.

Podczas wejścia na stronę udostępnioną przez `ngrok` dostaniemy stronę błędu z komunikatem `Invalid Host Header`.
Tworzymy plik `.env` w głównym katalogu projektu i ustawiamy zmienną środowiskową `DANGEROUSLY_DISABLE_HOST_CHECK`.

```
# NOTE: THIS IS DANGEROUS!
# It exposes your machine to attacks from the websites you visit.
DANGEROUSLY_DISABLE_HOST_CHECK=true
```

[https://create-react-app.dev/docs/proxying-api-requests-in-development](Proxying API Requests in Development)
