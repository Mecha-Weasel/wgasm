#!/bin/bash
#
#       ----------------------------------------------------------------------------
#       Script to update OS (RedHat family) packages required for these scripts
#       ============================================================================
#       Created:       2024-05-31, by Weasel.SteamID.155@gMail.com
#       Last modified: 2025-01-10, by Weasel.SteamID.155@gMail.com
#       ----------------------------------------------------------------------------
#       __        ___    ____  _   _ ___ _   _  ____
#       \ \      / / \  |  _ \| \ | |_ _| \ | |/ ___|_
#        \ \ /\ / / _ \ | |_) |  \| || ||  \| | |  _(_)
#         \ V  V / ___ \|  _ <| |\  || || |\  | |_| |_
#          \_/\_/_/   \_\_| \_\_| \_|___|_| \_|\____(_)
#
#       NOTE:  This is the ONLY script of the "wgasm" project,
#       ----   that actually REQUIRES that it be run either directly as
#              the "root" user, or a user with similar 'sudo' privileges.
#
#       ----------------------------------------------------------------------------
#
#               Figure-out where the scripts folder is located ...
#
SCRIPTS_FOLDER="$( dirname -- "$( readlink -f -- "$0"; )"; )";
#
#               Define some ANSI color escape sequences ...
#
ANSI_OFF="\033[0m";
ANSI_BLACK="\033[0;30m";
ANSI_RED="\033[0;31m";
ANSI_GREEN="\033[0;32m";
ANSI_BROWN="\033[0;33m";
ANSI_BLUE="\033[0;34m";
ANSI_PURPLE="\033[0;35m";
ANSI_CYAN="\033[0;36m";
ANSI_GRAYLT="\033[0;37m";
ANSI_GRAYDK="\033[1;30m";
ANSI_REDLT="\033[1;31m";
ANSI_GREENLT="\033[1;32m";
ANSI_YELLOW="\033[1;33m";
ANSI_BLUELT="\033[1;34m";
ANSI_PURPLELT="\033[1;35m";
ANSI_CYANLT="\033[1;36m";
ANSI_WHITE="\033[1;37m"
#
#       Capture the time the scipt started in date-serial form ...
#
SCRIPT_DATESERIAL_START=$(date +%s);
#
#       Dispaly standard output beginning message ...
#
DIVIDERLINE="+-----------------------------------------------------------------------------+";
OUPUTCONTENT="Begin: ${ANSI_CYANLT}${0##*/}${ANSI_OFF}, at ${ANSI_WHITE}$(date)${ANSI_OFF}";
DIVIDERLINE_LENGTH=${#DIVIDERLINE};
OUPUTCONTENT_NOANSI=$(echo -e "$OUPUTCONTENT" | ansi2txt);
OUPUTCONTENT_LENGTH=${#OUPUTCONTENT_NOANSI};
PAD_LENGTH=$(( $DIVIDERLINE_LENGTH - $(( $OUPUTCONTENT_LENGTH + 4 )) ));
OUTPUTPAD=$(printf '%*s' $PAD_LENGTH);
PADDED_OUTPUT="| $OUPUTCONTENT$OUTPUTPAD |";
PADDED_OUTPUT_NOANSI="| $OUPUTCONTENT_NOANSI$OUTPUTPAD |";
if [ -t 1 ]; then
        echo -e "$DIVIDERLINE\n$PADDED_OUTPUT\n$DIVIDERLINE";
        else
                echo -e "$DIVIDERLINE\n$PADDED_OUTPUT_NOANSI\n$DIVIDERLINE";
fi;
#
#       Check for Nike-Mode ("Just Do-It!") ...
#
PARAMETER="$1";
if [[ $PARAMETER != "" ]]; then
                case $PARAMETER in
                        nike|-nike|--nike)
                                NIKE_MODE=true;
                                MESSAGE="${ANSI_PURPLELT}WARNING:${ANSI_OFF}\n";
                                MESSAGE+="${ANSI_WHITE}Running in \"${ANSI_PURPLELT}Just Do-It! / Nike-Mode${ANSI_WHITE}\"${ANSI_OFF}";
                                echo -e "\n$MESSAGE\n";
                                ;;
                        *)
                                NIKE_MODE=false;
                                MESSAGE="${ANSI_YELLOW}WARNING:${ANSI_OFF}\n";
                                MESSAGE+="${ANSI_WHITE}Ignoring unrecognized command-line parameter: \"${ANSI_YELLOW}$PARAMETER${ANSI_WHITE}\"${ANSI_OFF}";
                                echo -e "\n$MESSAGE\n";
                                ;;
                esac;
        else
                NIKE_MODE=false;
                MESSAGE="${ANSI_GREENLT}Update:${ANSI_OFF}\n";
                MESSAGE+="${ANSI_WHITE}No command-line parameter passed, disabling \"${ANSI_PURPLELT}Just Do-It! / Nike-Mode${ANSI_WHITE}\"${ANSI_OFF}";
                echo -e "\n$MESSAGE\n";
fi;
#
#       Check if the user IS 'root' or HAS 'sudo' ...
#
if ! [[ $USER == "root" ]]; then
        SUDO_DETECTION_COMMAND="sudo -v &> /dev/null && echo \"true\" || echo \"false\"";
        SUDO_CHECK=${SUDO_DETECTION_COMMAND};
        if ! [[ $SUDO_CHECK == true ]]; then
                MESSAGE="${ANSI_REDLT}ERROR:${ANSI_OFF}\n";
                MESSAGE+="${ANSI_WHITE}This script requires 'root' or equivelant 'sudo' access privileges!${ANSI_OFF}";
                echo -e "\n$MESSAGE\n";
                exit 1;
        fi;
fi;
#
#       Verify that this is a Debian-family Linux distribution ...
#
COMPATIBLE_OS=false
OS_DETECTION_COMMAND="uname -a";
OS_DETECTION=$($OS_DETECTION_COMMAND);
echo "Distro Detection Command:                    $OS_DETECTION_COMMAND";
echo "Distro Detection Output (Mixed-Case):        $OS_DETECTION";
OS_DETECTION=$(echo "$OS_DETECTION" | tr '[:upper:]' '[:lower:]');
echo "Distro Detection Output (Lower-Case):        $OS_DETECTION";
if [[ $OS_DETECTION == *"rocky"* ]]; then
    echo -e "Distro Detected:                             ${ANSI_GREENLT}Rocky${ANSI_OFF}";
  COMPATIBLE_OS=true
fi;
if [[ $OS_DETECTION == *"fedora"* ]]; then
       echo -e "Distro Detected:                             ${ANSI_GREENLT}Fedora${ANSI_OFF}";
       COMPATIBLE_OS=true
fi;
if [[ $OS_DETECTION == *"centos"* ]]; then
       echo -e "Distro Detected:                             ${ANSI_GREENLT}CentOS${ANSI_OFF}";
       COMPATIBLE_OS=true
fi;
if [[ $OS_DETECTION == *".el"* ]]; then
       echo -e "Distro Detected:                             ${ANSI_GREENLT}RHEL${ANSI_OFF}";
       COMPATIBLE_OS=true

        subscription-manager repos --enable codeready-builder-for-rhel-9-$(arch)-rpms;
        dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm;

fi;
if ! [[ $COMPATIBLE_OS == true ]]; then
        MESSAGE="${ANSI_REDLT}ERROR:${ANSI_OFF}\n";
        MESSAGE+="${ANSI_WHITE}A compatible Linux distribution (RedHat family) has NOT been detected!${ANSI_OFF}";
        echo -e "\n$MESSAGE\n";
        exit 1;
fi;
#
#       Verify that a compatible architecture is installed ...
#
COMPATIBLE_ARCH=false
ARCH_DETECTION_COMMAND="arch";
ARCH_DETECTION=$($ARCH_DETECTION_COMMAND);
echo "Architecture Detection Command:              $ARCH_DETECTION_COMMAND";
echo "Architecture Detection Output (Mixed-Case):  $ARCH_DETECTION";
ARCH_DETECTION=$(echo "$ARCH_DETECTION" | tr '[:upper:]' '[:lower:]');
echo "Architecture Detection Output (Lower-Case):  $ARCH_DETECTION";
if [[ $ARCH_DETECTION == x86_64* ]]; then
        echo -e "Architecture Detected:                       ${ANSI_GREENLT}Intel: 64-bit (x86_64)${ANSI_OFF}";
        COMPATIBLE_ARCH=true
fi;
if [[ $ARCH_DETECTION == i*86 ]]; then
        echo -e "Architecture Detected:                       ${ANSI_GREENLT}Intel: 32-bit (x86/iX86)${ANSI_OFF}";
        COMPATIBLE_ARCH=true
fi;
if [[ $ARCH_DETECTION == x32 ]]; then
        echo -e "Architecture Detected:                       ${ANSI_GREENLT}Intel: 32-bit (x32)${ANSI_OFF}";
        COMPATIBLE_ARCH=true
fi;
if [[ $ARCH_DETECTION == amd64 ]]; then
        echo -e "Architecture Detected:                       ${ANSI_GREENLT}AMD: 64-bit (amd64)${ANSI_OFF}";
        COMPATIBLE_ARCH=true
fi;
if [[ $ARCH_DETECTION == arm ]]; then
        echo -e "Architecture Detected:                       ${ANSI_GREENLT}Arm${ANSI_OFF}";
        COMPATIBLE_ARCH=false
fi;
if [[ $ARCH_DETECTION == arm64 ]]; then
        echo -e "Architecture Detected:                       ${ANSI_GREENLT}Arm: 64-bit (arm64)${ANSI_OFF}";
        COMPATIBLE_ARCH=false
fi;
if ! [[ $COMPATIBLE_ARCH == true ]]; then
        MESSAGE="${ANSI_REDLT}ERROR:${ANSI_OFF}\n";
        MESSAGE+="${ANSI_WHITE}A compatible Linux architecture (Intel comptabile) has NOT been detected!${ANSI_OFF}";
        echo -e "\n$MESSAGE\n";
        exit 1;
fi;
#
#       Enable 32-bit Intel architecture support:
#
#echo -e "\n${ANSI_BLUELT}INSTALLING:${ANSI_WHITE} 32-bit Intel architecture support (Possibly already installed)${ANSI_OFF} ...";
#sudo dpkg --add-architecture i386;
#
#       Latest updates for existing packages:
#
echo -e "\n${ANSI_BLUELT}INSTALLING:${ANSI_WHITE} Latest updates for existing packages${ANSI_OFF} ...";
sudo dnf update -y;
sudo dnf upgrade -y;
sudo dnf autoremove -y;
#
#       General OS requirements:
#
echo -e "\n${ANSI_BLUELT}INSTALLING:${ANSI_WHITE} General OS requirements (Hopefully already installed)${ANSI_OFF} ...";
sudo dnf install -y openssh-server coreutils sudo nano;
#
#       Required for virtual machine:
#       (Enable if running under VirtualBox, VMware, etc.)
#
#echo -e "\nINSTALLING: Recommended for virtual machine ...";
#echo -e "(No harm-done if it is not a virtual machine)";
#sudo dnf install -y open-vm-tools exfat-fuse;
#
#       Required if using Webmin:
#
echo -e "\n${ANSI_BLUELT}INSTALLING:${ANSI_WHITE} Required or recommended if using Webmin${ANSI_OFF} ..";
sudo dnf install -y ntp sntp ntpdate apt-transport-https dialog xmlstarlet iptables;
#
#       Required by scripts:
#
echo -e "\n${ANSI_BLUELT}INSTALLING:${ANSI_WHITE} Required by scripts (Many probably already installed)${ANSI_OFF} ...";
sudo dnf install -y gawk git grep tree wget curl git htop screen net-tools bind9-dnsutils p7zip-full zip unzip tar dialog figlet colorized-logs dos2unix;
#
#	    Required for ANSI-color processsing (and removal):
#
wget https://github.com/gabe565/ansi2txt/releases/download/v0.0.1/ansi2txt_0.0.1_linux_amd64.rpm
sudo dnf install -y ./ansi2txt_0.0.1_linux_amd64.rpm;
#
#       Useful for SteamCMD and/or game-servers:
#
echo -e "\n${ANSI_BLUELT}INSTALLING:${ANSI_WHITE} Required by SteamCMD - or HLDS / SrcDS, etc.${ANSI_OFF} ...";
sudo dnf install -y ncompress bzip2;
#
#       More stuff required by some game-servers, etc.:
#
sudo dnf install -y libstdc++6 libstdc++6:i386 lib32gcc-s1 ncurses ncurses-libs libcurl;
sudo ln -s "/usr/lib64/libncurses.so" "/usr/lib64/libncurses.so.5";
sudo ln -s "/usr/lib64/libtinfo.so" "/usr/lib64/libtinfo.so.5";
sudo ln -s "/usr/lib64/libcurl.so" "/usr/lib64/libcurl-gnutls.so.4"
sudo ln -s "/usr/lib/libncurses.so" "/usr/lib/libncurses.so.5";
sudo ln -s "/usr/lib/libtinfo.so" "/usr/lib/libtinfo.so.5";
sudo ln -s "/usr/lib/libcurl.so" "/usr/lib/libcurl-gnutls.so.4"
#
#       Testing that various required commands/utilities work now ...
#
#               Define some stuff ..
#
TEST_ERROR_CHECK=false;
#
#               Actually test each command (tesing parameters vary by command) ...
#
echo -e "\n${ANSI_BLUELT}TESTING:${ANSI_WHITE} Testing that various required commands/utilities work now (Many probably worked before)${ANSI_OFF} ...";
echo -e -n "Testing 'cat':         ";cat --version &> /dev/null && echo -e "${ANSI_GREENLT}Pass.${ANSI_OFF}" || { echo -e "${ANSI_REDLT}FAIL!${ANSI_OFF}"; TEST_ERROR_CHECK=true; };
echo -e -n "Testing 'wc':          ";wc --help &> /dev/null && echo -e "${ANSI_GREENLT}Pass.${ANSI_OFF}" || { echo -e "${ANSI_REDLT}FAIL!${ANSI_OFF}"; TEST_ERROR_CHECK=true; };
echo -e -n "Testing 'more':        ";echo "test" | more &> /dev/null && echo -e "${ANSI_GREENLT}Pass.${ANSI_OFF}" || { echo -e "${ANSI_REDLT}FAIL!${ANSI_OFF}"; TEST_ERROR_CHECK=true; };
echo -e -n "Testing '(g)awk':      ";gawk -V &> /dev/null && echo -e "${ANSI_GREENLT}Pass.${ANSI_OFF}" || { echo -e "${ANSI_REDLT}FAIL!${ANSI_OFF}"; TEST_ERROR_CHECK=true; };
echo -e -n "Testing 'sed':         ";sed --help &> /dev/null && echo -e "${ANSI_GREENLT}Pass.${ANSI_OFF}" || { echo -e "${ANSI_REDLT}FAIL!${ANSI_OFF}"; TEST_ERROR_CHECK=true; };
echo -e -n "Testing 'tr':          ";tr --help &> /dev/null && echo -e "${ANSI_GREENLT}Pass.${ANSI_OFF}" || { echo -e "${ANSI_REDLT}FAIL!${ANSI_OFF}"; TEST_ERROR_CHECK=true; };
echo -e -n "Testing 'column':      ";column --help &> /dev/null && echo -e "${ANSI_GREENLT}Pass.${ANSI_OFF}" || { echo -e "${ANSI_REDLT}FAIL!${ANSI_OFF}"; TEST_ERROR_CHECK=true; };
echo -e -n "Testing 'tail':        ";tail --help &> /dev/null && echo -e "${ANSI_GREENLT}Pass.${ANSI_OFF}" || { echo -e "${ANSI_REDLT}FAIL!${ANSI_OFF}"; TEST_ERROR_CHECK=true; };
echo -e -n "Testing 'printf':      ";printf "test" &> /dev/null && echo -e "${ANSI_GREENLT}Pass.${ANSI_OFF}" || { echo -e "${ANSI_REDLT}FAIL!${ANSI_OFF}"; TEST_ERROR_CHECK=true; };
echo -e -n "Testing 'grep':        ";grep --help &> /dev/null && echo -e "${ANSI_GREENLT}Pass.${ANSI_OFF}" || { echo -e "${ANSI_REDLT}FAIL!${ANSI_OFF}"; TEST_ERROR_CHECK=true; };
echo -e -n "Testing 'tar':         ";tar --help &> /dev/null && echo -e "${ANSI_GREENLT}Pass.${ANSI_OFF}" || { echo -e "${ANSI_REDLT}FAIL!${ANSI_OFF}"; TEST_ERROR_CHECK=true; };
echo -e -n "Testing 'gzip':        ";gzip --help &> /dev/null && echo -e "${ANSI_GREENLT}Pass.${ANSI_OFF}" || { echo -e "${ANSI_REDLT}FAIL!${ANSI_OFF}"; TEST_ERROR_CHECK=true; };
echo -e -n "Testing 'wget':        ";wget --help &> /dev/null && echo -e "${ANSI_GREENLT}Pass.${ANSI_OFF}" || { echo -e "${ANSI_REDLT}FAIL!${ANSI_OFF}"; TEST_ERROR_CHECK=true; };
echo -e -n "Testing 'curl':        ";curl --help &> /dev/null && echo -e "${ANSI_GREENLT}Pass.${ANSI_OFF}" || { echo -e "${ANSI_REDLT}FAIL!${ANSI_OFF}"; TEST_ERROR_CHECK=true; };
echo -e -n "Testing 'tree':        ";tree --help &> /dev/null && echo -e "${ANSI_GREENLT}Pass.${ANSI_OFF}" || { echo -e "${ANSI_REDLT}FAIL!${ANSI_OFF}"; TEST_ERROR_CHECK=true; };
echo -e -n "Testing 'git':         ";git --help &> /dev/null && echo -e "${ANSI_GREENLT}Pass.${ANSI_OFF}" || { echo -e "${ANSI_REDLT}FAIL!${ANSI_OFF}"; TEST_ERROR_CHECK=true; };
echo -e -n "Testing 'screen':      ";screen -v &> /dev/null && echo -e "${ANSI_GREENLT}Pass.${ANSI_OFF}" || { echo -e "${ANSI_REDLT}FAIL!${ANSI_OFF}"; TEST_ERROR_CHECK=true; };
echo -e -n "Testing '7za':         ";7za --help &> /dev/null && echo -e "${ANSI_GREENLT}Pass.${ANSI_OFF}" || { echo -e "${ANSI_REDLT}FAIL!${ANSI_OFF}"; TEST_ERROR_CHECK=true; };
echo -e -n "Testing 'zip':         ";zip --help &> /dev/null && echo -e "${ANSI_GREENLT}Pass.${ANSI_OFF}" || { echo -e "${ANSI_REDLT}FAIL!${ANSI_OFF}"; TEST_ERROR_CHECK=true; };
echo -e -n "Testing 'unzip':       ";unzip --help &> /dev/null && echo -e "${ANSI_GREENLT}Pass.${ANSI_OFF}" || { echo -e "${ANSI_REDLT}FAIL!${ANSI_OFF}"; TEST_ERROR_CHECK=true; };
echo -e -n "Testing 'uncompress':  ";uncompress -h &> /dev/null && echo -e "${ANSI_GREENLT}Pass.${ANSI_OFF}" || { echo -e "${ANSI_REDLT}FAIL!${ANSI_OFF}"; TEST_ERROR_CHECK=true; };
echo -e -n "Testing 'bzip2':       ";bzip2 --help &> /dev/null && echo -e "${ANSI_GREENLT}Pass.${ANSI_OFF}" || { echo -e "${ANSI_REDLT}FAIL!${ANSI_OFF}"; TEST_ERROR_CHECK=true; };
echo -e -n "Testing 'dialog':      ";dialog --help &> /dev/null && echo -e "${ANSI_GREENLT}Pass.${ANSI_OFF}" || { echo -e "${ANSI_REDLT}FAIL!${ANSI_OFF}"; TEST_ERROR_CHECK=true; };
echo -e -n "Testing 'dos2unix':    ";echo -e "test" | dos2unix &> /dev/null && echo -e "${ANSI_GREENLT}Pass.${ANSI_OFF}" || { echo -e "${ANSI_REDLT}FAIL!${ANSI_OFF}"; TEST_ERROR_CHECK=true; };
echo -e -n "Testing 'figlet':      ";figlet "test" &> /dev/null && echo -e "${ANSI_GREENLT}Pass.${ANSI_OFF}" || { echo -e "${ANSI_REDLT}FAIL!${ANSI_OFF}"; TEST_ERROR_CHECK=true; };
echo -e -n "Testing 'netstat':     ";netstat --help &> /dev/null && echo -e "${ANSI_GREENLT}Pass.${ANSI_OFF}" || { echo -e "${ANSI_REDLT}FAIL!${ANSI_OFF}"; TEST_ERROR_CHECK=true; };
echo -e -n "Testing 'dig':         ";dig -h &> /dev/null && echo -e "${ANSI_GREENLT}Pass.${ANSI_OFF}" || { echo -e "${ANSI_REDLT}FAIL!${ANSI_OFF}"; TEST_ERROR_CHECK=true; };
echo -e -n "Testing 'ansi2txt':    ";echo -e "test" | ansi2txt &> /dev/null && echo -e "${ANSI_GREENLT}Pass.${ANSI_OFF}" || { echo -e "${ANSI_REDLT}FAIL!${ANSI_OFF}"; TEST_ERROR_CHECK=true; };
#
#       If any of thsoe checks failed, display an error messsage ...
#
if [[ $TEST_ERROR_CHECK == true ]]; then
                MESSAGE="${ANSI_REDLT}ERROR:${ANSI_OFF}\n";
                MESSAGE+="${ANSI_WHITE}One or more prerequisite commands or utilities are missing!\n${ANSI_OFF}";
                MESSAGE+="${ANSI_WHITE}You MUST resolve these errors by intalling the appropiate\n${ANSI_OFF}";
                MESSAGE+="${ANSI_WHITE}packages for failed tests before proceeding!${ANSI_OFF}";
                echo -e "\n$MESSAGE\n";
                exit 1;
        else
                MESSAGE="${ANSI_GREENLT}PASSED:${ANSI_OFF}\n";
                MESSAGE+="${ANSI_WHITE}So far, everything looks good!${ANSI_OFF}";
                echo -e "\n$MESSAGE\n";
fi;
#
#       Attempt to determine the computer's (local) IP address ...
#
SERVER_LOCAL_IP_ADDRESS=$(hostname --all-ip-addresses | cut -d' ' -f1);
#
#       Attempt to determine the computer's (public) IP address ...
#
SERVER_PUBLIC_IP_ADDRESS=$(dig +short txt o-o.myaddr.l.google.com @ns1.google.com | awk -F'"' '{print $2}');
#
#       Test if Webmin is already installed ...
#
sudo dnf list installed | grep webmin 2> /dev/null > /dev/null;
if [[ "$?" -gt 0 ]]; then
                WEBMIN_CHECK=false;
        else
                WEBMIN_CHECK=true
fi;
if [[ $WEBMIN_CHECK == false ]]; then
                #
                #       If Webmin is not installed, offer to install it ...
                #
                if [[ $NIKE_MODE == true ]]; then
                                PROMPT_INPUT="nike";
                        else
                                read -p "Would you like to install \"Webmin\" now? (y/n)" PROMPT_INPUT;
                fi;
                case $PROMPT_INPUT in
                        y|Y|yes|Yes|YES|nike)
                                #
                                #       Setup repos for Webmin installation ...
                                #
                                WEBMIN_FOLDER="/etc/webmin";
                                cd $WEBMIN_FOLDER;
                                echo "Downloading the \"Webmin\" repository-setup script (setup-repos.sh ) ...";
                                wget -O setup-repos.sh https://raw.githubusercontent.com/webmin/webmin/master/setup-repos.sh && TEST_ERROR_CHECK=false || TEST_ERROR_CHECK=true;
                                chmod +x ./setup-repos.sh -f && TEST_ERROR_CHECK=false || TEST_ERROR_CHECK=true;
                                sudo ./setup-repos.sh -f && TEST_ERROR_CHECK=false || TEST_ERROR_CHECK=true;
                                if [[ $TEST_ERROR_CHECK == true ]]; then
                                        TEST_USER_EXISTS=false;
                                        MESSAGE="${ANSI_REDLT}ERROR:${ANSI_OFF}\n";
                                        MESSAGE+="${ANSI_WHITE}There was a problem downloading (or running) the \"Webmin\" repository-setup script (setup-repos.sh)!${ANSI_OFF}\n";
                                        echo -e "\n$MESSAGE\n";
                                        exit 1;
                                fi;
                                rm -f setup-repos.sh 2> /dev/null > /dev/null;
                                #
                                #       Install Webmin  ...
                                #
                                echo "Attempting to install \"Webmin\" ...";
                                sudo dnf install -y iptables webmin && TEST_ERROR_CHECK=false || TEST_ERROR_CHECK=true;
                                sudo service webmin stop && TEST_ERROR_CHECK=false || TEST_ERROR_CHECK=true;
                                echo "Changing Webmin default port to  \"8443\" ...";
                                sudo sed -i 's/port=10000/port=8443/g' /etc/webmin/miniserv.conf 2> /dev/null > /dev/null && TEST_ERROR_CHECK=false || TEST_ERROR_CHECK=true;
                                sudo sed -i 's/listen=10000/listen=8443/g' /etc/webmin/miniserv.conf 2> /dev/null > /dev/null && TEST_ERROR_CHECK=false || TEST_ERROR_CHECK=true;
                                echo "Enabling Webmin \"referrers\" ...";
                                sudo sed -i 's/referers_none=1/referers_none=0/g' /etc/webmin/config 2> /dev/null > /dev/null && TEST_ERROR_CHECK=false || TEST_ERROR_CHECK=true;
                                sudo service webmin restart && TEST_ERROR_CHECK=false || TEST_ERROR_CHECK=true;
                                if [[ $TEST_ERROR_CHECK == true ]]; then
                                                MESSAGE="${ANSI_REDLT}ERROR:${ANSI_OFF}\n";
                                                MESSAGE+="${ANSI_WHITE}There was a problem installing (or configuring) the \"Webmin\"!${ANSI_OFF}\n";
                                                echo -e "\n$MESSAGE\n";
                                                exit 1;
                                        else
                                                MESSAGE="${ANSI_GREENLT}PASSED:${ANSI_OFF}\n";
                                                MESSAGE+="${ANSI_WHITE}The \"Webmin\" should now be installed and reachable in a web browser at:${ANSI_OFF}\n";
                                                MESSAGE+="${ANSI_YELLOW}https://$SERVER_LOCAL_IP_ADDRESS:8443${ANSI_OFF}\n";
                                                echo -e "\n$MESSAGE\n";
                                fi;
                                #
                                #               Create /root/.filemin/.bookmarks file ...
                                #
                                echo "Setting-up default File Manager \"bookmarks\" ...";
                                FILEMIN_BOOKMARKS_FOLDER="/root/.filemin/";
                                mkdir $FILEMIN_BOOKMARKS_FOLDER 2> /dev/null > /dev/null;
                                FILEMIN_BOOKMARKS_FILE="$FILEMIN_BOOKMARKS_FOLDER/.bookmarks";
                                echo -e "/" > $FILEMIN_BOOKMARKS_FILE;
                                echo -e "/root" >> $FILEMIN_BOOKMARKS_FILE;
                                echo -e "/etc" >> $FILEMIN_BOOKMARKS_FILE;
                                echo -e "/etc/webmin" >> $FILEMIN_BOOKMARKS_FILE;
                                echo -e "/home" >> $FILEMIN_BOOKMARKS_FILE;
                                echo -e "/home/game-servers" >> $FILEMIN_BOOKMARKS_FILE;
                                chown game-servers:game-serves $FILEMIN_BOOKMARKS_FILE 2> /dev/null > /dev/null;
                                ;;
                        n|N|no|No|NO)
                                #
                                #       Do not install Webmin, but warn about installing it ...
                                #
                                MESSAGE="${ANSI_YELLOW}WARNING:${ANSI_OFF}\n";
                                MESSAGE+="${ANSI_WHITE}Okay, whatever - if you want to make your life harder than it needs to be!${ANSI_OFF}\n";
                                echo -e "\n$MESSAGE\n";
                                ;;
                        *)
                                #
                                #       Something else happended, abort ...
                                #
                                MESSAGE="${ANSI_REDLT}ERROR:${ANSI_OFF}\n";
                                MESSAGE+="DUDE! I do not know what you mean? You were supposed to press \"Y\" or \"N\"!";
                                echo -e "\n$MESSAGE\n";
                                exit 1;
                                ;;
                esac;
        else
                MESSAGE="${ANSI_GREENLT}Update:${ANSI_OFF}\n";
                MESSAGE+="Looks like \"Webmin\" is already installed.";
                echo -e "\n$MESSAGE\n";
fi;
#
#       Test if Webmin is already installed ...
#
sudo dnf list installed | grep webmin 2> /dev/null > /dev/null;
if [[ "$?" -gt 0 ]]; then
                WEBMIN_CHECK=false;
        else
                WEBMIN_CHECK=true
fi;
if [[ $WEBMIN_CHECK == true ]]; then
                #
                #       If Webmin IS installed, offer to install "custom commands" for Webmin ...
                #
                if [[ $NIKE_MODE == true ]]; then
                                PROMPT_INPUT="nike";
                        else
                                read -p "Would you like to install Weasels \"Custom Commands\" into Webmin now? (y/n)" PROMPT_INPUT;
                fi;
                case $PROMPT_INPUT in
                        y|Y|yes|Yes|YES|nike)
                                #
                                #       Download the gzipped-tarball archive of Webmin "Custom Commands" ...
                                #
                                WEBMIN_FOLDER="/etc/webmin";
                                cd $WEBMIN_FOLDER;
                                CUSTOM_COMMANDS_FILE="webmin-custom.tar.gz";
                                echo "Downloading the Webmin \"Custom Commands\" archive (webmin-custom.tar.gz)  ...";
                                wget -O $CUSTOM_COMMANDS_FILE https://github.com/Mecha-Weasel/wgasm/raw/main/webmin-custom.tar.gz && TEST_ERROR_CHECK=false || TEST_ERROR_CHECK=true;
                                #
                                #       Extract the gzipped-tarball archive of Webmin "Custom Commands" ...
                                #
                                tar -xzf $CUSTOM_COMMANDS_FILE && TEST_ERROR_CHECK=false || TEST_ERROR_CHECK=true;
                                #
                                #       Check if any errors were thrown ...
                                #
                                if [[ $TEST_ERROR_CHECK == true ]]; then
                                        MESSAGE="${ANSI_REDLT}ERROR:${ANSI_OFF}\n";
                                        MESSAGE+="${ANSI_WHITE}There was a problem downloading (or extracting) the Webmin \"Custom Commands\"!${ANSI_OFF}";
                                        echo -e "\n$MESSAGE\n";
                                        exit 1;
                                fi;
                                #rm -f $CUSTOM_COMMANDS_FILE 2> /dev/null > /dev/null;
                                ;;
                        n|N|no|No|NO)
                                #
                                #       Do not install the "wgasm" system, but warn about creating it ...
                                #
                                MESSAGE="${ANSI_YELLOW}WARNING:${ANSI_OFF}\n";
                                MESSAGE+="${ANSI_WHITE}Okay, whatever - if you want to make your life harder than it needs to be!${ANSI_OFF}";
                                echo -e "\n$MESSAGE\n";
                                ;;
                        *)
                                #
                                #       Something else happended, abort ...
                                #
                                MESSAGE="${ANSI_REDLT}ERROR:${ANSI_OFF}\n";
                                MESSAGE+="DUDE! I do not know what you mean? You were supposed to press \"Y\" or \"N\"!";
                                echo -e "\n$MESSAGE\n";
                                exit 1;
                                ;;
                esac;
        else
                MESSAGE="${ANSI_YELLOW}WARNING:${ANSI_OFF}\n";
                MESSAGE+="Looks like \"Webmin\" is NOT already installed, so NOT offering to install Webmin \"Custom Commands\".";
                echo -e "\n$MESSAGE\n";
fi;

#
#       Test ti see if the game-servers user already exists ..
#
echo "Checking to see if the \"game-servers\" user already exists ...";
sudo id game-servers &> /dev/null && TEST_USER_EXISTS=true || TEST_USER_EXISTS=false;
if [[ $TEST_USER_EXISTS == false ]]; then
                #
                #       Prompt if the game-servers user should be created now ...
                #
                if [[ $NIKE_MODE == true ]]; then
                                PROMPT_INPUT="nike";
                        else
                                read -p "Would you like create the \"game-servers\" user now? (y/n)" PROMPT_INPUT;
                fi;
                case $PROMPT_INPUT in
                        y|Y|yes|Yes|YES|nike)
                                #
                                #       Create the game-servers user ...
                                #
                                echo "Creating user \"game-servers\" ...";
                                { sudo useradd -m -s /bin/bash game-servers; echo -e "n0t.Password!\nn0t.Password!\n" | sudo passwd game-servers; } && { echo -e "${ANSI_GREENLT}User created.${ANSI_OFF}"; TEST_ERROR_CHECK=false; } || { echo -e "${ANSI_REDLT}User failed to create!${ANSI_OFF}"; TEST_ERROR_CHECK=true; };
                                if [[ $TEST_ERROR_CHECK == true ]]; then
                                                TEST_USER_EXISTS=false;
                                                MESSAGE="${ANSI_REDLT}ERROR:${ANSI_OFF}\n";
                                                MESSAGE+="${ANSI_WHITE}There was a problem creating the \"game-servers\" user!\n${ANSI_OFF}";
                                                echo -e "\n$MESSAGE\n";
                                                exit 1;
                                        else
                                                TEST_USER_EXISTS=true;
                                                MESSAGE="${ANSI_GREENLT}PASSED:${ANSI_OFF}\n";
                                                MESSAGE+="${ANSI_WHITE}The user \"game-servers\" should now be created, and have the default password of \"${ANSI_YELLOW}n0t.Password${ANSI_OFF}\" - which of course you should ${ANSI_REDLT}immediately to change to something else${ANSI_OFF}.${ANSI_OFF}";
                                        echo -e "\n$MESSAGE\n";
                                fi;
                                ;;
                        n|N|no|No|NO)
                                #
                                #       Do not create the game-servers user, but warn about creating it ...
                                #
                                MESSAGE="${ANSI_YELLOW}WARNING:${ANSI_OFF}\n";
                                MESSAGE+="${ANSI_WHITE}Okay, whatever - just remember to create it later yourself! Remember that:\n${ANSI_OFF}";
                                MESSAGE+="${ANSI_WHITE}1) The users shell must be set to use \"${ANSI_YELLOW}/bin/bash${ANSI_OFF}\" for the scripts to run correctly!${ANSI_OFF}\n";
                                MESSAGE+="${ANSI_WHITE}2) The user must be named (exactly) \"${ANSI_YELLOW}game-servers${ANSI_OFF}\" if you want the related Webmin \"Custom Commands\" to work!${ANSI_OFF}";
                                echo -e "\n$MESSAGE\n";
                                ;;
                        *)
                                #
                                #       Something else happended, abort ...
                                #
                                MESSAGE="${ANSI_REDLT}ERROR:${ANSI_OFF}\n";
                                MESSAGE+="DUDE! I do not know what you mean? You were supposed to press \"Y\" or \"N\"!";
                                echo -e "\n$MESSAGE\n";
                                exit 1;
                                ;;
                esac;
        else
                #
                #       Skip creating the game-servers user since it already exists ...
                #
                MESSAGE="${ANSI_GREENLT}Update:${ANSI_OFF}\n";
                MESSAGE+="Looks like the \"game-servers\" user already exists, skipping creation of it ...";
                echo -e "\n$MESSAGE\n";
fi;
#
#       If game-servers user (now) exists, offer to download the installation script as that user ...
#
sudo id game-servers &> /dev/null && TEST_USER_EXISTS=true || TEST_USER_EXISTS=false;
if [[ $TEST_USER_EXISTS == true ]]; then
                #
                #       Offer to download the installer for the "wgasm" system, as the game-servers user ...
                #
                if [[ $NIKE_MODE == true ]]; then
                                PROMPT_INPUT="nike";
                        else
                                read -p "Would you like to pre-download the latest \"wgasm\" installation script (install-wgasm.sh) under the \"game-servers\" user now? (y/n)" PROMPT_INPUT;
                fi;
                case $PROMPT_INPUT in
                        y|Y|yes|Yes|YES|nike)
                                #
                                #       Create the game-servers user ...
                                #
                                echo "Downloading the \"wgasm\" installation script (install-wgasm.sh) under the \"game-servers\" user ...";
                                DOWNLOAD_COMMAND="wget -O install-wgasm.sh https://github.com/Mecha-Weasel/wgasm/raw/main/install-wgasm.sh";
                                SUDO_DOWNLOAD_COMMAND="sudo -i -u game-servers $DOWNLOAD_COMMAND";
                                { $SUDO_DOWNLOAD_COMMAND; } && { TEST_ERROR_CHECK=false; } || { TEST_ERROR_CHECK=true; };
                                if [[ $TEST_ERROR_CHECK == true ]]; then
                                                TEST_USER_EXISTS=false;
                                                MESSAGE="${ANSI_REDLT}ERROR:${ANSI_OFF}\n";
                                                MESSAGE+="${ANSI_WHITE}There was a problem downloading the \"wgasm\" installation script under the \"${ANSI_YELLOW}game-servers${ANSI_WHITE}\" user!${ANSI_OFF}\n";
                                                echo -e "\n$MESSAGE\n";
                                                exit 1;
                                        else
                                                TEST_USER_EXISTS=true;
                                                MESSAGE="${ANSI_GREENLT}PASSED:${ANSI_OFF}\n";
                                                MESSAGE+="${ANSI_WHITE}The \"wgasm\" installation script (install-wgasm.sh) should now be pre-downloaded under the \"${ANSI_YELLOW}game-servers${ANSI_WHITE}\" user.${ANSI_OFF}\n";
                                                MESSAGE+="${ANSI_WHITE}To install the \"wgasm\" system:${ANSI_OFF}\n";
                                                MESSAGE+="${ANSI_WHITE}1) Login as \"${ANSI_YELLOW}game-servers${ANSI_WHITE}\" user.${ANSI_OFF}\n";
                                                MESSAGE+="${ANSI_WHITE}2) Mark the ${ANSI_YELLOW}install-wgasm.sh${ANSI_WHITE} file as executable (using the command: \"chmod +x ~/install-wgasm.sh\").${ANSI_OFF}\n";
                                                MESSAGE+="${ANSI_WHITE}3) Run the ${ANSI_YELLOW}install-wgasm.sh${ANSI_WHITE} script (using the command: \"~/install-wgasm.sh\").${ANSI_OFF}";
                                                echo -e "\n$MESSAGE\n";
                                                sudo -i -u game-servers ls -lah;
                                fi;
                                ;;
                        n|N|no|No|NO)
                                #
                                #       Do not download "wgasm" installer, but warn about creating it ...
                                #
                                MESSAGE="${ANSI_YELLOW}WARNING:${ANSI_OFF}\n";
                                MESSAGE+="${ANSI_WHITE}Okay, whatever - just remember to download it later yourself!${ANSI_OFF}\n";
                                MESSAGE+="Remember when installing the \"wgasm\" system, be sure to be logged-in as the \"${ANSI_YELLOW}game-servers${ANSI_WHITE}\" user!${ANSI_OFF}";
                                echo -e "\n$MESSAGE\n";
                                ;;
                        *)
                                #
                                #       Something else happended, abort ...
                                #
                                MESSAGE="${ANSI_REDLT}ERROR:${ANSI_OFF}\n";
                                MESSAGE+="DUDE! I do not know what you mean? You were supposed to press \"Y\" or \"N\"!";
                                echo -e "\n$MESSAGE\n";
                                exit 1;
                                ;;
                esac;
        else
                #
                #       Skip downloading the "wgasm" system if the game-servers user does not exist ...
                #
                MESSAGE="${ANSI_GREENLT}Update:${ANSI_OFF}\n";
                MESSAGE+="Since \"game-servers\" does not exist, skipping offering to download the \"wgasm\" system.";
                echo -e "\n$MESSAGE\n";
fi;
#
#       Test if Webmin is installed AND game-servers user exists ...
#
sudo dnf list installed | grep webmin 2> /dev/null > /dev/null;
if [[ "$?" -gt 0 ]]; then
                WEBMIN_CHECK=false;
        else
                WEBMIN_CHECK=true
fi;
sudo id game-servers &> /dev/null && TEST_USER_EXISTS=true || TEST_USER_EXISTS=false;
if [ $WEBMIN_CHECK == true -a $TEST_USER_EXISTS == true ]; then
                #
                #       Offer to setup game-servers as a Webmin user ...
                #
                if [[ $NIKE_MODE == true ]]; then
                                PROMPT_INPUT="nike";
                        else
                                read -p "Would you like setup \"game-servers\" as a Webmin user now? (y/n)" PROMPT_INPUT;
                fi;
                WEBMIN_FOLDER="/etc/webmin";
                case $PROMPT_INPUT in
                        y|Y|yes|Yes|YES|nike)
                                #
                                #       Setup "game-servers" as a Webmin user ...
                                #
                                echo "Setting-up \"game-servers\" as a Webmin user ...";
                                #
                                #               Add "game-servers" to webmin/miniserv.users ...
                                #
                                #                       root:x:0
                                #                       game-servers:x::::::::0::::
                                #
                                WEBMIN_MINISERV_FILE="$WEBMIN_FOLDER/miniserv.users";
                                sed -i '/^game-servers/d' $WEBMIN_MINISERV_FILE;
                                WEBMIN_MINISERV_ENTRY="game-servers:x::::::::0::::";
                                echo "$WEBMIN_MINISERV_ENTRY" >> $WEBMIN_MINISERV_FILE;
                                #
                                #               Add "game-servers" to webmin/config ...
                                #
                                #                       realname_game-servers=Game-Servers
                                #                       notabs_game-servers=2
                                #
                                WEBMIN_CONFIG_FILE="$WEBMIN_FOLDER/config";
                                #
                                sed -i '/^realname_game-servers/d' $WEBMIN_CONFIG_FILE;
                                WEBMIN_CONFIG_ENTRY="realname_game-servers=Game-Servers";
                                echo "$WEBMIN_CONFIG_ENTRY" >> $WEBMIN_CONFIG_FILE;
                                #
                                sed -i '/^notabs_game-servers/d' $WEBMIN_CONFIG_FILE;
                                WEBMIN_CONFIG_ENTRY="notabs_game-servers=2";
                                echo "$WEBMIN_CONFIG_ENTRY" >> $WEBMIN_CONFIG_FILE;
                                #
                                #               Add "game-servers" to webmin/webmin.acl ...
                                #
                                #                       root: acl adsl-client apache at backup-config bacula-backup bandwidth bind8 change-user cluster-copy cluster-cron cluster-passwd cluster-shell cluster-software cluster-useradmin cluster-usermin cluster-webmin cpan cron custom dfsadmin dhcpd dovecot exim exports fail2ban fdisk fetchmail filemin filter firewall firewall6 firewalld fsdump heartbeat htaccess-htpasswd idmapd inetd init inittab ipfilter ipfw ipsec iscsi-client iscsi-server iscsi-target iscsi-tgtd krb5 ldap-client ldap-server ldap-useradmin logrotate logviewer lpadmin lvm mailboxes mailcap man mount mysql net nis openslp package-updates pam pap passwd phpini postfix postgresql ppp-client pptp-client pptp-server proc procmail proftpd qmailadmin quota raid samba sarg sendmail servers shell shorewall shorewall6 smart-status smf software spam squid sshd status stunnel syslog-ng syslog system-status tcpwrappers time tunnel updown useradmin usermin webalizer webmin webmincron webminlog xinetd xterm
                                #                       game-servers: custom filemin updown uthentic-theme
                                #
                                WEBMIN_ACL_FILE="$WEBMIN_FOLDER/webmin.acl";
                                sed -i '/^game-servers/d' $WEBMIN_ACL_FILE;
                                WEBMIN_ACL_ENTRY+="game-servers:";
                                WEBMIN_ACL_ENTRY+=" custom";
                                WEBMIN_ACL_ENTRY+=" filemin";
                                WEBMIN_ACL_ENTRY+=" updown";
                                WEBMIN_ACL_ENTRY+=" uthentic-theme";
                                echo -e "$WEBMIN_ACL_ENTRY" >> $WEBMIN_ACL_FILE;
                                #
                                #               Create webmin/game-servers.acl file ...
                                #
                                #                       gedit2=
                                #                       readonly=0
                                #                       feedback=0
                                #                       gedit_mode=0
                                #                       nodot=0
                                #                       uedit=
                                #                       webminsearch=0
                                #                       uedit2=
                                #                       otherdirs=
                                #                       rpc=0
                                #                       negative=1
                                #                       fileunix=game-servers
                                #                       root=
                                #                       uedit_mode=0
                                #                       gedit=
                                #
                                GAMESEVERS_ACL_FILE="$WEBMIN_FOLDER/game-servers.acl";
                                echo -e "gedit2=" > $GAMESEVERS_ACL_FILE;
                                echo -e "readonly=0" >> $GAMESEVERS_ACL_FILE;
                                echo -e "feedback=0" >> $GAMESEVERS_ACL_FILE;
                                echo -e "gedit_mode=0" >> $GAMESEVERS_ACL_FILE;
                                echo -e "nodot=0" >> $GAMESEVERS_ACL_FILE;
                                echo -e "uedit=" >> $GAMESEVERS_ACL_FILE;
                                echo -e "webminsearch=0" >> $GAMESEVERS_ACL_FILE;
                                echo -e "uedit2=" >> $GAMESEVERS_ACL_FILE;
                                echo -e "otherdirs=" >> $GAMESEVERS_ACL_FILE;
                                echo -e "rpc=0" >> $GAMESEVERS_ACL_FILE;
                                echo -e "negative=1" >> $GAMESEVERS_ACL_FILE;
                                echo -e "fileunix=game-servers" >> $GAMESEVERS_ACL_FILE;
                                echo -e "root=" >> $GAMESEVERS_ACL_FILE;
                                echo -e "uedit_mode=0" >> $GAMESEVERS_ACL_FILE;
                                echo -e "gedit=" >> $GAMESEVERS_ACL_FILE;
                                #
                                #               Create webmin/updown/game-servers.acl file ...
                                #
                                #                       upload=1
                                #                       home=1
                                #                       dirs=/home/game-servers
                                #                       fetch=1
                                #                       max=
                                #                       mode=1
                                #                       download=1
                                #                       users=game-servers
                                #
                                WEBMIN_UPDOWN_FILE="$WEBMIN_FOLDER/updown/game-servers.acl";
                                echo -e "upload=1" > $WEBMIN_UPDOWN_FILE;
                                echo -e "home=1" >> $WEBMIN_UPDOWN_FILE;
                                echo -e "dirs=/home/game-servers" >> $WEBMIN_UPDOWN_FILE;
                                echo -e "fetch=1" >> $WEBMIN_UPDOWN_FILE;
                                echo -e "max=" >> $WEBMIN_UPDOWN_FILE;
                                echo -e "mode=1" >> $WEBMIN_UPDOWN_FILE;
                                echo -e "download=1" >> $WEBMIN_UPDOWN_FILE;
                                echo -e "users=game-servers" >> $WEBMIN_UPDOWN_FILE;
                                #
                                #               Create webmin/filemin/game-servers.acl file ...
                                #
                                #                       work_as_user=game-servers
                                #                       work_as_root=0
                                #                       max=
                                #                       allowed_paths=/home/game-servers
                                #                       allowed_for_edit=application-x-php application-x-ruby application-xml application-xslt+xml application-javascript application-x-shellscript application-x-perl application-x-yaml application-json application-x-x509-ca-cert application-pkix-cert application-sql application-x-sql application-x-asp application-x-aspx application-xhtml+xml
                                #
                                WEBMIN_FILEMIN_FILE="$WEBMIN_FOLDER/filemin/game-servers.acl";
                                echo -e "work_as_user=game-servers" > $WEBMIN_FILEMIN_FILE;
                                echo -e "work_as_root=0" >> $WEBMIN_FILEMIN_FILE;
                                echo -e "max=" >> $WEBMIN_FILEMIN_FILE;
                                echo -e "allowed_paths=/home/game-servers" >> $WEBMIN_FILEMIN_FILE;
                                echo -e "allowed_for_edit=application-x-php application-x-ruby application-xml application-xslt+xml application-javascript application-x-shellscript application-x-perl application-x-yaml application-json application-x-x509-ca-cert application-pkix-cert application-sql application-x-sql application-x-asp application-x-aspx application-xhtml+xml" >> $WEBMIN_FILEMIN_FILE;
                                #
                                #               Create webmin/filemin/prefs.game-servers file ...
                                #
                                #                       config_portable_module_filemanager_tree_view_depth=3
                                #                       config_portable_module_filemanager_calculate_size=true
                                #                       config_portable_module_filemanager_view_limit=512000
                                #                       config_portable_module_filemanager_checksum_limit=1024000
                                #                       config_portable_module_filemanager_tree_expand_search=true
                                #                       config_portable_module_filemanager_editor_detect_encoding=true
                                #                       config_portable_module_filemanager_files_safe_mode=true
                                #                       config_portable_module_filemanager_hovered_toolbar=false
                                #                       config_portable_module_filemanager_switch_users=true
                                #                       config_portable_module_filemanager_tree_exclude_on_first_load=true
                                #                       per_page=500
                                #                       columns=type,size,owner_user,permissions,last_mod_time
                                #                       config_portable_module_filemanager_records_for_server_pagination=1000
                                #                       config_portable_module_filemanager_editor_tabs_to_spaces=false
                                #                       config_portable_module_filemanager_editor_maximized=false
                                #                       config_portable_module_filemanager_hide_tree_view=true
                                #                       config_portable_module_filemanager_remember_tabs=false
                                #                       config_portable_module_filemanager_force_tar=true
                                #                       config_portable_module_filemanager_hide_actions=true
                                #                       config_portable_module_filemanager_move_to_trash=false
                                #                       config_portable_module_filemanager_default_sort=0
                                #                       config_portable_module_filemanager_hide_toolbar=false
                                #                       config_portable_module_filemanager_show_dot_files=true
                                #
                                WEBMIN_FILEMIN_FILE="$WEBMIN_FOLDER/filemin/prefs.game-servers";
                                echo -e "config_portable_module_filemanager_tree_view_depth=3" > $WEBMIN_FILEMIN_FILE;
                                echo -e "config_portable_module_filemanager_calculate_size=true" >> $WEBMIN_FILEMIN_FILE;
                                echo -e "config_portable_module_filemanager_view_limit=512000" >> $WEBMIN_FILEMIN_FILE;
                                echo -e "config_portable_module_filemanager_checksum_limit=1024000" >> $WEBMIN_FILEMIN_FILE;
                                echo -e "config_portable_module_filemanager_tree_expand_search=true" >> $WEBMIN_FILEMIN_FILE;
                                echo -e "config_portable_module_filemanager_editor_detect_encoding=true" >> $WEBMIN_FILEMIN_FILE;
                                echo -e "config_portable_module_filemanager_files_safe_mode=true" >> $WEBMIN_FILEMIN_FILE;
                                echo -e "config_portable_module_filemanager_hovered_toolbar=false" >> $WEBMIN_FILEMIN_FILE;
                                echo -e "config_portable_module_filemanager_switch_users=true" >> $WEBMIN_FILEMIN_FILE;
                                echo -e "config_portable_module_filemanager_tree_exclude_on_first_load=true" >> $WEBMIN_FILEMIN_FILE;
                                echo -e "per_page=500" >> $WEBMIN_FILEMIN_FILE;
                                echo -e "columns=type,size,owner_user,permissions,last_mod_time" >> $WEBMIN_FILEMIN_FILE;
                                echo -e "config_portable_module_filemanager_records_for_server_pagination=1000" >> $WEBMIN_FILEMIN_FILE;
                                echo -e "config_portable_module_filemanager_editor_tabs_to_spaces=false" >> $WEBMIN_FILEMIN_FILE;
                                echo -e "config_portable_module_filemanager_editor_maximized=false" >> $WEBMIN_FILEMIN_FILE;
                                echo -e "config_portable_module_filemanager_hide_tree_view=true" >> $WEBMIN_FILEMIN_FILE;
                                echo -e "config_portable_module_filemanager_remember_tabs=false" >> $WEBMIN_FILEMIN_FILE;
                                echo -e "config_portable_module_filemanager_force_tar=true" >> $WEBMIN_FILEMIN_FILE;
                                echo -e "config_portable_module_filemanager_hide_actions=true" >> $WEBMIN_FILEMIN_FILE;
                                echo -e "config_portable_module_filemanager_move_to_trash=false" >> $WEBMIN_FILEMIN_FILE;
                                echo -e "config_portable_module_filemanager_default_sort=0" >> $WEBMIN_FILEMIN_FILE;
                                echo -e "config_portable_module_filemanager_hide_toolbar=false" >> $WEBMIN_FILEMIN_FILE;
                                echo -e "config_portable_module_filemanager_show_dot_files=true" >> $WEBMIN_FILEMIN_FILE;
                                #
                                #               Create /home/game-servers/.filemin/.bookmarks file ...
                                #
                                #                       /
                                #                       /backups
                                #                       /logs
                                #                       /wgasm
                                #                       /wgasm/backup-configs
                                #                       /wgasm/cron
                                #                       /wgasm/data
                                #                       /wgasm/include
                                #                       /wgasm/webmin
                                #
                                FILEMIN_BOOKMARKS_FOLDER="/home/game-servers/.filemin/";
                                mkdir $FILEMIN_BOOKMARKS_FOLDER 2> /dev/null > /dev/null;
                                FILEMIN_BOOKMARKS_FILE="$FILEMIN_BOOKMARKS_FOLDER/.bookmarks";
                                echo -e "/" > $FILEMIN_BOOKMARKS_FILE;
                                echo -e "/backups" >> $FILEMIN_BOOKMARKS_FILE;
                                echo -e "/logs" >> $FILEMIN_BOOKMARKS_FILE;
                                echo -e "/stencils" >> $FILEMIN_BOOKMARKS_FILE;
                                echo -e "/wgasm" >> $FILEMIN_BOOKMARKS_FILE;
                                echo -e "/wgasm/backup-configs" >> $FILEMIN_BOOKMARKS_FILE;
                                echo -e "/wgasm/cron" >> $FILEMIN_BOOKMARKS_FILE;
                                echo -e "/wgasm/data" >> $FILEMIN_BOOKMARKS_FILE;
                                echo -e "/wgasm/include" >> $FILEMIN_BOOKMARKS_FILE;
                                echo -e "/wgasm/webmin" >> $FILEMIN_BOOKMARKS_FILE;
                                chown -R game-servers:game-servers $FILEMIN_BOOKMARKS_FOLDER 2> /dev/null > /dev/null;
                                chown game-servers:game-servers $FILEMIN_BOOKMARKS_FILE 2> /dev/null > /dev/null;
                                #
                                #       Check for any errors thrown ...
                                #
                                if [[ $TEST_ERROR_CHECK == true ]]; then
                                                TEST_USER_EXISTS=false;
                                                MESSAGE="${ANSI_REDLT}ERROR:${ANSI_OFF}\n";
                                                MESSAGE+="${ANSI_WHITE}There was a problem setting-up \"game-servers\" as a Webmin user!${ANSI_OFF}\n";
                                                echo -e "\n$MESSAGE\n";
                                                exit 1;
                                        else
                                                #
                                                #       Skip creating the game-servers user since it already exists ...
                                                #
                                                MESSAGE="${ANSI_GREENLT}Update:${ANSI_OFF}\n";
                                                MESSAGE+="The Linux user \"game-servers\" should now be setup as a Webmin user also.";
                                                echo -e "\n$MESSAGE\n";
                                fi;
                                ;;
                        n|N|no|No|NO)
                                #
                                #       Do not install the Webmin, but warn about creating it ...
                                #
                                MESSAGE="${ANSI_YELLOW}WARNING:${ANSI_OFF}\n";
                                MESSAGE+="${ANSI_WHITE}Okay, whatever - if you want to make your life harder than it needs to be!${ANSI_OFF}\n";
                                echo -e "\n$MESSAGE\n";
                                ;;
                        *)
                                #
                                #       Something else happended, abort ...
                                #
                                MESSAGE="${ANSI_REDLT}ERROR:${ANSI_OFF}\n";
                                MESSAGE+="DUDE! I do not know what you mean? You were supposed to press \"Y\" or \"N\"!";
                                echo -e "\n$MESSAGE\n";
                                exit 1;
                                ;;
                esac;
        else
                MESSAGE="${ANSI_GREENLT}Update:${ANSI_OFF}\n";
                MESSAGE+="Skipping offering to setup \"game-servers\" in Webmin, because prerequisites not met.";
                echo -e "\n$MESSAGE\n";
fi;
#
#       Capture the time the scipt ended in date-serial form ...
#
SCRIPT_DATESERIAL_END=$(date +%s);
#
#       Calculate how-long the script was running ...
#
if [[ $SCRIPT_DATESERIAL_START ]]; then
                SCRIPT_DATESERIAL_DURATION=$(( $SCRIPT_DATESERIAL_END - $SCRIPT_DATESERIAL_START ));
    else
        SCRIPT_DATESERIAL_DURATION="";
fi;
#
#       Dispaly standard output ending message ...
#
if [[ $SCRIPT_DATESERIAL_DURATION ]]; then
                OUPUTCONTENT="End: ${ANSI_CYANLT}${0##*/}${ANSI_OFF}, at ${ANSI_WHITE}$(date) ($SCRIPT_DATESERIAL_DURATION secs)${ANSI_OFF}";
        else
                OUPUTCONTENT="End: ${ANSI_CYANLT}${0##*/}${ANSI_OFF}, at ${ANSI_WHITE}$(date)${ANSI_OFF}";
fi;
DIVIDERLINE="+-----------------------------------------------------------------------------+";
DIVIDERLINE_LENGTH=${#DIVIDERLINE};
OUPUTCONTENT_NOANSI=$(echo -e "$OUPUTCONTENT" | ansi2txt);
OUPUTCONTENT_LENGTH=${#OUPUTCONTENT_NOANSI};
PAD_LENGTH=$(( $DIVIDERLINE_LENGTH - $(( $OUPUTCONTENT_LENGTH + 4 )) ));
OUTPUTPAD=$(printf '%*s' $PAD_LENGTH);
PADDED_OUTPUT="| $OUPUTCONTENT$OUTPUTPAD |";
PADDED_OUTPUT_NOANSI="| $OUPUTCONTENT_NOANSI$OUTPUTPAD |";
if [ -t 1 ]; then
        echo -e "$DIVIDERLINE\n$PADDED_OUTPUT\n$DIVIDERLINE";
        else
                echo -e "$DIVIDERLINE\n$PADDED_OUTPUT_NOANSI\n$DIVIDERLINE";
fi;
#
#       ... thats all folks!
#

