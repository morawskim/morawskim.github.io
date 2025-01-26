# PyTorch

## Instalacja

Tworzymy nowe wirtualne środowisko w aktualnym katalogu roboczym - `python3 -m venv .`
Nastepnie je aktywujemy `source ./bin/activate`

Wchodzimy na stronę [PyTorch - Start Locally](https://pytorch.org/get-started/locally/) i wybieramy system operacyjny, język itd.
Otrzymamy polecenie, które musimy wykonać. W moim przypadku `pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu`
Następnie zapisujemy pobrane wersje pakietów do pliku `requirements.txt` - `pip3 freeze > requirements.txt`
Musimy dodać na początku pliku `requirements.txt` adres do dodatkowego repozytorium z pakietami pytorch: `--extra-index-url https://download.pytorch.org/whl/cpu`

## Demo resnet101

Plik imagenet_classes.txt [pobieramy](https://github.com/deep-learning-with-pytorch/dlwpt-code/blob/master/data/p1ch2/imagenet_classes.txt) i zapisujemy w tym samym katalogu roboczym co skrypt.

```
from torchvision import models
from torchvision import transforms
from PIL import Image
import torch
import sys

imagePath = sys.argv[1]
resnet = models.resnet101(pretrained=True)
preprocess = transforms.Compose([
    transforms.Resize(256),
    transforms.CenterCrop(224),
    transforms.ToTensor(),
    transforms.Normalize(
        mean=[0.485, 0.456, 0.406],
        std=[0.229, 0.224, 0.225]
    )
])

img = Image.open(imagePath)
img_t = preprocess(img)
batch_t = torch.unsqueeze(img_t, 0)
resnet.eval()
out = resnet(batch_t)

with open('imagenet_classes.txt') as f:
    labels = [line.strip() for line in f.readlines()]

percentage = torch.nn.functional.softmax(out, dim=1)[0] * 100
_, indices = torch.sort(out, descending=True)
result = [(labels[idx], percentage[idx].item()) for idx in indices[0][:5]]

print(result)
```

## DataSet

Własny DataSet może być przydatny, kiedy dane treningowe/testowe dla naszej sieci neuronowej są przechowywane w niestandardowy sposób.
Tworzymy go tworząc nową klasę, która dziedziczy po `torch.utils.data.Dataset` i implementuje metody `__len__` i `__getitem__`.

```
class MyDataSet(torch.utils.data.Dataset):
    def __len__(self):
        pass

    def __getitem__(self, index: int):
        pass

```

## CUDA

Do korzystania z CUDA potrzebujemy karty graficznej od NVIDIA.
W przypadku dystrybucji z rodziny Ubuntu instalujemy pakiety `sudo apt install nvidia-driver-550 nvidia-utils-550 nvidia-dkms-550`
Po ponownym uruchomieniu systemu, możemy wywołać program `nvidia-smi`, aby monitorować GPU.

```
Sat Jan 25 19:38:29 2025
+-----------------------------------------------------------------------------------------+
| NVIDIA-SMI 550.120                Driver Version: 550.120        CUDA Version: 12.4     |
|-----------------------------------------+------------------------+----------------------+
# .....
```

Jeśli w powłoce python REPL i otrzymamy błąd "Torch not compiled with CUDA enabled", to zainstalowaliśmy PyTorch bez obsługi CUDA.

```
>>> torch.cuda.is_available()
False
>>> torch.zeros(1).cuda()
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
  File "/zzzzzzzzzzz/lib/python3.12/site-packages/torch/cuda/__init__.py", line 310, in _lazy_init
    raise AssertionError("Torch not compiled with CUDA enabled")
AssertionError: Torch not compiled with CUDA enabled
```

Wchodzimy na stronę [PyTorch - Start Locally](https://pytorch.org/get-started/locally/) i wybieramy system operacyjny, język i wersję CUDA.
Otrzymamy polecenie, który należy wywołać na naszej maszynie.
Po pobraniu pakietu torch, wsparcie dla CUDA będzie dostępne.

```
>>> import torch
>>> torch.cuda.is_available()
True
>>> torch.zeros(1).cuda()
tensor([0.], device='cuda:0')
>>>
```

### Konfiguracja kodu niezależnego od urządzenia

```
device = "cuda" if torch.cuda.is_available() else "cpu"
```
