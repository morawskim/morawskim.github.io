# Design patterns - specification

Wzorca projektowego `specification` używamy, aby obudować regułę biznesową, która nie należy do encji lub obiektów wartości, ale jest do nich stosowana.

W projekcie implementowałem funkcjonalność podpowiadania zleceniodawców. Analityk biznesowy opracował tabele decyzyjną. Składała się ona z reguł, warunków i akcji. Reguła mogła się składać z jednego lub więcej warunków. W przypadku spełnienia wszystkich warunków, musiała się wykonać akcja np. wyświetlenia pełnomocnika lub zleceniodawcy.
Postanowiłem, więc wykorzystać wzorzec `specification` do obsługi tego wymagania.

Utworzyłem interfejs `RuleInterface`, który deklarował jedną publiczną metodę `isSatisfiedBy`. Przyjmowała ona jako argument model `TransactionModel`. Model ten to struktura, która przechowywała niezbędne dane do obliczeń.


``` php
interface RuleInterface
{
    public function isSatisfiedBy(TransactionModel $dataModel): bool;
}

``` php
class TransactionModel
{
    /**
     * @var array|null
     */
    private $participant;

    /** @var Disposition|NullDisposition */
    private $disposition;

    /** @var Commission|NullCommission */
    private $commission;

    /** @var ProxyDataItemDTO|null */
    private $proxyPersonData;

    // ....
```

Wszystkie warunki zaimplementowałem w formie klas. Niezbędne parametry/zależności były przekazywane przez konstruktor. Przykładowa reguła mogła wyglądać tak:

``` php
class DispositionTypeIn implements Condition
{
    private $allowedDispositionTypes;

    public function __construct(array $allowedDispositionTypes)
    {
        $this->allowedDispositionTypes = $allowedDispositionTypes;
    }

    public function isSatisfiedBy(TransactionModel $data): bool
    {
        return \in_array($data->getDisposition()->getDispositionType(), $this->allowedDispositionTypes, true);
    }
}
```

``` php
interface Condition
{
    public function isSatisfiedBy(TransactionModel $data) : bool;
}
```

Wszystkie klasy warunków musiały implementować interfejs `Condition`. Dodatkowo utworzyłem specjalne warunki, implementujące wzorzec `Compositor`. Za ich pomocą mogłem implementować logikę boolean (and, or, not).

``` php
class ConditionCompositorOr implements Condition
{
    /** @var Condition[] */
    private $conditions;

    public function __construct(Condition ...$conditions)
    {
        $this->conditions = $conditions;
    }

    public function isSatisfiedBy(TransactionModel $data) :bool
    {
        foreach ($this->conditions as $condition) {
            $result = $condition->isSatisfiedBy($data);
            if ($result) {
                return true;
            }
        }
        return false;
    }
}
```

Mając te wszystkie warunki zacząłem tworzyć klasy `Rule`. Klasy te musiały implementować interfejs `RuleInterface`.
W konstruktorze konfigurowałem wszystkie niezbędne warunki.

``` php
//budowa pierwszego warunku - zlecenie PE
$c1 = new ParticipantCustomerType(CustomerType::SHARED);
$c2 = new CommissionProductTypeIn([ProductType::PE]);
$c3 = new CommissionTypeIn(CommissionTypeVocabulary::PE_COMMISSIONS);
$c4 = new ConditionCompositorAnd($c1, $c2, $c3);

//budowa drugiego warunku - dyspozycje PE
$c5 = new DispositionProductTypeIn([ProductType::PSO]);
$c6 = new DispositionTypeIn(DispositionTypeVocabulary::PE_DISPOSITIONS);
$c7 = new ConditionCompositorAnd($c1, $c5, $c6);

$c8 = new ConditionCompositorOr($c4, $c7);

$this->setConditions([$c8]);
```

Posiadałem całą masę reguł (24 klas). Utworzyłem kolejną klasę, która implementowała wzorzec `Chain of responsibility`. Jeśli reguła była odpowiednia do obsługi danych wejściowych , zwracana była właśnie ta reguła.
W przypadku, gdy żadna reguła nie pasowała, mogłem zwrócić regułę fallback - w stylu `NullObject`.
Na końcu mając już odpowiednią regułę mogłem określić czy mogę wykonać specyficzną akcję. Klasy akcji dziedziczyły po klasie bazowej `ActionBase` i w zależności od zwracanej wartości `$rule->isSatisfiedBy($transactionModel)` podejmowałem decyzję o dalszych działaniach - np. wyświetleniu pełnomocnika czy też zleceniodawcy.
