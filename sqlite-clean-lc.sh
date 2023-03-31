#!/bin/sh

DF=${1:-"/tmp/lightningd.sqlite3"}
test -r "$DF" || exit 1

echo "=== Vacuuming $DF"
printf "Old: "
ls -lh $DF
{
echo "PRAGMA foreign_keys = ON;"
TABLES=$(sqlite3 $DF .tables)
echo "$TABLES" | tr ' ' '\n' | while read table
do
  grep -q "^$table$" $0-tables && echo "DELETE FROM $table;"
done
echo "VACUUM;"
} | tee /tmp/script | sqlite3 $DF
cat /tmp/script
printf "New: "
ls -lh $DF
echo "======================================================================="
