## Web Cryptography API

Obecnie w przeglądarkach mamy dostęp do [Web Cryptography API](https://caniuse.com/cryptography).
Za pomocą tego API możemy odszyfrować dane po stronie klienta.

Tworzymy prosty skrypt PHP, który zaszyfruje w tym przykładzie frazę "hello world" (może to być także zawartość pliku) wykorzystując algorytm "aes-256-cbc" i symetryczny klucz "secretpassword".

```php
<?php

$iv = openssl_random_pseudo_bytes(openssl_cipher_iv_length("aes-256-cbc"));
$encryptedFile = openssl_encrypt("hello world", "aes-256-cbc", "secretpassword", 0, $iv);
echo json_encode(["encrypted" => $encryptedFile, "iv" => base64_encode($iv)]);
```

W wyniku działania tego skryptu otrzymamy obiekt JSON z kluczami "encrypted" i "iv".

Tworzymy skrypt JavaScript.
Zaczynamy od utworzenia funkcji do utworzenia klucza symetrycznego do odszyfrowania danych:

```
async function generateKey(passphrase) {
    const encoder = new TextEncoder();
    const keyData = encoder.encode(passphrase);

    const paddedKeyData = new Uint8Array(32); // 32 bytes for AES-256
    paddedKeyData.set(keyData);

    return await window.crypto.subtle.importKey(
        'raw',
        paddedKeyData,
        {
            name: 'AES-CBC',
            length: 256
        },
        true,
        ['decrypt']
    )
}
```

Tworzymy także pomocniczą funkcję do odkodowania zaszyfrowanego tekstu.

```
async function decryptData(key, encryptedData, iv) {
    const decryptedData = await window.crypto.subtle.decrypt(
        {
            name: 'AES-CBC',
            iv: iv,
            length: 256,
        },
        key,
        encryptedData
    );
    return new TextDecoder().decode(decryptedData);
}
```

Następnie musimy w jakiś sposób pobrać zaszyfrowane dane.
Mając nasz obiekt musimy odkodować wektor inicjujący IV z kodowania base64 - `const iv = Uint8Array.from(atob(encryptedObject.iv), c => c.charCodeAt(0))`.

Możemy odszyfrować nasze dane. PHP domyślnie zwraca zaszyfrowane dane w kodowaniu base64, więc ponownie musimy je odkodować i przekazać do utworzonej funkcji `decryptData`

```
const data = await decryptData(
    key,
    Uint8Array.from(atob(encryptedObject.encrypted), c => c.charCodeAt(0)),
    iv
);
```

W zmiennej `data` będziemy mieć odszyfrowany ciąg znaków.

Pełen przykład odszyfrowania zawartości pliku:
```
fetch('./encrypted-file')
.then((r) => r.json())
.then(async ({iv: ivBase64 , encrypted}) => {
    const key = await generateKey('pobierz-haslo-od-uzytkownika-i-wstaw-je-tutaj');
    const iv = Uint8Array.from(atob(ivBase64), c => c.charCodeAt(0));
    const data = await decryptData(
        key,
        Uint8Array.from(atob(encrypted), c => c.charCodeAt(0)),
        iv
    );

    return JSON.parse(data);
})
```
