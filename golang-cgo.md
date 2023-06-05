# Go i cgo

## Pakiet C

W celu integracji kodu Go z C korzystamy z pseudo pakietu "C".
W kodzie Go możemy wtedy odwoływać się do typów/struktur/funkcji takich jak np. C.int, c.struct_<NAZWA>, C.puts.


| C | Go |
| - | - |
| Funkcja C np. puts | `C.puts()` |
| Typ int w C | `C.int(20)` |
| Typ struct T | `C.struct_T` |
| Wielkość typu T | `C.sizeof_T` np. `C.sizeof_struct_T` |
| Ciąg znaków | `C.CString("Hello")` Do konwersji ciągu znaków C (char*) do typu string Go korzystamy z funkcji `C.GoString(str)` |


Każda alokacja pamięci dokonana przez kod C nie jest znana menedżerowi pamięci Go.
Dlatego musimy pamiętać o zwolnieniu pamięci, wywołując `C.free`.

```
// Go string to C string
// The C string is allocated in the C heap using malloc.
// It is the caller's responsibility to arrange for it to be
// freed, such as by calling C.free (be sure to include stdlib.h
// if C.free is needed).
func C.CString(string) *C.char

// Go []byte slice to C array
// The C array is allocated in the C heap using malloc.
// It is the caller's responsibility to arrange for it to be
// freed, such as by calling C.free (be sure to include stdlib.h
// if C.free is needed).
func C.CBytes([]byte) unsafe.Pointer

// C string to Go string
func C.GoString(*C.char) string

> // C data with explicit length to Go string
func C.GoStringN(*C.char, C.int) string

// C data with explicit length to Go []byte
func C.GoBytes(unsafe.Pointer, C.int) []byte
```

[C? Go? Cgo!](https://go.dev/blog/cgo)

[cgo](https://pkg.go.dev/cmd/cgo)

## GDB

Do debugowania kodu C potrzebujemy gdb. Na ten moment Delve nie wspiera C.
Podczas budowania należy ustawić poniższe flagi kompilatora GCC: 

```
-g - dołącza symbole debugowania
-O0 - wyłącza optymalizacje kodu
```

Wystarczy ustawić zmienne środowiskowe CGO_CFLAGS/CGO_CPPFLAGS - `CGO_CFLAGS="-g -O0" CGO_CPPFLAGS="-g -O0" go build -gcflags "all=-N -l"`

Pod zbudowaniu, uruchamiamy polecenie `gdb ./sciezka/do/pliku/wykonywalnego/aplikacji/cgo`. Powinniśmy widzieć symbol zachęty gdb. Aby ustawić punkt wstrzymania (ang. breapoint), gdy wywoływana jest funkcja C "nazwa_funkcji_c", wydajemy polecenie `break nazwa_funkcji_c`. Następnie uruchamiamy program wpisując `run`:

> Reading symbols from ./XXXX... 
>
> Loading Go Runtime support.


Podczas startu gdb możemy zobaczyć komunikaty (na przykład w dystrybucji Ubuntu):

```
/usr/share/go-1.19/src/runtime/runtime-gdb.py" auto-loading has b
een declined by your `auto-load safe-path' set to "$debugdir:$datadir/auto-load"
.                                                                               
To enable execution of this file add                                            
add-auto-load-safe-path /usr/share/go-1.19/src/runtime/runtime-gdb.py   
line to your configuration file "/home/XXXX/.gdbinit".
```

W takim przypadku zgodnie z tym co zostało wyświetlane dodajemy do pliku `~/.gdbinit` linie `add-auto-load-safe-path /usr/local/go/src/runtime/runtime-gdb.py` na przykład poleceniem `echo add-auto-load-safe-path /usr/local/go/src/runtime/runtime-gdb.py >> ~/.gdbinit`.

Po ponownym uruchomieniu gdb powinniśmy już widzieć komunikat:
> Loading Go Runtime support.
