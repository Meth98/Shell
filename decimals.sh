#!/bin/sh

# Calculate a division, taking account of decimals

all_decimals() {
	calc() {
		awk "BEGIN { print "$*" }";
	}

	div=`calc $1/$2`
	# echo "Div with all decimals: $div"
}


two_decimals() {
	calc() {
		awk "BEGIN { print "$*" }";
	}

	div=`calc $1/$2`

	decimals=`echo $div | sed 's/^.*\.//'`          # taking account of numbers after the '.'
	# echo "Decimals: "$decimals

	decimals=`echo $decimals | cut -c -2`           # taking account of 2 decimals
	# echo "2 decimals: "$decimals

	integer=`echo $div | sed 's/\..*$//'`
	# echo "Integer: "$integer

	div=$integer"."$decimals
}


flag=

if [ $# -eq 2 ]; then
	for i in $*; do
		if [ $i -ge 0 ] 2> /dev/null; then
			continue
		else
			flag=1
		fi
	done

	if [ $flag ]; then
		echo "Warning!! You should put only numbers!"
	else
		all_decimals $1 $2
		echo -e "\n\e[0:32mResult with all decimals\e[0m\n"
		echo "$1 / $2 = "$div

		two_decimals $1 $2
		echo -e "\n\e[0:32mResult with only 2 decimals\e[0m\n"
		echo -e "$1 / $2 = "$div"\n"
	fi
else
	echo "Warning!! You should put 2 numbers!"
fi