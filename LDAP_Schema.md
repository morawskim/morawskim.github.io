LDAP Schema
===========

Przykładowy plik schematu LDAP.

```
objectidentifier eoViewSchema 1.3.6.1.4.1.5.7
objectidentifier eoViewAttrs eoViewSchema:3
objectidentifier eoViewOCs eoViewSchema:4

attributetype ( eoViewAttrs:1
        NAME 'eoViewCertifications'
        DESC 'Nazwa certyfikatu'
        EQUALITY caseIgnoreMatch
        SUBSTR caseIgnoreSubstringsMatch
        SYNTAX 1.3.6.1.4.1.1466.115.121.1.15{255} )

attributetype ( eoViewAttrs:2
        NAME 'eoViewTrainingCourses'
        DESC 'Nazwa szkolenia'
        EQUALITY caseIgnoreMatch
        SUBSTR caseIgnoreSubstringsMatch
        SYNTAX 1.3.6.1.4.1.1466.115.121.1.15{255} )

objectClass ( eoViewOCs:1
        NAME 'eoView'
        SUP ( top ) AUXILIARY
        MAY ( eoViewCertifications $ eoViewTrainingCourses ) )
</syntaxhighlighter>
Powyższy schemat tworzy dwa atrybuty. Oba są polami tekstowymi o maksymalnej długości 255 znaków. Zawierają one indeksy, które pozwolą filtrować po wartości atrybutu ignorując wielkość znaków. Aby móc korzystać z nowo utworzonych atrybutów eoViewCertifications i eoViewTrainingCourses, musimy wybranemu rekordowi dodać atrybut objectClass.

<syntaxhighlight lang="text">
objectClass: eoView
```

Jeśli chcemy ograniczyć ilość wystąpień danego atrybutu do 1 wartości to w definicji atrybutu dodajemy klucz "SINGLE-VALUE".

```
attributetype ( eoViewResourceAttrs:1
    NAME 'eoViewResourceHardwareSpecification'
    DESC 'Specyfikacja techniczna sprzętu'
    SYNTAX 1.3.6.1.4.1.1466.115.121.1.15{32768}
    SINGLE-VALUE )
```

Powyższa definicja tworzy tekstowy atrybut bez zakładania żadnych indeksów (nie można więc filtrować wartości po takim atrybucie) o maksymalnej długości 32768 znaków. Nowe serwery OpenLdap korzystają z nowego formatu schematów. Możemy go łatwo prze konwertować do nowego formatu. Tworzymy tymczasowe katalogi i kopiujemy nasz schemat.

``` bash
mkdir -p /tmp/ldap/schema
cd /tmp/ldap
cp /path/to/eoview.schema /tmp/ldap/schema
```

Tworzymy przykładowy plik konfiguracyjny serwera ldapa, w którym wczytujemy podstawowe schematy i nasz. Plik zapisujemy pod nazwą "test.conf" w katalogu /tmp/ldap.

```
 include /opt/zimbra/openldap/etc/openldap/schema/core.schema
 include /opt/zimbra/openldap/etc/openldap/schema/cosine.schema
 include /opt/zimbra/openldap/etc/openldap/schema/inetorgperson.schema
 include /tmp/ldap/schema/eoview.schema
```

Uruchamiamy polecenie slaptest, podając mu ścieżkę do naszego pliku konfiguracyjnego i tymczasowego katalogu ldap.

``` bash
/opt/zimbra/openldap/sbin/slaptest -f /tmp/ldap/test.conf -F /tmp/ldap
```

Program slaptest utworzy katalog "cn=config" w którym znajduje się kolejny katalog "cn=schema". Ten katalog zawiera prze konwertowany plik schematu.

``` bash
ls -la ./cn\=schema
total 52
drwxr-x--- 2 zimbra zimbra  4096 May 28 14:52 .
drwxr-x--- 3 zimbra zimbra  4096 May 28 14:52 ..
-rw------- 1 zimbra zimbra 15540 May 28 14:52 cn={0}core.ldif
-rw------- 1 zimbra zimbra 11361 May 28 14:52 cn={1}cosine.ldif
-rw------- 1 zimbra zimbra  2855 May 28 14:52 cn={2}inetorgperson.ldif
-rw------- 1 zimbra zimbra   951 May 28 14:52 cn={3}gpo.ldif
-rw------- 1 zimbra zimbra  1054 May 28 14:52 cn={4}eoview.ldif
-rw------- 1 zimbra zimbra   971 May 28 14:52 cn={5}eoviewresource.ldif
```

Zmieniamy numer wygenerowane pliku "cn={4}eoview.ldif" na liczbę większą od 10. Musimy także zmienić tą cyfrę w zawartości pliku.

```
#z
 dn: cn={4}eoview
 objectClass: olcSchemaConfig
 cn: {4}eoview
#na
dn: cn={14}eoview
objectClass: olcSchemaConfig
cn: {14}eoview

#zmiana nazwy pliku
mv cn={4}eoview.ldif ./cn={14}eoview.ldif
```

Zatrzymujemy serwer openldap. Kopiujemy nasz plik "cn={14}eoview.ldif" do katalogu "cn=schema/" serwera ldap.

``` bash
ldap stop
cp /tmp/ldap/cn\=config/cn\=schema/cn\=\{14\}eoview.ldif /opt/zimbra/data/ldap/config/cn\=config/cn\=schema/
ldap start
```

W tym przypadku - serwer ldap zimbry - nie musimy dodawać schematu do pliku konfiguracyjnego serwera openldap. Więcej informacji na temat schematów ldap - [1](http://www.openldap.org/doc/admin22/schema.html)