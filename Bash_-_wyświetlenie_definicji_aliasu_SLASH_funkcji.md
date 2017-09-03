Bash - wyświetlenie definicji aliasu/funkcji
============================================

Korzystając z wewnętrznego polecenia powłoki "type", możemy zobaczyć definicję aliasu.

``` bash
type l.
l. jest aliasem do ls -d .* --color=auto'
```

Podobnie, polecenie "type" pozwala nam zobaczyć definicję funkcji.

``` bash
type remove-passphrase-from-x509-key
remove-passphrase-from-x509-key jest funkcją
remove-passphrase-from-x509-key ()
{
    local input=$1;
    if [ -z $input ] || [ ! -f $input ]; then
        echo 'Input file not exist' 1>&2;
        return;
    fi;
    local output='';
    if [ -z $2 ]; then
        output=${1%/*};
        if [ -d $output ]; then
            output="$output/private-key-without-passphrase.key";
        else
            output="${output}.without-passphrase";
        fi;
    else
        output=$2;
    fi;
    if [ -f $output ]; then
        echo "Output file '$output' already exist" 1>&2;
        return;
    fi;
    openssl rsa -in $input -out $output
}
```