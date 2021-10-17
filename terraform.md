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
