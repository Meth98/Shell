#!/bin/sh

# Transform a filename in lowercase or in uppercase

print_usage() {
        echo -e "\n\e[0;32mUsage:\e[0m $0 -d [<directory>] [-m|-M]\n"
        echo -e "\e[0;32mOptions:\e[0m\n"
        echo -e "  '-d' = to specify the directory, where you want transform the filename\n"
        echo -e "  '-m' = to tansform the filename in the lower case\n"
        echo -e "  '-M' = to tansform the filename in the upper case\n"
        exit 1
}


lower_case() {
        for x in `ls`; do
                if [ -f $x ]; then
                        fname=`basename $x`
                        y=`echo $fname |tr A-Z a-z`

                        if [[ $fname != $y ]]; then
                                mv $fname $y
                        fi
                fi
        done

        if [[ -z $y ]]; then
                echo "In this directory do not exists any file!!"
        else
                sleep 2
                echo -e "\n\e[4mList of directory found:\e[0m\n"

                for obj in `ls`; do
                        echo -e "$obj\n";
                done
        fi
}


upper_case() {
        for x in `ls`; do
                if [ -f $x ]; then
                        fname=`basename $x`
                        y=`echo $fname |tr a-z A-Z`

                        if [[ $fname != $y ]]; then
                                mv $fname $y
                        fi
                fi
        done

        if [[ -z $y ]]; then
                echo "In this directory do not exists any file!!"
        else
                sleep 2
                echo -e "\n\e[4mList of directory found:\e[0m\n"

                for obj in `ls`; do
                        echo -e "$obj\n";
                done
        fi
}


if [ $# -eq 3 ]; then
        if [ $1 == '-d' ]; then
                if [ -d $2 ]; then
                        cd $2
                        
                        case $3 in
                                -m)
                                        lower_case ;;
                                -M)
                                        upper_case ;;
                                -?)
                                        echo -e "\n\e[40;31;1mWarning!! You have put an incorrect option!\e[0m"
                                        sleep 1
                                        print_usage ;;
                                *)
                                        echo -e "\n\e[40;31;1mWarning!! You have put something wrong!\e[0m"
                                        sleep 1
                                        print_usage ;;
                        esac
                else
                        echo -e "\n\e[40;31;1mWarning!! The first argument should be a directory!\e[0m"
                        sleep 1
                        print_usage
                fi
        else
                print_usage
        fi
else
        print_usage
fi