#!/bin/bash
#
#	----------------------------------------------------------------------------
#	Display information about a game-server (long/detailed version)
#	============================================================================
#	Created:       2024-05-17, by Weasel.SteamID.155@gMail.com        
#	Last modified: 2024-05-27, by Weasel.SteamID.155@gMail.com
#	----------------------------------------------------------------------------
#
#	Purpose:
#	
#		Displays all information associated for specific game-server.
#		Displays all information about the game-servers specific game-type.
#
#	Usage / command-line parameters:
#	
#		gameserverid
#	
#			The game-server identifier for the game-server information to display.
#		
#			Example:
#		
#				./game-server-detail.sh gameserverid;
#
#	----------------------------------------------------------------------------
#	
#	Figure-out where the scripts folder is located ...
#
SCRIPTS_FOLDER="$( dirname -- "$( readlink -f -- "$0"; )"; )";
#
#	Include the base script dependancies ...
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
#	Grab command-line parameter (which should be a GAMESERVERID) ...
#	
GAMESERVERID=$1;
#	
#	Process/validate parameter GAMESERVERID ...
#
source $SCRIPTS_FOLDER/include/include-gameserverid.inc;
#
#	Retrive data from game-servers table for specific GAMESERVERID ...
#	
source $SCRIPTS_FOLDER/include/include-gameserverfields.inc;
#
#	Display the information gathered ...
#
echo -e "Game-Server Information:";
echo -e "=======================";
echo -e "ID for game-server:                       $GAMESERVERID";
echo -e "ID for game-type:                         $GAMETYPEID";
echo -e "Game-server port number:                  $SERVERPORTNUMBER";
echo -e "Use verbose output?:                      $SERVERVERBOSE";
echo -e "Monitor for stale (GNU screen) logging?:  $SERVERSTALE";
echo -e "Monitoring threshold (in seconds):        $SERVERTHRESHOLD";
echo -e "Description (server):                     $SERVERDESC";
echo -e "Comment (server):                         $SERVERCOMMENT";
#	
#	Process/validate parameter GAMETYPEID ...
#
source $SCRIPTS_FOLDER/include/include-gametypeid.inc;
#
#	Retrive data from game-types table for specific GAMETYPEID ...
#	
source $SCRIPTS_FOLDER/include/include-gametypefields.inc;
#
#	Display the information gathered ...
#
echo -e "";
echo -e "Game-Type Information:";
echo -e "=====================";
echo -e "ID for game-type:              $GAMETYPEID";
echo -e "Game-Engine:                   $GAMEENGINE";
echo -e "Steam login (default):         $STEAM_LOGIN_DEFAULT_SHOW";
echo -e "Steam login (this game-type):  $STEAM_LOGIN_SERVER_SHOW"; 
echo -e "Steam login (to use):          $STEAM_LOGIN_USE_SHOW"; 
echo -e "AppID (for installation):      $APPIDINSTALL";
echo -e "AppID (for update check):      $APPIDCHECK";
echo -e "SteamCMD mod-type (if any):    $STEAMCMDMOD";
echo -e "SteamCMD (extra) options:      $STEAMCMDOPTS";
echo -e "Mod Sub-Folder:                $MODSUBFOLDER";
echo -e "Restart warning (text):        $WARNSTOPTEXT";
echo -e "Restart warning (audio):       $WARNSTOPAUDIO";
echo -e "Update warning (text):         $WARNUPDATETEXT";
echo -e "Update warning (audio):        $WARNUPDATEAUDIO";
echo -e "Description (for game-type):   $TYPEDESC";
echo -e "Comments (for game-type):      $TYPECOMMENT";
#
#	Find game-stencil records matching game-type ...
#	
GAMESTENCILMATCHCOUNT=$(awk -v GAMETYPEID="$GAMETYPEID" '$2 == GAMETYPEID' "$GAME_STENCILS_FILE"  | wc -l);
#
#	If no match is available,throw and error ...
#
if [ "$GAMESTENCILMATCHCOUNT" -lt "1" ]; then
		MESSAGE="${ANSI_WHITE}FYI: No game-stencils currently configured for this game type: ${ANSI_YELLOW}$GAMETYPEID${ANSI_OFF}";
		echo -e "$MESSAGE";
		if [[ $SCRIPT_LOG_FILE ]]; then
			echo -e "$MESSAGE" | ansi2txt >> "$SCRIPT_LOG_FILE";
		fi;      
    else
		echo -e "";
		echo -e "Related Game-Stencils:";
		echo -e "=====================";
		echo -e "Matching stencils count: $GAMESTENCILMATCHCOUNT";
		echo -e "";
		{ head -n 1 "$GAME_STENCILS_FILE" | cut -f1-7; awk -v GAMETYPEID="$GAMETYPEID" '($2 == GAMETYPEID)' "$GAME_STENCILS_FILE" | cut -f1-5; } | column -t -s $'\t' -o" ";
fi;
#
#	Display end of stuff ...
#
source $SCRIPTS_FOLDER/include/include-outputend.inc;
#
#	... thats all folks!
#
