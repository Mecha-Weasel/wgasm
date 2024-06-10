#!/bin/bash
#
#	----------------------------------------------------------------------------
#	Stop game-servers running as disconnected background 'screen' processes
#	============================================================================
#	Created:       2024-03-06, by Weasel.SteamID.155@gMail.com         
#	Last modified: 2024-05-27, by Weasel.SteamID.155@gMail.com
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
#			The game-server identifier(s) for the game-server(s) to stop.
#		
#			Example:
#		
#				./game-server-stop.sh gameserverid1 gameserverid2 gameserveridN;
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
if [ $GAMESERVERIDCOUNT -lt 1 ]; then
	MESSAGE="${ANSI_REDLT}$(figlet "Error:")${ANSI_OFF}\n";
	MESSAGE+="${ANSI_WHITE}At least one (1) gameserverid must be specified!${ANSI_OFF}";
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
#	Loop throuch each gameserverid and process it ...
#
while [ $# -gt 0 ]; do
	#
    #	Set gameserverid to current parameter ...
    #
	GAMESERVERID=$1;
    #
	#	Determine script log file ...
	#
	SCRIPT_LOG_FILE="$LOGS_FOLDER/$GAMESERVERID-stop.log";
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
	#	Process/validate parameter GAMETYPEID ...
	#
	source $SCRIPTS_FOLDER/include/include-gametypeid.inc;
	#
	#	Retrive data from game-types table for specific GAMETYPEID ...
	#	
	source $SCRIPTS_FOLDER/include/include-gametypefields.inc;
	#
	#	Define some variables ...
	#
	INSTALL_FOLDER="$SERVERS_INSTALL_FOLDER/$GAMESERVERID";
	BASE_FOLDER="$INSTALL_FOLDER/$MODSUBFOLDER";	
	#
	#	Display what server is being stopped ...
	#
	echo "Game-server selected: [ID=$GAMESERVERID] $SERVERDESC";
	echo "Game-server selected: [ID=$GAMESERVERID] $SERVERDESC" >> "$SCRIPT_LOG_FILE";
	#
	#	If in verbose mode, display list of running 'screen' processes ...
	#
	if [ "$SCRIPTS_VERBOSE" == true ]; then
		echo "Displaying 'screen' processes, before stop attempt ...";
	    echo "Displaying 'screen' processes, before stop attempt ...">> "$SCRIPT_LOG_FILE";
	    echo "-----------------------------";
		echo "-----------------------------" >> "$SCRIPT_LOG_FILE";
		screen -list 2>&1;
	    screen -list 2>&1 >> "$SCRIPT_LOG_FILE";
    	echo "-----------------------------";
		echo "-----------------------------" >> "$SCRIPT_LOG_FILE";
		echo "" >> "$SCRIPT_LOG_FILE";
	fi;
	#
	#	Display an in-game notification ...
	#
	echo "Displaying in-game notification ...";
	echo "Displaying in-game notification ..." >> "$SCRIPT_LOG_FILE";
	if [ "$SCRIPTS_VERBOSE" == true ]; then
		echo "$WARNSTOPTEXT";
		echo "$WARNSTOPTEXT" >> "$SCRIPT_LOG_FILE";
	fi;
	screen -S $GAMESERVERID -p 0 -X stuff "$WARNSTOPTEXT$(printf \\r)" 1>/dev/null 2>&1;
	#
	#	Play an in-game audible alert ...
	#
	echo "Playing in-game audible alert ...";
	echo "Playing in-game audible alert ..." >> "$SCRIPT_LOG_FILE";
	if [ "$SCRIPTS_VERBOSE" == true ]; then
		echo "$WARNSTOPAUDIO";
		echo "$WARNSTOPAUDIO" >> "$SCRIPT_LOG_FILE";
	fi;
	screen -S $GAMESERVERID -p 0 -X stuff "$WARNSTOPAUDIO$(printf \\r)" 1>/dev/null 2>&1;
	#
	#	Allow 15-sec for alert to play ...
	#
	echo "Allowing 15-sec for alert to play ...";
	echo "Allowing 15-sec for alert to play ..." >> "$SCRIPT_LOG_FILE";
	sleep 15s;
	#
	#	Sending 'quit' command to game-server ...
	#
	echo "Sending the 'quit' command ...";
	echo "Sending the 'quit' command ..." >> "$SCRIPT_LOG_FILE";
	screen -S $GAMESERVERID -p 0 -X stuff "quit$(printf \\r)" 1>/dev/null 2>&1;
	#
	#	Allowing 3-sec for graceful exit ...
	#
	echo "Allowing 3-sec for graceful exit ...";
	echo "Allowing 3-sec for graceful exit ..." >> "$SCRIPT_LOG_FILE";
	sleep 3s;
	#
	#	Sending CTRL+C to game-server ...
	#
	echo "Sending the CTRL+C to game server ...";
	echo "Sending the CTRL+C to game server ..." >> "$SCRIPT_LOG_FILE";
	screen -S $GAMESERVERID -p 0 -X stuff "$(printf \\x3)" 1>/dev/null 2>&1;
	#
	#	Allowing 1-sec before resorting to Linux 'kill' command ...
	#
	echo "Allowing 1-sec before resorting to Linux 'kill' command ...";
	echo "Allowing 1-sec before resorting to Linux 'kill' command ..." >> "$SCRIPT_LOG_FILE";
	sleep 1s;
	#
	#	Sending 'kill' to game-server ...
	#
	echo "Using 'kill' command on game server process ...";
	echo "Using 'kill' command on game server process ..." >> "$SCRIPT_LOG_FILE";
	kill $(ps aux | grep "game-server-run.sh $GAMESERVERID" | awk '{print $2}') 1>/dev/null 2>&1;
	#
	#	Display list of running 'screen' processes ...
	#
	echo "Displaying of 'screen' processes, AFTER stop attempt ...";
	echo "Displaying of 'screen' processes, AFTER stop attempt ..." >> "$SCRIPT_LOG_FILE";
	screen -list 2>&1;
	screen -list 2>&1 >> "$SCRIPT_LOG_FILE";
    #
    #	Use 'shift' to move to next parameter passed ...
    #
	shift;
	echo "";
    echo "" >> "$SCRIPT_LOG_FILE";
done;
#
#	Display end of stuff ...
#
source $SCRIPTS_FOLDER/include/include-outputend.inc;
#
#	... thats all folks!
#
