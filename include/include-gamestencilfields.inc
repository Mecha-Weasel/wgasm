#!/bin/bash
#
#	----------------------------------------------------------------------------
#	Include file for retrieving game-stencil information for a GAMESTENCILID
#	============================================================================
#	Created:       2024-05-26, by Weasel.SteamID.155@gMail.com        
#	Last modified: 2024-05-27, by Weasel.SteamID.155@gMail.com
#	----------------------------------------------------------------------------
#
#	USAGE NOTES:
#
#	Includes stuff such as ...
#	
#		Retrieving game-stencil information for a GAMESTENCILID
#
#	----------------------------------------------------------------------------
#
#	If verbose is on, display progress notification ...
#
if [ "$SCRIPTS_VERBOSE" == true ]; then
	MESSAGE="[Processing include file: ${ANSI_CYANLT}include-gamestencilfields.inc${ANSI_OFF} (via ${ANSI_WHITE}${0##*/}${ANSI_OFF})${ANSI_OFF}]";
	if [ -t 1 ]; then
			echo -e "$MESSAGE";
            	else
			echo -e "$MESSAGE" | ansi2txt;
    fi;
fi;
#
#	Validate that only one game-type record matches ...
#	
GAMESTENCILMATCHCOUNT=$(awk -v GAMESTENCILID="$GAMESTENCILID" '$1 == GAMESTENCILID' "$GAME_STENCILS_FILE"  | wc -l);
#
#	If no match is available,throw and error ...
#
if [ "$GAMESTENCILMATCHCOUNT" -lt "1" ]; then
	MESSAGE="${ANSI_REDLT}$(figlet "Error:")${ANSI_OFF}\n";
	MESSAGE+="${ANSI_WHITE}No match found for gamestencilid = ${ANSI_REDLT}$GAMESTENCILID${ANSI_OFF}";
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
if [ "$GAMESTENCILMATCHCOUNT" -gt "1" ]; then
	MESSAGE="${ANSI_REDLT}$(figlet "Error:")${ANSI_OFF}\n";
	MESSAGE+="${ANSI_WHITE}Multiple possible matches (${ANSI_REDLT}$GAMESTENCILMATCHCOUNT${ANSI_WHITE}) found for gamestencilid: ${ANSI_REDLT}$GAMESTENCILID${ANSI_OFF}";
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
#	Get a bunch of values from the GAME_STENCILS_FILE (tab-delimited) table ...
#
GAMESTENCILID=$(awk -v GAMESTENCILID="$GAMESTENCILID" '$1 == GAMESTENCILID' "$GAME_STENCILS_FILE" | head -n 1 | cut -f1);
GAMETYPEID=$(awk -v GAMESTENCILID="$GAMESTENCILID" '$1 == GAMESTENCILID' "$GAME_STENCILS_FILE" | head -n 1 | cut -f2);
STENCILFILE=$(awk -v GAMESTENCILID="$GAMESTENCILID" '$1 == GAMESTENCILID' "$GAME_STENCILS_FILE" | head -n 1 | cut -f3);
STENCILDESC=$(awk -v GAMESTENCILID="$GAMESTENCILID" '$1 == GAMESTENCILID' "$GAME_STENCILS_FILE" | head -n 1 | cut -f4);
STENCILCOMMENT=$(awk -v GAMESTENCILID="$GAMESTENCILID" '$1 == GAMESTENCILID' "$GAME_STENCILS_FILE" | head -n 1 | cut -f5);
#
#	If verbose is on, display some stuff ...
#
if [ "$SCRIPTS_VERBOSE" == true ]; then
	echo -e "Game-Stencil Information:";
	echo -e "========================";
    echo -e "ID for stencil-type:           $GAMESTENCILID";
	echo -e "ID for game-type:              $GAMETYPEID";
	echo -e "Stencil file-name:             $STENCILFILE";
	echo -e "Description (for game-type):   $STENCILDESC";
	echo -e "Comments (for game-type):      $STENCILCOMMENT";
fi;
#
#	If verbose is on, display progress notification ...
#
if [ "$SCRIPTS_VERBOSE" == true ]; then
	MESSAGE="[Finished include file: ${ANSI_CYANLT}include-gamestencilfields.inc${ANSI_OFF} (via ${ANSI_WHITE}${0##*/}${ANSI_OFF})${ANSI_OFF}]";
	if [ -t 1 ]; then
			echo -e "$MESSAGE";
            	else
			echo -e "$MESSAGE" | ansi2txt;
    fi;
fi;
#
#	... thats all folks!
#
