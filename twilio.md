# Twilio

## SMS "Permission to send an SMS has not been enabled for the region indicated by the 'To' number"

Domyślnie Twilio zezwala na wysyłanie SMS tylko do kraju przypisanego do numeru telefonu podanego przy rejestracji.
Próba wysłania SMS do innego kraju spowoduje wygenerowanie błędu `ERROR - 21408 Permission to send an SMS has not been enabled for the region indicated by the 'To' number`.
Musimy w [konsoli Twilio](https://www.twilio.com/console/sms/settings/geo-permissions) zezwolić na wysyłanie SMS do innych krajów - [https://www.twilio.com/docs/api/errors/21408?display=embedded](https://www.twilio.com/docs/api/errors/21408?display=embedded)
