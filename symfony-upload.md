# Symfony upload

Do uploadu plików w Symfony warto skorzystać z bundli `VichUploaderBundle`, `OneupFlysystemBundle` i `LiipImagineBundle` do generowania miniaturek.

Możemy zainstalować je wywołując polecenie `composer require oneup/flysystem-bundle vich/uploader-bundle liip/imagine-bundle`. Każdy zawiera dokumentację jak je należy skonfigurować i zintegrować między sobą.

W wcześniejszej wersji `VichUploaderBundle` był problem z nowszą wersją `OneupFlysystemBundle`, dlatego musimy korzystać z wersji `1.17` - [Support for league/flysystem v2.0](https://github.com/dustin10/VichUploaderBundle/issues/1177).

W pliku konfiguracyjnym `config/packages/oneup_flysystem.yaml` dodajemy konfigurację dla Amazon S3. W przykładowej konfiguracji korzystamy z jednego bucketa, ale tworzymy dwa systemy plików. Drugi system plików, będzie zapisywał dane w podkatalogu `avatars`.

```
# Read the documentation: https://github.com/1up-lab/OneupFlysystemBundle
oneup_flysystem:
    adapters:
        allspace.s3_adapter:
            awss3v3:
                client: s3client
                bucket: '%env(AWS_S3_BUCKET)%'
                prefix: ''
        allspace.s3_adapter.avatars:
            awss3v3:
                client: s3client
                bucket: '%env(AWS_S3_BUCKET)%'
                prefix: 'avatars'
    filesystems:
        images:
            adapter: allspace.s3_adapter
            mount: images
            visibility: public
        avatars:
            adapter: allspace.s3_adapter.avatars
            mount: avatars
            visibility: public
```

W pliku konfiguracyjnym `config/packages/vich_uploader.yaml` dodajemy mapping dla obrazków i avatarów.
Ustawiamy odpowiedni identyfikator usługi w kluczu `upload_destination`.

```
vich_uploader:
    db_driver: orm
    storage: flysystem

    mappings:
        images:
            upload_destination: oneup_flysystem.images_filesystem
            namer:
                service: Vich\UploaderBundle\Naming\HashNamer
                options: { algorithm: 'sha1', length: 40 }
            directory_namer:
                service: Vich\UploaderBundle\Naming\SubdirDirectoryNamer
                options: { chars_per_dir: 2, dirs: 2 }
            inject_on_load: true
        avatars:
            upload_destination: oneup_flysystem.avatars_filesystem
            namer:
                service: Vich\UploaderBundle\Naming\HashNamer
                options: { algorithm: 'sha1', length: 40 }
            directory_namer:
                service: Vich\UploaderBundle\Naming\SubdirDirectoryNamer
                options: { chars_per_dir: 2, dirs: 2 }
            inject_on_load: true
```

Jeśli chcemy generować miniaturki to w pliku konfiguracyjnym `config/packages/liip_imagine.yaml` dodajemy konfigurację:

```
# See dos how to configure the bundle: https://symfony.com/doc/current/bundles/LiipImagineBundle/basic-usage.html
liip_imagine:
  # valid drivers options include "gd" or "gmagick" or "imagick"
  driver: "imagick"

  resolvers:
    offers:
      flysystem:
        filesystem_service: oneup_flysystem.images_filesystem
        root_url:           "%offerImagesWebRoot%"
        cache_prefix:       miniatures
        visibility:         public
    avatars:
      flysystem:
        filesystem_service: oneup_flysystem.avatars_filesystem
        root_url:           "%avatarsImagesWebRoot%"
        cache_prefix:       miniatures
        visibility:         public
  loaders:
    offers:
      flysystem:
        filesystem_service: oneup_flysystem.images_filesystem
    avatars:
      flysystem:
        filesystem_service: oneup_flysystem.avatars_filesystem

  filter_sets:
    !php/const App\Core\Enum\OfferMiniatureFormatEnum::SMALL:
      cache: offers_always_stored_resolver
      data_loader: offers
      format: jpeg
      jpeg_quality: 85
      filters:
        thumbnail:
          size: [ 120, 120 ]
          mode: outbound
    #....
```

W pliku `config/services.yaml` musimy zarejestrować parametry:
```
offerImagesWebRoot: '%env(AWS_S3_PUBLIC)%/%env(AWS_S3_BUCKET)%'
avatarsImagesWebRoot: '%env(AWS_S3_PUBLIC)%/%env(AWS_S3_BUCKET)%/avatars'
```

A także usługi:

```
offers_always_stored_resolver:
    class: mmo\sf\ImagineBundle\ResolverAlwaysStoredDecorator
    arguments:
        $resolver: '@liip_imagine.cache.resolver.offers'
    tags:
        - { name: "liip_imagine.cache.resolver", resolver: offers_always_stored_resolver }

avatars_always_stored_resolver:
    class: mmo\sf\ImagineBundle\ResolverAlwaysStoredDecorator
    arguments:
        $resolver: '@liip_imagine.cache.resolver.avatars'
    tags:
        - { name: "liip_imagine.cache.resolver", resolver: avatars_always_stored_resolver }
```

Korzystam z dekoratora, który przechwytuje każde wywołanie sprawdzające czy miniatura już istnieje i zawsze zwracam wartość `true`. Dzięki temu nie musimy generować dodatkowego ruchu. W takim przypadku musimy jednak generować miniaturki asynchronicznie. Najlepiej skorzystać z pakiety `symfony/messenger`. Obecnie istnieje otwarte na to zadanie [Support Symfony Messenger Component #1193](https://github.com/liip/LiipImagineBundle/issues/1193). W tym zadaniu lub w PR [[WIP] Messenger support #1360](https://github.com/liip/LiipImagineBundle/pull/1360) istnieje przykładowy handler, który możemy wykorzystać/dostosować do naszych potrzeb.
