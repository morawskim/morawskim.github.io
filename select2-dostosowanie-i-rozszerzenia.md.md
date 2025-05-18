# Select2 - zbudowanie własnej wersji

W jednym z projektów korzystaliśmy z biblioteki [Select2](https://select2.org/).
Potrzebowaliśmy przefiltrować opcje listy rozwijanej na podstawie przedziału dat (od–do), zamiast używać standardowego pola tekstowego do wyszukiwania.

Niestety, biblioteka Select2 nie umożliwia nadpisania domyślnego szablonu filtrowania opcji – [odpowiedzialny za to fragment](https://github.com/select2/select2/blob/595494a72fee67b0a61c64701cbb72e3121f97b9/src/js/select2/dropdown/search.js#L10) jest zakodowany na stałe.

Aby dostosować działanie filtrowania do naszych potrzeb, zdecydowałem się na modyfikację źródeł biblioteki i samodzielne jej zbudowanie.

Tworzymy plik `docker-compose.yml`:

```
services:
  nodejs:
    image: node:14.0
    working_dir: /home/node/app
    volumes:
        - ./:/home/node/app
    tty: true
    command: "bash"
```

Następnie klonujemy repozytorium Select2 i przełączamy się na odpowiednią wersję:

```
git clone https://github.com/select2/select2.git
cd select2
git checkout -b ver 4.0.13
```

Nanosimy swoje zmiany w kodzie źródłowym, pamiętając o zmianie nazwy pluginu jQuery, aby uniknąć konfliktów z innymi wersjami Select2 w projekcie.
Wracamy do katalogu wyżej - `cd ..`

Uruchamiamy kontener
```
docker compose up -d
docker compose exec nodejs bash
```

W kontenerze:
```
cd select2 && npm ci && npx grunt compile minify
```

Po zakończeniu budowania, zmodyfikowane pliki Select2 będą dostępne w katalogu `dist/`.
Można je skopiować i dołączyć do projektu jako niestandardową wersję biblioteki.

## Dekorator dropdownAdapter

Standardowa kontrolka Select2 umożliwia filtrowanie listy przez pole tekstowe.
W naszym projekcie potrzebowaliśmy zamiast tego dwóch pól umożliwiających wybór zakresu dat.

Po analizie [kodu źródłowego](https://github.com/select2/select2/blob/595494a72fee67b0a61c64701cbb72e3121f97b9/src/js/select2/dropdown/search.js#L10) okazało się, że nie da się tego uzyskać bez użycia adapterów i dekoratorów – mechanizmów rozszerzających zachowanie Select2 bez modyfikacji biblioteki - [Adapters and Decorators](https://select2.org/advanced/adapters-and-decorators)

Przykład:
```
export class Select2DropoffArchived {
    static setupSelect2DropoffArchived($select) {
        $.fn.select2.amd.require([
            'select2/dropdown',
            'select2/dropdown/search',
            'select2/dropdown/attachBody',
            'select2/dropdown/closeOnSelect',
            'select2/utils',
            'select2/selection/base',
        ], function (Dropdown, c, AttachBody, CloseOnSelect, Utils, Base) {
            // @see https://github.com/select2/select2/blob/9ce61fd297fd2922fe771debea8b24dfd219a49a/src/js/select2/selection/base.js#L118
            Base.prototype._attachCloseHandler =  function (container) {
                $(document.body).on('mousedown.select2.' + container.id, function (e) {
                    const $target = $(e.target);

                    // my code, ignore click within calendar, appendTo option in flatpickr
                    // append calendar to select2 container, but calendar has not been displayed
                    if ($target.closest('.flatpickr-calendar').length) {
                        e.stopPropagation();
                        return;
                    }

                    const $select = $target.closest('.select2');
                    const $all = $('.select2.select2-container--open');

                    $all.each(function () {
                        if (this == $select[0]) {
                            return;
                        }

                        const $element = Utils.GetData(this, 'element');
                        $element.select2('close');
                    });
                });
            };

            function FilterByDateRange() {}
            FilterByDateRange.prototype.render = function (decorated) {
                const $rendered = decorated.call(this);
                const $search = $(
                    '<span class="select2-search select2-search--dropdown">' +
                    '<div class="d-flex">' +
                    '<input type="text" class="form-control me-4" name="dateFrom" autocomplete="off" placeholder="Data od">'+
                    '<input type="text" class="form-control" name="dateTo" autocomplete="off" placeholder="Data do">'+
                    '</div>'+
                    '</span>'
                );

                this.$searchContainer = $search;
                this.$dateInputs = $search.find('input');
                this.$dateFrom = $search.find(':input[name="dateFrom"]');
                this.$dateTo = $search.find(':input[name="dateTo"]');
                $rendered.prepend($search);

                return $rendered;
            }

            FilterByDateRange.prototype.bind = function (decorated, container, $container) {
                const self = this;

                this.$searchContainer.find(':input').each(function () {
                    $(this).flatpickr({
                        dateFormat: "Y-m-d",
                        onValueUpdate: (selectedDates, dateStr, instance) => {
                            self.handleSearch();
                        },
                    });
                });

                decorated.call(this, container, $container);
                container.on('close', function () {
                    self.$dateInputs.val('');
                });
            };

            FilterByDateRange.prototype.handleSearch = function () {
                this.trigger('query', {
                    dateFrom: this.$dateFrom.val(),
                    dateTo: this.$dateTo.val(),
                });
            };

            // @see https://github.com/select2/select2/blob/595494a72fee67b0a61c64701cbb72e3121f97b9/src/js/select2/defaults.js#L141
            var DropdownAdapter = Utils.Decorate(
                Utils.Decorate(
                    Utils.Decorate(
                        Dropdown,
                        FilterByDateRange,
                    ),
                    AttachBody,
                ),
                CloseOnSelect
            );

            const options = {
                dropdownAdapter: DropdownAdapter,
                closeOnSelect: true,
                matcher: function (params, data) {
                    if (typeof data.text === 'undefined') {
                        return null;
                    }

                    let dateFrom, dateTo, createTime;

                    if (data.id) {
                        createTime = moment(data.text, 'YYYY-MM-DD');
                    }

                    if (params.dateFrom) {
                        dateFrom = moment(params.dateFrom, 'YYYY-MM-DD');
                    }

                    if (params.dateTo) {
                        dateTo = moment(params.dateTo, 'YYYY-MM-DD');
                    }

                    if (createTime && dateFrom && dateTo) {
                        return createTime.isBetween(dateFrom, dateTo, undefined, '[]') ? data : null;
                    }  else if (createTime&& dateFrom) {
                        return createTime.isSameOrAfter(dateFrom) ? data : null;
                    } else if (createTime && dateTo) {
                        return createTime.isSameOrBefore(dateTo) ? data : null;
                    } else {
                        return data;
                    }
                }
            }

            $select.select2(options);
        });
    }
}

```
