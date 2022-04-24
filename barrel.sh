name="$(mktemp)"
echo "#lang barrel" >> "$name"
cat $@ >> "$name"
cat - | racket "$name"