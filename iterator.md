# Iterator

Iterator to wzorzec projektowy, który pozwala nam uzyskać dostęp do wszystkich elementów kolekcji, bez ujawnienia sposobu przechowywania danych. Często jest więc wykorzystywany z rekurencją. W PHP implementujemy interfejs [Iterator](https://www.php.net/manual/en/class.iterator.php).

W przykładzie poniżej utworzyłem klasy `Order` i `OrderLine`. Obiekt `Order` możemy zawierać wiele obiektów `OrderLine`, które reprezentują zakupione produkty. Chcemy utworzyć iterator, do którego przekażemy nasze zamówienia, aby uzyskać dostęp do wszystkich zamówionych produktów.

``` php
<?php

class Order
{
    /** @var int|null */
    private $id;
    private $orderLines = [];

    /**
     * @return int|null
     */
    public function getId(): ?int
    {
        return $this->id;
    }

    /**
     * @param int $id
     * @return Order
     */
    public function setId(int $id): self
    {
        $this->id = $id;

        return $this;
    }

    public function addOrderLine(OrderLine $line): self
    {
        $this->orderLines[] = $line;

        return $this;
    }

    /**
     * @return array
     */
    public function getOrderLines(): array
    {
        return $this->orderLines;
    }
}

class OrderLine
{
    /** @var int */
    private $id;

    /** @var string */
    private $name;

    /** @var int */
    private $price;

    public function __construct(int $id, string $name, int $price)
    {
        $this->id = $id;
        $this->name = $name;
        $this->price = $price;
    }

    /**
     * @return int
     */
    public function getId(): int
    {
        return $this->id;
    }

    /**
     * @return string
     */
    public function getName(): string
    {
        return $this->name;
    }

    /**
     * @return int
     */
    public function getPrice(): int
    {
        return $this->price;
    }
}
```

Tworzymy teraz nasz iterator. Ponieważ przekazujemy tablicę obiektów `Order` to nasz iterator rozszerza klasę `ArrayIterator`. Implementujemy także interfejs [RecursiveIterator](https://www.php.net/manual/en/class.recursiveiterator.php), aby trawersować tylko obiekty `OrderLine`.


``` php
<?php

class OrderItemIterator extends ArrayIterator implements RecursiveIterator
{
    public function hasChildren()
    {
        $current = $this->current();

        return $current instanceof Order && !empty($current->getOrderLines());
    }

    public function getChildren()
    {
        return new OrderItemIterator($this->current()->getOrderLines());
    }

    public function key()
    {
        /** @var OrderLine $current */
        $current = $this->current();

        return $current->getId();
    }
}
```

Finalnie możemy przetestować iterator.

``` php
<?php

$order = new Order();
$order->setId(1)
    ->addOrderLine(new OrderLine(1, 'foo', 123))
    ->addOrderLine(new OrderLine(2, 'bar', 999));

$order2 = new Order();
$order2->setId(2)
    ->addOrderLine(new OrderLine(3, 'foo', 123))
    ->addOrderLine(new OrderLine(4, 'bar', 999))
    ->addOrderLine(new OrderLine(5, 'foobar', 499));


$iterator = new RecursiveIteratorIterator(new OrderItemIterator([$order, $order2]));

foreach ($iterator as $key => $item) {
    var_dump($item);
}

$array = iterator_to_array($iterator);
var_dump(count($array));
```
