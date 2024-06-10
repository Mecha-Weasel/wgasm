#!/bin/bash
#
#	----------------------------------------------------------------------------
#	Test / development script
#	============================================================================
#	Created:       2024-05-18, by Weasel.SteamID.155@gMail.com        
#	Last modified: 2024-05-31, by Weasel.SteamID.155@gMail.com
#	----------------------------------------------------------------------------
#
#		Figure-out where the scripts folder is located ...
#
SCRIPTS_FOLDER="$( dirname -- "$( readlink -f -- "$0"; )"; )";
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
#
#	Display end of stuff ...
#
source $SCRIPTS_FOLDER/include/include-outputend.inc;
#
#	... thats all folks!
#
