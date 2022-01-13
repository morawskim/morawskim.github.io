# AWS

Andreas Wittig i Michael Wittig, _Amazon Web Services w akcji. Wydanie II_, Helion

## IAM

IAM Group - zawiera tylko użytkowników (nie można dodawać grup). Użytkownik może należeć do wielu grup.

IAM User - użytkownik organizacji

IAM Role - pozwala uwierzytelniać zasoby AWS, np. instancję EC2

IAM Policy - dokument JSON, który określa uprawnienia dla użytkownika, grupy lub roli. Istnieją dwa typy zasad: managed policy i inline policy.
Managed policy to zasady przeznaczone dla tych, co chcą je ponownie wykorzystać (np. AWS managed policy).


### Linki

[IAM Credentials Report](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_getting-report.html#getting-credential-reports-console)

[IAM Access Advisor](https://docs.aws.amazon.com/IAM/latest/UserGuide/what-is-access-analyzer.html)

[Actions, resources, and condition keys for AWS services](https://docs.aws.amazon.com/service-authorization/latest/reference/reference_policies_actions-resources-contextkeys.html)

## EC2

[Set the time for your Linux instance - Amazon Elastic Compute Cloud](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/set-time.html)

### Domyślna nazwa użytkownika dla AMI:

| Dystrybucja  | Nazwa użytkownika  |
|---|---|
| Amazon Linux 2/Amazon Linux AMI  | ec2-user  |
| CentOS  | centos lub ec2-user  |
| Debian  | admin  |
| Fedora  | fedora lub ec2-user  |
| RHEL  | root lub ec2-user  |
| SUSE  | root lub ec2-user  |
| Ubuntu  | ubuntu  |
| Oracle  | ec2-user  |
| Bitnami | bitnami  |

### Rodziny instancji

| Rodzina | Opis |
|---|---|
| T | tania, o umiarkowanej, podstawowej wydajności, z możliwością chwilowego przejścia do wyższej wydajności |
| M | ogólnego przeznaczenia, z równomiernym przydziałem mocy CPU i pamięci |
| C | zoptymalizowana obliczeniowo, z wysoką wydajnością procesora |
| R | zoptymalizowana pamięciowo, z większą ilością pamięci i mniejszą mocą procesora niż w rodzinie M |
| D | zoptymalizowana pod kątem magazynowania, zapewniająca dużą pojemność dysku HDD |
| I | zoptymalizowana pod kątem magazynowania, zapewniająca dużą pojemność dysku SSD |
| X | bardzo duża wydajność z naciskiem na pamięć, do 1952 GB pamięci i 128 wirtualnych rdzeni |

[Pozostałe rodzaje instancji](https://aws.amazon.com/ec2/instance-types/)

### Porady

* Adres IP serwera zostanie zachowany podczas zatrzymania lub restartu maszyny wirtualnej. Adres IP jest zwalniany tylko przy kasowania maszyny (terminated). Nie dotyczy klasycznego EC2.

* Ruch Inbound i outbound jest nazywany odpowiednio ruchem ingress i egress.

* Podczas tworzenia maszyny można włączyć tryb "Unlimited" dla instancji typu T2/T3. Opcja ta nazywa się w konsoli AWS "Credit specification". Więcej informacji w dokumentacji - [Unlimited mode for burstable performance instances](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/burstable-performance-instances-unlimited-mode.html)

* Plik z logiem cloud-init znajduje się w `/var/log/cloud-init-output.log`.

* Skrypt przekazany w user-data jest kopiowany i wykonywany z katalogu `/var/lib/cloud/instances/instance-id/`. Tworząc własny obraz AMI powinniśmy skasować ten katalog.

* Reguły Security group mogą tylko zezwalać na ruch. Nie jesteśmy w stanie stworzyć reguły która blokuje ruch.

* Amazon domyślnie blokuje ruch na porcie 25 - [How do I remove the restriction on port 25 from my Amazon EC2 instance or AWS Lambda function?](https://aws.amazon.com/premiumsupport/knowledge-center/ec2-port-25-throttle/)

## EBS

* Tylko wolumeny typu gp2/gp3/io1/io2 mogą być użyte jako wolumen root/boot.

* Multi attach jest dostępne tylko dla wolumenów typu io1/io2.

## ELB / ASG

* Domyślnie ELB czeka 300s na zakończenie wszystkich aktywnych połączeń z grupą docelową, która jest wyłączana. Ten parametr możemy zmodyfikować, jeśli nie potrzebujemy czekać tak długo. [Deregistration delay](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-target-groups.html#deregistration-delay)

* Polityka skalowania dla ASG może bazować na:
    * wykorzystaniu CPU/sieci
    * własnych metrykach CloudWatch
    * harmonogramie

* Parametr [cooldowns](https://docs.aws.amazon.com/autoscaling/ec2/userguide/Cooldown.html) - Ilość czasu (w sekundach) po zakończeniu czynności skalowania i przed rozpoczęciem następnej czynności skalowania.
