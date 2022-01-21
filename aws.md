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

## ElastiCache

* [Strategie buforowania](https://docs.aws.amazon.com/AmazonElastiCache/latest/mem-ug/Strategies.html):
    * Lazy loading - ładuje dane do pamięci podręcznej tylko wtedy, gdy jest to konieczne.
    * Write-through - dodaje dane lub aktualizuje dane w pamięci podręcznej za każdym razem, gdy dane są zapisywane w bazie danych

## Route 53

* Z wyjątkiem rekordów Alias, TTL jest obowiązkowe dla każdego rekordu DNS.

* Rekord aliasu — rozszerzenie AWS do funkcjonalności DNS. W przeciwieństwie do CNAME, może być używany do głównego rekordu DNS (Zone Apex). Rekord aliasu jest zawsze typu A/AAAA. Nie można ustawić TTL. Alias nie może być powiązany z nazwą DNS instancji EC2.

* [Polityki routingu](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy.html):
    * Simple - brak obsługi Health Checks
    * Weighted - wagi nie muszą się sumować do 100
    * Failover
    * Latency based - opóźnienie jest oparte na ruchu między użytkownikami a regionami AWS.
    * Geolocation - na podstawie lokalizacji użytkowników
    * Multi-Value Answer
    * Geoproximity - na podstawie lokalizacji geograficznej użytkownika i zasobów

* Health Checks nie mogą uzyskać dostępu do prywatnych punktów końcowych. W takim przypadku możemy utworzyć CloudWatch Metric i powiązać z CloudWatch Alarm, a następnie utworzyć Health Check, kóry monitoruje ten alarm.

## VPC

* Reguły Security group mogą tylko zezwalać na ruch. Nie jesteśmy w stanie stworzyć reguły która blokuje ruch. W regułach możemy odnosić się do adresów IP albo innych security groups.

* NACL mogą zawierać reguły zarówno zezwalające na ruch jak i blokujące ruch. W regułach możemy się odnosić tylko do adresów IP (brak security groups).

* VPC Peering to połączenie sieciowe między dwoma VPC, które umożliwia kierowanie ruchu między nimi przy użyciu adresów IP. Instancje w obu VPC mogą komunikować się ze sobą tak, jakby znajdowały się w tej samej sieci.

* VPC Endpoints pozwalają na łączenie się z usługami AWS za pomocą sieci prywatnej zamiast sieci publicznej.
