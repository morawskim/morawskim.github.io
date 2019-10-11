# Odczytywanie i wstawianie nowych wartości do bazy debconf

Musimy mieć zainstalowany pakiet `debconf-utils`, aby móc odczytywać i wstawiać nowe wartości do bazy `debconf`.

Na początku robimy zrzut bazy za pomocą polecenia `debconf-get-selections > debconf`

Następnie instalujemy jakiś pakiet, który powoduje wywołanie okna konfiguracyjnego. Przy minimalnej instalacji może to być pakiet `git`.
W tym przypadku jednak użyje postfix - `apt-get install postfix`.

Następnie ponownie robimy zrzut bazy, ale zapisujemy go do innego pliku `debconf-get-selections > debconf-NEW`

Za pomocą polecenie `diff` wyświetlamy różnicę - `diff -u <(cat debconf | sort) <(cat debconf-NEW |sort) | less`

```
+postfix        postfix/bad_recipient_delimiter error
+postfix        postfix/chattr  boolean false
+postfix        postfix/compat_conversion_warning       boolean true
+postfix        postfix/destinations    string  $myhostname, ubuntu-vagrant, localhost.localdomain, localhost
+postfix        postfix/dynamicmaps_conversion_warning  boolean
+postfix        postfix/kernel_version_warning  boolean
+postfix        postfix/lmtp_retired_warning    boolean true
+postfix        postfix/mailbox_limit   string  0
+postfix        postfix/mailname        string  ubuntu-vagrant
+postfix        postfix/main_cf_conversion_warning      boolean true
+postfix        postfix/main_mailer_type        select  Local only
+postfix        postfix/mydomain_warning        boolean
+postfix        postfix/mynetworks      string  127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128
+postfix        postfix/newaliases      boolean false
+postfix        postfix/not_configured  error
+postfix        postfix/procmail        boolean false
+postfix        postfix/protocols       select  all
+postfix        postfix/recipient_delim string  +
+postfix        postfix/relayhost       string
+postfix        postfix/relay_restrictions_warning      boolean
+postfix        postfix/retry_upgrade_warning   boolean
+postfix        postfix/rfc1035_violation       boolean false
+postfix        postfix/root_address    string
+postfix        postfix/sqlite_warning  boolean
+postfix        postfix/tlsmgr_upgrade_warning  boolean
```

Widzimy jakie zmiany zostały dokonane w bazie `debconf` poprzez instalację pakietu `postfix`.

Parametry konfiguracyjne pakietu `postfix` lepiej pobierać za pomocą polecenia - `sudo debconf-get-selections | grep 'postfix'`

```
postfix postfix/sqlite_warning  boolean
postfix postfix/tlsmgr_upgrade_warning  boolean
# Install postfix despite an unsupported kernel?
postfix postfix/kernel_version_warning  boolean
postfix postfix/mynetworks      string  127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128
postfix postfix/chattr  boolean false
postfix postfix/destinations    string  $myhostname, ubuntu-vagrant, localhost.localdomain, localhost
postfix postfix/retry_upgrade_warning   boolean
postfix postfix/mydomain_warning        boolean
postfix postfix/dynamicmaps_conversion_warning  boolean
postfix postfix/mailbox_limit   string  0
postfix postfix/main_mailer_type        select  Local only
postfix postfix/rfc1035_violation       boolean false
postfix postfix/bad_recipient_delimiter error
postfix postfix/recipient_delim string  +
postfix postfix/lmtp_retired_warning    boolean true
postfix postfix/protocols       select  all
postfix postfix/relay_restrictions_warning      boolean
postfix postfix/not_configured  error
postfix postfix/compat_conversion_warning       boolean true
postfix postfix/main_cf_conversion_warning      boolean true
postfix postfix/procmail        boolean false
postfix postfix/newaliases      boolean false
postfix postfix/relayhost       string
postfix postfix/mailname        string  ubuntu-vagrant
postfix postfix/root_address    string
```

Za pomocą poniższego polecenia importujemy parametry konfiguracyjne do bazy `debconf`.

```
cat << EOF | sudo debconf-set-selections
<tutaj wklejamy parametry skopiowane z polecenia wyżej>
EOF
```

Podczas importu dostaniemy kilka ostrzeżeń:
```
warning: Unknown type error, skipping line 14
warning: Unknown type error, skipping line 19
```

Jeśli skasujemy teraz pakiet - `apt-get purge postfix` i spróbujemy ponownie go zainstalować, to nie zostaniemy spytani o konfigurację.
Ma to duże znaczenie w przypadku automatycznej konfiguracji maszyny.
