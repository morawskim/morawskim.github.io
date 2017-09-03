Vim - śledzenie wywołań funkcji
===============================

Podczas uruchomienia, vim ładuje i wykonuje sporą ilość funkcji. Chcąc dowiedzieć się co dzieje się podczas tworzenie/wczytywania pliku należy wywołać edytor vim w trybie gadatliwym.

``` bash
vim -V[n]{plik_gdzie_bedzie_zapisywane_dane_trybu_gadatliwego} /tmp/test.spec
#np.
vim -V20/tmp/vimverbose  /tmp/test.spec
```

```
....
"/tmp/test.spec" [Nowy Plik]
Wczytuję plik viminfo "/home/marcin/.viminfo" zakładki
Wykonuję BufNewFile Autokomend dla "*.spec"
autokomenda call SKEL_spec()

chdir(/usr/share/vim/current/skeletons)
fchdir() to previous dir
"/usr/share/vim/current/skeletons/skeleton.spec"
"/usr/share/vim/current/skeletons/skeleton.spec" 51L, 1150C
Wykonuję FileType Autokomend dla "*"
....
```

W tym przypadku dla pliku \*.spec wywoływana jest funkcja SKEL_spec, która wczytuje szablon i podmienia symbole zastępcze.