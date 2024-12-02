# Gmail lIMAP extension

W projekcie istaniała funkcja zapisywania wiadomości email z konta Gmail w systemie CRM.
Czasami zapisywana wiadomość oznaczona była jako "Wersja robocza".
Chcieliśmy sie pozbyć takich przypadków.

Identyfikator wiadomości (uid) w katalogu "Wszystkie" jest lokalnym identyfikatorem.
W katalogu "Wersje robocze" ta wiadomość posiada inny identyfiaktor.

Przeglądając dokumentację [Gmail Imap](https://developers.google.com/gmail/imap/imap-extensions)
natrafiłem na rozszerzenie Gmail do protokołu IMAP, które pozwala na uzyskanie globalnego identyfiaktora wiadomości -
[Access to the Gmail unique message ID: X-GM-MSGID](https://developers.google.com/gmail/imap/imap-extensions#access_to_the_unique_message_id_x-gm-msgid).

Pobranie tego identyfikatora jest możliwe za pomocą atrybutu `X-GM-MSGID` w poleceniu `FETCH`.
Mając ten identyfikator możemy sprawdzić, czy wiadmość jest w katalogu "Wersje robocze".
