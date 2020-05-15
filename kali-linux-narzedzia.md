# kali linux - narzędzia

| Program     | Opis          |
| ------------- |:-------------:|
| sslscan      | Fast SSL scanner |
| sslyze      | Fast and full-featured SSL scanner |
| nikto | web server security scanner |
| wapiti |  web application vulnerability scanner |
| crunch | tool for creating wordlist |
| cewl | custom word list generator |
| cupp3 | generate dictionaries for attacks from personal data version for python3 |
| arachni | Web Application Security Scanner Framework |
| john | active password cracking tool |
| hydra | very fast network logon cracker |
| findmyhash | Crack hashes with online services |
| skipfish | |

## cewl

Aby zbudować listę słów o minimalniej długości 4 znaków dla strony onetu wywołujemy następujące polecenie `cewl -m 4 https://www.onet.pl`

```
CeWL 5.4.4.1 (Arkanoid) Robin Wood (robin@digi.ninja) (https://digi.ninja/)                                                                                                                                         
Wiadomości                                                                                                                                                                                                          
offer                                                                                                                                                                                                               
Świat                                                                                                                                                                                                               
Onet                                                                                                                                                                                                                
Warszawa                                                                                                                                                                                                            
Polski                                                                                                                                                                                                              
Polska                                                                                                                                                                                                              
Podróże                                                                                                                                                                                                             
Więcej                                                                                                                                                                                                              
Metropolia                                                                                                                                                                                                          
Liga                                                                                                                                                                                                                
Kraków                                                                                                                                                                                                              
Łódź
....
```

## cupp3/cupp

Aby pobrać listę haseł dla kraju polski wywołujemy polecenie `cupp -l`, a następnie podajemy numer bazy. Dla Polski jest to 28. Plik zostanie pobrany do katalogu `dictionaries/polish/words.polish.gz`.

## john

Jeśli mamy już dostępny słownik z hasłami, możemy go dodatkowo ulepszyć. Dodając flagę `--rules` modyfikujemy każde słowo np. zmieniając wielkość liter.

`john --stdout --wordlist=./words --rules`

john potrafi także złamać zahaszowane hasła. Plik `hashes.txt` powinien być w formacie:
```
username:passwordHash
username2:passwordHash
```

Aby wyświetlić obsługiwane formaty haszy korzystamy z polecenia `john --list=formats` i `john --list=subformats`.

Finalnie polecenie wygląda tak `john --wordlist=./dictionaries/polish/words.polish --format=raw-md5 --rules ./hashes.txt`

## nikto

Nikto domyślnie nie posiada parametru, który pozwoliłby nam ustawić ciasteczko z identyfikatorem sesji.
Aby wysyłać żądania HTTP z identyfikatorem sesji musimy utworzyć plik konfiguracyjny nikto.

Do pliku `nikto.conf` wklejamy zawartość:
```
STATIC-COOKIE="_identity-frontend=b54e1542177a680486044c552427f1508b290b3ebfeeec91ba0b98025ac93fefa%3A2%3A%7Bi%3A0%3Bs%3A18%3A%22_identity-frontend%22%3Bi%3A1%3Bs%3A47%3A%22%5B13%2C%22VovprjG9aXOs3hG0sMjLHIi_PXOxPePd%22%2C2592000%5D%22%3B%7D"
```

Następnie możemy już wywołać nikto `nikto -h ssorder.lvh.me -useproxy http://localhost:8080/ -config ./nikto.conf`
Choć wysyłanie requestów przez serwer proxy nie jest potrzebne, to warto to zrobić, aby mieć pewność że cookie jest wysyłane. Wcześniejsze wersje nikto miały z tym problem - https://github.com/sullo/nikto/issues/440.

## findmyhash

Po instalacji w kontenerze dockera `findmyhash` możemy dostać błąd: `The Python library httplib2 is not installed in your system.`. Jak widać pakiet nie wymaga `python-httplib2`. Musimy go ręcznie zainstalować.
Dodatkowo, podczas korzystania z skryptu, możemy dostać komunikat `The Python library libxml2 is not installed in your system.`. Wystarczy zainstalowac pakiet `python-libxml2`.
Po instalacji tych pakietów, możemy przeszukiwać bazy z sumami kontrolnymi `findmyhash MD5 -h 5f4dcc3b5aa765d61d8327deb882cf99`
