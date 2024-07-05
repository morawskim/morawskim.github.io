# Golang i WebAssembly

[Przykład](https://github.com/morawskim/go-projects/tree/main/webassembly)

## Konfiguracja GoLand dla WebAssembly

Tworząc projekt WebAssembly w GoLand przy imporcie pakietu `syscall/js` możemy otrzymać błąd:

![error build constraints goland i webassembly](./images/goland-webassembly/goland-webassembly-error.png)

W takim przypadku musimy w konfiguracji projektu `File -> Settings -> Go -> Build Tags` wybrać "js" dla "OS" o "wasm" dla Arch.

![konfiguracja goland i webassembly](./images/goland-webassembly/golang-webassembly.png)

[Configuring GoLand for WebAssembly (Wasm)](https://go.dev/wiki/Configuring-GoLand-for-WebAssembly)


## Promise

Wywołując funkcję `http.Get` w "eksportowanej" funkcji do JS otrzymamy błąd deadlcok - [runtime: wasm: fatal error: all goroutines are asleep - deadlock! #41310](https://github.com/golang/go/issues/41310). 

Zgodnie z [dokumentcją](https://pkg.go.dev/syscall/js#FuncOf):
> As a consequence, if one wrapped function blocks, JavaScript's event loop is blocked until that function returns. Hence, calling any async JavaScript API, which requires the event loop, like
> fetch (http.Client), will cause an immediate deadlock. Therefore a blocking function should explicitly start a new goroutine.

Rozwiązaniem jest wywołanie `http.Get` w nowej funkcji goroutine i skorzystanie z Promise.

```
// see https://github.com/golang/go/issues/41310
js.Global().Set("goFetch", js.FuncOf(func(this js.Value, args []js.Value) any {
    url := args[0].String()

    handler := js.FuncOf(func(this js.Value, args []js.Value) any {
        resolve := args[0]
        reject := args[1]

        go func() {
            r, err := http.Get(url)
            if err != nil {
                reject.Invoke(fmt.Sprintf("cannot send request: %s", err.Error()))
                return
            }

            defer r.Body.Close()
            body, err := io.ReadAll(r.Body)

            if err != nil {
                reject.Invoke(fmt.Sprintf("cannot read body: %s", err.Error()))
                return
            }

            resolve.Invoke(string(body))
        }()

        return nil
    })
    // Create and return the Promise
    promiseConstructor := js.Global().Get("Promise")
    return promiseConstructor.New(handler)
}))
```

## TinyGo

[Mój przykładowy projekt WebAssembly](https://github.com/morawskim/go-projects/tree/main/webassembly) po zbudowaniu przez kompilator go zajmuje niemal 9MB - `-rwxr-xr-x 1 marcin users 8,8M cze 30 11:51 functions.wasm`.
Jeśli chcemy znacząco zmniejszyć wynikowy plik to możemy skorzystać z kompilatora tinygo. 
W przypadku korzystania z dockera wywołujemy dwa polecenie:

```
docker run --rm -v $PWD:/app -w /app tinygo/tinygo:0.32.0 tinygo build -o ./assets/functions.wasm -target wasm --no-debug ./cmd/wasm
docker run --rm -v $(PWD):/app -w /app tinygo/tinygo:0.32.0 /bin/bash -c "cp /usr/local/tinygo/targets/wasm_exec.js ./assets/"
```

Wynikowy plik będzie miał rozmiar niecałych 800KB - `-rwxr-xr-x 1 marcin users 725K lip  4 16:34 functions.wasm`.
Niestety tinygo nie obsługuje wszystkiego - [syscall/js.finalizeRef not implemented](https://github.com/tinygo-org/tinygo/issues/1140)
