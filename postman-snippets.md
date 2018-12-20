# Postman snippets

Więcej przydatnych fragmentów kodów jest dostępnych pod adresem https://github.com/postmanlabs/postman-docs/blob/master/v6/postman/scripts/test_examples.md

## Postman i chai

Dodatkowe assert dla postmana są dostępne pod adresem https://github.com/postmanlabs/chai-postman/blob/develop/lib/index.js

## Get env variable

`pm.environment.get("variable_key");`

## Set env variable
`pm.environment.set("variable_key", "variable_value");`

## Unset env variable
`pm.environment.unset("variable_key");`

## Check for a JSON value
```
pm.test("Your test name", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData.value).to.eql(100);
});
```

## Status code is 200

```
pm.test("Status code is 200", function () {
    pm.response.to.have.status(200);
});
```

## Check header is present and value

```
pm.test("Header is set and have correct value", function () {
   pm.response.to.have.header("Content-Type");
   pm.response.to.be.header("Content-Type", "application/json");
});
```