# AWS EC2 GPU

Przed pierwszym uruchomieniem maszyny wirtualnej G4DN należy zwiększyć limity zasobów w AWS, w szczególności limity vCPU [AWS EC2 VcpuLimitExceeded](aws-ec2-vcpulimitexceeded.md).
Maszyny te są wyposażone w układ NVIDIA Tesla T4.

Sterowniki NVIDIA można pobrać z [oficjalnej strony](https://www.nvidia.com/en-us/drivers/).

![nvidia driver download](images/nvidia-driver-download.png)

Wybieramy następujące opcje:
* Product Category: Data Center / Tesla
* Product Series: T-Series
* Product: Tesla T4
* Operating System: używana dystrybucja Linux

W przypadku dystrybucji Ubuntu sterowniki można zainstalować również za pomocą apt, instalując odpowiednie pakiety: `nvidia-driver-XXX nvidia-utils-XXX nvidia-dkms-XXX`.

Po poprawnej instalacji sterowników powinno być dostępne narzędzie `nvidia-smi`.

W przypadku instalacji sterowników pobranych bezpośrednio ze strony NVIDIA należy skopiować klucz GPG do odpowiedniej lokalizacji, np.: `sudo cp /var/nvidia-driver-local-repo-ubuntu2404-590.48.01/nvidia-driver-local-D948D85A-keyring.gpg /usr/share/keyrings/`
