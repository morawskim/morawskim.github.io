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

function randomIntFromInterval(min: number, max: number) {
  return Math.floor(Math.random() * (max - min + 1) + min);
}

## compose

``` javascript
const compose = arr => arr.reduce((a, b) => (...args) => a(b(...args)));
const myFuncs = [func1, func2, func3, func4];
const chain = compose(myFuncs);
```

Compose function is somethinh like `const composed = (...args) => func1(func2(func3(func4(...args))));`

## isBinaryFile - wykrywa, czy plik jest binarny

[https://github.com/gjtorikian/isBinaryFile](https://github.com/gjtorikian/isBinaryFile)

``` javascript
import * as fs from 'fs';
import { promisify } from 'util';

const statAsync = promisify(fs.stat);
const openAsync = promisify(fs.open);
const closeAsync = promisify(fs.close);

const MAX_BYTES = 512;

export async function isBinaryFile(file: string | Buffer, size?: number): Promise<boolean> {
  if (isString(file)) {
    const stat = await statAsync(file);

    isStatFile(stat);

    const fileDescriptor = await openAsync(file, 'r');

    const allocBuffer = Buffer.alloc(MAX_BYTES);

    // Read the file with no encoding for raw buffer access.
    // NB: something is severely wrong with promisify, had to construct my own Promise
    return new Promise((fulfill, reject) => {
      fs.read(fileDescriptor, allocBuffer, 0, MAX_BYTES, 0, (err, bytesRead, _) => {
        closeAsync(fileDescriptor);
        if (err) {
          reject(err);
        } else {
          fulfill(isBinaryCheck(allocBuffer, bytesRead));
        }
      });
    });
  } else {
    if (size === undefined) {
      size = file.length;
    }
    return isBinaryCheck(file, size);
  }
}

export function isBinaryFileSync(file: string | Buffer, size?: number): boolean {
  if (isString(file)) {
    const stat = fs.statSync(file);

    isStatFile(stat);

    const fileDescriptor = fs.openSync(file, 'r');

    const allocBuffer = Buffer.alloc(MAX_BYTES);

    const bytesRead = fs.readSync(fileDescriptor, allocBuffer, 0, MAX_BYTES, 0);
    fs.closeSync(fileDescriptor);

    return isBinaryCheck(allocBuffer, bytesRead);
  } else {
    if (size === undefined) {
      size = file.length;
    }
    return isBinaryCheck(file, size);
  }
}

function isBinaryCheck(fileBuffer: Buffer, bytesRead: number): boolean {
  // empty file. no clue what it is.
  if (bytesRead === 0) {
    return false;
  }

  let suspiciousBytes = 0;
  const totalBytes = Math.min(bytesRead, MAX_BYTES);

  // UTF-8 BOM
  if (bytesRead >= 3 && fileBuffer[0] === 0xef && fileBuffer[1] === 0xbb && fileBuffer[2] === 0xbf) {
    return false;
  }

  // UTF-32 BOM
  if (
    bytesRead >= 4 &&
    fileBuffer[0] === 0x00 &&
    fileBuffer[1] === 0x00 &&
    fileBuffer[2] === 0xfe &&
    fileBuffer[3] === 0xff
  ) {
    return false;
  }

  // UTF-32 LE BOM
  if (
    bytesRead >= 4 &&
    fileBuffer[0] === 0xff &&
    fileBuffer[1] === 0xfe &&
    fileBuffer[2] === 0x00 &&
    fileBuffer[3] === 0x00
  ) {
    return false;
  }

  // GB BOM
  if (
    bytesRead >= 4 &&
    fileBuffer[0] === 0x84 &&
    fileBuffer[1] === 0x31 &&
    fileBuffer[2] === 0x95 &&
    fileBuffer[3] === 0x33
  ) {
    return false;
  }

  if (totalBytes >= 5 && fileBuffer.slice(0, 5).toString() === '%PDF-') {
    /* PDF. This is binary. */
    return true;
  }

  // UTF-16 BE BOM
  if (bytesRead >= 2 && fileBuffer[0] === 0xfe && fileBuffer[1] === 0xff) {
    return false;
  }

  // UTF-16 LE BOM
  if (bytesRead >= 2 && fileBuffer[0] === 0xff && fileBuffer[1] === 0xfe) {
    return false;
  }

  for (let i = 0; i < totalBytes; i++) {
    if (fileBuffer[i] === 0) {
      // NULL byte--it's binary!
      return true;
    } else if ((fileBuffer[i] < 7 || fileBuffer[i] > 14) && (fileBuffer[i] < 32 || fileBuffer[i] > 127)) {
      // UTF-8 detection
      if (fileBuffer[i] > 193 && fileBuffer[i] < 224 && i + 1 < totalBytes) {
        i++;
        if (fileBuffer[i] > 127 && fileBuffer[i] < 192) {
          continue;
        }
      } else if (fileBuffer[i] > 223 && fileBuffer[i] < 240 && i + 2 < totalBytes) {
        i++;
        if (fileBuffer[i] > 127 && fileBuffer[i] < 192 && fileBuffer[i + 1] > 127 && fileBuffer[i + 1] < 192) {
          i++;
          continue;
        }
      }

      suspiciousBytes++;
      // Read at least 32 fileBuffer before making a decision
      if (i > 32 && (suspiciousBytes * 100) / totalBytes > 10) {
        return true;
      }
    }
  }

  if ((suspiciousBytes * 100) / totalBytes > 10) {
    return true;
  }

  return false;
}

function isString(x: any): x is string {
  return typeof x === 'string';
}

function isStatFile(stat: fs.Stats): void {
  if (!stat.isFile()) {
    throw new Error(`Path provided was not a file!`);
  }
}
```
