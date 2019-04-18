# MySQL - wyłączenie sprawdzania poprawności kluczy obcych

Importując zrzut bazy danych, możemy natrafić na problem z kluczami obcymi.
Aby import się powiódł, do pliku z instrukcjami SQL możemy dodać linię `SET FOREIGN_KEY_CHECKS=0;`.
Jednak jeśli plik jest duży, to możemy mieć problem z jego edycją.
W takim przypadku możemy skorzystać z poniższego polecenia:

`cat <(echo "SET FOREIGN_KEY_CHECKS=0;") dump.sql | mysql`
