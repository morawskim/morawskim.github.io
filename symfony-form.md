# Symfony Form

## EventSubscriberInterface

Z aplikacji zewnętrznej otrzymywałem adres rozliczeniowy, lecz brakowało adresu wysyłki. Za pomocą subskrypcji do zdarzenia `form.pre_submit` postanowiłem ustawiać adres wysyłki na podstawie adresu rozliczeniowego.

Utworzyłem subskrybent zdarzeń `SetShippingAddressFromBillingAddressListener`, która implementowała domyślny interfejs Symfony `Symfony\Component\EventDispatcher\EventSubscriberInterface` i rejestrowała się pod zdarzenie `form.pre_submit`. W metodzie, która obsługuje zdarzenie utworzyłem implementację algorytmu. W przypadku braku danych w kluczu `shippingAddress` kopiowałem dane z `billingAddress` z niewielkimi zmianami (nie wszystkie pola były potrzebne).
Następnie w formularzu dodałem nasłuchiwacza - `$builder->addEventSubscriber(new SetShippingAddressFromBillingAddressListener());`.

Utworzyłem także test jednostkowy do sprawdzenia kilku przypadków brzegowych. Wzorowałem się na [testach wbudowanych nasłuchiwaczy Symfony.](https://github.com/symfony/form/blob/693154d88264468a1a965a2e60de7a0048928dc1/Tests/Extension/Core/EventListener/TrimListenerTest.php)

```
$expectedShippingAddress = [];

$data = [
    // ....
    'shippingAddress' => [
        // ....
    ],
    'billingAddress' => [
        // ....
    ],
];
$form = new Form(new FormConfigBuilder('name', null, new EventDispatcher()));
$event = new PreSubmitEvent($form, $data);

$filter = new SetShippingAddressFromBillingAddressListener();
$filter->preSubmit($event);

self::assertEquals($expectedShippingAddress, $event->getData()['shippingAddress']);
```

[How to Dynamically Modify Forms Using Form Events](https://symfony.com/doc/4.4/form/dynamic_form_modification.html)
