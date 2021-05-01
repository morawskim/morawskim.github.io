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

## Symfony

Symfony zawiera pakiet [ux-dropzone](https://github.com/symfony/ux-dropzone) do integracji dropzone. Jednak obecnie zainstalowanie tego pakietu powoduje problemy [[Dropzone] Impossible to install on SF4.4](https://github.com/symfony/ux/issues/66). Istnieje pull request, który może naprawić ten problem [Fix prepend twig extension](https://github.com/symfony/ux/pull/67/files).
