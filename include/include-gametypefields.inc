#!/bin/bash
#
#	----------------------------------------------------------------------------
#	Include file for retrieving game-type information for a GAMETYPEID
#	============================================================================
#	Created:       2024-05-19, by Weasel.SteamID.155@gMail.com        
#	Last modified: 2024-05-27, by Weasel.SteamID.155@gMail.com
#	----------------------------------------------------------------------------
#
#	USAGE NOTES:
#
#	Includes stuff such as ...
#	
#		Retrieving game-type information for a GAMETYPEID
#
#	----------------------------------------------------------------------------
#
#	If verbose is on, display progress notification ...
#
if [ "$SCRIPTS_VERBOSE" == true ]; then
	MESSAGE="[Processing include file: ${ANSI_CYANLT}include-gametypefields.inc${ANSI_OFF} (via ${ANSI_WHITE}${0##*/}${ANSI_OFF})${ANSI_OFF}]";
	if [ -t 1 ]; then
			echo -e "$MESSAGE";
            	else
			echo -e "$MESSAGE" | ansi2txt;
    fi;
fi;
#
#	Validate that only one game-type record matches ...
#	
GAMETYPEMATCHCOUNT=$(awk -v GAMETYPEID="$GAMETYPEID" '$1 == GAMETYPEID' "$GAME_TYPES_FILE"  | wc -l);
#
#	If no match is available,throw and error ...
#
if [ "$GAMETYPEMATCHCOUNT" -lt "1" ]; then
	MESSAGE="${ANSI_REDLT}$(figlet "Error:")${ANSI_OFF}\n";
	MESSAGE+="${ANSI_WHITE}No match found for gametypeid = ${ANSI_REDLT}$GAMETYPEID${ANSI_OFF}";
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
#	If more that one match is returned,throw and error ...
#	(NOTE: In theory, this should not happen, but ... just in case)
#
if [ "$GAMETYPEMATCHCOUNT" -gt "1" ]; then
	MESSAGE="${ANSI_REDLT}$(figlet "Error:")${ANSI_OFF}\n";
	MESSAGE+="${ANSI_WHITE}Multiple possible matches (${ANSI_REDLT}$GAMETYPEMATCHCOUNT${ANSI_WHITE}) found for gametypeid: ${ANSI_REDLT}$GAMETYPEID${ANSI_OFF}";
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
#	Get a bunch of values from the GAME_TYPES_FILE (tab-delimited) table ...
#
GAMETYPEID=$(awk -v GAMETYPEID="$GAMETYPEID" '$1 == GAMETYPEID' "$GAME_TYPES_FILE" | head -n 1 | cut -f1);
GAMEENGINE=$(awk -v GAMETYPEID="$GAMETYPEID" '$1 == GAMETYPEID' "$GAME_TYPES_FILE" | head -n 1 | cut -f2);
STEAM_LOGIN_SERVER=$(awk -v GAMETYPEID="$GAMETYPEID" '$1 == GAMETYPEID' "$GAME_TYPES_FILE" | head -n 1 | cut -f3);
APPIDINSTALL=$(awk -v GAMETYPEID="$GAMETYPEID" '$1 == GAMETYPEID' "$GAME_TYPES_FILE" | head -n 1 | cut -f4);
APPIDCHECK=$(awk -v GAMETYPEID="$GAMETYPEID" '$1 == GAMETYPEID' "$GAME_TYPES_FILE" | head -n 1 | cut -f5);
STEAMCMDMOD=$(awk -v GAMETYPEID="$GAMETYPEID" '$1 == GAMETYPEID' "$GAME_TYPES_FILE" | head -n 1 | cut -f6);
STEAMCMDOPTS=$(awk -v GAMETYPEID="$GAMETYPEID" '$1 == GAMETYPEID' "$GAME_TYPES_FILE" | head -n 1 | cut -f7);
MODSUBFOLDER=$(awk -v GAMETYPEID="$GAMETYPEID" '$1 == GAMETYPEID' "$GAME_TYPES_FILE" | head -n 1 | cut -f8);
WARNSTOPTEXT=$(awk -v GAMETYPEID="$GAMETYPEID" '$1 == GAMETYPEID' "$GAME_TYPES_FILE" | head -n 1 | cut -f9);
WARNSTOPAUDIO=$(awk -v GAMETYPEID="$GAMETYPEID" '$1 == GAMETYPEID' "$GAME_TYPES_FILE" | head -n 1 | cut -f10);
WARNUPDATETEXT=$(awk -v GAMETYPEID="$GAMETYPEID" '$1 == GAMETYPEID' "$GAME_TYPES_FILE" | head -n 1 | cut -f11);
WARNUPDATEAUDIO=$(awk -v GAMETYPEID="$GAMETYPEID" '$1 == GAMETYPEID' "$GAME_TYPES_FILE" | head -n 1 | cut -f12);
TYPEDESC=$(awk -v GAMETYPEID="$GAMETYPEID" '$1 == GAMETYPEID' "$GAME_TYPES_FILE" | head -n 1 | cut -f13);
TYPECOMMENT=$(awk -v GAMETYPEID="$GAMETYPEID" '$1 == GAMETYPEID' "$GAME_TYPES_FILE" | head -n 1 | cut -f14);
#
#		Validate the Steam login ...
#
#			Verify the Steam login does not contain problematic charaters ...
#
STEAM_LOGIN_TEMP=$(echo $STEAM_LOGIN_SERVER | tr -cd ' '[0-9A-Za-z]@.-);
if [ "$STEAM_LOGIN_SERVER" != "$STEAM_LOGIN_TEMP" ]; then
	MESSAGE="${ANSI_REDLT}$(figlet "Error:")${ANSI_OFF}\n";
	MESSAGE+="${ANSI_WHITE}Characters detected in game-type-specific Steam login information not supported (by these scripts)!${ANSI_OFF}";
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
#			If no Steam login is specified, use the system-wide default from the config file ...
#
if ! [[ $STEAM_LOGIN_SERVER ]]; then
		STEAM_LOGIN_SERVER=$STEAM_LOGIN_DEFAULT;
		STEAM_LOGIN_USE=$STEAM_LOGIN_DEFAULT;
	else
        STEAM_LOGIN_USE=$STEAM_LOGIN_SERVER;
fi;
#
#			Conditionally hide the game-type-specific Steam login information ...
#
if [ "$STEAM_LOGIN_SERVER" == "anonymous" ]; then
		STEAM_LOGIN_SERVER_SHOW="anonymous";
    else
   		STEAM_LOGIN_SERVER_SHOW="${ANSI_RED}HIDDEN${ANSI_OFF}"; 
        STEAM_LOGIN_USE_SHOW="${ANSI_RED}HIDDEN${ANSI_OFF}"; 
fi;
#
#			Conditionally hide the Steam login information to actually use ...
#
if [ "$STEAM_LOGIN_USE" == "anonymous" ]; then
		STEAM_LOGIN_USE_SHOW="anonymous";
    else
        STEAM_LOGIN_USE_SHOW="${ANSI_RED}HIDDEN${ANSI_OFF}"; 
fi;
#
#	If verbose is on, display some stuff ...
#
if [ "$SCRIPTS_VERBOSE" == true ]; then
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
fi;
#
#	If verbose is on, display progress notification ...
#
if [ "$SCRIPTS_VERBOSE" == true ]; then
	MESSAGE="[Finished include file: ${ANSI_CYANLT}include-gametypefields.inc${ANSI_OFF} (via ${ANSI_WHITE}${0##*/}${ANSI_OFF})${ANSI_OFF}]";
	if [ -t 1 ]; then
			echo -e "$MESSAGE";
            	else
			echo -e "$MESSAGE" | ansi2txt;
    fi;
fi;
#
#	... thats all folks!
#
