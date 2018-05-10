# systemd snippets

## systemctl cat
Show backing files of one or more units. Prints the "fragment" and "drop-ins" (source files) of units. Each file is preceded by a comment which includes the file name.

``` bash
$ systemctl cat cron.service
# /usr/lib/systemd/system/cron.service
[Unit]
Description=Command Scheduler
After=ypbind.service nscd.service network.target
After=postfix.service sendmail.service exim.service

[Service]
ExecStart=/usr/sbin/cron -n
ExecReload=/usr/bin/kill -s SIGHUP $MAINPID
Restart=on-abort

[Install]
WantedBy=multi-user.target

```

## systemctl show
Show properties of one or more units, jobs, or the manager itself. If no argument is specified, properties of the manager will be shown. If a unit name is specified, properties of the unit is shown, and if a job ID is specified, properties of the job is shown. By default, empty properties are suppressed. Use --all to show those too. To select specific properties to show, use --property=. This command is intended to be used whenever computer-parsable output is required. Use status if you are looking for formatted human-readable output.

``` bash
$systemctl show cron.service

Type=simple
Restart=on-abort
NotifyAccess=none
RestartUSec=100ms
TimeoutStartUSec=1min 30s
TimeoutStopUSec=1min 30s
WatchdogUSec=0
WatchdogTimestamp=nie 2017-10-15 09:11:26 CEST
WatchdogTimestampMonotonic=12776356
StartLimitInterval=10000000
StartLimitBurst=5
StartLimitAction=none
FailureAction=none
PermissionsStartOnly=no
RootDirectoryStartOnly=no
RemainAfterExit=no
GuessMainPID=yes
MainPID=2625
ControlPID=0
FileDescriptorStoreMax=0
NFileDescriptorStore=0
StatusErrno=0
Result=success
ExecMainStartTimestamp=nie 2017-10-15 09:11:26 CEST
ExecMainStartTimestampMonotonic=12776310
ExecMainExitTimestampMonotonic=0
ExecMainPID=2625
ExecMainCode=0
ExecMainStatus=0
ExecStart={ path=/usr/sbin/cron ; argv[]=/usr/sbin/cron -n ; ignore_errors=no ; start_time=[nie 2017-10-15 09:11:26 CEST] ; stop_time=[n/a] ; pid=2625 ; code=(null) ; status=0/0 }
ExecReload={ path=/usr/bin/kill ; argv[]=/usr/bin/kill -s SIGHUP $MAINPID ; ignore_errors=no ; start_time=[n/a] ; stop_time=[n/a] ; pid=0 ; code=(null) ; status=0/0 }
Slice=system.slice
ControlGroup=/system.slice/cron.service
MemoryCurrent=720896
CPUUsageNSec=40466151
TasksCurrent=1
Delegate=no
CPUAccounting=no
CPUShares=18446744073709551615
StartupCPUShares=18446744073709551615
CPUQuotaPerSecUSec=infinity
BlockIOAccounting=no
BlockIOWeight=18446744073709551615
StartupBlockIOWeight=18446744073709551615
MemoryAccounting=no
MemoryLimit=18446744073709551615
DevicePolicy=auto
TasksAccounting=yes
TasksMax=512
UMask=0022
LimitCPU=18446744073709551615
LimitFSIZE=18446744073709551615
LimitDATA=18446744073709551615
LimitSTACK=18446744073709551615
LimitCORE=18446744073709551615
LimitRSS=18446744073709551615
LimitNOFILE=4096
LimitAS=18446744073709551615
LimitNPROC=31547
LimitMEMLOCK=65536
LimitLOCKS=18446744073709551615
LimitSIGPENDING=31547
LimitMSGQUEUE=819200
LimitNICE=0
LimitRTPRIO=0
LimitRTTIME=18446744073709551615
OOMScoreAdjust=0
Nice=0
IOScheduling=0
CPUSchedulingPolicy=0
CPUSchedulingPriority=0
TimerSlackNSec=50000
CPUSchedulingResetOnFork=no
NonBlocking=no
StandardInput=null
StandardOutput=journal
StandardError=inherit
TTYReset=no
TTYVHangup=no
TTYVTDisallocate=no
SyslogPriority=30
SyslogLevelPrefix=yes
SyslogLevel=6
SyslogFacility=3
SecureBits=0
CapabilityBoundingSet=18446744073709551615
MountFlags=0
PrivateTmp=no
PrivateNetwork=no
PrivateDevices=no
ProtectHome=no
ProtectSystem=no
SameProcessGroup=no
UtmpMode=init
IgnoreSIGPIPE=yes
NoNewPrivileges=no
SystemCallErrorNumber=0
RuntimeDirectoryMode=0755
KillMode=control-group
KillSignal=15
SendSIGKILL=yes
SendSIGHUP=no
Id=cron.service
Names=cron.service
Requires=sysinit.target system.slice
WantedBy=multi-user.target
Conflicts=shutdown.target
Before=shutdown.target multi-user.target
After=sendmail.service ypbind.service system.slice network.target basic.target sysinit.target nscd.service postfix.service exim.service systemd-journald.socket
Description=Command Scheduler
LoadState=loaded
ActiveState=active
SubState=running
FragmentPath=/usr/lib/systemd/system/cron.service
UnitFileState=enabled
UnitFilePreset=enabled
InactiveExitTimestamp=nie 2017-10-15 09:11:26 CEST
InactiveExitTimestampMonotonic=12776359
ActiveEnterTimestamp=nie 2017-10-15 09:11:26 CEST
ActiveEnterTimestampMonotonic=12776359
ActiveExitTimestampMonotonic=0
InactiveEnterTimestampMonotonic=0
CanStart=yes
CanStop=yes
CanReload=yes
CanIsolate=no
StopWhenUnneeded=no
RefuseManualStart=no
RefuseManualStop=no
AllowIsolate=no
DefaultDependencies=yes
OnFailureJobMode=replace
IgnoreOnIsolate=no
NeedDaemonReload=no
JobTimeoutUSec=0
JobRunningTimeoutUSec=0
JobTimeoutAction=none
ConditionResult=yes
AssertResult=yes
ConditionTimestamp=nie 2017-10-15 09:11:26 CEST
ConditionTimestampMonotonic=12762465
AssertTimestamp=nie 2017-10-15 09:11:26 CEST
AssertTimestampMonotonic=12762465
Transient=no
NetClass=0
```

## systemd-cat
Connect a pipeline or program's output with the journal

This calls /bin/ls with standard output and error connected to the journal:
``` bash
$ systemd-cat ls
```

## systemd-delta
Find overridden configuration files

```
systemd-delta
[OVERRIDDEN] /etc/systemd/system/php-fpm.service → /usr/lib/systemd/system/php-fpm.service

--- /usr/lib/systemd/system/php-fpm.service	2017-09-18 12:15:34.000000000 +0200
+++ /etc/systemd/system/php-fpm.service	2017-05-20 12:22:31.000000000 +0200
@@ -4,8 +4,12 @@
 Before=apache2.service nginx.service lighttpd.service
 
 [Service]
-Type=notify
-ExecStart=/usr/sbin/php-fpm --nodaemonize --fpm-config /etc/php5/fpm/php-fpm.conf
+# We dont use notify, because it not work with PHP53
+Type=simple
+Environment=MPHP_FPM_BIN_PATH=/usr/sbin/php-fpm
+EnvironmentFile=/etc/sysconfig/mphp-fpm
+ExecStart=/usr/sbin/mphp-fpm --nodaemonize --fpm-config /etc/php5/fpm/php-fpm.conf
+ExecStartPre=/usr/sbin/mphp-fpm-set-symlink
 ExecReload=/bin/kill -USR2 $MAINPID
 ExecStop=/bin/kill -QUIT $MAINPID
 PrivateTmp=true

...
104 overridden configuration files found.
```

## systemd-run (v235)
``` bash
systemd-run -p IPAccounting=yes --wait wget https://cfp.all-systems-go.io/en/ASG2017/public/schedule/2.pdf
```

## systemctl edit
```
systemctl edit UNIT
```

## Lista timerów (unit timer)
```
systemctl list-timers
NEXT                          LEFT        LAST                          PASSED       UNIT                         ACTIVATES
wto 2018-05-08 17:53:50 CEST  23h left    pon 2018-05-07 17:53:50 CEST  29min ago    systemd-tmpfiles-clean.timer systemd-tmpfiles-clean.service
pon 2018-05-14 00:00:00 CEST  6 days left pon 2018-05-07 17:10:54 CEST  1h 12min ago fstrim.timer                 fstrim.service

2 timers listed.
Pass --all to see loaded but inactive timers, too.
```
