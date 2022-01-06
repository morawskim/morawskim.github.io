# Cypress E2E testy bibliotek

## API i upload pliku (FormData)

Cypress nie umożliwia nam wysyłanie obiektu FormData przez `cy.request` ([Posting formData using cypress doesn't work #1647](https://github.com/cypress-io/cypress/issues/1647)). Musimy skorzystać z XMLHttpRequest.
W pliku `support/commands.ts` dodajemy definicję polecenia `uploadFile`.

```
Cypress.Commands.add('uploadFile', (blob: Blob, fileName: string, jwt: string) => {
    Cypress.log({
        name: 'apiUploadFile',
        displayName: 'API Upload file',
        message: `Upload file"`,
        consoleProps: () => {
            return {
                'file': blob,
            }
        }
    });

    const formData = new FormData();
    formData.set('file', blob, fileName);

    const xhr = new XMLHttpRequest();
    xhr.open("POST", "/api/files/upload");
    xhr.setRequestHeader('Authorization', `Bearer ${jwt}`)

    return new Cypress.Promise((resolve, reject) => {
        xhr.onload = function () {
            resolve(xhr);
        };
        xhr.onerror = function () {
            resolve(xhr);
        };

        xhr.send(formData);
    })
})
```
W pliku `support/index.d.ts` dodajemy deklarację naszej metody dla TS.
```
/// <reference types="cypress" />

declare namespace Cypress {
    interface Chainable {
        uploadFile(blog: Blob, fileName: string, token: string): Chainable<XMLHttpRequest>;
    }
}
```

Następnie tworzymy test. Z fixtures pobieramy plik i korzystając z nowego polecenia cypress `uploadFile` przesyłamy plik na serwer.

```
const fileName = 'huge.jpg';

cy.fixture(fileName, 'binary')
    .then(Cypress.Blob.binaryStringToBlob)
    .then( (blob) => {
        cy.uploadFile(blob, fileName, token).then(response => {
            expect(response.status).to.eq(201);
        });
    });
```

## Stripe

Aby wykonać testy E2E bramki płatności Stripe w pliku konfiguracyjnym `config/frontend.json` dodajemy  `"chromeWebSecurity": false,`. Możemy zainstalować także plugin [cypress-plugin-stripe-elements](https://www.npmjs.com/package/cypress-plugin-stripe-elements), który ułatwia wyciąganie elementów z iframe - `cy.fillElementsInput('cardNumber', '4242424242424242');`.

Konfiguracja tego pluginu jest dostępna na stronie projektu. Niestety plugin ten nie zadziała w projekcie, gdzie nie korzystamy z gotowego widgetu Stripe.js. W takim przypadku mamy dostępne znacznie więcej ramek, w których znajdują się poszczególne elementy formularza.
Ten problem da się obejść tworząc pomocniczą funkcję (na bazie tej z pluginu):

```
const getStripeElement = (iframe, selector) => {
    if (Cypress.config('chromeWebSecurity')) {
        throw new Error('To get stripe element `chromeWebSecurity` must be disabled');
    }

    return cy
        .get('iframe')
        .its('0.contentDocument.body').should('not.be.empty')
        .then(cy.wrap)
        .find(selector);
};

// usage
getStripeElement(`input[data-elements-stable-field-name="cardNumber"]`).type('4242424242424242');
getStripeElement(`input[name="cc-csc"]`).type('123', {force: true});
getStripeElement(`input[name="cc-exp-month"]`).type('12', {force: true});
getStripeElement(`input[name="cc-exp-year"]`).type('28', {force: true});
```

Jednak możemy także przekazać w parametrze referencję do elementu iframe. Najlepiej wykorzystać do tego polecenie cypress, ale najprostsza implementacja to:

```
const getStripeElement = (iframe, selector) => {
    if (Cypress.config('chromeWebSecurity')) {
        throw new Error('To get stripe element `chromeWebSecurity` must be disabled');
    }

    return cy
        .wrap(iframe)
        .its('0.contentDocument.body').should('not.be.empty')
        .then(cy.wrap)
        .find(selector);
};
```

[Testing Stripe Integration with Cypress](https://medium.com/swinginc/testing-stripe-integration-with-cypress-3f0d665cfef7)

## Braintree

Test E2E bramki płatności Braintree nie różni się od Stripe. Musimy tylko wyciągnąć inne elementy z ramki iframe.

```
const getBraintreeElement = (iframe, selector) => {
    if (Cypress.config('chromeWebSecurity')) {
        throw new Error('To get stripe element `chromeWebSecurity` must be disabled');
    }

    return cy
        .wrap(iframe)
        .its('0.contentDocument.body').should('not.be.empty')
        .then(cy.wrap)
        .find(selector);
};

cy.get('.braintree-hosted-fields-wrapper form').within(el => {
    cy.contains('Card Number')
        .closest('div')
        .find('iframe')
        .then($iframe => getBraintreeElement($iframe, `input[name="credit-card-number"]`).type('4111111111111111'));

    cy.contains('Month / Year')
        .closest('div')
        .find('iframe')
        .then($iframe => getBraintreeElement($iframe, `input[name="expiration"]`).type('10/24'));

    cy.contains('Secure Code')
        .closest('div')
        .find('iframe')
        .then($iframe => getBraintreeElement($iframe, `input[name="cvv"]`).type('123'));
});

cy.get('.braintree-hosted-fields-wrapper form  button[type="submit"]').click();
```

## CKEDitor

[How to add/type a text in CKeditor (v4) in Cypress Automation?Or any Method to Set The Value for Ckeditor in Cypress Automation?](https://stackoverflow.com/questions/65068660/how-to-add-type-a-text-in-ckeditor-v4-in-cypress-automationor-any-method-to-s)

### Wersja 4
```
const typeToCKEditor = (haystack, content) => {
    cy.window().then(win => {
        // editor instance can start from haystack
        const keys = Object.keys(win.CKEDITOR.instances).filter((key) => key.indexOf(haystack) > 0);
        win.CKEDITOR.instances[keys[0]].setData(content);
    });
};
```

### Wersja 5
```
cy.get('.ck-content')
    .clear()
    .type('Hello CKEditor');
```
