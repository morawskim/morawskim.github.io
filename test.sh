#/bin/sh

for filename in $(ls *.md); do
    title=$(cat $filename | head -4 | grep 'title:' | cut -d' ' -f2-)
    escaped_filename=$(echo $filename | sed 's/(/%28/' | sed 's/)/%29/')
    echo "[$title]($escaped_filename)"
done
