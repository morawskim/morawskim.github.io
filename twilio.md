# Twilio

## SMS "Permission to send an SMS has not been enabled for the region indicated by the 'To' number"

Domyślnie Twilio zezwala na wysyłanie SMS tylko do kraju przypisanego do numeru telefonu podanego przy rejestracji.
Próba wysłania SMS do innego kraju spowoduje wygenerowanie błędu `ERROR - 21408 Permission to send an SMS has not been enabled for the region indicated by the 'To' number`.
Musimy w [konsoli Twilio](https://www.twilio.com/console/sms/settings/geo-permissions) zezwolić na wysyłanie SMS do innych krajów - [https://www.twilio.com/docs/api/errors/21408?display=embedded](https://www.twilio.com/docs/api/errors/21408?display=embedded)

## Zaplanowany SMS

[Message Scheduling is Now in Public Beta](https://www.twilio.com/blog/message-scheduling-public-beta)

[Send Scheduled SMS with Ruby and Twilio](https://www.twilio.com/blog/send-scheduled-sms-ruby-twilio)

[Schedule a Message resource](https://www.twilio.com/docs/sms/api/message-resource#schedule-a-message-resource)

[Message Scheduling FAQs and Beta Limitations](https://support.twilio.com/hc/en-us/articles/4412165297947-Message-Scheduling-FAQs-and-Beta-Limitations)
