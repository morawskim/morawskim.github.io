Dmesg - czytelna data
=====================

Domyślnie dmesg wyświetla datę i czas w nieczytelnym formacie. Dodanie parametry "-T" spowoduje wyświetlenie daty w formie czytelnej dla człowieka.

``` bash
dmesg | grep -i sda
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.16.7-53-desktop root=UUID=0642d108-0639-4e11-95b1-3aa692b1b75f ro resume=/dev/sda2 splash=silent quiet showopts
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.16.7-53-desktop root=UUID=0642d108-0639-4e11-95b1-3aa692b1b75f ro resume=/dev/sda2 splash=silent quiet showopts
[    1.123432] PM: Checking hibernation image partition /dev/sda2
[    1.445321] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    1.445327] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    1.445376] sd 0:0:0:0: [sda] Write Protect is off
[    1.445380] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.445405] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.504335]  sda: sda1 sda2 sda3 sda4
[    1.504694] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.799168] EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: (null)
[   10.116032] EXT4-fs (sda3): re-mounted. Opts: acl,user_xattr
[   12.427765] FAT-fs (sda1): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
[   13.684332] Adding 2104316k swap on /dev/sda2.  Priority:-1 extents:1 across:2104316k FS
[   13.912245] EXT4-fs (sda4): mounted filesystem with ordered data mode. Opts: acl,user_xattr
```

``` bash
dmesg | grep -i sda
[pon sty  2 09:13:47 2017] Command line: BOOT_IMAGE=/boot/vmlinuz-3.16.7-53-desktop root=UUID=0642d108-0639-4e11-95b1-3aa692b1b75f ro resume=/dev/sda2 splash=silent quiet showopts
[pon sty  2 09:13:47 2017] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.16.7-53-desktop root=UUID=0642d108-0639-4e11-95b1-3aa692b1b75f ro resume=/dev/sda2 splash=silent quiet showopts
[pon sty  2 09:13:48 2017] PM: Checking hibernation image partition /dev/sda2
[pon sty  2 09:13:48 2017] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[pon sty  2 09:13:48 2017] sd 0:0:0:0: [sda] 4096-byte physical blocks
[pon sty  2 09:13:48 2017] sd 0:0:0:0: [sda] Write Protect is off
[pon sty  2 09:13:48 2017] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[pon sty  2 09:13:48 2017] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[pon sty  2 09:13:48 2017]  sda: sda1 sda2 sda3 sda4
[pon sty  2 09:13:48 2017] sd 0:0:0:0: [sda] Attached SCSI disk
[pon sty  2 09:13:50 2017] EXT4-fs (sda3): mounted filesystem with ordered data mode. Opts: (null)
[pon sty  2 09:13:57 2017] EXT4-fs (sda3): re-mounted. Opts: acl,user_xattr
[pon sty  2 09:13:59 2017] FAT-fs (sda1): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
[pon sty  2 09:14:00 2017] Adding 2104316k swap on /dev/sda2.  Priority:-1 extents:1 across:2104316k FS
[pon sty  2 09:14:00 2017] EXT4-fs (sda4): mounted filesystem with ordered data mode. Opts: acl,user_xattr
```