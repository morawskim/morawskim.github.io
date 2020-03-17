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
