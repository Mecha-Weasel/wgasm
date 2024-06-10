#!/bin/bash
#
#	----------------------------------------------------------------------------
#	Include file for processing and validate GAMEENGINE value
#	============================================================================
#	Created:       2024-05-21, by Weasel.SteamID.155@gMail.com        
#	Last modified: 2024-05-29, by Weasel.SteamID.155@gMail.com
#	----------------------------------------------------------------------------
#
#	USAGE NOTES:
#
#	Includes stuff such as ...
#	
#		Ensure gameengineid has been passed (not blank/empty)
#		Ensure gameengineid is lower-case alpha-numeric (plus "-") only.
#		Throw errors if any of that is not true.
#
#	----------------------------------------------------------------------------
#
#	If verbose is on, display progress notification ...
#
if [ "$SCRIPTS_VERBOSE" == true ]; then
	MESSAGE="[Processing include file: ${ANSI_CYANLT}include-gameengineid.inc${ANSI_OFF} (via ${ANSI_WHITE}${0##*/}${ANSI_OFF})${ANSI_OFF}]";
	if [ -t 1 ]; then
			echo -e "$MESSAGE";
            	else
			echo -e "$MESSAGE" | ansi2txt;
    fi;
fi;
#
#	Process GAMEENGINE:
#
#		Check that GAMEENGINE is only lower-case alpha-numeric ...
#
TEMP_GAMEENGINE=$(echo $GAMEENGINE | tr -cd [0-9a-z]-);
if [ "$TEMP_GAMEENGINE" != "$GAMEENGINE" ]; then
	MESSAGE="${ANSI_REDLT}$(figlet "Error:")${ANSI_OFF}\n";
	MESSAGE+="${ANSI_WHITE}Only lower-case alpha-numeric charaters (and "-") permitted in parameter: ${ANSI_REDLT}gameengine${ANSI_OFF}";
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
#	Check that GAMESERVERID has been provided ...
#
if ! [[ $TEMP_GAMEENGINE ]]; then
	MESSAGE="${ANSI_REDLT}$(figlet "Error:")${ANSI_OFF}\n";
	MESSAGE+="${ANSI_WHITE}Missing (required) parameter: ${ANSI_REDLT}gameengine${ANSI_OFF}";
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
#	If verbose is on, display some stuff ...
#
if [ "$SCRIPTS_VERBOSE" == true ]; then
    echo -e "Option:                       Value:";  
    echo -e "----------------------------  -----";
    echo -e "Verbose mode:                 $SCRIPTS_VERBOSE";
    echo -e "Game-Engine:                  $GAMEENGINE";
	echo -e "----------------------------  -----";
fi;
#
#	Validate game-engine is supported by this script ...
#
case $GAMEENGINE in
	"goldsrc")
		#
		#	If in verbose mode, display and log some extra stuff ...
		#
		if [ "$SCRIPTS_VERBOSE" == true ]; then
			MESSAGE="${ANSI_WHITE}Supported game-engine detected as: ${ANSI_GREENLT}$GAMEENGINE${ANSI_OFF}";
			echo -e "$MESSAGE";
			if [[ $SCRIPT_LOG_FILE ]]; then
				echo -e "$MESSAGE" | ansi2txt >> "$SCRIPT_LOG_FILE";
			fi;
        fi;
		;;
	"source")
		#
		#	If in verbose mode, display and log some extra stuff ...
		#
		if [ "$SCRIPTS_VERBOSE" == true ]; then
			MESSAGE="${ANSI_WHITE}Supported game-engine detected as: ${ANSI_GREENLT}$GAMEENGINE${ANSI_OFF}";
			echo -e "$MESSAGE";
			if [[ $SCRIPT_LOG_FILE ]]; then
				echo -e "$MESSAGE" | ansi2txt >> "$SCRIPT_LOG_FILE";
			fi;
		fi;
		;;
	"src2cs2")
		#
		#	If in verbose mode, display and log some extra stuff ...
		#
		if [ "$SCRIPTS_VERBOSE" == true ]; then
        	echo -e "${ANSI_WHITE}Supported game-engine detected as: ${ANSI_GREENLT}$GAMEENGINE${ANSI_OFF}";
            if [[ $SCRIPT_LOG_FILE ]]; then
				echo -e "Supported game-engine detected as: $GAMEENGINE" >> "$SCRIPT_LOG_FILE";
            fi;
		fi;
		;;
	*)
		MESSAGE="${ANSI_REDLT}$(figlet "Error:")${ANSI_OFF}\n";
		MESSAGE+="${ANSI_WHITE}Unsupported or unspecified game-engine: ${ANSI_REDLT}$GAMEENGINE${ANSI_OFF}";
		echo -e "$MESSAGE";
		if [[ $SCRIPT_LOG_FILE ]]; then
			echo -e "$MESSAGE" | ansi2txt >> "$SCRIPT_LOG_FILE";
		fi;
		#
		#	Display end of stuff ...
		#
		source $SCRIPTS_FOLDER/include/include-outputend.inc;
		exit 1;
		;;
esac;
#
#	If verbose is on, display progress notification ...
#
if [ "$SCRIPTS_VERBOSE" == true ]; then
	MESSAGE="[Finished include file: ${ANSI_CYANLT}include-gameengineid.inc${ANSI_OFF} (via ${ANSI_WHITE}${0##*/}${ANSI_OFF})${ANSI_OFF}]";
	if [ -t 1 ]; then
			echo -e "$MESSAGE";
            	else
			echo -e "$MESSAGE" | ansi2txt;
    fi;
fi;
#
#	... thats all folks!
#
