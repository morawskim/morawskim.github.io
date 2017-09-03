Skrypt do kompilacji i instalacji PHP
=====================================

Kiedy piszemy rozszerzenia do PHP w języku C potrzebujemy odpowiednio skompilowanej wersji PHP. Poniższy skrypt pobiera kod źródłowy PHP i go kompiluje. Taka wersja PHP będzie mieć włączony tryb debugowania (m.in wycieki pamięci będą zgłaszane) i ZTS (Zend Thread Safety). Wszystkie zależności np. deweloperskie pakiety muszą być już zainstalowane w systemie.

``` bash
#!/bin/bash
#Shell script to download and compiling PHP.
#You must manually install all dependencies!
#Author: Marcin Morawski <marcin@morawskim.pl>

#Exit immediately if a command exits with a non-zero status.
set -e

#Avoid accidental overwriting of a file
set -o noclobber

PHP_VERSION=$1
PHP_DOWNLOAD_MUSEUM_URL="http://museum.php.net/php5/php-$PHP_VERSION.tar.gz"
PHP_DOWNLOAD_CURRENT_URL="http://pl1.php.net/get/php-$PHP_VERSION.tar.gz/from/this/mirror"

PHP_SRC_DIRECTORY="/usr/local/src/php"
PHP_INSTALL_DIRECTORY="/opt/php/$PHP_VERSION"
PHP_INI_DIR="/opt/php/$PHP_VERSION/etc/conf.d"

#we dont use TMPDIR
TMPDIRECTORY="/tmp"
PHP_SRC_DOWNLOAD_TO="$TMPDIRECTORY/phpsource.tar.gz"

MYSQL_CONFIG_BIN=$(which mysql_config)
#APXS2_BIN=$(which apxs2)
#--with-apxs2=$APXS2_BIN \

PHP_USER='root'
PHP_GROUP='root'
PHP_OPTIONS=" --with-readline --with-gmp --enable-cli --with-openssl \
  --enable-sockets --with-curl --enable-ftp --enable-pcntl --enable-memory-limit \
  --enable-bcmath --with-iconv \
  --with-ctype --enable-mbstring --with-mime-magic \
  --enable-pdo --with-pdo-mysql --with-pdo-sqlite --with-mysqli=$MYSQL_CONFIG_BIN \
  --enable-libxml --with-xsl --enable-soap --with-mcrypt --with-mhash  --enable-intl \
  --enable-shmop --enable-sysvsem  --enable-sysvshm  --enable-sysvmsg --enable-tokenizer \
  --with-config-file-scan-dir=$PHP_INI_DIR
  --enable-debug --enable-maintainer-zts
"

if [ $# -ne 1 ]; then
  echo "Usage:" >&2
  echo `basename $0` ' phpVersion' >&2
  exit 1
fi

if [ $UID -ne 0 ]; then
  echo 'You must run this script as root'>&2
  exit 1
fi

#create dirs
mkdir -p $PHP_SRC_DIRECTORY
mkdir -p $PHP_INI_DIR
mkdir -p $PHP_INSTALL_DIRECTORY

#download php src. We use two server because old releases are stored in museum, new not
wget -O $PHP_SRC_DOWNLOAD_TO $PHP_DOWNLOAD_MUSEUM_URL || wget -O $PHP_SRC_DOWNLOAD_TO $PHP_DOWNLOAD_CURRENT_URL
sudo -u $PHP_USER tar -zxvf $PHP_SRC_DOWNLOAD_TO -C $PHP_SRC_DIRECTORY >/dev/null

#compiling and install
SOURCE_DIR="$PHP_SRC_DIRECTORY/php-$PHP_VERSION"
cd $SOURCE_DIR
sudo -u $PHP_USER ./configure --prefix=$PHP_INSTALL_DIRECTORY $PHP_OPTIONS
sudo -u $PHP_USER make
make install
chown $PHP_USER:$PHP_GROUP -R $PHP_INSTALL_DIRECTORY
rm -f $PHP_SRC_DOWNLOAD_TO
```

Mając kilka zainstalowanych w taki sposób wersji, można się między nimi łatwo przełączać korzystając z skryptu php-version użytkownika wilmoore - [1](https://github.com/wilmoore/php-version) Pobieramy skrypt php-version.sh. W pliku konfiguracyjnym powłoki ~/.bashrc (w przypadku bash'a) musimy dodać

``` bash
#katalog gdzie przechowywane są skompilowane wersje PHP'a
export PHP_VERSIONS="/opt/php"
source /SCIEZKA/DO/php-version.sh
#ustawmy domyślna wartość na starcie
php-version 5.5
```

Skrypt wykryje wszystkie skompilowane wersje PHP'a

``` bash
php-version
  5.4.20
  5.4.42
  5.5.26
  5.6.10
```

``` bash
#ustawmy najwyższą możliwą wersję PHP z gałęzi 5.5
php-version 5.5
#sprawdźmy aktualną wybraną wersję php
php-version
  5.4.20
  5.4.42
* 5.5.26
  5.6.10
#spr czy wszystko działa
php -v
PHP 5.5.26 (cli) (built: Jul  4 2015 10:16:02) (DEBUG)
Copyright (c) 1997-2015 The PHP Group
Zend Engine v2.5.0, Copyright (c) 1998-2015 Zend Technologies
```