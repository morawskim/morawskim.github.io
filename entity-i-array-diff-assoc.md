# Entity i array_diff_assoc

Otrzymałem zadanie, aby w przypadku gdy wprowadzone zmiany nie wpływają na wyniki to nie wykonywać ponownie obliczeń. Sam algorytm ponownego obliczeń zajmował najczęściej około 3 minut. Musiałem porównać dane między dwoma encjami i na podstawie różnić (zmian) określić, czy niezbędne jest ponowne przeliczenie danych.

Wydzieliłem kod tworzenia encji z obiektu DTO. Posiadałem więc swój aktualny i zmodyfikowany obiekt encji. Następnie musiałem je porównać. Nie były to proste encje. Zawierały one referencje do innych encji a także przechowywały tablice. Musiałem zastosować rekurencyjne określenie różnić. Wbudowana funkcja PHP `array_diff_assoc` ze względu na brak wsparcia dla zagnieżdzonych struktur danych odpadała. Gotową funkcję dostarcza jednak CMS Drupal -  https://github.com/drupal/drupal/blob/4a68993cdf28620ac7856468037703de5997cbff/core/lib/Drupal/Component/Utility/DiffArray.php#L27
Dodałem do projektu tą klasę. Następnie musiałem zserializować swoją encję do tablicy PHP. Ostatecznie wystarczyło przekazać te dwie tablice do klasy Drupala. W wyniku otrzymałem tablicę z zmianami między strukturami, czyli naszymi encjami. Niżej zmodyfikowana metoda, określająca czy powiniśmy przeliczyć dane czy nie.

``` php
private function isRecalculationNeed(Audience $oldAudience, Audience $newAudience): bool
{
    $oldData = $serializer->toArray($audience);
    $newData = $serializer->toArray($newAudience);

    $diff = DiffArray::diffAssocRecursive($oldData, $newData);
    $difference = array_diff_key($diff, ['title' => 1, 'dailyRefresh' => 1, 'relativeDates' => 1, 'userNotifyFlag' => 1]);
    return count($difference) > 0;
}
```
