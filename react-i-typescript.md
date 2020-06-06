# React i TypeScript

Czasami musimy rozszerzyć lub ograniczyć typ właściwości komponentu (`props`).
Oczywistym rozwiązaniem jest wyeksportowanie tego typu. Jednak w przypadku zewnętrznych bibliotek nie jesteśmy w tanie tego dokonać. Plik definicji TS dla Reacta, umożliwia nam wyciągnięcie typu właściwości z komponentu.

```
type LoginFormProps = React.ComponentProps<typeof LoginForm>;
type Props = Omit<LoginFormProps, "onSuccessLogin">
```

W powyższym kodzie do typu `LoginFormProps` przypisujemy wszystkie właściwości komponentu `LoginForm`.
Mając taki typ możemy dodawać lub ujmować poszczególne właściwości. Jednak powyższe rozwiązanie nie działa w przypadku uogólnionych właściwości.

[Use lookup types for accessing component State/Props types](https://medium.com/@martin_hotell/10-typescript-pro-tips-patterns-with-or-without-react-5799488d6680)

[React & Redux in TypeScript - React.ComponentProps](https://github.com/piotrwitek/react-redux-typescript-guide#reactcomponentpropstypeof-xxx)
