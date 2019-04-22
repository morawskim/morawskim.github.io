# JAVA_HOME

Mając w systemie wiele wersji JVM możemy wymusić podczas uruchamiania programu, z której wersji javy chcemy skorzystać.

Najczęściej robimy to przez `update-alternatives` i jest to zmiana globalna. Dotyczy to wsystkich programów. Jednak jeśli tylko jeden program ma korzystać z starszej wersji to wystarczy ustawić zmienna środowiskową `JAVA_HOME` i zmodyfikować `PATH`.

W powłoce bash, zmienne środowiskowe można podać przed nazwą programu do uruchomienia - 
`JAVA_HOME=/usr/lib64/jvm/java-1.8.0-openjdk-1.8.0/jre PATH="$JAVA_HOME/bin:$PATH"  ./Vega`
