# How-To Projekty: Realne przypadki i rozwiązania

[Building Your Own Virtual Private Cloud on Linux: A Deep Dive into Network Namespaces ](https://dev.to/cypher682/building-your-own-virtual-private-cloud-on-linux-a-deep-dive-into-network-namespaces-1l3e)

[Build a Tiny Certificate Authority For Your Homelab](https://smallstep.com/blog/build-a-tiny-ca-with-raspberry-pi-yubikey/)

[How Zalando Delivers Real-Time Insights to Its Partners Brands (Delta Sharing)](https://blog.bytebytego.com/p/how-zalando-delivers-real-time-insights)

### Architektura SaaS: multi-tenant w Symfony

[Architektura SaaS: multi-tenant w Symfony](https://bulldogjob.pl/readme/architektura-saas-multi-tenant-w-symfony)

[repo symfony4-multitenancy-example](https://github.com/jzawadzki/symfony4-multitenancy-example)

Artykuł wyjaśnia, czym jest architektura multi-tenant w aplikacjach SaaS i czym różni się od single-tenant, gdzie każda firma ma osobną instancję aplikacji.
Przedstawia przykładową implementację w Symfony i Doctrine, gdzie korzystamy z jednej bazy danych, a dane są rozdzielane przez TenantID i automatyczne filtry w zapytaniach.


### How Cloudflare Eliminates Cold Starts for Serverless Workers

[How Cloudflare Eliminates Cold Starts for Serverless Workers](https://blog.bytebytego.com/p/how-cloudflare-eliminates-cold-starts)

Artykuł opisuje, jak Cloudflare zmniejszył opóźnienia "cold start" dzięki technice zwanej worker sharding.

Zamiast przyspieszać sam proces startu, firma zaczęła kierować wszystkie żądania dla danej aplikacji na ten sam serwer w centrum danych, używając struktury consistent hashing, dzięki czemu instancja Worker pozostaje w pamięci i rzadziej musi się uruchamiać od zera. Jeśli żądanie trafi na inny serwer, jest przekazywane do właściwego serwera.

## AI

[How Grab Built an AI Foundation Model To Understand Customers Better](https://blog.bytebytego.com/p/how-grab-built-an-ai-foundation-model)

[How Uber Built a Conversational AI Agent For Financial Analysis](https://blog.bytebytego.com/p/how-uber-built-a-conversational-ai)

[How Google’s Tensor Processing Unit (TPU) Works?](https://blog.bytebytego.com/p/how-googles-tensor-processing-unit)

## Migracje

[How Reddit Migrated Comments Functionality from Python to Go](https://blog.bytebytego.com/p/how-reddit-migrated-comments-functionality)

[Migrating from DigitalOcean to Hetzner: From $1,432 to $233/month With Zero Downtime](https://isayeter.com/posts/digitalocean-to-hetzner-migration/)

Artykuł opisuje migrację produkcyjnej infrastruktury z DigitalOcean do Hetznera głównie ze względu na znacznie niższe koszty przy lepszych parametrach sprzętowych.
Przeniesienie obejmowało złożony system (m.in. bazę danych, aplikacje i serwisy webowe) i zostało zaplanowane tak, aby uniknąć przestojów, wykorzystując replikację MySQL, rsync oraz tymczasowy reverse proxy.
Do migracji bazy danych bez przestojów autor wykorzystał mydumper/myloader do szybkiego dumpowania i odtwarzania danych.


### Introduction to PostgreSQL Indexes

[Introduction to PostgreSQL Indexes](https://dlt.github.io/blog/posts/introduction-to-postgresql-indexes/)

Artykuł wyjaśnia jak działają indeksy w PostgreSQL, zaczynając od podstaw: jak dane są fizycznie przechowywane na dysku, a potem pokazując, jak indeksy przyspieszają wyszukiwanie.
