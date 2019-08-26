# yaml snippets

## Multiline

[https://yaml-multiline.info/](https://yaml-multiline.info/)

```
before_script:
    - |
      echo "-----BEGIN CERTIFICATE-----
      ...
      -----END CERTIFICATE-----" >> /kaniko/ssl/certs/ca-certificates.crt

```
