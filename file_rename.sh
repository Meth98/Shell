#!/bin/sh

# Rename a file with a different extension

print_usage() {
        echo -en "\n\e[0;32mUsage:\e[0m"
        echo -e " $0 -d [<directory1>] -D [<directory2>] -e [<extension1>] -E [<extension2>]\n"
        echo -e "\e[0;32mOptions:\e[0m\n"
        echo -e "  '-d' = to specify the directory to create, for the file with the original extension\n"
        echo -e "  '-D' = to specify the directory to create, for the renamed file\n"
        echo -e "  '-e' = to specify the original extension\n"
        echo -e "  '-E' = to specify the renamed file extension\n"
        exit 1
}


while getopts ':hd:D:e:E:' opt; do
        case $opt in
                h)
                        print_usage ;;
                d)
                        old_dir=${OPTARG} ;;
                D)
                        new_dir=${OPTARG} ;;
                e)
                        old_extension=${OPTARG} ;;
                E)
                        new_extension=${OPTARG} ;;
                *)
                        echo -e "\n\e[40;31;1mWarning!! You have done something wrong!\e[0m"
                        sleep 1
                        print_usage ;;
        esac
done
shift $(($OPTIND-1))

if [[ ! -z $1 ]]; then
        echo -e "\n\e[40;31;1mWarning!! You should pay attention to insert the correct arguments!\e[0m"
        sleep 1
        print_usage
else
        if [[ -z $old_dir || -z $new_dir || -z $old_extension || -z $new_extension ]]; then
                print_usage
        else
                if [[ $old_extension =~ ^\. ]] || [[ $new_extension =~ ^\. ]]; then
                        echo "The extension dot is automatically inserted, you should put only the characters after itself!!"
                else
                        if [[ $old_extension =~ sh$ ]] || [[ $new_extension =~ sh$ ]]; then
                                echo "Warning!! The file cannot have the extension of a Shell script!"
                        else
                                if [[ ! -d $old_dir && ! -d $new_dir ]]; then
                                        echo -e "\n\e[0;32mProcessing..."
                                        sleep 2
                                        mkdir $old_dir $new_dir
                                        touch file{1,2,3}.$old_extension

                                        for file in `ls`; do
                                                if [ -f $file ]; then
                                                        if [[ ! $file =~ sh$ ]]; then
                                                                fname=`basename $file`
                                                                noextension=`echo $fname |cut -d '.' -f 1`
                                                                cp $fname $new_dir/$noextension.$new_extension
                                                        fi
                                                fi
                                        done

                                        mv file{1,2,3}.$old_extension $old_dir
                                        echo -e "\nOperation completed!! It has been created one directory for the original file and, one for the renamed file!\e[0m"
                                        echo -e "\n\e[4mDirectory of the original file:\e[0m $old_dir"
                                        echo -e "\n\e[4mDirectory of the renamed file:\e[0m $new_dir"
                                        cd $old_dir
                                        echo -en "\n\e[4mOriginal file:\e[0m " ; ls
                                        cd ../$new_dir
                                        echo -en "\n\e[4mRenamed file:\e[0m " ; ls ; cd .. ; echo ; exit 0
                                elif [[ ! -d $old_dir && -d $new_dir || -d $old_dir && ! -d $new_dir ]]; then
                                        if [[ $old_dir =~ $old_dir$ && $new_dir =~ $new_dir$ || $old_dir =~ $old_dir$ && $new_dir =~ $new_dir$ ]]; then
                                                echo "Warning!! One of that directory you want create, already exist!"
                                        fi
                                else
                                        if [[ $old_dir =~ $old_dir$ && $new_dir =~ $new_dir$ || $old_dir =~ $old_dir$ && $new_dir =~ $new_dir$ ]]; then
                                                echo -e "\n\e[0;32mDirectory '"$old_dir"' and '"$new_dir"' already exist!!\e[0m"
                                                sleep 1
                                                echo -e "\nRemoving these directory..."
                                                sleep 2
                                                rm -r $old_dir $new_dir
                                                echo -e "\nTo re-create it, run again this program and you should put the correct parameters!\n"
                                        fi
                                fi
                        fi
                fi
        fi
fi