Symfony2 - aplikacja konsolowa globalna opcja
=============================================

Kiedy tworzymy aplikację konsolową w oparciu o komponent Symfony/console, czasem potrzebujemy utworzyć globalną opcję dla wszystkich naszych poleceń. Możemy to zrobić pobierając obiekt InputDefinition z naszej aplikacji konsolowej.

``` php
$application = new Application('tt-rrs-cli', TT_RSS_CLI_VERSION);
$application->getDefinition()->addOption(
    new InputOption('tt-rss', 'p', InputOption::VALUE_OPTIONAL,
        'The path to tt-rss docroot', ''));
```

``` bash
marcin@opensuse-asus:~/Projekty/ttrss-cli> php src/application.php
tt-rrs-cli version 0.1.0

Usage:
  command [options] [arguments]

Options:
  -h, --help             Display this help message
  -q, --quiet            Do not output any message
  -V, --version          Display this application version
      --ansi             Force ANSI output
      --no-ansi          Disable ANSI output
  -n, --no-interaction   Do not ask any interactive question
  -p, --tt-rss[=TT-RSS]  The path to tt-rss docroot [default: ""]
  -v|vv|vvv, --verbose   Increase the verbosity of messages: 1 for normal output, 2 for more verbose output and 3 for debug
...............
```