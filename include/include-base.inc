#!bin/bash
#
#	----------------------------------------------------------------------------
#	Base include file for related game-server mangement scripts
#	============================================================================
#	Created:       2024-05-19, by Weasel.SteamID.155@gMail.com
#	Last modified: 2024-06-09, by Weasel.SteamID.155@gMail.com
#	----------------------------------------------------------------------------
#
#	USAGE NOTES:
#
#	Includes stuff such as ...
#
#		ANSI color escape codes.
#		Reading values from the related configuration file (scripts.conf).
#		Determining various folders, etc.
#		Validate some of that stuff (make sure folders exist, etc.).
#		Throw errors if any of that is invalid.
#
#	----------------------------------------------------------------------------
#
#	Include the base script dependancies ...
#
source $SCRIPTS_FOLDER/include/include-ansi.inc;
#
#	Figure-out where the scripts folder is located ...
#
SCRIPTS_FOLDER="$( dirname -- "$( readlink -f -- "$0"; )"; )";
#
#	Figure-out where the config file is located ...
#
CONFIG_FILE="$SCRIPTS_FOLDER/config.txt";
#
#	Import some stuff from the config file ...
#
source $CONFIG_FILE;
DATA_FOLDER="$data_folder";
GAME_TYPES_FILE="$DATA_FOLDER/$game_types_file";
GAME_SERVERS_FILE="$DATA_FOLDER/$game_servers_file";
GAME_STENCILS_FILE="$DATA_FOLDER/$game_stencils_file";
BANNER_FILE="$DATA_FOLDER/$banner_file";
SERVERS_INSTALL_FOLDER="$servers_install_folder";
STEAMCMD_FOLDER="$steamcmd_folder";
LOGS_FOLDER="$logs_folder";
TEMP_FOLDER="$temp_folder";
TEMPINSTALL_FOLDER="$tempinstall_folder";
BACKUP_FOLDER="$backup_folder";
BACKUP_CONFIGS_FOLDER="$backup_configs_folder";
STENCILS_FOLDER="$stencils_folder";
STEAM_LOGIN_DEFAULT="$steam_login";
PURGE_TEMP_INSTALLS="$purge_temp_installs";
AUTOBACKUP_BY_CHECK="$autobackup_by_check";
AUTOEXECLUDE_BY_CHECK="$autoexclude_by_check";
MORON_DETECTION="$moron_detection";
MORON_ACKNOWLEDGEMENT="$i_acknowledge_that_i_am_a_moron";
SCRIPTS_VERBOSE="$scripts_verbose";
DISPLAY_BANNER="$display_banner";
#
#	If verbose is on, display progress notification ...
#
if [ "$SCRIPTS_VERBOSE" == true ]; then
	MESSAGE="[Processing include file: ${ANSI_CYANLT}include-base.inc${ANSI_OFF} (via ${ANSI_WHITE}${0##*/}${ANSI_OFF})${ANSI_OFF}]";
	if [ -t 1 ]; then
			echo -e "$MESSAGE";
            	else
			echo -e "$MESSAGE" | ansi2txt;
    fi;
fi;
#
#	Display warning if moron-detection is disabled (unless acknowledged in the config) ...
#
if ! [[ $MORON_ACKNOWLEDGEMENT == true ]]; then
	if ! [[ $MORON_DETECTION == true ]]; then
		MESSAGE="${ANSI_YELLOW}$(figlet "Warning:")${ANSI_OFF}\n";
		MESSAGE+="${ANSI_WHITE}The 'moron-detection' option is disabled!\n${ANSI_OFF}";
		MESSAGE+="${ANSI_WHITE}Proceed with extreme caution!${ANSI_OFF}";
		echo -e "$MESSAGE";
		if [[ $SCRIPT_LOG_FILE ]]; then
			echo -e "$MESSAGE" | ansi2txt >> "$SCRIPT_LOG_FILE";
		fi;
	fi;
fi
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
	echo "Sudo detection: $(sudo -n whoami)";
	MESSAGE="${ANSI_REDLT}$(figlet "Error:")${ANSI_OFF}\n";
	MESSAGE="${ANSI_YELLOW}$(figlet "!! MORON DETECTION !!")${ANSI_OFF}\n";
	MESSAGE+="${ANSI_WHITE}This script should NOT be run under a Linux user with 'sudo' access!${ANSI_OFF}\n";
	MESSAGE+="${ANSI_WHITE}You should NEVER run any game-server under a privileged account!${ANSI_OFF}";
	echo -e "$MESSAGE";
	exit 1;
fi;
#
#	Validate some stuff ...
#
#		Validate that the scripts configuration file exists ...
#
if [ ! -f $CONFIG_FILE ]; then
	MESSAGE="${ANSI_REDLT}$(figlet "Error:")${ANSI_OFF}\n";
	MESSAGE+="${ANSI_WHITE}Configuration file NOT found at: ${ANSI_REDLT}$CONFIG_FILE${ANSI_OFF}";
	echo -e "$MESSAGE";
	if [[ $SCRIPT_LOG_FILE ]]; then
		echo -e "$MESSAGE" | ansi2txt >> "$SCRIPT_LOG_FILE";
	fi;
	#
	#	Display end of stuff ...
	#
	source $SCRIPTS_FOLDER/include/include-outputend.inc;
	exit 1;
fi;
#
#		Validate that the game-types file exists ...
#
if [ ! -f $GAME_TYPES_FILE ]; then
	MESSAGE="${ANSI_REDLT}$(figlet "Error:")${ANSI_OFF}\n";
	MESSAGE+="${ANSI_WHITE}Game-types data table NOT found at: ${ANSI_REDLT}$GAME_TYPES_FILE${ANSI_OFF}";
	echo -e "$MESSAGE";
	if [[ $SCRIPT_LOG_FILE ]]; then
		echo -e "$MESSAGE" | ansi2txt >> "$SCRIPT_LOG_FILE";
	fi;
	#
	#	Display end of stuff ...
	#
	source $SCRIPTS_FOLDER/include/include-outputend.inc;
	exit 1;
fi;
#
#		Validate that the game-servers file exists ...
#
if [ ! -f $GAME_SERVERS_FILE ]; then
	MESSAGE="${ANSI_REDLT}$(figlet "Error:")${ANSI_OFF}\n";
	MESSAGE+="${ANSI_WHITE}Game-servers data table NOT found at: ${ANSI_REDLT}$GAME_SERVERS_FILE${ANSI_OFF}";
	echo -e "$MESSAGE";
	if [[ $SCRIPT_LOG_FILE ]]; then
		echo -e "$MESSAGE" | ansi2txt >> "$SCRIPT_LOG_FILE";
	fi;
	#
	#	Display end of stuff ...
	#
	source $SCRIPTS_FOLDER/include/include-outputend.inc;
	exit 1;
fi;
#
#		Validate that the game-stencils file exists ...
#
if [ ! -f $GAME_STENCILS_FILE ]; then
	MESSAGE="${ANSI_REDLT}$(figlet "Error:")${ANSI_OFF}\n";
	MESSAGE+="${ANSI_WHITE}Game-stencil data file NOT found at: ${ANSI_REDLT}$GAME_STENCILS_FILE${ANSI_OFF}";
	echo -e "$MESSAGE";
	if [[ $SCRIPT_LOG_FILE ]]; then
		echo -e "$MESSAGE" | ansi2txt >> "$SCRIPT_LOG_FILE";
	fi;
	#
	#	Display end of stuff ...
	#
	source $SCRIPTS_FOLDER/include/include-outputend.inc;
	exit 1;
fi;
#
#		Validate that the banner file exists ...
#
if [ ! -f $BANNER_FILE ]; then
	MESSAGE="${ANSI_REDLT}$(figlet "Error:")${ANSI_OFF}\n";
	MESSAGE+="${ANSI_WHITE}Banner file NOT found at: ${ANSI_REDLT}$BANNER_FILE${ANSI_OFF}";
	echo -e "$MESSAGE";
	if [[ $SCRIPT_LOG_FILE ]]; then
		echo -e "$MESSAGE" | ansi2txt >> "$SCRIPT_LOG_FILE";
	fi;
	#
	#	Display end of stuff ...
	#
	source $SCRIPTS_FOLDER/include/include-outputend.inc;
	exit 1;
fi;
#
#		Validate that SteamCMD exists ...
#
if [ ! -f $STEAMCMD_FOLDER/steamcmd.sh ]; then
	MESSAGE="${ANSI_YELLOW}$(figlet "WARNING:")${ANSI_OFF}\n";
	MESSAGE+="${ANSI_WHITE}SteamCMD NOT found at: ${ANSI_YELLOW}$STEAMCMD_FOLDER/steamcmd.sh${ANSI_WHITE},Install\n";
	MESSAGE+="${ANSI_WHITE}SteamCMD, and update ${ANSI_YELLOW}$CONFIG_FILE${ANSI_WHITE} appropriately.${ANSI_OFF}";
	echo -e "$MESSAGE";
	if [[ $SCRIPT_LOG_FILE ]]; then
		echo -e "$MESSAGE" | ansi2txt >> "$SCRIPT_LOG_FILE";
	fi;
	#
	#	Display end of stuff ...
	#
	source $SCRIPTS_FOLDER/include/include-outputend.inc;
fi;
#
#		Validate that game-servers install folder exists ...
#
#			Attempt to create it, to make sure it exists ...
#
mkdir $SERVERS_INSTALL_FOLDER > /dev/null 2>&1;
#
#			If it still does not exist, throw an error ...
#
if [ ! -d $SERVERS_INSTALL_FOLDER ]; then
	MESSAGE="${ANSI_REDLT}$(figlet "Error:")${ANSI_OFF}\n";
	MESSAGE+="${ANSI_WHITE}Folder to install servers inside of NOT found at: ${ANSI_REDLT}$SERVERS_INSTALL_FOLDER${ANSI_OFF}";
	echo -e "$MESSAGE";
	if [[ $SCRIPT_LOG_FILE ]]; then
		echo -e "$MESSAGE" | ansi2txt >> "$SCRIPT_LOG_FILE";
	fi;
	#
	#	Display end of stuff ...
	#
	source $SCRIPTS_FOLDER/include/include-outputend.inc;
	exit 1;
fi;
#
#		Validate that the temp working folder exists ...
#
#			Attempt to create it, to make sure it exists ...
#
mkdir $TEMP_FOLDER > /dev/null 2>&1;
#
#			If it still does not exist, throw an error ...
#
if [ ! -d $TEMP_FOLDER ]; then
	MESSAGE="${ANSI_REDLT}$(figlet "Error:")${ANSI_OFF}\n";
	MESSAGE+="${ANSI_WHITE}Temporary working folder NOT found at: ${ANSI_REDLT}$TEMP_FOLDER${ANSI_OFF}";
	echo -e "$MESSAGE";
	if [[ $SCRIPT_LOG_FILE ]]; then
		echo -e "$MESSAGE" | ansi2txt >> "$SCRIPT_LOG_FILE";
	fi;
	#
	#	Display end of stuff ...
	#
	source $SCRIPTS_FOLDER/include/include-outputend.inc;
	exit 1;
fi;
#
#		Validate that the temp install folder exists ...
#
#			Attempt to create it, to make sure it exists ...
#
mkdir $TEMPINSTALL_FOLDER > /dev/null 2>&1;
#
#			If it still does not exist, throw an error ...
#
if [ ! -d $TEMPINSTALL_FOLDER ]; then
	MESSAGE="${ANSI_REDLT}$(figlet "Error:")${ANSI_OFF}\n";
	MESSAGE+="${ANSI_WHITE}Temporary install folder NOT found at: ${ANSI_REDLT}$TEMPINSTALL_FOLDER${ANSI_OFF}";
	echo -e "$MESSAGE";
	if [[ $SCRIPT_LOG_FILE ]]; then
		echo -e "$MESSAGE" | ansi2txt >> "$SCRIPT_LOG_FILE";
	fi;
	#
	#	Display end of stuff ...
	#
	source $SCRIPTS_FOLDER/include/include-outputend.inc;
	exit 1;
fi;
#
#		Validate that the logs folder exists ...
#
#			Attempt to create it, to make sure it exists ...
#
mkdir $LOGS_FOLDER > /dev/null 2>&1;
#
#			If it still does not exist, throw an error ...
#
if [ ! -d $LOGS_FOLDER ]; then
	MESSAGE="${ANSI_REDLT}$(figlet "Error:")${ANSI_OFF}\n";
	MESSAGE+="${ANSI_WHITE}Logs folder folder NOT found at: ${ANSI_REDLT}$LOGS_FOLDER${ANSI_OFF}";
	echo -e "$MESSAGE";
	if [[ $SCRIPT_LOG_FILE ]]; then
		echo -e "$MESSAGE" | ansi2txt >> "$SCRIPT_LOG_FILE";
	fi;
	#
	#	Display end of stuff ...
	#
	source $SCRIPTS_FOLDER/include/include-outputend.inc;
	exit 1;
fi;
#
#		Validate that the backups folder exists ...
#
#			Attempt to create it, to make sure it exists ...
#
mkdir $BACKUP_FOLDER > /dev/null 2>&1;
#
#			If it still does not exist, throw an error ...
#
if [ ! -d $BACKUP_FOLDER ]; then
	MESSAGE="${ANSI_REDLT}$(figlet "Error:")${ANSI_OFF}\n";
	MESSAGE+="${ANSI_WHITE}Backups folder folder NOT found at: ${ANSI_REDLT}$BACKUP_FOLDER${ANSI_OFF}";
	echo -e "$MESSAGE";
	if [[ $SCRIPT_LOG_FILE ]]; then
		echo -e "$MESSAGE" | ansi2txt >> "$SCRIPT_LOG_FILE";
	fi;
	#
	#	Display end of stuff ...
	#
	source $SCRIPTS_FOLDER/include/include-outputend.inc;
	exit 1;
fi;
#
#		Validate that the backups configuration folder exists ...
#
#			Attempt to create it, to make sure it exists ...
#
mkdir $BACKUP_CONFIGS_FOLDER > /dev/null 2>&1;
#
#			If it still does not exist, throw an error ...
#
if [ ! -d $BACKUP_CONFIGS_FOLDER ]; then
	MESSAGE="${ANSI_REDLT}$(figlet "Error:")${ANSI_OFF}\n";
	MESSAGE+="${ANSI_WHITE}Backups configuration folder folder NOT found at: ${ANSI_REDLT}$BACKUP_CONFIGS_FOLDER${ANSI_OFF}";
	echo -e "$MESSAGE";
	if [[ $SCRIPT_LOG_FILE ]]; then
		echo -e "$MESSAGE" | ansi2txt >> "$SCRIPT_LOG_FILE";
	fi;
	#
	#	Display end of stuff ...
	#
	source $SCRIPTS_FOLDER/include/include-outputend.inc;
	exit 1;
fi;
#
#		Validate that the stencils folder exists ...
#
#			Attempt to create it, to make sure it exists ...
#
mkdir $STENCILS_FOLDER > /dev/null 2>&1;
#
#			If it still does not exist, throw an error ...
#
if [ ! -d $STENCILS_FOLDER ]; then
	MESSAGE="${ANSI_REDLT}$(figlet "Error:")${ANSI_OFF}\n";
	MESSAGE+="${ANSI_WHITE}Stencils folder folder NOT found at: ${ANSI_REDLT}$STENCILS_FOLDER${ANSI_OFF}";
	echo -e "$MESSAGE";
	if [[ $SCRIPT_LOG_FILE ]]; then
		echo -e "$MESSAGE" | ansi2txt >> "$SCRIPT_LOG_FILE";
	fi;
	#
	#	Display end of stuff ...
	#
	source $SCRIPTS_FOLDER/include/include-outputend.inc;
	exit 1;
fi;
#
#		Validate the Steam login ...
#
#			If no Steam login is specified, use anonymous ...
#
if ! [[ $STEAM_LOGIN_DEFAULT ]]; then
	STEAM_LOGIN_DEFAULT="anonymous";
fi;
#
#			Verify the Steam login does not contain problematic charaters ...
#
STEAM_LOGIN_TEMP=$(echo $STEAM_LOGIN_DEFAULT | tr -cd ' '[0-9A-Za-z]@.-);
if [ "$STEAM_LOGIN_DEFAULT" != "$STEAM_LOGIN_TEMP" ]; then
	MESSAGE="${ANSI_REDLT}$(figlet "Error:")${ANSI_OFF}\n";
	MESSAGE+="${ANSI_WHITE}Characters detected in Steam login information not supported (by these scripts)!${ANSI_OFF}";
	echo -e "$MESSAGE";
	if [[ $SCRIPT_LOG_FILE ]]; then
		echo -e "$MESSAGE" | ansi2txt >> "$SCRIPT_LOG_FILE";
	fi;
	#
	#	Display end of stuff ...
	#
	source $SCRIPTS_FOLDER/include/include-outputend.inc;
    exit 1;
fi;
#
#			Conditionally hide the Steam login information ...
#
if [ "$STEAM_LOGIN_DEFAULT" == "anonymous" ]; then
		STEAM_LOGIN_DEFAULT_SHOW="anonymous";
    else
   		STEAM_LOGIN_DEFAULT_SHOW="${ANSI_RED}HIDDEN${ANSI_OFF}";
        STEAM_LOGIN_USE_SHOW="${ANSI_RED}HIDDEN${ANSI_OFF}";
fi;
#
#			Set Steam login to actually use, to (initially) be this one ...
#
STEAM_LOGIN_USE=$STEAM_LOGIN_DEFAULT
#
#	Attempt to determine the computer's (local) IP address ...
#
SERVER_LOCAL_IP_ADDRESS=$(hostname --all-ip-addresses | cut -d' ' -f1);
#
#	Attempt to determine the computer's (public) IP address ...
#
SERVER_PUBLIC_IP_ADDRESS=$(dig +short txt o-o.myaddr.l.google.com @ns1.google.com | awk -F'"' '{print $2}');
#
#	If verbose is on, display some stuff ...
#
if [ "$SCRIPTS_VERBOSE" == true ]; then
	echo -e "Option:                       Value:";
	echo -e "----------------------------  -----";
	echo -e "Scripts folder:               $SCRIPTS_FOLDER";
	echo -e "Config file:                  $CONFIG_FILE";
	echo -e "Display banner:               $DISPLAY_BANNER";
	echo -e "Verbose mode:                 $SCRIPTS_VERBOSE";
    echo -e "Moron detection:              $MORON_DETECTION";
    echo -e "Purge 'exclude' installs:     $PURGE_TEMP_INSTALLS";
    echo -e "Auto-backup by 'check':       $AUTOBACKUP_BY_CHECK";
    echo -e "Auto-exclude by 'check':      $AUTOEXECLUDE_BY_CHECK";
	echo -e "Game-servers install folder:  $SERVERS_INSTALL_FOLDER";
	echo -e "Script-logging folder:        $LOGS_FOLDER";
	echo -e "Temporary working folder:     $TEMP_FOLDER";
	echo -e "Temporary install folder:     $TEMPINSTALL_FOLDER";
	echo -e "Data folder:                  $DATA_FOLDER";
	echo -e "Game-types data file:         $GAME_TYPES_FILE";
	echo -e "Game-servers data file:       $GAME_SERVERS_FILE";
    echo -e "Game-stencils data file:      $GAME_STENCILS_FILE";
    echo -e "Banner file:                  $BANNER_FILE";
	echo -e "Backup files folder:          $BACKUP_FOLDER";
	echo -e "Backup configs folder:        $BACKUP_CONFIGS_FOLDER";
	echo -e "Stencils folder:              $STENCILS_FOLDER";
	echo -e "SteamCMD folder:              $STEAMCMD_FOLDER";
	echo -e "Default Steam login:          $STEAM_LOGIN_DEFAULT_SHOW";
    if [[ $SERVER_LOCAL_IP_ADDRESS ]]; then
			echo -e "Apparent (local) IP Address:  $SERVER_LOCAL_IP_ADDRESS";
        else
        	echo -e "Apparent (local) IP Address:  {unknown}";
	fi;
	if [[ $SERVER_PUBLIC_IP_ADDRESS ]]; then
			echo -e "Apparent (public) IP Address: $SERVER_PUBLIC_IP_ADDRESS";
        else
        	echo -e "Apparent (public) IP Address: {unknown}";
	fi;
fi;
#
#	Display banner, if enabled (in the config file) ...
#
source $SCRIPTS_FOLDER/include/include-banner.inc;
#
#	If verbose is on, display progress notification ...
#
if [ "$SCRIPTS_VERBOSE" == true ]; then
	MESSAGE="[Finished include file: ${ANSI_CYANLT}include-base.inc${ANSI_OFF} (via ${ANSI_WHITE}${0##*/}${ANSI_OFF})${ANSI_OFF}]";
	if [ -t 1 ]; then
			echo -e "$MESSAGE";
            	else
			echo -e "$MESSAGE" | ansi2txt;
    fi;
fi;
#
#	... thats all folks!
#
