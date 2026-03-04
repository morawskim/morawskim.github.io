# AMD Ryzen AI, ROCm i PyTorch

Do instalacji ROCm na Ubuntu 24 utworzyłem [playbook ansible](https://github.com/morawskim/provision-dev-servers/blob/5e6b6b9ef9c4b8f7974ad0056a4fdee8b5bd6703/workstation/gmktec/playbook.yml#L55).

Możemy też bazować na filmie: [Uruchom prywatne AI na zwykłym PC (cz.2) - A może Ollama nie na Windows a na Ubuntu Server... ??](https://www.youtube.com/watch?v=hRk759LCQkw).

AMD zaleca instalację PyTorch z ich repozytorium.
Aby to zrobić, musimy znać zainstalowaną wersję ROCm.

Sprawdzenie wersji ROCm:
* `hipcc --version`

> HIP version: 7.1.52802-26aae437f6
AMD clang version 20.0.0git (https://github.com/RadeonOpenCompute/llvm-project roc-7.1.1 25444 27682a16360e33e37c4f3cc6adf9a620733f8fe1)
Target: x86_64-unknown-linux-gnu
Thread model: posix
InstalledDir: /opt/rocm-7.1.1/lib/llvm/bin
Configuration file: /opt/rocm-7.1.1/lib/llvm/bin/clang++.cfg

* `dpkg -l | grep rocm`

> ii  rocm  7.1.1.70101-38~24.04     amd64    Radeon Open Compute (ROCm) software stack meta package

Z powyższych wyników widać, że zainstalowana wersja ROCm to 7.1.1.
Na stronie [Linux support matrices by ROCm version](https://rocm.docs.amd.com/projects/radeon-ryzen/en/latest/docs/compatibility/compatibilityryz/native_linux/native_linux_compatibility.html) można sprawdzić kompatybilność z systemem i Pythonem.

Dla wersji ROCm 7.1.1 obsługiwany jest Python 3.12 i PyTorch 2.9.

Pakiety PyTorch dla ROCm znajdują się pod adresem: [https://repo.radeon.com/rocm/manylinux/](https://repo.radeon.com/rocm/manylinux/).
Musimy podać odpowiednią wersję ROCm. Dla ROCm 7.1.1 adres będzie wyglądał tak:
[https://repo.radeon.com/rocm/manylinux/rocm-rel-7.1.1/](https://repo.radeon.com/rocm/manylinux/rocm-rel-7.1.1/)

Tworzymy katalog projektu, np. test-pytorch-rocm:

```
mkdir test-pytorch-rocm
cd test-pytorch-rocm
python3 -m venv .
```

Aktywujemy środowisko: `source bin/active`
Wywołuejmy polecenie:

```
wget https://repo.radeon.com/rocm/manylinux/rocm-rel-7.1.1/torch-2.9.1%2Brocm7.1.1.lw.git351ff442-cp312-cp312-linux_x86_64.whl && \
wget https://repo.radeon.com/rocm/manylinux/rocm-rel-7.1.1/torchvision-0.24.0%2Brocm7.1.1.gitb919bd0c-cp312-cp312-linux_x86_64.whl && \
wget https://repo.radeon.com/rocm/manylinux/rocm-rel-7.1.1/triton-3.5.1%2Brocm7.1.1.gita272dfa8-cp312-cp312-linux_x86_64.whl && \
wget https://repo.radeon.com/rocm/manylinux/rocm-rel-7.1.1/torchaudio-2.9.0%2Brocm7.1.1.gite3c6ee2b-cp312-cp312-linux_x86_64.whl && \
pip3 uninstall torch torchvision triton torchaudio && \
pip3 install torch-2.9.1+rocm7.1.1.lw.git351ff442-cp312-cp312-linux_x86_64.whl torchvision-0.24.0+rocm7.1.1.gitb919bd0c-cp312-cp312-linux_x86_64.whl triton-3.5.1+rocm7.1.1.gita272dfa8-cp312-cp312-linux_x86_64.whl torchaudio-2.9.0+rocm7.1.1.gite3c6ee2b-cp312-cp312-linux_x86_64.whl
```

## Weryfikacja instalacji

Sprawdzenie, czy PyTorch widzi GPU ROCm: `python3 -c 'import torch; print(torch.cuda.is_available())'`.
Powinno zwrócić: `True`.

Sprawdzenie nazwy urządzenia: `python3 -c "import torch; print(f'device name [0]:', torch.cuda.get_device_name(0))"`.
Powinno zwrócić:
> device name [0]: AMD Radeon Graphics

[Install PyTorch for ROCm](https://rocm.docs.amd.com/projects/radeon-ryzen/en/latest/docs/install/installryz/native_linux/install-pytorch.html)
