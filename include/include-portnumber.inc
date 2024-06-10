#!/bin/bash
#
#	----------------------------------------------------------------------------
#	Include file for processing and validate SERVERPORTNUMBER value
#	============================================================================
#	Created:       2024-05-19, by Weasel.SteamID.155@gMail.com        
#	Last modified: 2024-05-27, by Weasel.SteamID.155@gMail.com
#	----------------------------------------------------------------------------
#
#	USAGE NOTES:
#
#	Includes stuff such as ...
#	
#		Ensure gametypeid has been passed (not blank/empty)
#		Ensure gametypeid is numeric only.
#		Throw errors if any of that is not true.
#
#	----------------------------------------------------------------------------
#
#	If verbose is on, display progress notification ...
#
if [ "$SCRIPTS_VERBOSE" == true ]; then
	MESSAGE="[Processing include file: ${ANSI_CYANLT}include-portnumber.inc${ANSI_OFF} (via ${ANSI_WHITE}${0##*/}${ANSI_OFF})${ANSI_OFF}]";
	if [ -t 1 ]; then
			echo -e "$MESSAGE";
            	else
			echo -e "$MESSAGE" | ansi2txt;
    fi;
fi;
#
#	Process SERVERPORTNUMBER:
#
#		Check that SERVERPORTNUMBER is only numeric ...
#
TEMP_SERVERPORTNUMBER=$(echo $SERVERPORTNUMBER | tr -cd [0-9]);
if [ "$TEMP_SERVERPORTNUMBER" != "$SERVERPORTNUMBER" ]; then
	MESSAGE="${ANSI_REDLT}$(figlet "Error:")${ANSI_OFF}\n";
	MESSAGE+="${ANSI_WHITE}Only numeric charaters permitted in parameter: ${ANSI_REDLT}portnumber${ANSI_OFF}";
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
#	Check that PORTNUMBER has been provided ...
#
if ! [[ $TEMP_SERVERPORTNUMBER ]]; then
	MESSAGE="${ANSI_REDLT}$(figlet "Error:")${ANSI_OFF}\n";
	MESSAGE+="${ANSI_WHITE}Missing (required) parameter: ${ANSI_REDLT}portnumber${ANSI_OFF}";
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
    echo -e "Port-Number:                  $SERVERPORTNUMBER";
	echo -e "----------------------------  -----";
fi;
#
#	If verbose is on, display progress notification ...
#
if [ "$SCRIPTS_VERBOSE" == true ]; then
	MESSAGE="[Finished include file: ${ANSI_CYANLT}include-portnumber.inc${ANSI_OFF} (via ${ANSI_WHITE}${0##*/}${ANSI_OFF})${ANSI_OFF}]";
	if [ -t 1 ]; then
			echo -e "$MESSAGE";
            	else
			echo -e "$MESSAGE" | ansi2txt;
    fi;
fi;
#
#	... thats all folks!
#
