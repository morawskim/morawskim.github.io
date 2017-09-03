Zabbix - monitorowanie własnych parametrów
==========================================

Tworzymy szablon.

```
Configuration -> Templates -> Create template
```

Uzupełniamy pola formularza

```
Template name -> Template Speed test
Visible name -> Speed test
Groups -> dodajemy grupę "Templates"
Hosts/Templates zostawiamy puste
```

Z listy szablonów wybieramy nasz nowo utworzony szablon.
Z toolbara konfiguracji szablonu wybieramy "Applications".
Po przejściu na nową stronę klikamy w "Create application".
W polu "Name" wpisujemy Speedtest.
Klikamy na pozycję "Items", która znajduje się powyżej tabelki z aplikacjami przypisanymi do szablonu. Klikamy w "Create item". Uzupełniamy formularz.

```
Name -> Speed test upload
Type Zabbix agent
Key speedtest.upload
Type of information Numeric
Data type Decimal
Units bps
Use custom multiplier - pozostawiamy puste
Update interval (in sec) - 28800 (8h)
Flexible intervals - pozostawiamy puste
History storage period (in days) - zostawiamy domyślną wartość 90dni
Trend storage period (in days) - zostawiamy domyślną wartość 365dni
Store value - zostawiamy domyślną wartość "As is"
Show value - zostawiamy domyślną wartość "As is"
New applicatio - zostawiamy pustą wartość
Applications - wybieramy naszą aplikację "Speedtest"
populates host inventory field - wybieramy "-None-"
Description - zostawiamy puste
Enable - Zaznaczamy checkbox
```

Zapisujemy dane formularza.
Podobnie dodajemy wpisy dla speedtest.download i speedtest.latency.
Tworzymy wykres. Klikamy w pozycję "Graphs",a potem w "Create graph". Uzupełniamy formularz.

```
Name - "Internet connection speed"
Width - pozostawiamy domyślną wartość 900
Height: pozostawiamy domyślną wartość 200
Graph type - wybieramy Normal (wartość domyślna)
Show legend - zaznaczamy checkbox (wartość domyślna)
Show working time - zaznaczamy checkboxa (wartość domyślna)
Show triggers - zaznaczamy checkboxa (wartość domyślna)
Percentile line (left) - odznaczamy checkboxa (wartość domyślna)
Percentile line (right) - odznacamy checkboxa (wartość domyślna)
Y axis MIN value - zostawiamy domyślną wartość "Calculated"
Y axis MAX value - jw.
```

Dodajemy 2 pozycje do naszego wykresu:

```
Speed test: Speed test download
Speed test: Speed test upload
```

Obie pozycje jako funkcję powinny mieć wybraną wartość "avg". Styl rysowania to "Line". Y axis side ustawione na "Left". Kolor według gustu. Zapisujemy wykres.
Wybieramy z głównego menu "Configuration" -&gt; Hosts. Z listy hostów wybieramy ten do którego chcemy przypisać nasz szablon. Przechodzimy do zakładki "Templates". W polu "Link new templates" wpisujemy lub wybieramy nasz szablon "Speed test". Klikamy "Add" i zapisujemy zmiany "Save".
Sprawdzamy, czy katalog "/etc/zabbix/zabbix_agentd.d/" istnieje.

```
ls -la /etc/zabbix/zabbix_agentd.d/
total 16
drwxr-xr-x 2 root root 4096 Jul 8 19:39 .
drwxr-xr-x 4 root root 4096 Jul 8 18:12 ..
-rw-r--r-- 1 root root 424 Jul 8 19:36 speedtest.conf
-rw-r--r-- 1 root root 1517 Jul 17 2014 userparameter_mysql.conf
```

Jeśli nie to tworzymy taki katalog. Upewniamy się że usługa zabbix-agentd wczyta zawartość tego katalogu. Otwieramy plik konfiguracyjny agenta - /etc/zabbix/zabbix_agentd.conf i szukamy frazy "Include".

```
cat /etc/zabbix/zabbix_agentd.conf | grep -i Include
### Option: Include
# You may include individual files or all files in a directory in the configuration file.
# Installing Zabbix will create include directory in /usr/local/etc, unless modified during the compile time.
# Include=
Include=/etc/zabbix/zabbix_agentd.d/
# Include=/usr/local/etc/zabbix_agentd.userparams.conf
# Include=/usr/local/etc/zabbix_agentd.conf.d/
# It is allowed to include multiple LoadModule parameters.
```

Jeśli linia nie istnieje lub jest za komentowana to ją dodajemy.

```
Include=/etc/zabbix/zabbix_agentd.d/
```

Tworzymy plik speedtest.cong w katalogu "/etc/zabbix/zabbix_agentd.d". Test badania łącza trochę trwa czasu. Zabbix ubije proces nim ten zwróci dane. Odpowiada za to parametr "Timeout" konfiguracji agenta.

```
UserParameter=speedtest.download,/usr/local/bin/connection-speed-wrapper download
UserParameter=speedtest.upload,/usr/local/bin/connection-speed-wrapper upload
UserParameter=speedtest.latency,/usr/local/bin/connection-speed-wrapper latency
```

Sprawdzenia wydajności łącza odbywa się cyklicznie przez usługę cron. Skrypt "connection-speed-wrapper" odczytuje zapisane dane z pliku.