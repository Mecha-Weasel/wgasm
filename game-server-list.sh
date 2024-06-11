#!/bin/bash
#
#	----------------------------------------------------------------------------
#	Display a list of all defined game-servers
#	============================================================================
#	Created:       2024-05-18, by Weasel.SteamID.155@gMail.com        
#	Last modified: 2024-05-27, by Weasel.SteamID.155@gMail.com
#	----------------------------------------------------------------------------
#
#	Purpose:
#	
#		Displays a list of game-servers from the related TSV file.
#
#	Usage / command-line parameters:
#	
#		{none}
#	
#			No command-line parameters are required or supported.
#		
#			Example:
#		
#				./game-server-list.sh;
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
#	Find game-server records ...
#
GAMESERVERMATCHCOUNT=$(awk -v GAMESERVERID="gameserverid" '!($1 == GAMESERVERID)' "$GAME_SERVERS_FILE" | wc -l);
#
#	If no match is available,throw and error ...
#
if [ "$GAMESERVERMATCHCOUNT" -lt "1" ]; then
		MESSAGE="${ANSI_YELLOW}$(figlet "Warning:")${ANSI_OFF}\n";
		MESSAGE+="${ANSI_WHITE}FYI: No game-servers currently configured.${ANSI_OFF}";
		echo -e "$MESSAGE";
		if [[ $SCRIPT_LOG_FILE ]]; then
			echo -e "$MESSAGE" | ansi2txt >> "$SCRIPT_LOG_FILE";
		fi;
    else
		echo "Game-Servers:";
		echo "============";
		echo "Record count: $GAMESERVERMATCHCOUNT";
		echo "";
        cat "$GAME_SERVERS_FILE" | cut -f1-7 | column -t -s $'\t' -o" ";
fi;
#
#	Display end of stuff ...
#
source $SCRIPTS_FOLDER/include/include-outputend.inc;
#
#	... thats all folks!
#
