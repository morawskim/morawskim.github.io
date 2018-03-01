# Tworzenie CA - certyfikat serwera i klienta

Tworzenie klucza i certyfikatu CA
```
openssl genrsa -aes256 -out ca-key.pem 2048
openssl req -new -x509 -days 365 -key ca-key.pem -sha256 -out ca.pem
``

Tworzenie klucza i CSR serwera
```
openssl genrsa -out server-key.pem 2048
openssl req -subj "/CN=example.com" -new -key server-key.pem -out server.csr
```

Dodatkowe adresy IP/domenowe (subjectAltName) i podpisywanie CSR
```
echo subjectAltName = IP:192.168.15.71,IP:127.0.0.1 > extfile.cnf
openssl x509 -req -days 365 -in server.csr -CA ca.pem -CAkey ca-key.pem  -CAcreateserial -out server-cert.pem -extfile extfile.cnf 
```

Tworzenie klucza i CSR klienta
```
openssl genrsa -out key.pem 2048
openssl req -subj '/CN=client' -new -key key.pem -out client.csr 
```

Podpisywanie CSR
```
echo extendedKeyUsage = clientAuth > extfile_client.cnf
openssl x509 -req -days 365 -in client.csr -CA ca.pem -CAkey ca-key.pem  -CAcreateserial -out cert.pem -extfile extfile_client.cnf 
```
