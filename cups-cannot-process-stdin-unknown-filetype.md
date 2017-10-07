# cups Cannot process "&lt;STDIN&gt;": Unknown filetype.

Po aktualizacji do opensuse leap 42.2, nie mogłem wydrukować plików. Drukarka była podłaczona do innego komputera i udostępniona przez protokół IPP.

W logach `cups` na serwerze znalazłem:
```
I [29/Sep/2017:08:26:46 +0000] [Job 250] Adding start banner page "none".
I [29/Sep/2017:08:26:46 +0000] [Job 250] Queued on "samsung2010ml" by "vagrant".
I [29/Sep/2017:08:26:46 +0000] [Job 250] File of type application/vnd.cups-pdf queued by "vagrant".
I [29/Sep/2017:08:26:46 +0000] [Job 250] Adding end banner page "none".
D [29/Sep/2017:08:26:46 +0000] [Job 250] time-at-processing=1506673606
D [29/Sep/2017:08:26:46 +0000] [Job 250] 1 filters for job:
D [29/Sep/2017:08:26:46 +0000] [Job 250] foomatic-rip (application/vnd.cups-pdf to printer/samsung2010ml, cost 0)
D [29/Sep/2017:08:26:46 +0000] [Job 250] job-sheets=none,none
D [29/Sep/2017:08:26:46 +0000] [Job 250] argv[0]="samsung2010ml"
D [29/Sep/2017:08:26:46 +0000] [Job 250] argv[1]="250"
D [29/Sep/2017:08:26:46 +0000] [Job 250] argv[2]="vagrant"
D [29/Sep/2017:08:26:46 +0000] [Job 250] argv[3]="(stdin)"
D [29/Sep/2017:08:26:46 +0000] [Job 250] argv[4]="1"
D [29/Sep/2017:08:26:46 +0000] [Job 250] argv[5]="finishings=3 job-uuid=urn:uuid:2726736b-613e-3c32-4fff-7e37dde11b51 number-up=1 job-originating-host-name=192.168.0.11 time-at-creation=1506673606 time-at-processing=1506673606"
D [29/Sep/2017:08:26:46 +0000] [Job 250] argv[6]="/var/spool/cups/d00250-001"
D [29/Sep/2017:08:26:46 +0000] [Job 250] envp[0]="CUPS_CACHEDIR=/var/cache/cups"
D [29/Sep/2017:08:26:46 +0000] [Job 250] envp[1]="CUPS_DATADIR=/usr/share/cups"
D [29/Sep/2017:08:26:46 +0000] [Job 250] envp[2]="CUPS_DOCROOT=/usr/share/cups/doc-root"
D [29/Sep/2017:08:26:46 +0000] [Job 250] envp[3]="CUPS_FONTPATH=/usr/share/cups/fonts"
D [29/Sep/2017:08:26:46 +0000] [Job 250] envp[4]="CUPS_REQUESTROOT=/var/spool/cups"
D [29/Sep/2017:08:26:46 +0000] [Job 250] envp[5]="CUPS_SERVERBIN=/usr/lib/cups"
D [29/Sep/2017:08:26:46 +0000] [Job 250] envp[6]="CUPS_SERVERROOT=/etc/cups"
D [29/Sep/2017:08:26:46 +0000] [Job 250] envp[7]="CUPS_STATEDIR=/var/run/cups"
D [29/Sep/2017:08:26:46 +0000] [Job 250] envp[8]="HOME=/var/spool/cups/tmp"
D [29/Sep/2017:08:26:46 +0000] [Job 250] envp[9]="PATH=/usr/lib/cups/filter:/usr/bin:/usr/sbin:/bin:/usr/bin"
D [29/Sep/2017:08:26:46 +0000] [Job 250] envp[10]="SERVER_ADMIN=root@raspberrypi"
D [29/Sep/2017:08:26:46 +0000] [Job 250] envp[11]="SOFTWARE=CUPS/1.7.5"
D [29/Sep/2017:08:26:46 +0000] [Job 250] envp[12]="TMPDIR=/var/spool/cups/tmp"
D [29/Sep/2017:08:26:46 +0000] [Job 250] envp[13]="USER=root"
D [29/Sep/2017:08:26:46 +0000] [Job 250] envp[14]="CUPS_MAX_MESSAGE=2047"
D [29/Sep/2017:08:26:46 +0000] [Job 250] envp[15]="CUPS_SERVER=/var/run/cups/cups.sock"
D [29/Sep/2017:08:26:46 +0000] [Job 250] envp[16]="CUPS_ENCRYPTION=IfRequested"
D [29/Sep/2017:08:26:46 +0000] [Job 250] envp[17]="IPP_PORT=631"
D [29/Sep/2017:08:26:46 +0000] [Job 250] envp[18]="CHARSET=utf-8"
D [29/Sep/2017:08:26:46 +0000] [Job 250] envp[19]="LANG=pl_PL.UTF-8"
D [29/Sep/2017:08:26:46 +0000] [Job 250] envp[20]="PPD=/etc/cups/ppd/samsung2010ml.ppd"
D [29/Sep/2017:08:26:46 +0000] [Job 250] envp[21]="RIP_MAX_CACHE=128m"
D [29/Sep/2017:08:26:46 +0000] [Job 250] envp[22]="CONTENT_TYPE=application/vnd.cups-pdf"
D [29/Sep/2017:08:26:46 +0000] [Job 250] envp[23]="DEVICE_URI=usb://Samsung/ML-2010?serial=4621BKDPA24185W."
D [29/Sep/2017:08:26:46 +0000] [Job 250] envp[24]="PRINTER_INFO=samsung"
D [29/Sep/2017:08:26:46 +0000] [Job 250] envp[25]="PRINTER_LOCATION="
D [29/Sep/2017:08:26:46 +0000] [Job 250] envp[26]="PRINTER=samsung2010ml"
D [29/Sep/2017:08:26:46 +0000] [Job 250] envp[27]="PRINTER_STATE_REASONS=none"
D [29/Sep/2017:08:26:46 +0000] [Job 250] envp[28]="CUPS_FILETYPE=document"
D [29/Sep/2017:08:26:46 +0000] [Job 250] envp[29]="FINAL_CONTENT_TYPE=printer/samsung2010ml"
D [29/Sep/2017:08:26:46 +0000] [Job 250] envp[30]="AUTH_I****"
I [29/Sep/2017:08:26:46 +0000] [Job 250] Started filter /usr/lib/cups/filter/gziptoany (PID 8928)
I [29/Sep/2017:08:26:46 +0000] [Job 250] Started filter /usr/lib/cups/filter/foomatic-rip (PID 8929)
I [29/Sep/2017:08:26:46 +0000] [Job 250] Started backend /usr/lib/cups/backend/usb (PID 8930)
D [29/Sep/2017:08:26:46 +0000] [Job 250] PID 8928 (/usr/lib/cups/filter/gziptoany) exited with no errors.
D [29/Sep/2017:08:26:46 +0000] [Job 250] Loading USB quirks from "/usr/share/cups/usb".
D [29/Sep/2017:08:26:46 +0000] [Job 250] Loaded 113 quirks.
D [29/Sep/2017:08:26:46 +0000] [Job 250] Printing on printer with URI: usb://Samsung/ML-2010?serial=4621BKDPA24185W.
D [29/Sep/2017:08:26:46 +0000] [Job 250] Calling FindDeviceById(cups-samsung2010ml)
D [29/Sep/2017:08:26:46 +0000] [Job 250] libusb_get_device_list=6
D [29/Sep/2017:08:26:46 +0000] [Job 250] STATE: +connecting-to-device
D [29/Sep/2017:08:26:46 +0000] [Job 250] STATE: -connecting-to-device
D [29/Sep/2017:08:26:46 +0000] [Job 250] Found device /org/freedesktop/ColorManager/devices/cups_samsung2010ml
D [29/Sep/2017:08:26:46 +0000] [Job 250] Calling org.freedesktop.ColorManager.Device.Get(ProfilingInhibitors)
D [29/Sep/2017:08:26:46 +0000] [Job 250] Device protocol: 2
I [29/Sep/2017:08:26:46 +0000] [Job 250] Sending data to printer.
D [29/Sep/2017:08:26:46 +0000] [Job 250] Set job-printer-state-message to "Sending data to printer.", current level=INFO
D [29/Sep/2017:08:26:46 +0000] [Job 250] 'CM Color Calibration' Mode in SPOOLER-LESS: Off
D [29/Sep/2017:08:26:46 +0000] [Job 250] Getting input from file 
D [29/Sep/2017:08:26:46 +0000] [Job 250] foomatic-rip version 1.0.61 running...
D [29/Sep/2017:08:26:46 +0000] [Job 250] Parsing PPD file ...
D [29/Sep/2017:08:26:46 +0000] [Job 250] Added option ColorSpace
D [29/Sep/2017:08:26:46 +0000] [Job 250] Added option Manualfeed
D [29/Sep/2017:08:26:46 +0000] [Job 250] Added option Resolution
D [29/Sep/2017:08:26:46 +0000] [Job 250] Added option Economode
D [29/Sep/2017:08:26:46 +0000] [Job 250] Added option MediaType
D [29/Sep/2017:08:26:46 +0000] [Job 250] Added option RET
D [29/Sep/2017:08:26:46 +0000] [Job 250] Added option Copies
D [29/Sep/2017:08:26:46 +0000] [Job 250] Added option PageSize
D [29/Sep/2017:08:26:46 +0000] [Job 250] Added option ImageableArea
D [29/Sep/2017:08:26:46 +0000] [Job 250] Added option PaperDimension
D [29/Sep/2017:08:26:46 +0000] [Job 250] Added option Density
D [29/Sep/2017:08:26:46 +0000] [Job 250] Added option JamRecovery
D [29/Sep/2017:08:26:46 +0000] [Job 250] Added option AllowReprint
D [29/Sep/2017:08:26:46 +0000] [Job 250] Added option Altitude
D [29/Sep/2017:08:26:46 +0000] [Job 250] Added option PageTimeout
D [29/Sep/2017:08:26:46 +0000] [Job 250] Added option PowerSaving
D [29/Sep/2017:08:26:46 +0000] [Job 250] Added option PowerSaveTime
D [29/Sep/2017:08:26:46 +0000] [Job 250] Added option PageSizeJCL
D [29/Sep/2017:08:26:46 +0000] [Job 250] Added option PageSizePS
D [29/Sep/2017:08:26:46 +0000] [Job 250] Added option Font
D [29/Sep/2017:08:26:46 +0000] [Job 250] Parameter Summary
D [29/Sep/2017:08:26:46 +0000] [Job 250] -----------------
D [29/Sep/2017:08:26:46 +0000] [Job 250] Spooler: cups
D [29/Sep/2017:08:26:46 +0000] [Job 250] Printer: samsung2010ml
D [29/Sep/2017:08:26:46 +0000] [Job 250] Shell: /bin/bash
D [29/Sep/2017:08:26:46 +0000] [Job 250] PPD file: /etc/cups/ppd/samsung2010ml.ppd
D [29/Sep/2017:08:26:46 +0000] [Job 250] ATTR file: 
D [29/Sep/2017:08:26:46 +0000] [Job 250] Printer model: Samsung ML-2010 Foomatic/gdi
D [29/Sep/2017:08:26:46 +0000] [Job 250] Job title: stdin
D [29/Sep/2017:08:26:46 +0000] [Job 250] File(s) to be printed:
D [29/Sep/2017:08:26:46 +0000] [Job 250] <STDIN>
D [29/Sep/2017:08:26:46 +0000] [Job 250] Ghostscript extra search path ('GS_LIB'): /usr/share/cups/fonts
D [29/Sep/2017:08:26:46 +0000] [Job 250] Printing system options:
D [29/Sep/2017:08:26:46 +0000] [Job 250] Pondering option 'finishings=3'
D [29/Sep/2017:08:26:46 +0000] [Job 250] Unknown option finishings=3.
D [29/Sep/2017:08:26:46 +0000] [Job 250] Pondering option 'job-uuid=urn:uuid:2726736b-613e-3c32-4fff-7e37dde11b51'
D [29/Sep/2017:08:26:46 +0000] [Job 250] Unknown option job-uuid=urn:uuid:2726736b-613e-3c32-4fff-7e37dde11b51.
D [29/Sep/2017:08:26:46 +0000] [Job 250] Pondering option 'number-up=1'
D [29/Sep/2017:08:26:46 +0000] [Job 250] Unknown option number-up=1.
D [29/Sep/2017:08:26:46 +0000] [Job 250] Pondering option 'job-originating-host-name=192.168.0.11'
D [29/Sep/2017:08:26:46 +0000] [Job 250] Unknown option job-originating-host-name=192.168.0.11.
D [29/Sep/2017:08:26:46 +0000] [Job 250] Pondering option 'time-at-creation=1506673606'
D [29/Sep/2017:08:26:46 +0000] [Job 250] Unknown option time-at-creation=1506673606.
D [29/Sep/2017:08:26:46 +0000] [Job 250] Pondering option 'time-at-processing=1506673606'
D [29/Sep/2017:08:26:46 +0000] [Job 250] Unknown option time-at-processing=1506673606.
D [29/Sep/2017:08:26:46 +0000] [Job 250] CM Color Calibration Mode in CUPS: Off
D [29/Sep/2017:08:26:46 +0000] [Job 250] Options from the PPD file:
D [29/Sep/2017:08:26:46 +0000] [Job 250] ================================================
D [29/Sep/2017:08:26:46 +0000] [Job 250] File: <STDIN>
D [29/Sep/2017:08:26:46 +0000] [Job 250] ================================================
D [29/Sep/2017:08:26:46 +0000] [Job 250] Cannot process "<STDIN>": Unknown filetype.
D [29/Sep/2017:08:26:46 +0000] [Job 250] Process is dying with "Could not print file <STDIN>
D [29/Sep/2017:08:26:46 +0000] [Job 250] ", exit stat 2
D [29/Sep/2017:08:26:46 +0000] [Job 250] Cleaning up...
D [29/Sep/2017:08:26:46 +0000] [Job 250] Sent 0 bytes...
D [29/Sep/2017:08:26:46 +0000] [Job 250] Waiting for read thread to exit...
D [29/Sep/2017:08:26:46 +0000] [Job 250] PID 8929 (/usr/lib/cups/filter/foomatic-rip) stopped with status 2.
D [29/Sep/2017:08:26:53 +0000] [Job 250] Read thread still active, aborting the pending read...
D [29/Sep/2017:08:26:54 +0000] [Job 250] Resetting printer.
D [29/Sep/2017:08:26:54 +0000] [Job 250] PID 8930 (/usr/lib/cups/backend/usb) exited with no errors.
E [29/Sep/2017:08:26:54 +0000] [Job 250] Job stopped due to filter errors; please consult the error_log file for details.
D [29/Sep/2017:08:26:54 +0000] [Job 250] The following messages were recorded from 08:26:46 to 08:26:46
D [29/Sep/2017:08:26:54 +0000] [Job 250] Printer found with device ID: MFG:Samsung;CMD:GDI;MDL:ML-2010;CLS:PRINTER;STATUS:BUSY; Device URI: usb://Samsung/ML-2010?serial=4621BKDPA24185W.
D [29/Sep/2017:08:26:54 +0000] [Job 250] End of messages
D [29/Sep/2017:08:26:54 +0000] [Job 250] printer-state=3(idle)
D [29/Sep/2017:08:26:54 +0000] [Job 250] printer-state-message="Filter failed"
D [29/Sep/2017:08:26:54 +0000] [Job 250] printer-state-reasons=none
D [29/Sep/2017:08:26:55 +0000] [Job 250] Unloading...
D [29/Sep/2017:08:26:58 +0000] [Job 250] Loading attributes...
D [29/Sep/2017:08:27:59 +0000] [Job 250] Unloading...
D [29/Sep/2017:08:27:59 +0000] [Job 250] Loading attributes...
D [29/Sep/2017:08:29:00 +0000] [Job 250] Unloading...
D [29/Sep/2017:08:29:00 +0000] [Job 250] Loading attributes...
D [29/Sep/2017:08:30:02 +0000] [Job 250] Unloading...
D [29/Sep/2017:08:30:02 +0000] [Job 250] Loading attributes...
D [29/Sep/2017:08:31:03 +0000] [Job 250] Unloading...
D [29/Sep/2017:08:31:07 +0000] [Job 250] Loading attributes...
E [29/Sep/2017:08:31:57 +0000] [Job 250] Stopping unresponsive job.
D [29/Sep/2017:08:32:08 +0000] [Job 250] Unloading...
D [29/Sep/2017:08:32:11 +0000] [Job 250] Loading attributes...
D [29/Sep/2017:08:33:12 +0000] [Job 250] Unloading...
D [29/Sep/2017:08:33:13 +0000] [Job 250] Loading attributes...
D [29/Sep/2017:08:34:16 +0000] [Job 250] Unloading...
D [29/Sep/2017:08:35:26 +0000] [Job 250] Loading attributes...
D [29/Sep/2017:08:36:27 +0000] [Job 250] Unloading...
D [29/Sep/2017:09:24:03 +0000] [Job 250] Loading attributes...
D [29/Sep/2017:09:25:07 +0000] [Job 250] Unloading...
D [29/Sep/2017:09:35:33 +0000] [Job 250] Loading attributes...
D [29/Sep/2017:09:36:37 +0000] [Job 250] Unloading...
```

Zaciekawił mnie następujący wpis.
```
D [29/Sep/2017:08:26:46 +0000] [Job 250] Cannot process "<STDIN>": Unknown filetype.
```

Strona https://bugzilla.redhat.com/show_bug.cgi?id=1160913, opisywała problem bardzo podobny do mojego.
Zasugerowane rozwiązanie, okazało się poprawne. Musiałem zmienić `Make` na `Generic` i `Model` na `IPP Everywhere Printer` w konfiguracji drukarki.
>After installation, run system-config-printer, then try the following (you may be prompted to enter the root password during this process):
Double click on the printer to amend > Settings > Make and model > Change... > Select printer from database > Choose the "Generic" make > Choose the "Raw Queue" option > Use the new PPD as is > Apply.

