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
