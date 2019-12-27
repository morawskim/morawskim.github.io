# Funkcje

## Mapowanie zakresu liczbowego na inny

Jeśli mamy liczby x w zakresie `[a, b]`, i chcemy je przekształcić na liczby y w zakresie `[c, d]` to wystarczy użyć [wzoru](https://rosettacode.org/wiki/Map_range).

Przykładowa implementacja TypeScript
```
const rangeToAnother = (value: number, fromMin: number, fromMax: number, toMin: number, toMax: number) => {
    return toMin + (value - fromMin) * (toMax - toMin)/(fromMax - fromMin);
};
```

## travis_retry - ponawiaj  polecenie do trzech razy jeśli kod powrotu nie jest równy zero

https://github.com/travis-ci/travis-build/blob/4f580b238530108cdd08719c326cd571d4e7b99f/lib/travis/build/bash/travis_retry.bash

``` bash
travis_retry() {
  local result=0
  local count=1
  while [[ "${count}" -le 3 ]]; do
    [[ "${result}" -ne 0 ]] && {
      echo -e "\\n${ANSI_RED}The command \"${*}\" failed. Retrying, ${count} of 3.${ANSI_RESET}\\n" >&2
    }
    "${@}" && { result=0 && break; } || result="${?}"
    count="$((count + 1))"
    sleep 1
  done

  [[ "${count}" -gt 3 ]] && {
    echo -e "\\n${ANSI_RED}The command \"${*}\" failed 3 times.${ANSI_RESET}\\n" >&2
  }

  return "${result}"
}
```

Przykładowe użycie `travis_retry composer install`

## shuffle

```
function shuffle<T>(array: Array<T>): Array<T> {
    let count = array.length;
    let rnd, temp;

    while (count) {
        rnd = Math.floor(Math.random() * count--);
        temp = array[count];
        array[count] = array[rnd];
        array[rnd] = temp;
    }
    return array;
}
```

Użycie:
```
console.log(shuffle([1,2,3,4,5]));
// output
// [ 5, 1, 4, 3, 2 ]
```
