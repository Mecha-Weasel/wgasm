#!/bin/bash
#
#	----------------------------------------------------------------------------
#	Script to install wGASM ...
#	============================================================================
#	Created:       2024-05-31, by Weasel.SteamID.155@gMail.com
#	Last modified: 2024-06-13, by Weasel.SteamID.155@gMail.com
#	----------------------------------------------------------------------------
#	__        ___    ____  _   _ ___ _   _  ____
#	\ \      / / \  |  _ \| \ | |_ _| \ | |/ ___|_
#	 \ \ /\ / / _ \ | |_) |  \| || ||  \| | |  _(_)
#	  \ V  V / ___ \|  _ <| |\  || || |\  | |_| |_
#	   \_/\_/_/   \_\_| \_\_| \_|___|_| \_|\____(_)
#
#	NOTE:  This script and most scripts of the "wgasm" project,
#	----   should NOT be run under the "root" Linux user, or any Linux
#	       user with similar 'sudo' privileges!  Instead, they should be
#	       run under some other "un-privileged" user.  All the examples
#	       assume this Linux user is named "game-servers".  This may be
#	       changed to something else - although doing so will break the
#	       related Webmin "Custom-Commands" setup (if you use that).
#
#	----------------------------------------------------------------------------
#
#		Figure-out where the scripts folder is located ...
#
SCRIPTS_FOLDER="$( dirname -- "$( readlink -f -- "$0"; )"; )";
#
#		Define some ANSI color escape sequences ...
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
#	Capture the time the scipt started in date-serial form ...
#
SCRIPT_DATESERIAL_START=$(date +%s);
#
#	Display standard output beginning message ...
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
#	Check for Nike-Mode ("Just Do-It!") ...
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
#	Ensure the user is NOT 'root' ...
#
if [ "$(whoami)" = "root" ]; then
	MESSAGE="${ANSI_REDLT}$(figlet "Error:")${ANSI_OFF}\n";
	MESSAGE="${ANSI_YELLOW}$(figlet "!! MORON DETECTION !!")${ANSI_OFF}\n";
	MESSAGE+="${ANSI_WHITE}This script should NOT be run under a the Linux user with 'root'!${ANSI_OFF}\n";
	MESSAGE+="${ANSI_WHITE}You should NEVER run any game-server under a privileged account!${ANSI_OFF}";
	echo -e "$MESSAGE";
	exit 1;
fi;
#
#	Ensure the user does NOT have 'sudo' privileges ...
#
if [ "$(sudo -n whoami 2> /dev/null)" = "root" ]; then
	MESSAGE="${ANSI_REDLT}$(figlet "Error:")${ANSI_OFF}\n";
	MESSAGE="${ANSI_YELLOW}$(figlet "!! MORON DETECTION !!")${ANSI_OFF}\n";
	MESSAGE+="${ANSI_WHITE}This script should NOT be run under a Linux user with 'sudo' access!${ANSI_OFF}\n";
	MESSAGE+="${ANSI_WHITE}You should NEVER run any game-server under a privileged account!${ANSI_OFF}";
	echo -e "$MESSAGE";
	exit 1;
fi;
#
#	Testing that various required commands/utilities work now ...
#
#		Define some stuff ..
#
TEST_ERROR_CHECK=false;
#
#		Actually test each command (tesing parameters vary by command) ...
#
echo -e "\n${ANSI_BLUELT}TESTING:${ANSI_WHITE} Testing that various required commands/utilities work now (Many probaby worked before)${ANSI_OFF} ...";
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
echo -e -n "Testing 'uncompress':  ";uncompress --help &> /dev/null && echo -e "${ANSI_GREENLT}Pass.${ANSI_OFF}" || { echo -e "${ANSI_REDLT}FAIL!${ANSI_OFF}"; TEST_ERROR_CHECK=true; };
echo -e -n "Testing 'bzip2':       ";bzip2 --help &> /dev/null && echo -e "${ANSI_GREENLT}Pass.${ANSI_OFF}" || { echo -e "${ANSI_REDLT}FAIL!${ANSI_OFF}"; TEST_ERROR_CHECK=true; };
echo -e -n "Testing 'dialog':      ";dialog --help &> /dev/null && echo -e "${ANSI_GREENLT}Pass.${ANSI_OFF}" || { echo -e "${ANSI_REDLT}FAIL!${ANSI_OFF}"; TEST_ERROR_CHECK=true; };
echo -e -n "Testing 'dos2unix':    ";echo -e "test" | dos2unix &> /dev/null && echo -e "${ANSI_GREENLT}Pass.${ANSI_OFF}" || { echo -e "${ANSI_REDLT}FAIL!${ANSI_OFF}"; TEST_ERROR_CHECK=true; };
echo -e -n "Testing 'ansi2txt':    ";echo -e "test" | ansi2txt &> /dev/null && echo -e "${ANSI_GREENLT}Pass.${ANSI_OFF}" || { echo -e "${ANSI_REDLT}FAIL!${ANSI_OFF}"; TEST_ERROR_CHECK=true; };
echo -e -n "Testing 'figlet':      ";figlet "test" &> /dev/null && echo -e "${ANSI_GREENLT}Pass.${ANSI_OFF}" || { echo -e "${ANSI_REDLT}FAIL!${ANSI_OFF}"; TEST_ERROR_CHECK=true; };
echo -e -n "Testing 'nicstat':     ";nicstat &> /dev/null && echo -e "${ANSI_GREENLT}Pass.${ANSI_OFF}" || { echo -e "${ANSI_REDLT}FAIL!${ANSI_OFF}"; TEST_ERROR_CHECK=true; };
echo -e -n "Testing 'netstat':     ";netstat --help &> /dev/null && echo -e "${ANSI_GREENLT}Pass.${ANSI_OFF}" || { echo -e "${ANSI_REDLT}FAIL!${ANSI_OFF}"; TEST_ERROR_CHECK=true; };
echo -e -n "Testing 'dig':         ";dig -h &> /dev/null && echo -e "${ANSI_GREENLT}Pass.${ANSI_OFF}" || { echo -e "${ANSI_REDLT}FAIL!${ANSI_OFF}"; TEST_ERROR_CHECK=true; };
#
#	If any of thsoe checks failed, display an error messsage ...
#
if [[ $TEST_ERROR_CHECK == true ]]; then
		MESSAGE="${ANSI_REDLT}ERROR:${ANSI_OFF}\n";
		MESSAGE+="${ANSI_WHITE}One or more prerequisite commands or utilities are missing!${ANSI_OFF}\n";
		MESSAGE+="${ANSI_WHITE}You MUST resolve these errors by intalling the appropiate${ANSI_OFF}\n";
		MESSAGE+="${ANSI_WHITE}packages for failed tests before proceeding!${ANSI_OFF}";
		echo -e "\n$MESSAGE\n";
		exit 1;
	else
		MESSAGE="${ANSI_GREENLT}PASSED:${ANSI_OFF}\n";
		MESSAGE+="${ANSI_WHITE}Everything looks good (so far)!${ANSI_OFF}";
		echo -e "\n$MESSAGE\n";
fi;
#
#	Download and extract latest scripts archive from GitHub ...
#
#		New, "git clone" version ...
#
cd $HOME 2> /dev/null > /dev/null;
mkdir $HOME/temp 2> /dev/null > /dev/null;
rm -Rf $HOME/temp/temp-git 2> /dev/null > /dev/null;
mkdir $HOME/temp/temp-git 2> /dev/null > /dev/null;
mkdir $HOME/wgasm 2> /dev/null > /dev/null;
git clone https://github.com/Mecha-Weasel/wgasm temp/temp-git;
if [[ "$?" -gt 0 ]]; then
	TEST_ERROR_CHECK=true;
fi;
echo -e "Size of 'temp-git' content:         $(du -h -s $HOME/temp/temp-git;)";
echo -e "Stats for 'temp-git' content:       $(tree $HOME/temp/temp-git | tail -n 1)";
rm -Rf $HOME/temp/temp-git/.git 2>&1 > /dev/null;
cp -Rf $HOME/temp/temp-git/* $HOME/wgasm/ 2>&1 > /dev/null;
rm -Rf $HOME/temp/temp-git 2>&1 > /dev/null;
chmod +x $HOME/wgasm/*.sh;
chmod +x $HOME/wgasm/cron/*.sh;
echo -e "Size of 'wgasm' folder:    $(du -h -s $HOME/wgasm;)";
echo -e "Stats for 'wgasm' folder:  $(tree $HOME/wgasm | tail -n 1)";
#
#	If any of checks failed, display an error messsage ...
#
if [[ $TEST_ERROR_CHECK == true ]]; then
		MESSAGE="${ANSI_REDLT}ERROR:${ANSI_OFF}\n";
		MESSAGE+="${ANSI_WHITE}Something went wrong!${ANSI_OFF}";
		echo -e "\n$MESSAGE\n";
		exit 1;
	else
		MESSAGE="${ANSI_GREENLT}PASSED:${ANSI_OFF}\n";
		MESSAGE+="${ANSI_WHITE}Everything looks good (so far)!${ANSI_OFF}";
		echo -e "\n$MESSAGE\n";
fi;
#
#	If the default config file does not yet exist,
#	use a copy of the example config file.  But,
#	do NOT overwrite any existing config file ...
#
echo -e "Deploying config ...";
if [ ! -f $HOME/wgasm/config.txt ]; then
	cp -f $HOME/wgasm/config-example.txt $HOME/wgasm/config.txt;
fi;
#
#	If the default banner file does not yet exist,
#	use a copy of the example banner file.  But,
#	do NOT overwrite any existing banner file ...
#
echo -e "Deploying banner ...";
if [ ! -f $HOME/wgasm/data/banner.txt ]; then
	cp -f $HOME/wgasm/data/banner-example.txt $HOME/wgasm/data/banner.txt;
fi;
#
#	If the various data "tables" do not exist yet,
#	use copies of the example tables.  But,
#	do NOT overwrite any existing tables ...
#
echo -e "Deploying data tables ...";
if [ ! -f $HOME/wgasm/data/game-types.tsv ]; then
	cp -f $HOME/wgasm/data/game-types-example.tsv $HOME/wgasm/data/game-types.tsv;
fi;
if [ ! -f $HOME/wgasm/data/game-stencils.tsv ]; then
	cp -f $HOME/wgasm/data/game-stencils-example.tsv $HOME/wgasm/data/game-stencils.tsv;
fi;
if [ ! -f $HOME/wgasm/data/game-servers.tsv ]; then
	cp -f $HOME/wgasm/data/game-servers-example.tsv $HOME/wgasm/data/game-servers.tsv;
fi;
#
#	If the recommended "webmin" lists do not exist yet,
#	use copies of the example webmin lists.  But,
#	do NOT overwrite any existing webmin lists ...
#
echo -e "Deploying Webmin lists ...";
if [ ! -f $HOME/wgasm/webmin/list-backups-all.txt ]; then
	cp -f $HOME/wgasm/webmin/list-backups-all-example.txt $HOME/wgasm/webmin/list-backups-all.txt;
fi;
if [ ! -f $HOME/wgasm/webmin/list-servers-all.txt ]; then
	cp -f $HOME/wgasm/webmin/list-servers-all-example.txt $HOME/wgasm/webmin/list-servers-all.txt;
fi;
#
#	If the recommended "cron" sripts do not exist yet,
#	use copies of the example cron scripts.  But,
#	do NOT overwrite any existing cron scripts ...
#
echo -e "Deploying cron scripts ...";
if [ ! -f $HOME/wgasm/cron/games-weekly.sh ]; then
	cp -f $HOME/wgasm/cron/games-weekly-example.sh $HOME/wgasm/cron/games-weekly.sh;
fi;
if [ ! -f $HOME/wgasm/cron/games-daily.sh ]; then
	cp -f $HOME/wgasm/cron/games-daily-example.sh $HOME/wgasm/cron/games-daily.sh;
fi;
if [ ! -f $HOME/wgasm/cron/games-hourly.sh ]; then
	cp -f $HOME/wgasm/cron/games-hourly-example.sh $HOME/wgasm/cron/games-hourly.sh;
fi;
if [ ! -f $HOME/wgasm/cron/games-often.sh ]; then
	cp -f $HOME/wgasm/cron/games-often-example.sh $HOME/wgasm/cron/games-often.sh;
fi;
#
#	If any of checks failed, display an error messsage ...
#
if [[ $TEST_ERROR_CHECK == true ]]; then
		MESSAGE="${ANSI_REDLT}ERROR:${ANSI_OFF}\n";
		MESSAGE+="${ANSI_WHITE}Something went wrong!${ANSI_OFF}";
		echo -e "\n$MESSAGE\n";
		exit 1;
	else
		MESSAGE="${ANSI_GREENLT}PASSED:${ANSI_OFF}\n";
		MESSAGE+="${ANSI_WHITE}Everything looks good (so far)!${ANSI_OFF}";
		echo -e "\n$MESSAGE\n";
fi;
#
#	Prompt if SteamCMD should be installed now ...
#
if [[ $NIKE_MODE == true ]]; then
		PROMPT_INPUT="nike";
	else
		read -p "Would you like to install \"SteamCMD\" now? (y/n)" PROMPT_INPUT;
fi;
case $PROMPT_INPUT in
	y|Y|yes|Yes|YES|nike)
		#
		#	Install SteamCMD ...
		#
		echo -e "";
		echo -e "Running the SteamCMD installation script ...";
		cd $HOME/wgasm;
		#chmod +x install-steamcmd.sh;
		./install-steamcmd.sh;
		if [[ "$?" -gt 0 ]]; then
			TEST_ERROR_CHECK=true;
		fi;
		;;
	n|N|no|No|NO)
		#
		#	Do not install SteamCMD, but warn about creating it ...
		#
		MESSAGE="${ANSI_YELLOW}WARNING:${ANSI_OFF}\n";
		MESSAGE+="${ANSI_WHITE}Okay, whatever - just remember to install it later yourself! Remember that:${ANSI_OFF}\n";
		MESSAGE+="${ANSI_WHITE}1) SteamCMD is expected to be in ${ANSI_YELLOW}$HOME/steamcmd${ANSI_WHITE} by default.${ANSI_OFF}\n";
		MESSAGE+="${ANSI_WHITE}2) You can override that with a setting in the ${ANSI_YELLOW}$HOME/wgasm/config.txt${ANSI_WHITE} file.${ANSI_OFF}";
		echo -e "\n$MESSAGE\n";
		;;
	*)
		#
		#	Something else happended, abort ...
		#
		MESSAGE="${ANSI_REDLT}ERROR:${ANSI_OFF}\n";
		MESSAGE+="DUDE! I do not know what you mean? You were supposed to press \"Y\" or \"N\"!";
		echo -e "\n$MESSAGE\n";
		exit 1;
		;;
esac;
#
#	If any of checks failed, display an error messsage ...
#
if [[ $TEST_ERROR_CHECK == true ]]; then
		MESSAGE="${ANSI_REDLT}ERROR:${ANSI_OFF}\n";
		MESSAGE+="${ANSI_WHITE}Something went wrong!${ANSI_OFF}";
		echo -e "\n$MESSAGE\n";
		exit 1;
	else
		MESSAGE="${ANSI_GREENLT}PASSED:${ANSI_OFF}\n";
		MESSAGE+="${ANSI_WHITE}Everything looks good (so far)!${ANSI_OFF}";
		echo -e "\n$MESSAGE\n";
fi;
#
#	Prompt if Stencils should be installed now ...
#
if [[ $NIKE_MODE == true ]]; then
		PROMPT_INPUT="nike";
	else
		read -p "Would you like to install example \"Stencils\" now? (y/n)" PROMPT_INPUT;
fi;
case $PROMPT_INPUT in
	y|Y|yes|Yes|YES|nike)
		#
		#	Download and install example Stencils ...
		#
		echo -e "";
		echo -e "Running the Stencils installation script ...";
		cd $HOME/wgasm;
		#chmod +x install-stencils.sh;
		./install-stencils.sh;
		if [[ "$?" -gt 0 ]]; then
			TEST_ERROR_CHECK=true;
		fi;
		;;
	n|N|no|No|NO)
		#
		#	Do not install Stencils, but warn about creating it ...
		#
		MESSAGE="${ANSI_YELLOW}WARNING:${ANSI_OFF}\n";
		MESSAGE+="${ANSI_WHITE}Okay, whatever - just remember to install it later yourself! Remember that:\n${ANSI_OFF}";
		MESSAGE+="${ANSI_WHITE}1) Stencils are expected to be in ${ANSI_YELLOW}$HOME/stencils${ANSI_WHITE} by default.${ANSI_OFF}\n";
		MESSAGE+="${ANSI_WHITE}2) You can override that with a setting in the ${ANSI_YELLOW}$HOME/wgasm/config.txt${ANSI_WHITE} file.${ANSI_OFF}";
		echo -e "\n$MESSAGE\n";
		;;
	*)
		#
		#	Something else happended, abort ...
		#
		MESSAGE="${ANSI_REDLT}ERROR:${ANSI_OFF}\n";
		MESSAGE+="DUDE! I do not know what you mean? You were supposed to press \"Y\" or \"N\"!";
		echo -e "\n$MESSAGE\n";
		exit 1;
		;;
esac;
#
#	If any of checks failed, display an error messsage ...
#
if [[ $TEST_ERROR_CHECK == true ]]; then
		MESSAGE="${ANSI_REDLT}ERROR:${ANSI_OFF}\n";
		MESSAGE+="${ANSI_WHITE}Something went wrong!${ANSI_OFF}";
		echo -e "\n$MESSAGE\n";
		exit 1;
	else
		MESSAGE="${ANSI_GREENLT}PASSED:${ANSI_OFF}\n";
		MESSAGE+="${ANSI_WHITE}Everything looks good (so far)!${ANSI_OFF}";
		echo -e "\n$MESSAGE\n";
fi;
#
#	Capture the time the scipt ended in date-serial form ...
#
SCRIPT_DATESERIAL_END=$(date +%s);
#
#	Calculate how-long the script was running ...
#
if [[ $SCRIPT_DATESERIAL_START ]]; then
		SCRIPT_DATESERIAL_DURATION=$(( $SCRIPT_DATESERIAL_END - $SCRIPT_DATESERIAL_START ));
    else
    	SCRIPT_DATESERIAL_DURATION="";
fi;
#
#	Display standard output ending message ...
#
if [[ $SCRIPT_DATESERIAL_DURATION ]]; then
		OUPUTCONTENT="End: ${ANSI_CYANLT}${0##*/}${ANSI_OFF}, at ${ANSI_WHITE}$(date) ($SCRIPT_DATESERIAL_DURATION s)${ANSI_OFF}";
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
#	... thats all folks!
#
