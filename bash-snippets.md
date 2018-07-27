# Bash snippets

## !$ vs $_

```
echo hello > /dev/null
echo !$
/dev/null
```

```
echo hello > /dev/null
echo $_
hello
```

## Here string

```
cat <<< 'hi there'
hi there
```

## Lista wszystkich sekwencji klawiszy powiązanych z poleceniami powłoki

```
bind -X
"\C-t": "fzf-file-widget"
```

