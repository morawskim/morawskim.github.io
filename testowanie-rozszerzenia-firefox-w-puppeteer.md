# Testowanie rozszerzenia Firefox w Puppeteer

Jednym z elementów mojego projektu jest rozszerzenie do przeglądarki Firefox.
Jego zadaniem jest przekształcenie strony internetowej w czytelną wersję, pozbawioną reklam, nawigacji i innych rozpraszających elementów.
Obsługuje również artykuły dostępne za paywallem.

Chciałem uruchamiać testy end-to-end tego rozszerzenia w procesie CI.

Biblioteka puppeteer umożliwia automatyzację przeglądarki.
W przypadku Firefoksa napotkałem kilka problemów konfiguracyjnych, jednak ostatecznie udało się nawiązać połączenie z uruchomioną przeglądarką.
Kluczowe okazało się użycie protokołu `webDriverBiDi` oraz połączenie przez `browserWSEndpoint`:

```
const browser = await puppeteer.connect({
    browserWSEndpoint: "ws://127.0.0.1:9222/session",
    protocol: 'webDriverBiDi',
});
```

Firefox należy uruchomić z włączonym zdalnym debugowaniem: `--remote-debugging-port=9222'`.
Po uruchomieniu Firefoksa z parametrem `--remote-debugging-port=9222` endpoint `ws://127.0.0.1:9222/session` jest automatycznie udostępniany przez przeglądarkę i to właśnie jego należy przekazać w `browserWSEndpoint`.

Korzystając z pakietu NPM web-ext, można przekazać ten argument w następujący sposób:

`web-ext run  --source-dir ./dist/ --browser-console --arg='--remote-debugging-port=9222' --arg='--headless'`

### Przykładowy skrypt Puppeteer

```
import puppeteer from 'puppeteer-core';
import path from 'node:path';

const screenshotPath = path.join(process.cwd(), 'screenshot.png');
let failed = false;
const browser = await puppeteer.connect({
    browserWSEndpoint: "ws://127.0.0.1:9222/session",
    protocol: 'webDriverBiDi',
});
const page = await browser.newPage();
await page.goto('https://pl.wikipedia.org/wiki/PHP');
await page.setViewport({width: 1080, height: 1024});

page.on('console', msg => {
    console.log(`[browser:${msg.type()}] ${msg.text()}`);
});

await page.evaluate(() => {
    window.postMessage({
        type: "webpage2kindle.createReadableVersion",
    }, "*");
});
try {
    await page.waitForFunction(
        () => window.location.href.startsWith('https://pushtokindle.fivefilters.org'),
        {
            timeout: 20_000,
            polling: 1000,
        }
    );
    console.log('Success');
} catch (err) {
    failed = true;
    console.error(`Something wrong. Check console.logs in output and screenshot ${screenshotPath}`, err);
} finally {
    await page.screenshot({
        path: screenshotPath,
        fullPage: true,
    });
    await browser.disconnect();
    // await browser.close();
    if (failed) {
        process.exit(1);
    }
}

```
