#!/bin/sh

#############################################################
## Description: Some informations about your Linux system
##
## Author: Matteo Z.
#############################################################

GetPackageManager() {
        if [ `rpm -q rpm 2> /dev/null |grep -E '^rpm-[0-9].*' |wc -l` = 1 ]; then
                PackageMan=`rpm --version`
        elif [ `dpkg -l dpkg 2> /dev/null |grep -E '^ii.*' |wc -l` = 1 ]; then
                PackageMan=`dpkg --version |sed -n '1p'`
        elif [ `pacman -Q pacman 2> /dev/null |grep -E 'pacman.[0-9]' |wc -l` = 1 ]; then
                PackageMan=`pacman -Q pacman`
        else
                PackageMan="???"
        fi
}


GetOSFullName() {
        if [[ ! -z $1 ]]; then
                if [[ ! -z $2 && ! -z $3 ]]; then
                        OSFullName="$1 - Version: $2; Like: $3"
                elif [[ -z $2 && ! -z $3 ]]; then
                        OSFullName="$1 - Like: $3"
                elif [[ ! -z $2 && -z $3 ]]; then
                        OSFullName="$1 - Version: $2"
                else
                        OSFullName="$1"
                fi
        else
                OSFullName="???"
        fi
}


GetLinuxInfo() {
        # Determine release file
        ReleaseFile=`ls $EtcPath/*release* 2> /dev/null`

        if [[ -z $ReleaseFile ]]; then
                echo "Warning!! I do not recognize the OS release of this Linux system!"
                exit 1
        fi

        ReleaseFile=`ls $EtcPath/os-release 2> /dev/null`

        if [[ ! -z $ReleaseFile ]]; then
                ReleaseFile="os-release"
                TestFile=$EtcPath"/"$ReleaseFile

                if [ -s $TestFile ]; then        # file's size > 0
                        OSName=`cat $TestFile |grep -E '^NAME=' |cut -d '=' -f 2 |sed 's/"//g'`
                        OSVersion=`cat $TestFile |grep -E '^VERSION=' |cut -d '=' -f 2 |sed 's/"//g'`
                        OSLike=`cat $TestFile |grep -E '^ID_LIKE=' |cut -d '=' -f 2 |sed 's/"//g'`
                        GetOSFullName "$OSName" "$OSVersion" "$OSLike"
                else
                        OSFullName="???"
                fi
        else
                ReleaseFile=`ls $EtcPath/lsb-release 2> /dev/null`

                if [[ ! -z $ReleaseFile ]]; then
                        ReleaseFile="lsb-release"
                        TestFile=$EtcPath"/"$ReleaseFile

                        if [ -s $TestFile ]; then
                                OSName=`cat $TestFile |grep -E '^DISTRIB_ID=' |cut -d '=' -f 2`
                                OSVersion=`cat $TestFile |grep -E '^DISTRIB_RELEASE=' |cut -d '=' -f 2`
                                GetOSFullName "$OSName" "$OSVersion"
                        else
                                OSFullName="???"
                        fi
                else
                        OSFullName="???"
                fi
        fi

        # Determine the package manager
        GetPackageManager

        # Determine the memory of the system
        Memory=( $Memory )

        for ((i=0; i<=${#Memory[@]}; i++)); do
                if [[ ${Memory[$i]} == "Mem:" ]]; then
                        mem_tot=${Memory[$i+1]}
                        mem_free=${Memory[$i+3]}
                fi

                if [[ ${Memory[$i]} == "Swap:" ]]; then
                        swap_tot=${Memory[$i+1]}
                        swap_free=${Memory[$i+3]}
                fi

                if [[ ${Memory[$i]} == "Total:" ]]; then
                        tot=${Memory[$i+1]}
                        free=${Memory[$i+3]}
                fi
        done

        if [[ -z $mem_tot || -z $mem_free || -z $tot || -z $free ]]; then
                Memory="???"
        else
                if [[ ! -z $swap_tot && ! -z $swap_free ]]; then
                        Memory="Total: $mem_tot - Free: $mem_free (Swap total: $swap_tot - Swap free: $swap_free) -> Tot: $tot - Free: $free"
                else
                        Memory="Total: $mem_tot - Free: $mem_free"
                fi
        fi

        # Determine the CPU of the system
        cpu=`echo "$CPU" |grep -E '^CPU\(s\):' |awk '{ print $2 }'`
        model=`echo "$CPU" |grep -E '^Model name:' |sed "s/Model name://" |awk '{ print $_ }' |sed "s/^\s*//"`

        if [[ -z $cpu || -z $model ]]; then
                CPU="???"
        else
                CPU="$cpu - Model: $model"
        fi
}


########## MAIN ##########

if [[ ! -z $1 ]]; then
        echo "Warning!! You have done something wrong!"
        echo "Usage: $0"
else
        Hostname=`hostname`
        KernelName=`uname -s`
        KernelRelease=`uname -r`
        HW_machine=`uname -m`
        OS=`uname -o`
        Memory=`free -h -t --giga`      # the memory informations can be read also in '/proc/meminfo'
        CPU=`lscpu`
        ReleaseFile=""
        EtcPath="/etc"

        if [[ -z $Hostname || -z $KernelName || -z $KernelRelease || -z $HW_machine || -z $OS || -z $Memory || -z $CPU ]]; then
                echo "Warning!! The command to extract informations about your Linux system does not work!"
                echo "You can try to execute it manually (uname --help)!"
                exit 1
        else
                GetLinuxInfo

                echo -e "\nHostname = $Hostname"
                echo "Kernel Name = $KernelName"
                echo "Kernel release = $KernelRelease"
                echo "Machine hardware name = $HW_machine"
                echo "Operating system = $OS"
                echo "Package manager = $PackageMan"
                echo "OS name = $OSFullName"
                echo "Memory = $Memory"
                echo -e "CPU = $CPU\n"
        fi
fi