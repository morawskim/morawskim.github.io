# MySQL 5.7 hasło roota

MySQL 5.7 domyślnie tworzy hasło dla użytkownika root. W systemach debian/ubuntu instalator pyta użytkownika o hasło. Jeśli go nie poda, konto root nie będzie mieć hasła. Jednak na takie konto można się zalogować tylko przez gniazdo UNIX. W przypadku Centos/Redhat hasło roota powinno być dostępne w logach.

```
UPDATE mysql.user SET authentication_string=PASSWORD('YOURNEWPASSWORD'), plugin='mysql_native_password' WHERE User='root' AND Host='%';
```

Wciąż jednak musimy uruchomić serwer mysql bez sprawdzania uprawnień i bez dostępu sieciowego.
```
sudo mysqld_safe --skip-grant-tables --skip-networking &
```

Więcej informacji
* https://coderwall.com/p/j9btlg/reset-the-mysql-5-7-root-password-in-ubuntu-16-04-lts
* https://www.percona.com/blog/2016/05/18/where-is-the-mysql-5-7-root-password/
* https://www.percona.com/blog/2016/03/16/change-user-password-in-mysql-5-7-with-plugin-auth_socket/
