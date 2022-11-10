# AWS IAM

IAM Group - zawiera tylko użytkowników (nie można dodawać grup). Użytkownik może należeć do wielu grup.

IAM User - użytkownik organizacji

IAM Role - pozwala uwierzytelniać zasoby AWS, np. instancję EC2. Rola IAM ma własną politykę uprawnień. Jest jak użytkownik IAM, ale bez hasła czy klucza API.

IAM Policy - dokument JSON, który określa uprawnienia dla użytkownika, grupy lub roli. Istnieją dwa typy zasad: managed policy i inline policy.
Managed policy to zasady przeznaczone dla tych, co chcą je ponownie wykorzystać (np. AWS managed policy).

Polityka IAM to dokument JSON z kluczami Sid, Effect, Principal, Action i Resource.

Domyślnie każdy użytkownik, grupa, rola IAM am zablokowany dostęp do zasobu. Dostęp do zasobu musi być jawnie zdefiniowany w polityce. Dołączona polityka z jawną regułą zablokowania dostępu
jawnie blokuje dostęp do zasobu.

Dodatkowe usługi które mogą nam pomóc w określeniu uprawnień Access advisor i credential report.

## Linki

[IAM Credentials Report](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_getting-report.html#getting-credential-reports-console)

[IAM Access Advisor](https://docs.aws.amazon.com/IAM/latest/UserGuide/what-is-access-analyzer.html)

[Actions, resources, and condition keys for AWS services](https://docs.aws.amazon.com/service-authorization/latest/reference/reference_policies_actions-resources-contextkeys.html)

## STS assume-role

Tworzymy role i użytkownika w AWS. Następnie generujemy token API do nowo utworzonego konta i konfigurujemy narzędzie AWS CLI pod utworzone konto.

Wywołując polecenie `aws sts get-caller-identity` może potwierdzić, że polecenia AWS CLI są wywoływane z uprawnieniami utworzonego użytkownika.

Generujemy tymczasowy token podając ARN roli i własną nazwę sesji - `aws sts assume-role --role-arn "arn:aws:iam::<ACCOUNT_ID>:role/<ROLE_NAME>" --role-session-name "<SESSION_NAME>"`

Na wyjściu otrzymamy tymczasowe klucze AWS:
```
{                                                                                                                                                                                           
     "Credentials": {
        "AccessKeyId": "A...5",
        "SecretAccessKey": "/Yp.....aP",
        "SessionToken": "IQo....hl",
    }

```

Eksportujemy zmienne środowiskowe `export AWS_ACCESS_KEY_ID=A...5 AWS_SECRET_ACCESS_KEY=/Yp.....aP AWS_SESSION_TOKEN=IQo....hl`

Wywołujemy ponownie polecenie `aws sts get-caller-identity`.
Tym razem otrzymamy wynik podobny do poniższego, co potwierdza korzystanie z tymczasowych tokenów AWS:

```
{
    "UserId": "AROAVGY3FAXDCVBJ4K7A7:<SESSION_NAME>",
    "Account": "<ACCOUNT_ID>",
    "Arn": "arn:aws:sts::<ACCOUNT_ID>:assumed-role/<ROLE_NAME>/<SESSION_NAME>"
}
```

Możemy także połączyć kroki tworzenia tymczasowego tokenu AWS i eksportu zmiennych środowiskowych do jednego polecenia:
```
export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s" \
$(aws sts assume-role \
--role-arn <AWS_ROLE_ARN> \
--role-session-name <SESSION_NAME> \
--query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" \
--output text))
```

[How do I assume an IAM role using the AWS CLI?](https://aws.amazon.com/premiumsupport/knowledge-center/iam-assume-role-cli/)
