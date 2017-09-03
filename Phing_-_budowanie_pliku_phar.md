Phing - budowanie pliku phar
============================

``` xml
<project name="mail2print" default="phar">
    <target name="phar">
        <pharpackage
                stub="stub.php"
                destfile="mail2print.phar"
                basedir="../">
            <fileset dir="../">
                <include name="src/**" />
                <include name="vendor/**" />
            </fileset>
            <metadata>
                <element name="version" value="0.1.0" />
                <element name="authors">
                    <element name="Marcin Morawski">
                        <element name="e-mail" value="marcin@morawskim.pl" />
                    </element>
                </element>
            </metadata>
        </pharpackage>
    </target>
</project>
```

Przykładowy plik stub.php

``` php
#!/usr/bin/env php
<?php

Phar::mapPhar();

include "phar://" . __FILE__ . "/src/application.php";

__HALT_COMPILER();
```

``` bash
/usr/bin/php phing-latest.phar -f /home/marcin/Projekty/php-mail2print/build/build.xml
```