#!/bin/bash
#
#	----------------------------------------------------------------------------
#	Dispaly information about a game-type (long/detailed version)
#	============================================================================
#	Created:       2024-05-17, by Weasel.SteamID.155@gMail.com        
#	Last modified: 2024-05-27, by Weasel.SteamID.155@gMail.com
#	----------------------------------------------------------------------------
#
#	Purpose:
#	
#		Displays all information associated for a specific game-type.
#		Display list of servers matching that specific game-type.
#
#	Usage / command-line parameters:
#	
#		gametypeid
#	
#			The game-type identifier for the game-type information to display.
#		
#			Example:
#		
#				./game-type-detail.sh gametypeid;
#
#	----------------------------------------------------------------------------
#	
#	Figure-out where the scripts folder is located ...
#
SCRIPTS_FOLDER="$( dirname -- "$( readlink -f -- "$0"; )"; )";
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
#	Grab command-line parameter (which should be a GAMETYPEID) ...
#	
GAMETYPEID=$1;
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
#	Find game-server records matching game-type ...
#	
GAMESERVERMATCHCOUNT=$(awk -v GAMETYPEID="$GAMETYPEID" '$2 == GAMETYPEID' "$GAME_SERVERS_FILE"  | wc -l);
#
#	If no match is available,throw and error ...
#
if [ "$GAMESERVERMATCHCOUNT" -lt "1" ]; then
		MESSAGE="${ANSI_YELLOW}$(figlet "Warning:")${ANSI_OFF}\n";
		MESSAGE+="${ANSI_WHITE}FYI: No game-servers currently configured for this game type: ${ANSI_WHITE}$GAMETYPEID${ANSI_OFF}";
		echo -e "$MESSAGE";
		if [[ $SCRIPT_LOG_FILE ]]; then
			echo -e "$MESSAGE" | ansi2txt >> "$SCRIPT_LOG_FILE";
		fi;
    else
		echo -e "";
		echo -e "Related Game-Servers:";
		echo -e "====================";
		echo -e "Matching servers count: $GAMESERVERMATCHCOUNT";
		echo -e "";
		{ head -n 1 "$GAME_SERVERS_FILE" | cut -f1-7; awk -v GAMETYPEID="$GAMETYPEID" '($2 == GAMETYPEID)' "$GAME_SERVERS_FILE" | cut -f1-7; } | column -t -s $'\t' -o" ";
fi;
#
#	Find game-stencil records matching game-type ...
#	
GAMESTENCILMATCHCOUNT=$(awk -v GAMETYPEID="$GAMETYPEID" '$2 == GAMETYPEID' "$GAME_STENCILS_FILE"  | wc -l);
#
#	If no match is available,throw and error ...
#
if [ "$GAMESTENCILMATCHCOUNT" -lt "1" ]; then
		MESSAGE="${ANSI_YELLOW}$(figlet "Warning:")${ANSI_OFF}\n";
		MESSAGE+="${ANSI_WHITE}FYI: No game-stencils currently configured for this game type: ${ANSI_WHITE}$GAMETYPEID${ANSI_OFF}";
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
