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

## Form themes

[W Dokumentacji](https://symfony.com/doc/current/form/form_themes.html) opisano jak działa mechanizm szablonów dla formularzy. W projekcie jeden formularz może znacząco się różnić od pozostałych np. logowania czy rejestracji.
W takim przypadku możemy nadpisać bloki formularza tylko dla jednego formularza. Do szablonu Twig dodajemy tag:

```
{% raw %}
{# the raw tag is only for fix build, this is not part of twig file #}
{% form_theme registrationForm _self %}
{% endraw %}
```

Dzięki temu Twig będzie szukał nadpisanych bloków formularza w szablonie. Zmienna `registrationForm` to nazwa formularza dostępna w szablonie Twig.

Profiler zawiera użyteczną informację jakie prefixy bloków są sprawdzane podczas wyświetlania formularza. Dzięki nim możemy utworzyć blok dla jednego specyficznego pola formularza.

Szablony dostarczane wraz z Symfony znajdują się w katalogu `vendor/symfony/twig-bridge/Resources/views/Form`.

## Wyświetlanie błędów bez przesłania formularza

[Display Symfony form errors, without any submit](https://jolicode.com/blog/display-symfony-form-errors-without-any-submit)

[[Form] Show errors even without submit #32336](https://github.com/symfony/symfony/issues/32336)

## Domyślna wartość dla pola, które nie zostało przesłane

```
$builder->add('foo', EnumType::class, [
    'enum_class' => PackingModeEnum::class,
])->addEventListener(FormEvents::PRE_SUBMIT, function (FormEvent $event) {
    $data = $event->getData();
    if (empty($data['foo'])) {
        $data['foo'] = (new FooEnum(FooEnum::DEFAULT_VALUE))->getValue();
    }

    $event->setData($data);
});
```
