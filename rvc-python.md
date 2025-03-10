# rvc-python

Projekt rvc-python ([GitHub](https://github.com/daswer123/rvc-python)) to implementacja Retrieval-based Voice Conversion (RVC) w języku Python, pozwalająca na modyfikację głosu przy użyciu modeli AI.

Modele RVC można pobrać ze strony [Hugging Face](https://huggingface.co/UBandant/RVCModels).

Używamy Vagrant, aby stworzyć maszynę wirtualną z Ubuntu.
W moim przypadku maszyna wirtualna musiał posiadać minimum 6GB pamięci.

```
vagrant init ubuntu/jammy64
vagrant up
vagrant ssh  # Logowanie do maszyny wirtualnej
```

Po zalogowaniu do VM wykonujemy:
```
sudo apt update
sudo apt install -y unzip python3-venv
```

Tworzymy wirtualne środowisko Pythona i instalujemy bibliotekę rvc-python:

```
python3 -m venv rvc
cd rvc
source bin/activate
pip3 install rvc-python

```

Dla przykładu pobierzemy model Donald:
```
wget -O donald.zip 'https://huggingface.co/UBandant/RVCModels/resolve/main/Donald.zip?download=true'
unzip donald.zip
```

Aby przekształcić plik audio `clip.wav`, wykonujemy:
`python3 -m rvc_python cli -i /vagrant/clip.wav -o output.wav -mp ./Donald.pth --index added_IVF1072_Flat_nprobe_1_Donald_v2.index`

Jeśli pojawi się błąd:

>2025-03-10 11:34:47 | WARNING | rvc_python.modules.vc.modules | Traceback (most recent call last):
  File "/home/vagrant/rvc/lib/python3.10/site-packages/rvc_python/modules/vc/modules.py", line 168, in vc_single
    self.hubert_model = load_hubert(self.config,self.lib_dir)
  File "/home/vagrant/rvc/lib/python3.10/site-packages/rvc_python/modules/vc/utils.py", line 22, in load_hubert
    models, _, _ = checkpoint_utils.load_model_ensemble_and_task(
  File "/home/vagrant/rvc/lib/python3.10/site-packages/fairseq/checkpoint_utils.py", line 425, in load_model_ensemble_and_t
ask
    state = load_checkpoint_to_cpu(filename, arg_overrides)
  File "/home/vagrant/rvc/lib/python3.10/site-packages/fairseq/checkpoint_utils.py", line 315, in load_checkpoint_to_cpu
    state = torch.load(f, map_location=torch.device("cpu"))
  File "/home/vagrant/rvc/lib/python3.10/site-packages/torch/serialization.py", line 1470, in load
    raise pickle.UnpicklingError(_get_wo_message(str(e))) from None
_pickle.UnpicklingError: Weights only load failed. This file can still be loaded, to do so you have two options, do those steps only if you trust the source of the checkpoint.
...
  (1) In PyTorch 2.6, we changed the default value of the `weights_only` argument in `torch.load` from `False` to `True`. Re-running `torch.load` with `weights_only` set to `False` will likely succeed, but it can result in arbitrary code ex
ecution. Do it only if you got the file from a trusted source.

musimy zmodyfikować plik `lib/python3.10/site-packages/fairseq/checkpoint_utils.py`.
Modyfikujemy linię 315 (dodajemy argument `weights_only=False`):

```
- state = torch.load(f, map_location=torch.device("cpu"))
+ state = torch.load(f, map_location=torch.device("cpu"), weights_only=False)
```

Po poprawce ponownie uruchamiamy polecenie konwersji:
`python3 -m rvc_python cli -i /vagrant/clip.wav -o output.wav -mp ./Donald.pth --index added_IVF1072_Flat_nprobe_1_Donald_v2.index`.
Teraz powinniśmy otrzymać plik `output.wav`
