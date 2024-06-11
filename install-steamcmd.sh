#!/bin/bash
#
#	----------------------------------------------------------------------------
#	Install SteamCMD (using folder specified in the config file)
#	============================================================================
#	Created:       2024-05-31, by Weasel.SteamID.155@gMail.com
#	Last modified: 2024-06-03, by Weasel.SteamID.155@gMail.com
#	----------------------------------------------------------------------------
#
#		Figure-out where the scripts folder is located ...
#
SCRIPTS_FOLDER="$( dirname -- "$( readlink -f -- "$0"; )"; )";
#
#	Include the ANSI escape code definitions ...
#
source $SCRIPTS_FOLDER/include/include-ansi.inc;
#
#	Innclude the base script dependancies ...
#
source $SCRIPTS_FOLDER/include/include-base.inc;
#
#	NO script log file ...
#
SCRIPT_LOG_FILE="";
#
#	Display start of stuff ...
#
source $SCRIPTS_FOLDER/include/include-outputbegin.inc;
#
#	Dsplay some stuff ...
#
echo -e "Important configuration options:";
echo -e "";
echo -e "Option:                       Value:";
echo -e "----------------------------  -----";
echo -e "Scripts folder:               $SCRIPTS_FOLDER";
echo -e "Config file:                  $CONFIG_FILE";
echo -e "Moron detection:              $MORON_DETECTION";
echo -e "SteamCMD folder:              $STEAMCMD_FOLDER";
echo -e "Default Steam login:          $STEAM_LOGIN_DEFAULT_SHOW";
#
#	Install SteamCMD ...
#
echo -e "Installing SteamCMD ...";
mkdir $STEAMCMD_FOLDER 2> /dev/null > /dev/null;
cd $STEAMCMD_FOLDER 2> /dev/null > /dev/null;
wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz;
if [[ "$?" -gt 0 ]]; then
	TEST_ERROR_CHECK=true;
fi;
tar -zxvf steamcmd_linux.tar.gz 2> /dev/null > /dev/null;
if [[ "$?" -gt 0 ]]; then
	TEST_ERROR_CHECK=true;
fi;
chmod +x steamcmd.sh 2> /dev/null > /dev/null;
./steamcmd.sh login $STEAM_LOGIN_DEFAULT +quit;
if [[ "$?" -gt 0 ]]; then
	TEST_ERROR_CHECK=true;
fi;
mkdir ~/.steam 2> /dev/null > /dev/null;
mkdir ~/.steam/sdk32 2> /dev/null > /dev/null;
mkdir ~/.steam/sdk64 2> /dev/null > /dev/null;
ln -s ~/steamcmd/linux32/steamclient.so ~/.steam/sdk32/steamclient.so 2> /dev/null > /dev/null;
ln -s ~/steamcmd/linux64/steamclient.so ~/.steam/sdk64/steamclient.so 2> /dev/null > /dev/null;
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
#	Display end of stuff ...
#
source $SCRIPTS_FOLDER/include/include-outputend.inc;
#
#	... thats all folks!
#
