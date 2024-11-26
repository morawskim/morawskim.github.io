# Google Sheets i Apps Script

W Google Sheets uruchamialiśmy własną funkcję `myfunction` stworzoną w Apps Script, która łączyła się z API i pobrane dane wrzucała do arkusza kalkulacyjnego.
Stara wersja końcówki API wykonywała się długo i wywołując ją w arkuszu (`=myfunction()`) często otrzymywaliśmy błędy:

> Exceeded maximum execution time (line 0).

W [dokumentacji Return values](https://developers.google.com/apps-script/guides/sheets/functions#return_values) mamy punkt, że wywołanie funkcji (`=myfunction()`)
musi skończyć się w ciągu 30 sekund.

> A custom function call must return within 30 seconds. If it does not, the cell displays #ERROR! and the cell note is Exceeded maximum execution time (line 0).

Jednak wywołanie tej samej funkcji przez "przycisk" nie posiada takiego limitu.

Z menu Google Sheets klikamy na "Wstaw", a następnie na "Rysunek".

Wybieramy "Kształt" i z rozwijanego menu najeżdzamy na pozycję "Kształty" i wybieramy np. "prostokąt".

Po dodaniu, zaznaczamy kształt i kilkamy na 3 kropki w jego prawym górnym rogu i wybieramy pozycję "przypisz skrypt".

W polu tekstowym wpisujemy naszą utworzoną funkcję Apps Script `myfunction`.

Po kliknięciu w tak utworzony przycisk, pobieranie danych i załadowanie ich do arkusza mogło trwać nawet 180 sekund.

```
const API_URL = 'http://api.lvh.me';
const API_TOKEN = 'secret';

function toQueryString(obj) {
  var str = [];
  for (var p in obj)
    if (obj.hasOwnProperty(p)) {
      str.push(encodeURIComponent(p) + "=" + encodeURIComponent(obj[p]));
    }
  return str.join("&");
};


function myfunction(startDate, endDate) {
    const url = API_URL +'/v1/endpoint?'+toQueryString(filters);
    const options = {
      'method' : 'get',
      'contentType': 'application/json',
      'headers': {
          'Authorization': 'Bearer '+API_TOKEN
      }
    };
    const filters = {
      "start_date": startDate || '2024-07-01',
      "end_date": endDate || '2024-07-31',
    };


    const response = JSON.parse(UrlFetchApp.fetch(url, options));
    //console.log(response);
    let rows = [];

    for(let i in response.data) {
      let row = response.data[i];

      rows.push([
        // .....
      ]);
    }
    insertData(rows, rows[0].length ?? 0);
};


function insertData(values, numberOfColumns) {
  var sheet = SpreadsheetApp.getActiveSpreadsheet().getActiveSheet();
  var range = sheet.getRange(2, 1, values.length, numberOfColumns);
  range.setValues(values);
}

```
