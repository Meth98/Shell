#!/bin/bash

################################################################################################################################################################
## Description: Script to identify which is the correct process running among the standard ones and, upon user request, check how many processes are active
##
## Author: Matteo Z.
################################################################################################################################################################

print_usage() {
        echo -e "\nDescription:"
        echo -e "\n    Script to identify which is the correct process running among the standard ones and, upon user request, check how many processes are active"
        echo -e "\nUsage:"
        echo -e "\n    1 - $0 -C <process>"
        echo -e "\n    2 - $0 -N <process>"
        echo -e "\nOptions:"
        echo -e "\n   -C -> to count the process"
        echo -e "\n   -N -> to print the process name found"
        echo -e "\nOther info:"
        echo -e "\n    process -> for example 'ssh' or '/usr/sbin/sshd' or 'ssh|sshd'\n"
        exit 1
}


########## MAIN ##########

count_proc_flag=0
name_proc_flag=0

while getopts ':C:N:' opt; do
        case $opt in
                C)
                        process="${OPTARG}"
                        count_proc_flag=1 ;;
                N)
                        process="${OPTARG}"
                        name_proc_flag=1 ;;
                *)
                        echo -e "\nWarning!! You have something wrong!"
                        print_usage ;;
        esac
done
shift $((OPTIND-1))

if [[ -z "$process" ]]; then
        print_usage
else
        # to get the list of PIDs matching the process name, excluding the current script
        pids=$(pgrep -f "$process" |grep -v "^${BASHPID}$")
        # echo "PIDs: $pids"

        if [[ -z "$pids" ]]; then
                echo "Warning!! Process not found!"
        else
                # to get the full command line of the process excluding this script
                find_proc=$(ps -o args= -p $pids |grep -v "$0")
                # echo "Find process: $find_proc"

                if [[ -z "$find_proc" ]]; then
                        echo "Warning!! Process not found!"
                else
                        if [[ $count_proc_flag -eq 1 ]]; then
                                proc_count=$(echo "$find_proc" |wc -l)
                                echo "$proc_count"
                        elif [[ $name_proc_flag -eq 1 ]]; then
                                echo "$find_proc"
                        fi
                fi
        fi
fi