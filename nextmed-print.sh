#!/bin/sh

nm=/tmp/nm
nextmed.sh | safecat.sh $nm
maxw=$(tail -1 $nm | cut -d " " -f1)
halfw=$(($maxw/2))
halfline=$(awk "\$1>$halfw{print \$0; exit}" $nm)
medline=$(grep -B1 "$halfline" $nm | head -1)
#medline=${medline#* }
echo $medline
