# npm snippets

## Instalacja pakietu wraz ze wszystkimi zależnościami peerDependencies

```
npm info "<PKG>" peerDependencies --json | command sed 's/[\{\},]//g ; s/: /@/g; s/ *//g' | xargs npm install --save "<PKG>"
```

Warto także zapoznać się z [stop auto-installing peerDependencies #6565](https://github.com/npm/npm/issues/6565).
