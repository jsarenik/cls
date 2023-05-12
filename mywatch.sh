#!/busybox/ash

TMP=/tmp/mywatch-$$
cols=$(tput cols)
sleep="2.0s"
test "$1" = "-n" && { sleep=${2:-"2.0s"}; shift 2; }

trap "cat $TMP 2>/dev/null; rm -f ${TMP}*; tput cnorm; exit" INT QUIT EXIT
#reset; clear
printf '\033[2J'

printf "[?25l"
printf "[H"

O=""
while true;
do
  datetime=$(date +"%Y-%m-%d %H:%M:%S")
  datetimew=$(printf "%s" "$datetime" | wc -c)
  move=$((cols-datetimew-1))
  line="Every ${sleep}: $@ [${move}G ${datetime}"
  printf "%s\n" "${line}" > $TMP
  echo >>$TMP
  echo "$@" | $SHELL -s >>$TMP 2>&1
  N=$(md5sum $TMP | cut -b-32)
  if
    test "$O" = "$N"
  then
    :
  else
    size_rows=$(cat $TMP | wc -l)
    test -r $TMP-new && size_rows=$(cat $TMP | wc -l)
    for i in $(seq $size_rows);
    do
      printf "[K\n"
    done > $TMP-emptyline
    printf "[K\n" >> $TMP-emptyline
    {
    cat $TMP | paste - $TMP-emptyline | tr -d '\t'
    #printf "[${size_rows}F"
    printf "[H"
    } | nicecat.sh $TMP-new
  fi
  O=$N
  sleep ${sleep}
done
