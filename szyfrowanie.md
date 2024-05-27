# Szyfrowanie

## Crypto 101

* Szyfrowanie blokowe ECB jest uważane za niebezpieczne.

> For reasons we already discussed, ECB mode is insecure. Fortunately, plenty of other choices exist.

[Laurens Van Houtven (lvh), _Crypto 101_](https://github.com/crypto101/book/blob/fdd5dbbb02ebf3ed316f66db2af62dbad4e39455/src/stream-ciphers.rst#block-cipher-modes-of-operation)

* IV (initialization vectors) nie musi być trzymany w tajemnicy

> Instead, we select an IV: a random block in place of the “first” ciphertext. initialization vectors also appears in
> many algorithms. An initialization vector should be unpredictable, ideally, cryptographically random. IVs do not have
> to be kept secret: they are typically just added to ciphertext messages in plaintext.

[Laurens Van Houtven (lvh), _Crypto 101_](https://github.com/crypto101/book/blob/fdd5dbbb02ebf3ed316f66db2af62dbad4e39455/src/stream-ciphers.rst#cbc-mode)

* nie używaj klucza jako IV

> Lesson learned: don't use the key as an IV.

[Laurens Van Houtven (lvh), _Crypto 101_]([Laurens Van Houtven (lvh), _Crypto 101_](https://github.com/crypto101/book/blob/fdd5dbbb02ebf3ed316f66db2af62dbad4e39455/src/stream-ciphers.rst#attacks-on-cbc-mode-with-the-key-as-the-iv)
