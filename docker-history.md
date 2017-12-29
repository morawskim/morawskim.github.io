# docker history

Mając obraz dockera, chcemy wiedziec jak został zbudowany. Do tego służy polecenie `docker history`.

```
$docker history c462a3c35701
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
c462a3c35701        2 weeks ago         /bin/sh -c #(nop)  CMD ["bash" "-l"]            0 B                 
c40b9f29a630        2 weeks ago         /bin/sh -c zypper --non-interactive install p   110.2 MB            
19b630b6033c        2 weeks ago         /bin/sh -c #(nop) ADD file:a70dc47af55fbe6ee4   108.1 MB            
<missing>           11 months ago       /bin/sh -c #(nop)  MAINTAINER SUSE Containers   0 B                 
```

Domyślnie docker przytnie informacje. Aby wyświetlić pełne dane korzystamy z opcji `--no-trunc`
``` bash
$docker history --no-trunc c462a3c35701
IMAGE                                                                     CREATED             CREATED BY                                                                                          SIZE                COMMENT
sha256:c462a3c357012be15ed9e2c8dd7e06dc0ce5f62ab27aa1cb7c85456e71ebc1b6   2 weeks ago         /bin/sh -c #(nop)  CMD ["bash" "-l"]                                                                0 B                 
sha256:c40b9f29a630ff4958aacd673cbcd9c622afbb2db618e56713852aeb7f730337   2 weeks ago         /bin/sh -c zypper --non-interactive install puppet && zypper clean                                  110.2 MB            
sha256:19b630b6033c8a31cc2a70ac9b377e69fc3fc1baca3df03c8b8f68ab83f081e7   2 weeks ago         /bin/sh -c #(nop) ADD file:a70dc47af55fbe6ee432c5053b3432cea78921c30cc19a8b19c26adc4a764374 in /    108.1 MB            
<missing>                                                                 11 months ago       /bin/sh -c #(nop)  MAINTAINER SUSE Containers Team <containers@suse.com>                            0 B
```
