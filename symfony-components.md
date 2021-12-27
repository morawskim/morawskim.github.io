# Symfony komponenty

## Lock

W ramach integracji między aplikacją, a bramką płatności Stripe przypisywałem karty kredytowe do utworzonego klienta w Stripe. W tabeli przechowywałem powiązanie między identyfikatorem klienta w Stripe, a kontem użytkownika aplikacji. W trakcie sprawdzania, czy klient ma założone konto w Stripe, może dojść do wyścigu. Prócz dodania indeksu unikalności na kolumnie `customer_id` wykorzystałem także komponent [Lock](https://symfony.com/doc/current/components/lock.html) do tworzenia blokad.

Jak każdy komponent jest on domyślnie zintegrowany z Symfony. Po instalacji w pliku `config/packages/lock.yaml` dodajemy tzw. [named lock](https://symfony.com/doc/current/lock.html#named-lock)

```
framework:
    lock:
        stripe: ['%env(REDIS_DSN)%']
```

Wywołując polecenia `./bin/console debug:container lockFactory` powinniśmy ujrzeć zarejestrowaną fabrykę (`\Symfony\Component\Lock\LockFactory $stripeLockFactory`), którą wstrzykujemy do usługi. Fragment metody usługi:

```
$lock = $this->stripeLockFactory->createLock('stripe_lock_' . $accountId);

if (!$lock->acquire()) {
    throw ConflictException::lockAcquireFail($accountId);
}

# ...

try {
    # ...
} catch (CardException $e) {
    # ...
} catch (ApiErrorException $e) {
    # ...
} finally {
    $lock->release();
}
```
