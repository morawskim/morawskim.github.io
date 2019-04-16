# CKEditor - snippets

## Disabling content filtering

Edytory WYSIWYG filtrują kod HTML. Jeśli w naszym fragmencie HTML, będą jakieś dodatkowe atrybuty np. dodatkowe klasy CSS, to zostaną one skasowane. Możemy także zamiast wyłączać w pełni tą funkcjonalność, skonfigurować białą listę dozwolonych klas CSS.

W celu pełnego wyłączenia filtrowania kodu HTML ustawiamy parametr `allowedContent` jak poniżej
```
config.allowedContent = true;
```

Aby zezwolić elementowi `div` na posiadanie klasy CSS `row` ustawiamy parametr `extraAllowedContent` jak poniżej
```
config.extraAllowedContent = 'div(row)';
```

Więcej informacji:
https://ckeditor.com/docs/ckeditor4/latest/guide/dev_acf.html
https://ckeditor.com/docs/ckeditor4/latest/guide/dev_advanced_content_filter.html
