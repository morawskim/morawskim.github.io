Excel - osadzenie kolumny tekstowej bezpośrednio w pliku XML content
====================================================================

Biblioteka PHPExcel ułatwia generowanie dokumentów xlsx. Ma jednak jedną wadą. Całą strukturę dokumentu przechowuje w pamięci, aż do wywołania metody save. Powoduje to błędy z brakiem pamięci RAM. Zamiast ciągle zwiększać limit pamięci, postanowiłem samemu zbudować prostą bibliotekę w ramach jednego projektu. Domyślnie jeśli chcemy przechowywać ciąg znaków w pliku excela to musimy utworzyć oddzielny plik XML. A w wartości komórki przekazać identyfikator ciągu tekstowego. Istnieje też prosta opcja. Osadzenie tekstu inline. Plik wynikowy będzie większy jeśli tekst się pojawia wielokrotnie, ale prościej taki dokument wygenerować. Poniżej wycinek kodu, który buduje niezbędny element XML do osadzenia tekstu inline.

``` php
//gdzies indziej
//$columnLetter = PHPExcel_Cell::stringFromColumnIndex($columnIndex);
//$col = $columnLetter . $rowIndex;


/**
 * Generuje kolumne przechowujaca tekst
 *
 * @param ExcelValue $value
 * @param $col
 */
public function columnString(ExcelValue $value, $col)
{
    $this->xmlWriter->startElement('c');
    $this->xmlWriter->writeAttribute('r', $col);
    $this->xmlWriter->writeAttribute('t', 'inlineStr');


    $this->xmlWriter->startElement('is');
    $this->xmlWriter->startElement('r');
    $this->xmlWriter->startElement('t');
    $this->xmlWriter->writeAttribute('xml:space', 'preserve');
    $this->xmlWriter->writeRaw($value->getValue());
    $this->xmlWriter->endElement(); //end t
    $this->xmlWriter->endElement(); //end r
    $this->xmlWriter->endElement(); //end is

    $this->xmlWriter->endElement(); //end c
}
```