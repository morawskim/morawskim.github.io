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

### Linki

[IAM Credentials Report](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_getting-report.html#getting-credential-reports-console)

[IAM Access Advisor](https://docs.aws.amazon.com/IAM/latest/UserGuide/what-is-access-analyzer.html)

[Actions, resources, and condition keys for AWS services](https://docs.aws.amazon.com/service-authorization/latest/reference/reference_policies_actions-resources-contextkeys.html)
