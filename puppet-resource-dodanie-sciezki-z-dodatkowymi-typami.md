# puppet-resource - dodanie ścieżki z dodatkowymi typami

Za pomocną polecenie możemy wygenerować zrzut zasobu, który wystarczy wkleić do pliku manifestu.

``` bash
puppet resource user marcin
user { 'marcin':
  ensure  => 'present',
  comment => 'Marcin Morawski',
  gid     => '1000',
  groups  => ['disk', 'www', 'dialout', 'users', 'systemd-journal', 'docker', 'tomcat', 'vboxusers', 'sshfs', 'vagrant'],
  home    => '/home/marcin',
  shell   => '/bin/bash',
  uid     => '1000',
}
```

Jednak jeśli chcemy skorzystać z zewnętrznych typów (dostarczanych wraz z modułami puppet) to musimy dodać parametr `--basemodulepath=SCIEZKA_DO_MODULOW`.

``` bash
puppet resource --basemodulepath=/home/marcin/projekty/puppet_configuration/modules/ printer
printer { 'hp':
  ensure      => 'present',
  accept      => 'true',
  description => 'hp laserjet 2300',
  duplex      => 'None',
  enabled     => 'true',
  input_tray  => 'Default',
  options     => {'copies' => '1', 'finishings' => '3', 'job-hold-until' => 'no-hold', 'job-priority' => '50', 'job-sheets' => 'none,none', 'number-up' => '1', 'printer-make-and-model' => 'HP LaserJet 2300 Series hpijs, 3.16.5', 'printer-state-reasons' => 'none', 'printer-type' => '8425500', 'printer-uri-supported' => 'ipp://localhost:631/printers/hp'},
  page_size   => 'Letter',
  ppd_options => {'PrintoutMode' => 'Normal', 'Quality' => 'FromPrintoutMode'},
  uri         => 'socket://192.168.15.10',
}
printer { 'samsung':
  ensure      => 'present',
  accept      => 'true',
  color_model => 'Gray',
  description => 'samsung',
  duplex      => 'None',
  enabled     => 'true',
  input_tray  => 'Auto',
  options     => {'copies' => '1', 'finishings' => '3', 'job-hold-until' => 'no-hold', 'job-priority' => '50', 'job-sheets' => 'none,none', 'number-up' => '1', 'printer-make-and-model' => 'Samsung ML-2010, SpliX V. 2.0.0', 'printer-state-reasons' => 'none', 'printer-type' => '8400980', 'printer-uri-supported' => 'ipp://localhost:631/printers/samsung'},
  page_size   => 'Letter',
  ppd_options => {'Altitude' => 'LOW', 'EconoMode' => '0', 'JamRecovery' => 'False', 'MediaType' => 'OFF', 'PowerSave' => '5', 'Resolution' => '600dpi', 'TonerDensity' => '3'},
  uri         => 'http://print.morawskim.pl:631/printers/samsung2010ml',
}
```
