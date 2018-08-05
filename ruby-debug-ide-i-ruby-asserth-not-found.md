# ruby-debug-ide i ruby_assert.h not found

W systemie openSuSe Leap 15 próbowałem zainstalować przez bundler pakiet gem `ruby-debug-ide` w wersji 0.6.1.
Podczas budowania rozszerzenia dostałem błąd:

```
compiling debase_internals.c
In file included from ./hacks.h:1:0,
from debase_internals.c:2:
/usr/include/ruby-2.5.0/vm_core.h:45:10: fatal error: ruby_assert.h: Nie ma takiego pliku ani katalogu
#include "ruby_assert.h"
^~~~~~~~~~~~~~~
compilation terminated.
make: *** [Makefile:242: debase_internals.o] Błąd 1
```

Musiałem doinstalować pakiet dostarczający `rubygem(debase-ruby_core_source)`.
W moim przypadku jest to `ruby2.5-rubygem-debase-ruby_core_source`.
Musiałem jeszcze skonfigurować bundler, tak aby do make przekazać dodatkowe parametry kompilacji.

```
bundle config build.ruby-debug-ide --with-cppflags=-I/usr/lib64/ruby/gems/2.5.0/gems/debase-ruby_core_source-0.10.3/lib/debase/ruby_core_source/ruby-2.5.0-p0/
``

```
bundle config build.debase --with-cppflags=-I/usr/lib64/ruby/gems/2.5.0/gems/debase-ruby_core_source-0.10.3/lib/debase/ruby_core_source/ruby-2.5.0-p0/
```

Wszystkie zmiany powinny być widoczne po wywołaniu polecenia `bundle config`
```
Settings are listed in order of priority. The top value will be used.
jobs
Set for the current user (/home/marcin/.bundle/config): "3"

path
Set for the current user (/home/marcin/.bundle/config): "vendor/bundle"

# vim: ft=yaml
You have not configured a value for `# vim: ft=yaml`

build.debase
Set for the current user (/home/marcin/.bundle/config): "--with-cppflags=-I/usr/lib64/ruby/gems/2.5.0/gems/debase-ruby_core_source-0.10.3/lib/debase/ruby_core_source/ruby-2.5.0-p0/"

build.ruby-debug-ide
Set for the current user (/home/marcin/.bundle/config): "--with-cppflags=-I/usr/lib64/ruby/gems/2.5.0/gems/debase-ruby_core_source-0.10.3/lib/debase/ruby_core_source/ruby-2.5.0-p0/"
```

Po dodaniu ścieżki z plikami nagłówkowymi, pakiet zainstalował się pomyślnie.
