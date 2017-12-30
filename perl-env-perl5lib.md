# Perl - env PERL5LIB

Do działania skryptu `analyze-ssl.pl` (https://github.com/noxxi/p5-ssl-tools/blob/master/analyze-ssl.pl) potrzebny jest pakiet perla `IO::Socket::SSL` w wersji 1.984. OpenSUSE dostarcza w głównym repo wersję 1.962. Postanowiłem pobrać ten pakiet i zainstalować go w katalogu domowym.


```
wget https://cpan.metacpan.org/authors/id/S/SU/SULLR/IO-Socket-SSL-2.052.tar.gz
tar -xzvf IO-Socket-SSL-2.052.tar.gz
cd IO-Socket-SSL-2.052
perl Makefile.PL INSTALL_BASE=/home/marcin/.local/analyze-ssl
make
make test
make install
```

Jeśli teraz wywołamy polecenie, to na jego wyjściu zobaczymy ścieżki do bibliotek perla.
```
perl -e 'print join "\n", @INC;'

/usr/lib/perl5/site_perl/5.18.2/x86_64-linux-thread-multi
/usr/lib/perl5/site_perl/5.18.2
/usr/lib/perl5/vendor_perl/5.18.2/x86_64-linux-thread-multi
/usr/lib/perl5/vendor_perl/5.18.2
/usr/lib/perl5/5.18.2/x86_64-linux-thread-multi
/usr/lib/perl5/5.18.2
/usr/lib/perl5/site_perl
.
```

Ustawiając zmienną środowiskową `PERL5LIB` możemy dodać ścieżkę do tablicy `@INC`.
```
export PERL5LIB=/home/marcin/.local/analyze-ssl/lib/perl5/
perl -e 'print join "\n", @INC;'

/home/marcin/.local/analyze-ssl/lib/perl5//x86_64-linux-thread-multi
/home/marcin/.local/analyze-ssl/lib/perl5/
/usr/lib/perl5/site_perl/5.18.2/x86_64-linux-thread-multi
/usr/lib/perl5/site_perl/5.18.2
/usr/lib/perl5/vendor_perl/5.18.2/x86_64-linux-thread-multi
/usr/lib/perl5/vendor_perl/5.18.2
/usr/lib/perl5/5.18.2/x86_64-linux-thread-multi
/usr/lib/perl5/5.18.2
/usr/lib/perl5/site_perl
.

```

Tym samym po wyeksportowaniu zmiennej środowiskowej `PERL5LIB` skrypt `analyze-ssl.pl` działa.
Jeśli nie chcemy eksportować zmiennej środowiskowej możemy uruchomić skrypt w poniższy sposób. Dodatkowo w celu zaoszczędzenia pisania, można utworzyć alias bash.
```
PERL5LIB=/home/marcin/.local/analyze-ssl/lib/perl5/ analyze-ssl.pl
```
