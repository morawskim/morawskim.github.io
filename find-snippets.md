# Linux find snippets

## Znajdź i posortuj pliki po dacie modyfikacji

```
find . -printf "%T@ %Tc %p\n" | sort -n


1518795986.9751028560 pią, 16 lut 2018, 16:46:26 ./ctop/rpmbuild.log
1521374908.2028537110 nie, 18 mar 2018, 13:08:28 ./php70v/rpmbuild.log
1521375072.2739670470 nie, 18 mar 2018, 13:11:12 ./php70v-gearman/rpmbuild.log
```
