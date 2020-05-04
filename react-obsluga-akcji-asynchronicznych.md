# React - obsługa akcji asynchronicznych

Wywołując w komponentach React akcje asynchroniczne np. pobieranie danych z API musimy uważać na dwa główne problemy:

* odmontowanie komponentu, przed zakończeniem asynchronicznej akcji
* zmiany stanu/props wywołują akcje asynchroniczne, których kolejność zakończenia nie jest gwarantowana (wyścigi)

W przypadku pierwszego problemu React w konsoli wyświetli nam błąd:
>Warning: Can’t perform a React state update on an unmounted component. This is a no-op, but it indicates a memory leak in your application.

Z drugim problemem często możemy się spotkać przy wyszukiwaniu danych. Gdy szukamy po frazie `foo`, a następnie `bar`, możemy dostać wyniki pasujące do frazy `foo`. Akcje asynchroniczne mogą zakończyć się w dowolnej kolejności. Musimy więc wcześniejsze wywołania anulować.

Możemy implementować [własne rozwiązanie](https://dev.to/alexandrudanpop/correctly-handling-async-await-in-react-components-4h74), jednak istnieje do tego biblioteka `react-async`.

Korzystając z `react-async` dostaniemy:

* automatyczne anulowanie żądań HTTP, gdy zmienią się parametry
* automatyczne pobieranie danych z końcówki, jeśli zmieniły się parametry
* przekazywanie statusu (isPending, error)


```
const PostFetch = ({ postId }) => {
  const { data, error, isPending } = useAsync({
    promiseFn: fetchPost,
    postId,
    watch: postId
  });

  if (isPending) return "Loading...";
  if (error) return `Something went wrong: ${error.message}`;
  if (data) return <PostComponent post={data} />;
  return null;
};

export default PostFetch;
```

[Demo react-async](https://codesandbox.io/s/react-async-ei2c2)

[Dokumentacja](https://docs.react-async.com/)
