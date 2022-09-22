# ansible-bender

ansible-bender służy do budowania obrazu kontenera za pomocą anisble, podman i buildah.
Obecnie chcąc budować obrazy za pomocą buildah musimy doinstalować moduł ansible - `ansible-galaxy collection install containers.podman`.
Poleceniem `ansible-doc -t connection -l` potwierdzamy dostępność pluginu do połączenia się z buildah "containers.podman.buildah".

```
containers.podman.buildah Interact with an existing buildah container
containers.podman.podman  Interact with an existing podman container
local                     execute on controller
paramiko_ssh              Run tasks via python ssh (paramiko)
psrp                      Run tasks over Microsoft PowerShell Remoting Protocol
ssh                       connect via SSH client binary
winrm                     Run tasks over Microsoft's WinRM
```

Obraz budujemy poleceniem `ansible-bender build /path/to/playbook.yml`.
W przypadku błędów możemy dodać flagi (`-vvv --debug`) aby wyświetlać dodatkowe informacje diagnostyczne `ansible-bender -vvv --debug build /path/to/playbook.yml`.

Jeśli uruchamiamy ansible-bender w dockerze to kontener musi działać w trybie z dodatkowymi uprawnieniami - `docker run --privileged ...`

### Dockerfile:

```
FROM fedora:latest

RUN dnf -y install podman buildah ansible-bender findutils fuse-overlayfs
RUN ansible-galaxy collection install containers.podman

ADD https://raw.githubusercontent.com/containers/libpod/master/contrib/podmanimage/stable/containers.conf /etc/containers/containers.conf
ADD https://raw.githubusercontent.com/containers/libpod/master/contrib/podmanimage/stable/podman-containers.conf /home/podman/.config/containers/containers.conf

RUN mkdir -p /var/lib/shared/overlay-images /var/lib/shared/overlay-layers /var/lib/shared/vfs-images /var/lib/shared/vfs-layers; touch /var/lib/shared/overlay-images/images.lock; touch /var/lib/shared/overlay-layers/layers.lock; touch /var/lib/shared/vfs-images/images.lock; touch /var/lib/shared/vfs-layers/layers.lock

```

### playbook

```
---
- name: Demonstration of ansible-bender functionality
  hosts: all
  vars:
    ansible_bender:
      base_image: docker.io/python:3-alpine
      target_image:
        name: a-very-nice-image

  tasks:
  - name: Run a sample command
    command: 'ls -lha /'

```

[How to use Podman inside of a container](https://www.redhat.com/sysadmin/podman-inside-container)
