# Flatpickr

Flatpickr to lekka i konfigurowalna biblioteka JavaScript służąca do tworzenia nowoczesnych pól wyboru daty i czasu (datepickerów).

Dokumentacja: [https://flatpickr.js.org](https://flatpickr.js.org)

## Wyróżnienie konkretnej daty w kalendarzu

W ramach projektu pojawiła się potrzeba wyróżnienia konkretnej daty w komponencie datapickera.

```
const myDateTimestampInMillisecond = 1748563200000;
const $el = $('[data-role="datepicker"]');

$el.flatpickr({
    // ...
    onDayCreate: function(dObj, dStr, fp, dayElem) {
        if (+dayElem.dateObj === myDateTimestampInMillisecond) {
            dayElem.classList.add("our-css-class-name");
        }
    },
});
```

## Dodaj klasę do elementu flatpickr-calendar

W trakcie prac nad projektem pojawiła się potrzeba dostosowania wyglądu tylko jednego, konkretnego datapickera, bez wpływu na pozostałe instancje Flatpickr użyte w aplikacji.

```
const $el = $('[data-role="datepicker"]');

$el.flatpickr({
    // ...
    onReady (_, __, fp) {
        fp.calendarContainer.classList.add("myClass");
    },
});
```
