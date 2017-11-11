Skrypt powłoki do tworzenia kopii baz danych MySQL
==================================================

Należy zmienić zmienną BACKUPDIR. Domyślnie backup jest zapisywany do /tmp/mysql. Dane autoryzacyjne do serwera mysql są pobierane z pliku .my.cnf w katalogu domowym użytkownika, który uruchamia skrypt. Skrypt domyślnie wykonuje kopie bezpieczeństwa wszystkich znalezionych baz danych za wyjątkiem tych wymienionych w zmiennej IGNOREDB. Domyślna wartość ignoruje następujące bazy danych: performance_schema, mysql i test.

Przykładowy plik .my.cnf

```
[mysqldump]
user=root
password="password"
```

Skrypt basha

``` bash
#!/bin/sh

#Shell script to backup mysql databases.
#Credentials to mysql are not stored in this script. You should create .my.cnf file in user's home directory!
#Author: Marcin Morawski <marcin@morawskim.pl>

#Exit immediately if a command exits with a non-zero status.
set -e

#CURRENT DATE
NOW=$(date +'%Y-%m-%d')

#Path where mysql stores databases files. If can not be detected, change to "static" path.
DATA_DIR=$(cat /etc/mysql/my.cnf | grep datadir | cut -d= -f2 | tr -d ' ')

#Backup main dir
BACKUPDIR="/tmp/mysql/$NOW"

# DO NOT BACKUP these databases. Databases must be separated by "|"
IGNOREDB="performance_schema|mysql|test"

#Bin paths, change if these programs are not stored in paths of PATH environment variable
MYSQLDUMP=$(which mysqldump)
GZIP=$(which gzip)
CHOWN=$(which chown)
CHMOD=$(which chmod)
ID=$(which id)

#Owner of backup files. Default user that run this script.
USER_UID=$($ID -u)
USER_GID=$($ID -g)

#if not exist dir, create. We assume that filesystem is mounted
if [ ! -d $BACKUPDIR ]; then
  mkdir -p $BACKUPDIR && $CHMOD 0700 $BACKUPDIR && $CHOWN $USER_UID:$USER_GID $BACKUPDIR
fi

#Check .my.cnf file exist in user's home dir.
if [ ! -f "$HOME/.my.cnf" ]; then
  echo ".my.cnf file do not exists in user's home dir ($HOME). The credentials must be stored there." >&2
  exit 1
fi

for dbname in $(ls -l $DATA_DIR | grep '^d' | awk '{print $9}' | grep -vE "$IGNOREDB");
  do
    FILE="$BACKUPDIR/$dbname.gz"
    echo "Creating backup for $dbname"
    $MYSQLDUMP --add-drop-database --opt --lock-all-tables $dbname | $GZIP > $FILE
    $CHMOD 0400 $FILE
    $CHOWN $USER_UID:$USER_GID $FILE
done;
```
