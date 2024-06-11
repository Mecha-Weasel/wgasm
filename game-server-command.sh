#!/bin/bash
#
#	----------------------------------------------------------------------------
#	Send commands to a disconnected background 'screen' processes
#	============================================================================
#	Created:       2024-03-31, by Weasel.SteamID.155@gMail.com         
#	Last modified: 2024-05-31, by Weasel.SteamID.155@gMail.com
#	----------------------------------------------------------------------------
#
#	Purpose:
#	
#		Stop (an already started in the background) game-server.
#		DOES stop any instance with the same name already running in the background.
#		Accepts multiple gameserverids in the same command-line.
#
#	Usage / command-line parameters:
#	
#		gameserverid
#	
#			The game-server identifier(s) for the game-server(s) to affed.
#			
#		command
#	
#			The command to send to the game-server
#		
#			Example:
#		
#				./game-server-command.sh gameserverid1 "whatever console commands here";
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
#	Process command-line parameters ...
#
#		Check how many parameters were passed ...
#
GAMESERVERIDCOUNT="$#";
if [ $GAMESERVERIDCOUNT -lt 2 ]; then
	MESSAGE="${ANSI_REDLT}$(figlet "Error:")${ANSI_OFF}\n";
	MESSAGE+="${ANSI_WHITE}At least two (2) parameters must be specified!${ANSI_OFF}";
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
#	Set gameserverid to current parameter ...
#
GAMESERVERID=$1;
#
#	Determine script log file ...
#
SCRIPT_LOG_FILE="$LOGS_FOLDER/$GAMESERVERID-command.log";
#
#	Display start of stuff ...
#
source $SCRIPTS_FOLDER/include/include-outputbegin.inc;
#	
#	Process/validate parameter GAMESERVERID ...
#
source $SCRIPTS_FOLDER/include/include-gameserverid.inc;
#
#	Retrive data from game-types table for specific GAMESERVERID ...
#	
source $SCRIPTS_FOLDER/include/include-gameserverfields.inc;
#
#	Display what server is being operated-upon ...
#
echo "Game-server selected: [ID=$GAMESERVERID] $SERVERDESC";
echo "Game-server selected: [ID=$GAMESERVERID] $SERVERDESC" >> "$SCRIPT_LOG_FILE";
#
#	Ensure the game-server is already started under GNU 'screen'
#
SCREEN_LIST_CAPTURE=$(screen -ls | grep $GAMESERVERID);
if ! [[ $SCREEN_LIST_CAPTURE == *"$GAMESERVERID"* ]]; then
	MESSAGE="${ANSI_REDLT}$(figlet "Error:")${ANSI_OFF}\n";
	MESSAGE+="${ANSI_WHITE}The game-server you selected is NOT currently running under GNU 'screen'!${ANSI_OFF}";
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
#	Determine the command to send to the server ...
#
ALL_PARAMETERS="$@";
ALL_PARAMETERS_LENGTH=${#ALL_PARAMETERS};
SERVER_PARAMETER_LENGTH=${#GAMESERVERID};
COMMAND_PARAMETER_START=$(( SERVER_PARAMETER_LENGTH + 1 ));
COMMAND_PARAMETER_LENGTH=$((ALL_PARAMETERS_LENGTH - (( SERVER_PARAMETER_LENGTH + 1 )) ));
COMMAND_TO_SEND=${ALL_PARAMETERS:COMMAND_PARAMETER_START:COMMAND_PARAMETER_LENGTH};
#
#	If in verbose mode, display and log some extra stuff ...
#
if [ "$SCRIPTS_VERBOSE" == true ]; then
	echo "ALL_PARAMETERS:            $ALL_PARAMETERS";
	echo "ALL_PARAMETERS_LENGTH:     $ALL_PARAMETERS_LENGTH"
	echo "SERVER_PARAMETER_LENGTH:   $SERVER_PARAMETER_LENGTH"
	echo "COMMAND_PARAMETER_START:   $COMMAND_PARAMETER_START";
	echo "COMMAND_PARAMETER_LENGTH:  $COMMAND_PARAMETER_LENGTH";
	echo "COMMAND_TO_SEND:           $COMMAND_TO_SEND";
fi;
#
#	Display and log command to send to game-server ...
#
echo "Command to send: ...";
echo "Command to send: ..." >> "$SCRIPT_LOG_FILE";
echo "$COMMAND_TO_SEND";
echo "$COMMAND_TO_SEND" >> "$SCRIPT_LOG_FILE";
#
#	Sending command to game-server ...
#
echo "Sending command ...";
echo "Sending command ..." >> "$SCRIPT_LOG_FILE";
screen -S $GAMESERVERID -p 0 -X stuff "$COMMAND_TO_SEND$(printf \\r)" 1>/dev/null 2>&1;
#
#	Display end of stuff ...
#
source $SCRIPTS_FOLDER/include/include-outputend.inc;
#
#	... thats all folks!
#
