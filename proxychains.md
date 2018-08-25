# proxychains

Jeśli mamy bibliotekę/aplikację w której nie możemy ustawić serwera proxy do połączeń HTTP (HTTPS wymaga wyłączenia weryfikacji certyfikatów SSL) to pomoże nam w tym proxychains.

```
proxychains4 /usr/bin/node /home/marcin/projekty/minio-js/dist/main/listen-bucket-notification.js

```

W tym przypadku bez zmiany kody biblioteki `minio-js` wszystkie połączenia przechodzą przez serwer proxy.
W programie `owasp-zap` widzimy ruch:

Request
```
GET http://play.minio.io:9000/bucket1?location HTTP/1.1
user-agent: Minio (linux; x64) minio-js/7.0.1
x-amz-date: 20180825T121205Z
x-amz-content-sha256: e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
authorization: AWS4-HMAC-SHA256 Credential=Q3AM3UQ867SPQQA43P2F/20180825/us-east-1/s3/aws4_request, SignedHeaders=host;x-amz-content-sha256;x-amz-date, Signature=a021045e153e8d8ca4b51d2f6bd13336d538b4674de837fd07149dac0e325df1
Connection: close
Host: play.minio.io:9000
```

Response
```
HTTP/1.0 403 Forbidden

SSL required
```
