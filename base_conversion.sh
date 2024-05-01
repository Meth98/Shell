#!/bin/bash

# It shows a number in different bases

script=`basename "$0"`               # script name

print_usage() {
        echo -e "\nUsage:\n"
        echo -e "    $0 [<num1>] [<num2>] [<num3>] ...\n"
        echo -e "Description:\n"
        echo -e "    $script - It shows a number in different bases\n"
        echo -e "A number can be:\n"
        echo -e "    Binary (base 2)         It starts with 0b (e.g. 0b1100)\n"
        echo -e "    Octal (base 8)          It starts with 0 (e.g. 014)\n"
        echo -e "    Hexadecimal (base 16)   It starts with 0x (e.g. 0xc)\n"
        echo -e "    Decimal                 All other cases (e.g. 12)\n"
        exit 1
}


print_number() {
        for i; do
                case "$i" in
                        0b*)
                                ibase=2 ;;              # binary
                        0x*|[a-f]*|[A-F]*)
                                ibase=16 ;;             # hexadecimal
                        0*)
                                ibase=8 ;;              # octal
                        [1-9]*)
                                ibase=10 ;;             # decimal
                        *)
                                echo "Invalid number - $i has been skipped"
                                continue ;;
                esac

                number=`echo "$i" | sed -e 's:^0[bBxX]::' | tr '[a-f]' '[A-F]'`
                dec=`echo "ibase=$ibase; $number" | bc`                                 # it converts the number to decimal
                echo -e "\n- Number: $number\n"

                case "$dec" in
                        [0-9]*)        ;;                                               # good number
                        *)
                                continue ;;                                             # error: skip it
                esac

                echo -n "    "
                echo `bc <<OUTPUT
                        base=16;  "Hexadecimal="; $dec
                        obase=10; "Decimal="; $dec
                        obase=8;  "Octal="; $dec
                        obase=2;  "Binary="; $dec
OUTPUT
                ` |sed -e 's: :        :g'
                echo -e "\n------------------------------------------------------------------------"
        done
}


while [ $# -gt 0 ]; do
        case "$1" in
                --)
                        shift
                        break ;;
                -h)
                        print_usage ;;
                -*)
                        print_usage ;;
                *)
                        break ;;
        esac
        shift
done

if [ $# -gt 0 ]; then
        print_number "$@"
else
        print_usage
fi