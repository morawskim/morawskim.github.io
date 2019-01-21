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
