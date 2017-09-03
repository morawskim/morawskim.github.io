Bundler - pobieranie gemów z repozytoriów git
=============================================

Podczas pracy przy projekcie zainstalowałem gem ruby-prof. Chciałem wygenerować stos wywołań funkcji.

``` bash
./bin/ruby-prof -d -p call_tree ./test.rb
hello world
Exception `ArgumentError' at /home/marcin/projekty/hiera/vendor/bundle/gems/ruby-prof-0.16.2/bin/ruby-prof:335 - wrong number of arguments (2 for 0..1)
/home/marcin/projekty/hiera/vendor/bundle/gems/ruby-prof-0.16.2/lib/ruby-prof/printers/call_tree_printer.rb:46:in `print': wrong number of arguments (2 for 0..1) (ArgumentError)
        from /home/marcin/projekty/hiera/vendor/bundle/gems/ruby-prof-0.16.2/bin/ruby-prof:335:in `block in <top (required)>'
```

Błąd wynika z złego wywołania metody. Ten błąd był już znany twórcom (https://github.com/ruby-prof/ruby-prof/issues/203) Niestety ta łatka znajdowała się w branch master. A ja korzystałem z wersji 0.16.2.

``` bash
git branch --contains 837edf447914663d0100e5599ab8c44f81f0eae0
* master
```

Żeby skorzystać z tej poprawki musiałem zainstalować gem ruby-prof z gita. W pliku Gemfile modyfikujemy linie:

``` ruby
gem 'ruby-prof'
```

na

``` ruby
gem 'ruby-prof', :git => 'https://github.com/ruby-prof/ruby-prof.git', :branch => 'master'
```

Instalujemy pakiet gem z repozytorium git.

``` bash
bundle install
```

Więcej informacji: <http://bundler.io/git.html>