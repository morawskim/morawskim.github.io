# Golang i WebAssembly

[Przykład](https://github.com/morawskim/go-projects/tree/main/webassembly)

## Konfiguracja GoLand dla WebAssembly

Tworząc projekt WebAssembly w GoLand przy imporcie pakietu `syscall/js` możemy otrzymać błąd:

![error build constraints goland i webassembly](./images/goland-webassembly/goland-webassembly-error.png)

W takim przypadku musimy w konfiguracji projektu `File -> Settings -> Go -> Build Tags` wybrać "js" dla "OS" o "wasm" dla Arch.

![konfiguracja goland i webassembly](./images/goland-webassembly/golang-webassembly.png)

[Configuring GoLand for WebAssembly (Wasm)](https://go.dev/wiki/Configuring-GoLand-for-WebAssembly)
