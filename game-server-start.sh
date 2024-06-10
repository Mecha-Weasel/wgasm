#!/bin/bash
#
#	----------------------------------------------------------------------------
#	Start game-server(s) as disconnected background 'screen' processes
#	============================================================================
#	Created:       2024-03-25, by Weasel.SteamID.155@gMail.com        
#	Last modified: 2024-05-27, by Weasel.SteamID.155@gMail.com
#	----------------------------------------------------------------------------
#
#	Purpose:
#	
#		Run a dedicated game-server instance in the backgound using GNU "Screen" utlity.
#		Does NOT check if the instance may already be latest version.
#		DOES stop any instance with the same name already running in the background.
#		Accepts multiple gameserverids in the same command-line.
#
#	Usage / command-line parameters:
#	
#		gameserverid
#	
#			The game-server identifier(s) for the game-server(s) to start.
#		
#			Example:
#		
#				./game-server-start.sh gameserverid1 gameserverid2 gameserveridN;
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
	SCRIPT_LOG_FILE="$LOGS_FOLDER/$GAMESERVERID-start.log";
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
	SCREEN_LOG_FILE="$LOGS_FOLDER/$GAMESERVERID-screen.log";
	GAME_SERVER_STOP_COMMAND="$SCRIPTS_FOLDER/game-server-stop.sh $GAMESERVERID";
	GAME_SERVER_RUN_COMMAND="$SCRIPTS_FOLDER/game-server-run.sh $GAMESERVERID";
	#
	#	Display what server is being started ...
	#
	echo "Game-server selected: [ID=$GAMESERVERID] $SERVERDESC";
	echo "Game-server selected: [ID=$GAMESERVERID] $SERVERDESC" >> "$SCRIPT_LOG_FILE";
	#
	#	Check if the game-server is already started under GNU 'screen'
	#
	SCREEN_LIST_CAPTURE=$(screen -ls | grep $GAMESERVERID);
	if [[ $SCREEN_LIST_CAPTURE == *"$GAMESERVERID"* ]]; then
				SCREEN_RUNNING_CHECK=true;
		else
				SCREEN_RUNNING_CHECK=false;
	fi;
	#
	#	If in verbose mode, display and log some extra stuff ...
	#
	if [ "$SCRIPTS_VERBOSE" == true ]; then
		echo "Install folder: $INSTALL_FOLDER";
		echo "Install folder: $INSTALL_FOLDER" >> "$SCRIPT_LOG_FILE";
		echo "Script log file: $SCRIPT_LOG_FILE";
		echo "Script log file: $SCRIPT_LOG_FILE" >> "$SCRIPT_LOG_FILE";
		echo "Screen log file: $SCREEN_LOG_FILE";
		echo "Screen log file: $SCREEN_LOG_FILE" >> "$SCRIPT_LOG_FILE";
		echo "Stop command: $GAME_SERVER_STOP_COMMAND";
		echo "Stop command: $GAME_SERVER_STOP_COMMAND" >> "$SCRIPT_LOG_FILE";
		echo "Run command: $GAME_SERVER_RUN_COMMAND";
		echo "Run command: $GAME_SERVER_RUN_COMMAND" >> "$SCRIPT_LOG_FILE";
	    echo "Related screen already started?: $SCREEN_RUNNING_CHECK";
		echo "Related screen already started?: $SCREEN_RUNNING_CHECK" >> "$SCRIPT_LOG_FILE";
	fi;
	#
	#	Stop an existing game-server, if is already started under GNU 'screen'
	#
	if [ "$SCREEN_RUNNING_CHECK" == true ]; then
			echo "Stopping background instance of this game server ... ";
			echo "Stopping background instance of this game server ... " >> "$SCRIPT_LOG_FILE";
			$GAME_SERVER_STOP_COMMAND;
			echo "Stopped background instance of this game server. ";
			echo "Stopped background instance of this game server. " >> "$SCRIPT_LOG_FILE";
		else
	 		echo "No background instance of this game server detected.";
			echo "No background instance of this game server detected." >> "$SCRIPT_LOG_FILE";   
	fi;
	#
	#	Starting this server in the background using the GNU "screen" utility ...
	#
	echo "Starting game with the 'screen' utility ... ";
	echo "Starting game with the 'screen' utility ... " >> "$SCRIPT_LOG_FILE";
	screen -L -Logfile "$SCREEN_LOG_FILE" -A -m -d -S $GAMESERVERID $GAME_SERVER_RUN_COMMAND;
	#
	#	Display list of screen sessions ...
	#
	echo "Displaying list of 'screen' processes, AFTER start attempt ...";
	echo "Displaying list of 'screen' processes, AFTER start attempt ...">> "$SCRIPT_LOG_FILE";
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
