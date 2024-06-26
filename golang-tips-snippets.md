# Golang tips i snippets

## Context value i własny typ

Kontekst może przenosić różne wartości. Klucz i wartość mogą być dowolnego typu.
Możemy skorzystać z ciągu znakowego jako klucz, ale w takim przypadku ryzykujemy, że inny pakiet
ustawi wartość w kontekście wykorzystując ten sam ciąg znaków jako klucz.
Możemy się przed tym zabezpieczyć tworząc własny typ.

```
type ctxKey string

const traceIdCtxKey ctxKey = "traceId"

func usageContextKey() {
	ctx := context.WithValue(context.Background(), traceIdCtxKey, "some-id")
	traceId := ctx.Value(traceIdCtxKey).(string)
	fmt.Println(traceId)
}
```

## JSON encode/decode - pomocnicza funkcja

```
func encode[T any](w http.ResponseWriter, r *http.Request, status int, v T) error {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	if err := json.NewEncoder(w).Encode(v); err != nil {
		return fmt.Errorf("encode json: %w", err)
	}
	return nil
}

func decode[T any](r *http.Request) (T, error) {
	var v T
	if err := json.NewDecoder(r.Body).Decode(&v); err != nil {
		return v, fmt.Errorf("decode json: %w", err)
	}
	return v, nil
}
```

## Weryfikacja zgodności interfejsu

Jeśli nasz typ "implementuje" interfejs `fmt.Stringer`, ale w ramach refactoringu
skasujemy tą metodę to kompilator Go może nie zwrócić żadnego błędu.

Rozwiązaniem tego problemu jest utworzenie zmiennej o typie implementowanego interfejsu i przypisanie do niej pustej wartości typu, który powinien implementować ten interfejs.

`var _ fmt.Stringer = User{} // User musi implementowac interfejs fmt.Stringer`

[Demo](https://go.dev/play/p/cEBSKBrjHqm)

[Compile time checks to ensure your type satisfies an interface](https://medium.com/@matryer/golang-tip-compile-time-checks-to-ensure-your-type-satisfies-an-interface-c167afed3aae)
