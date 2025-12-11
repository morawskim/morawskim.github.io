# Dynamiczny import w Vite

W jednym z projektów użytkownicy mieli możliwość dołączania zdjęć poprzez formularz.
Część z nich uploadowała pliki w formacie HEIC, który ma słabe wsparcie w przeglądarkach (https://caniuse.com/heif).
Do obsługi przesyłania plików wykorzystywaliśmy bibliotekę Dropzone, która generowała miniaturki przesyłanych zdjęć po stronie klienta.
W przypadku plików HEIC miniatury się jednak nie tworzyły.

Po stronie serwera istniał już mechanizm konwersji z HEIC do JPG, jednak przesyłanie pliku na serwer tylko po to, aby uzyskać miniaturę, było mało optymalne — opóźniało to działanie aplikacji i zwiększało obciążenie backendu.

Szukając rozwiązania po stronie klienta, natrafiłem na bibliotekę [heic2any](https://www.npmjs.com/package/heic2any), która potrafi konwertować pliki HEIC do JPG w przeglądarce.
Problemem okazał się jednak jej rozmiar — biblioteka waży ponad 1 MB (przed kompresją).
Dołączona bezpośrednio do głównego bundla znacznie powiększałaby rozmiar pliku JavaScript ładowanego przy starcie aplikacji.

Projekt korzysta z Vite, dlatego zdecydowałem się skorzystać z dynamicznego importu.
Zamiast klasycznego: `import heic2any from 'heic2any';` użyłem `const heic2any = (await import('heic2any')).default;`.
Dzięki temu Vite automatycznie wydzielił bibliotekę do osobnego chunku.

Plik ten jest pobierany dopiero wtedy, gdy rzeczywiście jest potrzebny — czyli w momencie konwersji zdjęcia HEIC.
Aby potwierdzić, że mechanizm działa prawidłowo, wykorzystałem [vite-bundle-analyzer](https://www.npmjs.com/package/vite-bundle-analyzer).
Analiza pokazała, że heic2any faktycznie zostało usunięte z głównego bundle’a.
Dodatkowo narzędzia deweloperskie Chrome potwierdziły, że biblioteka jest ładowana osobno, tylko wtedy, gdy aplikacja wykonuje dynamiczny import.
