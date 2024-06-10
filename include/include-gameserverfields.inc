#!/bin/bash
#
#	----------------------------------------------------------------------------
#	Include file for retrieving game-server information for a GAMESERVERID
#	============================================================================
#	Created:       2024-05-19, by Weasel.SteamID.155@gMail.com        
#	Last modified: 2024-05-27, by Weasel.SteamID.155@gMail.com
#	----------------------------------------------------------------------------
#
#	USAGE NOTES:
#
#	Includes stuff such as ...
#	
#		Retrieving game-type information for a GAMESERVERID
#
#	----------------------------------------------------------------------------
#
#	If verbose is on, display progress notification ...
#
if [ "$SCRIPTS_VERBOSE" == true ]; then
	MESSAGE="[Processing include file: ${ANSI_CYANLT}include-gameserverfields.inc${ANSI_OFF} (via ${ANSI_WHITE}${0##*/}${ANSI_OFF}).${ANSI_OFF}]";
	if [ -t 1 ]; then
			echo -e "$MESSAGE";
            	else
			echo -e "$MESSAGE" | ansi2txt;
    fi;
fi;
#		
#	Validate that only one game-server record matches ...
#	
GAMESERVERMATCHCOUNT=$(awk -v GAMESERVERID="$GAMESERVERID" '$1 == GAMESERVERID' "$GAME_SERVERS_FILE"  | wc -l);
#
#	If no match is available,throw and error ...
#
if [ "$GAMESERVERMATCHCOUNT" -lt "1" ]; then
	MESSAGE="${ANSI_REDLT}$(figlet "Error:")${ANSI_OFF}\n";
	MESSAGE+="${ANSI_WHITE}No match found for gameserverid = ${ANSI_REDLT}$GAMESERVERID${ANSI_OFF}";
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
if [ "$GAMESERVERMATCHCOUNT" -gt "1" ]; then
	MESSAGE="${ANSI_REDLT}$(figlet "Error:")${ANSI_OFF}\n";
	MESSAGE+="${ANSI_WHITE}Multiple possible matches (${ANSI_REDLT}$GAMESERVERMATCHCOUNT${ANSI_WHITE}) found for gameserverid: ${ANSI_REDLT}$GAMESERVERID${ANSI_OFF}";
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
#	Get a bunch of values from the GAME_SERVERS_FILE (tab-delimited) table ...
#
GAMESERVERID=$(awk -v GAMESERVERID="$GAMESERVERID" '$1 == GAMESERVERID' "$GAME_SERVERS_FILE" | head -n 1 | cut -f1);
GAMETYPEID=$(awk -v GAMESERVERID="$GAMESERVERID" '$1 == GAMESERVERID' "$GAME_SERVERS_FILE" | head -n 1 | cut -f2);
SERVERPORTNUMBER=$(awk -v GAMESERVERID="$GAMESERVERID" '$1 == GAMESERVERID' "$GAME_SERVERS_FILE" | head -n 1 | cut -f3);
SERVERVERBOSE=$(awk -v GAMESERVERID="$GAMESERVERID" '$1 == GAMESERVERID' "$GAME_SERVERS_FILE" | head -n 1 | cut -f4);
SERVERSTALE=$(awk -v GAMESERVERID="$GAMESERVERID" '$1 == GAMESERVERID' "$GAME_SERVERS_FILE" | head -n 1 | cut -f5);
SERVERTHRESHOLD=$(awk -v GAMESERVERID="$GAMESERVERID" '$1 == GAMESERVERID' "$GAME_SERVERS_FILE" | head -n 1 | cut -f6);
SERVERDESC=$(awk -v GAMESERVERID="$GAMESERVERID" '$1 == GAMESERVERID' "$GAME_SERVERS_FILE" | head -n 1 | cut -f7);
SERVERCOMMENT=$(awk -v GAMESERVERID="$GAMESERVERID" '$1 == GAMESERVERID' "$GAME_SERVERS_FILE" | head -n 1 | cut -f8);
#
#	Set verbose option to true if it is set for server ..
#
if [ "$SERVERVERBOSE" == true ]; then
	SCRIPTS_VERBOSE=true;
fi;
#
#	If verbose is on, display some stuff ...
#
if [ "$SCRIPTS_VERBOSE" == true ]; then
	echo "Game-Server Information:";
	echo "=======================";
	echo "ID for game-server:                       $GAMESERVERID";
	echo "ID for game-type:                         $GAMETYPEID";
	echo "Game-server port number:                  $SERVERPORTNUMBER";
	echo "Use verbose output?:                      $SERVERVERBOSE";
	echo "Monitor for stale (GNU screen) logging?:  $SERVERSTALE";
	echo "Monitoring threshold (in seconds):        $SERVERTHRESHOLD";
	echo "Description (server):                     $SERVERDESC";
	echo "Comment (server):                         $SERVERCOMMENT";
fi;
#
#	If verbose is on, display progress notification ...
#
if [ "$SCRIPTS_VERBOSE" == true ]; then
	MESSAGE="[Finished include file: ${ANSI_CYANLT}include-gameserverfields.inc${ANSI_OFF} (via ${ANSI_WHITE}${0##*/}${ANSI_OFF})${ANSI_OFF}]";
	if [ -t 1 ]; then
			echo -e "$MESSAGE";
            	else
			echo -e "$MESSAGE" | ansi2txt;
    fi;
fi;
#
#	... thats all folks!
#
