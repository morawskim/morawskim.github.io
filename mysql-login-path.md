# MySQL - login-path

Narzędzie `mysql_config_editor` umożliwia przechowywanie danych uwierzytelniających w zamaskowanym pliku.
Plik ten może być następnie odczytany przez programy klienckie MySQL w celu uzyskania danych potrzebnych do połączenia z serwerem.

Przykład zapisu danych logowania:
`mysql_config_editor set --login-path=client --host=localhost --user=localuser --password`

W przypadku braku tego polecenia należy zainstalować pakiet `mysql-client-core-8.0` w systemie Ubuntu 24.04.

Zapisane dane można wyświetlić poleceniem:
`mysql_config_editor print --all`

Hasło nie zostanie ujawnione.


Korzystając z narzędzia `my_print_defaults` (dostarczanego przez pakiet `mysql-server-core-8.0` w Ubuntu 24.04), możemy wyświetlić również zapisane hasło:

`my_print_defaults -s  <login-path>`

[mysql_config_editor — MySQL Configuration Utility](https://dev.mysql.com/doc/refman/8.0/en/mysql-config-editor.html)
