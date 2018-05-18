# sed - snippets

## Dopisz linię po dopasowaniu

```
find -iname Vagrantfile -exec sed -i  -e '/"vagrant" => "1",/a\      "operatingsystemrelease" => "15.0",' {} \;
```
