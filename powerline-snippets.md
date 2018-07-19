# powerline - snippets

## powerline-render

W systemie openeSuSE Leap 15 pakiet powerline-tmux używa pythona3. Musiałem zainstalować dodatkowo pakiet `python3-psutil`, ponieważ korzystałem z dodatkowych segmentów powerline-tmux. Wywołując polecenie `powerline-render` z odpowiednimi argumentami na wyjściu zobaczymy pełen błąd. Zaś w statusbar tmux tylko fragment tego błędu.

```
/usr/bin/python3 /usr/bin/powerline-render tmux left -R pane_id=%0 --width=150 -R width_adjust=20
2018-07-17 20:37:58,493:ERROR:tmux:segment_generator:Failed to import attr mem_usage from module powerlinemem.mem_usage: No module named 'psutil'
Traceback (most recent call last):
  File "/usr/lib/python3.6/site-packages/powerline/__init__.py", line 392, in get_module_attr
    return getattr(__import__(module, fromlist=(attr,)), attr)
  File "/home/marcin/.local/share/powerline_segments/powerlinemem/mem_usage.py", line 1, in <module>
    import psutil
ModuleNotFoundError: No module named 'psutil'
```