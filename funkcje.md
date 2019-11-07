# Funkcje

## Mapowanie zakresu liczbowego na inny

Jeśli mamy liczby x w zakresie `[a, b]`, i chcemy je przekształcić na liczby y w zakresie `[c, d]` to wystarczy użyć [wzoru](https://rosettacode.org/wiki/Map_range).

Przykładowa implementacja TypeScript
```
const rangeToAnother = (value: number, fromMin: number, fromMax: number, toMin: number, toMax: number) => {
    return toMin + (value - fromMin) * (toMax - toMin)/(fromMax - fromMin);
};
```
