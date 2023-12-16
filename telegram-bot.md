# Telegram bot

Aby utworzyć nowego bota musimy rozpocząć konwersację z kontem "botfather".
Mając otwarty czat z tym kontem z Menu (przy polu wiadomości) wybieramy akcję "/newbot".
Odpowiadamy na pytania. Na koniec otrzymamy token, który daje nam dostęp do API.

Dodajemy do grupy/czatu naszego bota. Bota wyszukujemy po nazwie użytkownika (czyli tej z końcówką bot), a następnie określamy jego uprawnienia na kanale.

Do wysyłania wiadomości na Telegram korzystam z biblioteki [Shoutrrr](https://containrrr.dev/shoutrrr/v0.8/). Aby wysłać wiadomość na Telegram musimy znać identyfikator kanału/czatu.
Uruchamiamy polecenie `docker run --rm -it containrrr/shoutrrr generate telegram` i podajemy nasz token bota, a następnie wysyłamy wiadomość na czacie.
Jeśli nasz bot jest zaproszony na ten czat to powinniśmy otrzymać identyfikator czatu.
Na koniec polecenie wyświetli URL, który podajemy przy wysyłaniu wiadomości przez shoutrrr na Telegram ("telegram://foo123:bar1234@telegram?chats=-9999999995430&preview=No")
Przykładowe polecenie do wysyłania wiadomości `shoutrrr send --url "telegram://foo123:bar1234@telegram?chats=-9999999995430&preview=No" --message "Test"`
