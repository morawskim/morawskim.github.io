# Dropzone

`Dropzone` to popularna biblioteka do przesyłania plików.

Przykładowa konfiguracja:
```
Dropzone.autoDiscover = false;
const myDropzone = new Dropzone("div#dropzone", {
    url: `/upload-image`,
    paramName: "file",
    maxFilesize: 5, // MB
    addRemoveLinks: true,
    acceptedFiles: 'image/*',
});
myDropzone.on('removedfile', function (file) {
    if (file.status === "success") {
        removeFile(file.fileId);
    }
});
myDropzone.on('success', function (file, response) {
    file.fileId = response.fileId;
});
// myDropzone.on('error', function(file, data, response) {
//     if (true) {
//         const message = 'Extract message form data variable';
//         const msgEl = file.previewElement.querySelector('.dz-error-message');
//         msgEl.innerHTML = message;
//     }
// });

```

### Upload progress

Podczas przesyłania pliku możemy wyświetlić postęp przesyłania pliku. Musimy jedynie w konfiguracji przekazać funkcję do klucza `uploadprogress`. Jeśli plik jest mały a prędkość przesyłania danych jest wysoka to nasza funkcja zostanie od razu wywołana po przesłaniu całego pliku. Przesłanie pliku (postęp równy 100%) nie oznacza przetworzenie go po stronie serwera, które może także potrwać.

```
const myDropzone = new Dropzone("div#dropzone", {
    // ...
    uploadprogress: function(file, progress, bytesSent) {
        console.log(file, progress, bytesSent);
    }
});

myDropzone.on("totaluploadprogress", function (progress, totalBytes, sentBytes) {
    // ...
});
```

[How to show upload progress percentage in dropzone.js](https://newbedev.com/how-to-show-upload-progress-percentage-in-dropzone-js)

## Cypress

Aby przetestować upload pliku w cypress musimy zainstalować pakiet `cypress-file-upload`.
Następnie wykonujemy niezbędną [konfigurację](https://github.com/abramenal/cypress-file-upload#installation).
Musimy między innymi dodać definicję do pliku `tsconfig.json` czy też zaimportować bibliotekę w pliku `cypress/support/commands.ts`. Po tych krokach możemy korzystać z tej biblioteki.

Przykładowy test przesyłania pliku z wykorzystaniem dropzone. W katalogu `cypress/fixtures/` musimy mieć plik `picture.jpg`.
```
cy.intercept('POST', '/some/path/*/upload-image').as('upload');

const fileName = 'picture.jpg';
cy.get('.dropzone').attachFile(fileName, { subjectType: 'drag-n-drop' });
cy.wait('@upload');
```

### Cypress 9.3

W wersji 9.3 dodano polecenie `selectFile`, które umożliwia wybranie pliku w przypadku korzystania z elementu HTML5 albo skorzystania z symulacji przeciągnięcia pliku nad element.
Istnieje przewodnik [migracja z cypress-file-upload](https://docs.cypress.io/guides/references/migration-guide#Migrating-from-cypress-file-upload-to-selectFile).

Migracja:
```
// cypress-file-upload
cy.get('.dropzone')
    .attachFile('picture.jpg', { subjectType: 'drag-n-drop' });

// new cypress selectFile command
cy.get('.dropzone')
    .selectFile('cypress/fixtures/picture.jpg', {
        action: 'drag-drop',
    });
```

[API selectFile](https://docs.cypress.io/api/commands/selectfile)
[Uploading files made easy with the .selectFile command](https://cypress.io/blog/2022/01/18/uploading-files-with-selectfile/)

## Symfony

Symfony zawiera pakiet [ux-dropzone](https://github.com/symfony/ux-dropzone) do integracji dropzone. Jednak obecnie zainstalowanie tego pakietu powoduje problemy [[Dropzone] Impossible to install on SF4.4](https://github.com/symfony/ux/issues/66). Istnieje pull request, który może naprawić ten problem [Fix prepend twig extension](https://github.com/symfony/ux/pull/67/files).
