# vagrant - atlas.hashicorp.com 404 Not found

Chciałem pobrać obraz `morawskim/openSUSE-15.0-x86_64-BETA`. Otrzymywałem jednak bląd:

```
vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Box 'morawskim/openSUSE-15.0-x86_64-BETA' could not be found. Attempting to find and install...
    default: Box Provider: virtualbox
    default: Box Version: >= 0
The box 'morawskim/openSUSE-15.0-x86_64-BETA' could not be found or
could not be accessed in the remote catalog. If this is a private
box on HashiCorp's Atlas, please verify you're logged in via
`vagrant login`. Also, please double-check the name. The expanded
URL and error message are shown below:

URL: ["https://atlas.hashicorp.com/morawskim/openSUSE-15.0-x86_64-BETA"]
Error: The requested URL returned error: 404 Not Found
```

Po migracji na nowe serwery wymagany jest vagrant w wersji 1.9.6.

https://github.com/hashicorp/vagrant/commit/5f955c3d38f27a036e3eb569ad17494afe293a21#diff-89a1e020e1111d536533beb7b79c751a
