# Terraform

## KVM cloud-init

Za pomocą terraform i dostawcy libvirt możemy zarządzać maszynami wirtualnymi KVM. Dystrybucja ubuntu i inne oferują gotowe obrazy do wdrażania w chmurach, które obsługują standard cloud-init. Za jego pomocą możemy dokonać modyfikacji systemu podczas pierwszego uruchomienia maszyny. Terraform wyręcza nas z tworzenia obrazów ISO z konfiguracją dla cloud-init.

```
resource "libvirt_volume" "ubuntu-lts-20" {
  name = "ubuntu-lts-20.qcow2"
  pool = "default"
  source = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img"
  format = "qcow2"
}

data "template_file" "user_data" {
  template = file("${path.module}/cloud_init.cfg")
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name = "commoninit-docker.iso"
  user_data      = data.template_file.user_data.rendered
}
```

[terraform-libvirt provider for Ubuntu hosts](https://github.com/fabianlee/terraform-libvirt-ubuntu-examples)
[libvirt cloudinit](https://github.com/dmacvicar/terraform-provider-libvirt/blob/master/website/docs/r/cloudinit.html.markdown)
[Ubuntu Cloud Images](https://cloud-images.ubuntu.com/)
[Cloud config examples](https://cloudinit.readthedocs.io/en/latest/topics/examples.html)

## Publiczny adres IP

Budują środowiska (np. do testów wydajności) chcemy ograniczyć dostęp do serwera do zaufanych adresów IP. W fazie testów możemy dodać nasz aktualny adres publiczny do reguł firewalla. Nasz publiczny adres IP poznamy za pomocą usługi [http://checkip.amazonaws.com](http://checkip.amazonaws.com).

```
# ...
data "http" "my_ip" {
   url = "http://checkip.amazonaws.com/"
}

# chomp(data.http.my_ip.body)
```

## Usuwanie ręcznie skasowanego zasobu z pliku stanu

Podczas tworzenia środowiska do testów wydajnościowych pojawiały się błędy API z DigitalOcean. Część zasobów zostało utworzonych, część nie. Dodatkowo próba skasowania utworzonych zasobów kończyła się także błędem API. Zasoby skasowałem przez panel użytkownika. Następnego dnia chciałem ponownie zbudować infrastrukturę pod testy wydajnościowe, ale dostałem błąd:

```
 Error: Error retrieving DatabaseFirewall: GET https://api.digitalocean.com/v2/databases/a3109a4af7b7-4de4-8d1f-8880c69521b3/firewall: 404 (request "d28c65b6-c7d0-45c3-8b98-f1747a868c03") cluster not found
│
│   with digitalocean_database_firewall.redis-fw,
│   on provider.tf line 155, in resource "digitalocean_database_firewall" "redis-fw":
│  155: resource "digitalocean_database_firewall" "redis-fw" {
│
```

Był to jeden z zasobów, które skasowałem ręcznie w panelu. Musimy go ręcznie skasować z pliku z stanem Terraform - `terraform state rm digitalocean_database_firewall.redis-fw`.

[Command: state rm](https://www.terraform.io/docs/cli/commands/state/rm.html)

[Resource manually deleted, now cant Destroy, Plan or Apply due to it missing, what do?](https://discuss.hashicorp.com/t/resource-manually-deleted-now-cant-destroy-plan-or-apply-due-to-it-missing-what-do/12215)

## Tips

Yevgeniy Brikman, _Terraform. Krótkie wprowadzenie. Tworzenie infrastruktury za pomocą kodu. Wydanie II_, Helion

* Za pomocą polecenia `terraform fmt` możemy sformatować kod zgodnie z wytycznymi Terraform. Na serwerze CI możemy wywołać polecenie `terraform fmt -check`.

* W przypadku wykorzystywania starszej wersji Terraform (< 1.0.0) zaleca się jawne określenie wymaganej wersji, ponieważ zaktualizowany plik stanu nie będzie zgodny z starszą wersją.

* Kod Terraform jest zawsze wdrażany z jednej gałęzi repozytoria. Zmiany są wprowadzane tylko w jednym rzeczywistym środowisku, więc wdrażanie z różnych gałęzi powodują problemy.

* W procesie CI powinniśmy nie zapominać o pliku `errored.tfstate` tworzonym przez Terraform, kiedy nie może zaktualizować zdalnego backendu np. Amazon S3. Mając taki plik możemy wysłać stan naszej infrastruktury później poleceniem `terraform state push errored.tfstate`.

* W przypadku wystąpienia problemu o zablokowanym stanu i mając pewność że nikt nie wykonuje żadnych zmian możemy wymusić zwolnienie blokady wywołując polecenie `terraform force-unlock <LOCK>`, gdzie `LOCK` to identyfikator blokady z komunikatu błędu.

* Ręcznie utworzone zasoby możemy zaimportować do pliku stanu poprzez wywołanie polecenia `import`.
W przypadku zasobu AWS polecenie będzie wyglądać następująco `terraform import zasóbAWS.<IDENTYFIKATOR_W_PLIKU_TF> <IDENYTIKATOR_AWS>`.

```
# fragment pliku tf
...
resource "aws_cloudwatch_log_group" "codebuild-SymfonyAwsDemo" {
  name              = "/aws/codebuild/SymfonyAwsDemo"
  retention_in_days = 3
}
...

# Polecenie do importu zasobu do pliku stanu terraform
terraform import aws_cloudwatch_log_group.codebuild-SymfonyAwsDemo /aws/codebuild/SymfonyAwsDemo
```

# Narzędzia

[Export existing AWS resources to Terraform style (tf, tfstate)](http://terraforming.dtan4.net/)

[Atlantis - Terraform Pull Request Automation](https://www.runatlantis.io/)

>Atlantis is an application for automating Terraform via pull requests. It is deployed as a standalone application into your infrastructure. No third-party has access to your credentials.

>Atlantis listens for GitHub, GitLab or Bitbucket webhooks about Terraform pull requests. It then runs terraform plan and comments with the output back on the pull request.

>When you want to apply, comment atlantis apply on the pull request and Atlantis will run terraform apply and comment back with the output.
