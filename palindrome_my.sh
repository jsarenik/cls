#!/bin/sh
 
num=$1
 
# store the original number
original_num=$num
 
revermy() {
  sed -e 's/./&\n/g' | sed '$d' | tac | tr -d '\n'
}

# reverse the number
rev=0
len=$(echo $num | wc -c)
leno=$(($len - 1))
hal=$(($len / 2))
half=$(($leno / 2))
middle=$(echo $original_num | cut -b $hal)
#while test "$num" -gt 0
for i in $(seq $hal)
do
    # get the remainder of the number
    remainder=$(($num % 10))
    
    # multiply reverse by 10 then add the remainder
    rev=$((($rev * 10) + $remainder))
    
    # divide the number by 10
    num=$(($num / 10))
done
 
nhalf=$(echo $original_num | cut -b -$half)
nhalf=$(($nhalf + 1))
old=$(
{
echo $nhalf
test $(($len % 2)) -eq 0 && echo $middle
echo $nhalf | revermy
} | tr -d '\n'
)

echo $old
