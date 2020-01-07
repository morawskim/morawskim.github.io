# python - snippets

## UnicodeEncodeError: 'ascii' codec can't encode character

Na kontenerze opensuse chciałem zainstalować pakiet pythona przez narzędzie pipx.
Pakiet się instalował, ale dostawałem na końcu błąd.
Pipx próbuje na końcu pracy wyświetlić symbole utf8 - ✨ 🌟 ✨.
Na kontenerze nie miałem ustawionej lokalizacji utf8.

```
Traceback (most recent call last):
  File "/usr/bin/pipx", line 11, in <module>
    load_entry_point('pipx==0.12.2.0', 'console_scripts', 'pipx')()
  File "/usr/lib/python3.6/site-packages/pipx/main.py", line 348, in cli
    exit(run_pipx_command(parsed_pipx_args, binary_args))
  File "/usr/lib/python3.6/site-packages/pipx/main.py", line 117, in run_pipx_command
    force=args.force,
  File "/usr/lib/python3.6/site-packages/pipx/commands.py", line 314, in install
    print(f"done! {stars}")
UnicodeEncodeError: 'ascii' codec can't encode character '\u2728' in position 6: ordinal not in range(128)
```

Problem ten można rozwiązać na dwa sposoby.

Pierwszy to ustawienie zmiennej środowiskowej `PYTHONIOENCODING`. Jak poniżej.
`PYTHONIOENCODING=utf-8 pipx install csvkit`

Drugi to ustawienie lokalizacji i języka:
```
export LOCALE='C.utf8'
export LANG='C.utf8'
```
