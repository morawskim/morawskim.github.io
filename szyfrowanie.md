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

[Laurens Van Houtven (lvh), _Crypto 101_](https://github.com/crypto101/book/blob/fdd5dbbb02ebf3ed316f66db2af62dbad4e39455/src/stream-ciphers.rst#attacks-on-cbc-mode-with-the-key-as-the-iv)

* Szyfrowanie kluczem publicznym jest zbyt wolne do szyfrowania dużych ilości danych

> At face value, it seems that public-key encryption algorithms obsolete all our previous secret-key encryption algorithms. We could just use public key encryption for everything, avoiding all the added complexity of having to do key agreement for our symmetric algorithms. However, when we look at practical cryptosystems, we see that they're almost always hybrid cryptosystems: while public-key algorithms play a very important role, the bulk of the encryption and authentication work is done by secret-key algorithms.
> 
> By far the most important reason for this is performance. Compared to our speedy stream ciphers (native or otherwise), public-key encryption mechanisms are extremely slow. For example, with a 2048-bit (256 bytes) RSA key, encryption takes 0.29 megacycles, and decryption takes a whopping 11.12 megacycles. cryptopp:bench To put this into perspective, symmetric key algorithms work within an order of magnitude of 10 or so cycles per byte in either direction. This means it will take a symmetric key algorithm approximately 3 kilocycles in order to decrypt 256 bytes, which is about 4000 times faster than the asymmetric version

[Laurens Van Houtven (lvh), _Crypto 101_](https://github.com/crypto101/book/blob/fdd5dbbb02ebf3ed316f66db2af62dbad4e39455/src/public-key-encryption.rst#why-not-use-public-key-encryption-for-everything)

* Obecnie nie zaleca się używania MD5 do generowania podpisów cyfrowych

> Nowadays, it is not recommended to use MD5 for generating digital signatures, but it is important to note that HMAC-MD5 is still a secure form of message authentication; however, it probably shouldn't be implemented in new cryptosystems.

[Laurens Van Houtven (lvh), _Crypto 101_](https://github.com/crypto101/book/blob/fdd5dbbb02ebf3ed316f66db2af62dbad4e39455/src/hash-functions.rst#md5)

* SHA-1 nie jest już uważany za bezpieczny.

> Just like MD5, SHA-1 is no longer considered secure for digital signatures. Many software companies and browsers, including Google Chrome, have started to retire support of the signature algorithm of SHA-1.

[Laurens Van Houtven (lvh), _Crypto 101_](https://github.com/crypto101/book/blob/fdd5dbbb02ebf3ed316f66db2af62dbad4e39455/src/hash-functions.rst#sha-1)

* SHA-224 i SHA-256 zostały zaprojektowane dla 32-bitowych procesorów, a SHA-384 i SHA-512 dla 64-bitowych procesorów

> SHA-224 and SHA-256 were designed for 32-bit processor registers, while SHA-384 and SHA-512 for 64-bit registers. The 32-bit register variants will therefore run faster on a 32-bit CPU and the 64-bit variants will perform better on a 64-bit CPU.

[Laurens Van Houtven (lvh), _Crypto 101_](https://github.com/crypto101/book/blob/fdd5dbbb02ebf3ed316f66db2af62dbad4e39455/src/hash-functions.rst#sha-2)

* używanie kryptograficznego skrótu z unikalną solą dla każdego użytkownika jest trudniejsze do złamania, ale wcale nie bezpieczne

> Many systems used a single salt for all users. While that prevented an ahead-of-time rainbow table attack, it still allowed attackers to attack all passwords simultaneously, once they knew the value of the salt. An attacker would simply compute a single rainbow table for that salt, and compare the results with the hashed passwords from the database. While this would have been prevented by using a different salt for each user, systems that use a cryptographic hash with a per-user salt are still considered fundamentally broken today; they are just harder to crack, but not at all secure.
>
> Perhaps the biggest problem with salts is that many programmers were suddenly convinced they were doing the right thing. They'd heard of broken password storage schemes, and they knew what to do instead, so they ignored all talk about how a password database could be compromised. They weren't the ones storing passwords in plaintext, or forgetting to salt their hashes, or re-using salts for different users. It was all of those other people that didn't know what they were doing that had those problems. Unfortunately, that's not true. Perhaps that's why broken password storage schemes are still the norm.

[Laurens Van Houtven (lvh), _Crypto 101_](https://github.com/crypto101/book/blob/fdd5dbbb02ebf3ed316f66db2af62dbad4e39455/src/hash-functions.rst#salts)

* wyłączenie kompresji TLS zapobiega atakom CRIME

> In order to defend against CRIME, disable TLS compression. This is generally done in most systems by default.

[Laurens Van Houtven (lvh), _Crypto 101_](https://github.com/crypto101/book/blob/fdd5dbbb02ebf3ed316f66db2af62dbad4e39455/src/ssl-and-tls.rst#crime-and-breach)
