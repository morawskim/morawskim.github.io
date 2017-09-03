Git - lista ignorowanych plików
===============================

Czasami chcemy sprawdzić jakie pliki/katalogi ignoruje git. Możemy to zrobić za pomocą poniższego polecenia:

``` bash
git status --ignored
On branch master
Your branch is up-to-date with 'origin/master'.
Ignored files:
  (use "git add -f <file>..." to include in what will be committed)

        .idea/copyright/
        .idea/deployment.xml
        .idea/modules.xml
        .idea/server.iml
        .idea/vcs.xml
        .idea/workspace.xml
        apps/bookmarks/
        config/config.php
        data/

nothing to commit, working directory clean
```