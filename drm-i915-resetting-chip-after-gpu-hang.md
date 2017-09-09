drm/i915: Resetting chip after gpu hang
=======================================

Po aktualizacji z openSUSE 13.2 do 42.3 zauważyłem problemy z zawieszaniem się interfejsu graficznego. Przez parę sekund interfejs był zamrożony - nie można było w nic klikać. Po paru sekundach wszystko wracało do normy. Niemniej jednak ten problem często występował.

Postanowiłem sprawdzic komunikaty kernela.
``` bash
dmesg -T
....
[czw sie 10 12:48:52 2017] [drm:intel_set_cpu_fifo_underrun_reporting [i915]] *ERROR* uncleared fifo underrun on pipe B
[czw sie 10 12:48:52 2017] [drm:ironlake_irq_handler [i915]] *ERROR* CPU pipe B FIFO underrun
[czw sie 10 12:56:11 2017] drm/i915: Resetting chip after gpu hang
....
```

``` bash
dmesg -T
...
pią sie 11 08:21:38 2017] [drm] GPU HANG: ecode 7:0:0xf3cffffe, in X [3248], reason: Hang on render ring, action: reset
[pią sie 11 08:21:38 2017] [drm] GPU hangs can indicate a bug anywhere in the entire gfx stack, including userspace.
[pią sie 11 08:21:38 2017] [drm] Please file a _new_ bug report on bugs.freedesktop.org against DRI -> DRM/Intel
[pią sie 11 08:21:38 2017] [drm] drm/i915 developers can then reassign to the right component if it's not a kernel issue.
[pią sie 11 08:21:38 2017] [drm] The gpu crash dump is required to analyze gpu hangs, so please always attach it.
[pią sie 11 08:21:38 2017] [drm] GPU crash dump saved to /sys/class/drm/card0/error
[pią sie 11 08:21:38 2017] drm/i915: Resetting chip after gpu hang
[pią sie 11 08:21:41 2017] IPv6: ADDRCONF(NETDEV_UP): vboxnet0: link is not ready
[pią sie 11 08:21:41 2017] SUPR0GipMap: fGetGipCpu=0xb
[pią sie 11 08:21:42 2017] vboxdrv: 0000000000000000 VMMR0.r0
[pią sie 11 08:21:42 2017] VBoxNetFlt: attached to 'vboxnet0' / 0a:00:27:00:00:00
[pią sie 11 08:21:42 2017] IPv6: ADDRCONF(NETDEV_CHANGE): vboxnet0: link becomes ready
[pią sie 11 08:21:42 2017] device vboxnet0 entered promiscuous mode
[pią sie 11 08:21:42 2017] vboxdrv: 0000000000000000 VBoxDDR0.r0
[pią sie 11 08:21:50 2017] drm/i915: Resetting chip after gpu hang
[pią sie 11 08:22:00 2017] drm/i915: Resetting chip after gpu hang
[pią sie 11 08:22:01 2017] SFW2-INext-DROP-DEFLT IN=p2p1 OUT= MAC=64:00:6a:43:e8:05:b8:ae:ed:d6:9f:a6:08:00
...
```

Mając pewne informacje postanowiłem poszukać pomocy w internecie. Jak się okazało nie tylko ja miałem taki problem:
* https://bugs.freedesktop.org/show_bug.cgi?id=101967
* https://bugzilla.opensuse.org/show_bug.cgi?id=1051060#c15
* https://bugzilla.opensuse.org/show_bug.cgi?id=1050256
* https://bugs.freedesktop.org/show_bug.cgi?id=102120
* https://bugs.freedesktop.org/show_bug.cgi?id=99671
* https://forums.opensuse.org/showthread.php/520969-drm-915-Resetting-chip-after-gpu-hang/page2

Problem powodował pakiet `drm-kmp-default`, ponieważ miałem procesor `i3-4170  Haswell`. Inni użytkownicy proponowali skasować ten pakiet w przypadku czwartej lub wcześniejszych generacji procesora Intel i3. Po skasowaniu tego pakietu i ponownym uruchomieniu komputera, problem  już nie występował.





