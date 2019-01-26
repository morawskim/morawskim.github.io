# angular - snippets

## md error: long error messages overlap input fields

Zgodnie z zgłoszeniem https://github.com/angular/material2/issues/4580 material ma problem z wyświetlaniem długich komunikatów walidacji. Użytkownik blyndcide podał rozwiązanie dla wersji 6 (https://github.com/angular/material2/issues/4580#issuecomment-386759677).

```
mat-form-field .mat-form-field {
  &-underline {
    position: static;
  }
  &-subscript-wrapper {
    position: static;
  }
}
```

## material datepicker i błędy walidacji

Kontrolka datepicker w pakecie `angular/matieral2` posiada wbudowaną walidację.
Aby włączyć walidację musimy do naszego elementu input dodać atrybuty: `matDatepickerFilter`, `min` lub `max`.
Wykorzystywane są następujące klucze błędów:

```
<mat-error *ngIf="resultPickerModel.hasError('matDatepickerParse')">
  "{{resultPickerModel.getError('matDatepickerParse').text}}" is not a valid date!
</mat-error>
<mat-error *ngIf="resultPickerModel.hasError('matDatepickerMin')">Too early!</mat-error>
<mat-error *ngIf="resultPickerModel.hasError('matDatepickerMax')">Too late!</mat-error>
<mat-error *ngIf="resultPickerModel.hasError('matDatepickerFilter')">Date unavailable!</mat-error>
```
