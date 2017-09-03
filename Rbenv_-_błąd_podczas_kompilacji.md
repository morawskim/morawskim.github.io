Rbenv - błąd podczas kompilacji
===============================

Podczas kompilacji ruby 1.9.3-p374 otrzymałem błąd:

```
ossl_pkey_ec.c: In function ‘ossl_ec_group_initialize’:
ossl_pkey_ec.c:761:17: warning: implicit declaration of function ‘EC_GF2m_simple_method’ [-Wimplicit-function-declaration]
                 method = EC_GF2m_simple_method();
                 ^
ossl_pkey_ec.c:761:24: warning: assignment makes pointer from integer without a cast [enabled by default]
                 method = EC_GF2m_simple_method();
                        ^
ossl_pkey_ec.c:816:29: error: ‘EC_GROUP_new_curve_GF2m’ undeclared (first use in this function)
                 new_curve = EC_GROUP_new_curve_GF2m;
                             ^
ossl_pkey_ec.c:816:29: note: each undeclared identifier is reported only once for each function it appears in
Makefile:267: polecenia dla obiektu 'ossl_pkey_ec.o' nie powiodły się
```

Jest to znamy błąd - <https://bugs.ruby-lang.org/issues/8384> Musimy pobrać łatkę - <https://github.com/ruby/ruby/commit/0d58bb55985e787364b0235e5e69278d0f0ad4b0.patch> A następnie wywołujemy polecenie

``` bash
cat ruby.patch |filterdiff -x a/ChangeLog  | rbenv install --patch 1.9.3-p374
```