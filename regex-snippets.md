# Regex - snippets

## lookbehind

Live demo: https://regex101.com/r/kLXifZ/1
Poniższe wyrażenie regularne dopasowuje nazwy kont w stylu twittera.
```
(?<=\B\@)(\w)+
```
