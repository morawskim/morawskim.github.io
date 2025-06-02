# PDF

## Konwersja PDF (pierwsza strona) do pliku PNG

`convert -density 150 input.pdf[0] -quality 90 output.png`

## Zdejmowanie hasła z pliku PDF

`qpdf --password=<your-password> --decrypt /path/to/secured.pdf out.pdf`
