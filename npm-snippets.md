# npm snippets

## Instalacja pakietu wraz ze wszystkimi zależnościami peerDependencies

```
npm info "<PKG>" peerDependencies --json | command sed 's/[\{\},]//g ; s/: /@/g; s/ *//g' | xargs npm install --save "<PKG>"
```

Warto także zapoznać się z [stop auto-installing peerDependencies #6565](https://github.com/npm/npm/issues/6565).

## Aktualizacja pakietów npm do najnowszej wersji

1. Polecenie `npm outdated` wyświetla które pakiety wymagają aktualizacji
1. Polecenie `npm update` aktualizuje zależności biorąc pod uwagę ograniczenia wersji z pliku `package.json`.
1. Polecenie `npm install <packagename>@latest` aktualizuje pakiet do najnowszej wersji ignorując ograniczenie wersji.
1. Polecenie `npx npm-check-updates -u && npm install` modyfikuje plik `package.json`, a następnie aktualizuje wszystkie zależności do najnowszej wersji. Za pomocą parametru `--target minor` możemy zabronić aktualiacji pakietów do aktualizacji wersji major (tylko najnowszy minor/patch).

[npm-check-updates](https://www.npmjs.com/package/npm-check-updates)
