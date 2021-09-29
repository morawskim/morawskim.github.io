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
