#!/bin/bash
#
#	----------------------------------------------------------------------------
#	Update game-servers running as disconnected background 'screen' processes
#	============================================================================
#	Created:       2024-03-07, by Weasel.SteamID.155@gMail.com       
#	Last modified: 2024-05-27, by Weasel.SteamID.155@gMail.com
#	----------------------------------------------------------------------------
#
#	Purpose:
#	
#		Send an in-game text notification, that the server will be updated soon.
#		Play an in-game audible notification, that the server will be updated soon.
#		Stop the game-server if its already running under GNU 'screen'
#		Update the game-server.
#		If the game-server was running under GNU 'screen' before, restart it after.
#		Accepts multiple gameserverids in the same command-line.
#
#	Usage / command-line parameters:
#	
#		gameserverid
#	
#			The game-server identifier(s) for the game-server(s) to update.
#		
#			Example:
#		
#				./game-server-update.sh gameserverid1 gameserverid2 gameserveridN;
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
	SCRIPT_LOG_FILE="$LOGS_FOLDER/$GAMESERVERID-update.log";
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
	INSTALL_FOLDER="$SERVERS_INSTALL_FOLDER/$GAMESERVERID";                 # install folder for the game.
	BASE_FOLDER="$INSTALL_FOLDER/$MODSUBFOLDER";	                        # base-folder for the game (valve, cstrike, etc.)
	STOP_SCRIPT="$SCRIPTS_FOLDER/game-server-stop.sh $GAMESERVERID";        # script to stop existing game-server instance.
	INSTALL_SCRIPT="$SCRIPTS_FOLDER/game-server-install.sh $GAMESERVERID";  # script to install/update game-server content.
	START_SCRIPT="$SCRIPTS_FOLDER/game-server-start.sh $GAMESERVERID";      # script to restart game-server instance.
	CHECK_CONTROL_FILE="$BASE_FOLDER/update-in-progress.txt";               # file used to avoid conflicting update/install processes.
	#
	#	Display what server is being updated ...
	#
	echo "Game-server selected: [ID=$GAMESERVERID] $SERVERDESC";
	echo "Game-server selected: [ID=$GAMESERVERID] $SERVERDESC" >> "$SCRIPT_LOG_FILE";
	#
	#	Validate game-engine is support by this script ...
	#
	case $GAMEENGINE in
		"goldsrc")
			#
			#	If in verbose mode, display and log some extra stuff ...
			#
			if [ "$SCRIPTS_VERBOSE" == true ]; then
				echo -e "Supported game-engine detected as: ${ANSI_WHITE}$GAMEENGINE${ANSI_OFF}";
	            echo -e "Supported game-engine detected as: $GAMEENGINE" >> "$SCRIPT_LOG_FILE";
	        fi;
			;;
		"source")
			#
			#	If in verbose mode, display and log some extra stuff ...
			#
			if [ "$SCRIPTS_VERBOSE" == true ]; then
				echo -e "Supported game-engine detected as: ${ANSI_WHITE}$GAMEENGINE${ANSI_OFF}";
	            echo -e "Supported game-engine detected as: $GAMEENGINE" >> "$SCRIPT_LOG_FILE";
			fi;
			;;
		"src2cs2")
			#
			#	If in verbose mode, display and log some extra stuff ...
			#
			if [ "$SCRIPTS_VERBOSE" == true ]; then
	        	echo -e "Supported game-engine detected as: ${ANSI_WHITE}$GAMEENGINE${ANSI_OFF}";
	            echo -e "Supported game-engine detected as: $GAMEENGINE" >> "$SCRIPT_LOG_FILE";
			fi;
			;;
		*)
			MESSAGE="${ANSI_REDLT}$(figlet "Error:")${ANSI_OFF}\n";
			MESSAGE+="${ANSI_WHITE}Unsupported or unspecified game-engine: ${ANSI_REDLT}$GAMEENGINE${ANSI_OFF}";
			echo -e "$MESSAGE";
			if [[ $SCRIPT_LOG_FILE ]]; then
				echo -e "$MESSAGE" | ansi2txt >> "$SCRIPT_LOG_FILE";
			fi;
			exit 1;
			;;
	esac;
	#
	#	Check to see if an update is
	#	already in progress ...
	#
	if [ -e "$CHECK_CONTROL_FILE" ]; then
			#
			#	Display a notification that there
			#	is already an update in progress ...
			#
			MESSAGE="${ANSI_REDLT}$(figlet "Error:")${ANSI_OFF}\n";
			MESSAGE+="${ANSI_YELLOW}Game install or update already in progress!${ANSI_OFF} ${ANSI_YELLOW}Aborting this update attempt.${ANSI_OFF}";
			echo -e "$MESSAGE";
			if [[ $SCRIPT_LOG_FILE ]]; then
				echo -e "$MESSAGE" | ansi2txt >> "$SCRIPT_LOG_FILE";
			fi;
		else
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
				echo "Information:                     Value:";
				echo "Information:                     Value:" >> "$SCRIPT_LOG_FILE";
				echo "-----------                      -----";
				echo "-----------                      -----" >> "$SCRIPT_LOG_FILE";
				echo "Game-server this is for:         $GAMESERVERID";
				echo "Game-server this is for:         $GAMESERVERID" >> "$SCRIPT_LOG_FILE";
				echo "Sub-folder where game is:        $MODSUBFOLDER";
				echo "Sub-folder where game is:        $MODSUBFOLDER" >> "$SCRIPT_LOG_FILE";
				echo "Folder where scripts are:        $SCRIPTS_FOLDER";
				echo "Folder where scripts are:        $SCRIPTS_FOLDER" >> "$SCRIPT_LOG_FILE";
				echo "Base folder where game is:       $BASE_FOLDER";
				echo "Base folder where game is:       $BASE_FOLDER" >> "$SCRIPT_LOG_FILE";
				echo "Log file for this update:        $SCRIPT_LOG_FILE";
				echo "Log file for this update:        $SCRIPT_LOG_FILE" >> "$SCRIPT_LOG_FILE";
				echo "Alert display-text command:      $WARNUPDATETEXT";
				echo "Alert display-text command:      $WARNUPDATETEXT" >> "$SCRIPT_LOG_FILE";
				echo "Alert play-audio command:        $WARNUPDATEAUDIO";
				echo "Alert play-audio command:        $WARNUPDATEAUDIO" >> "$SCRIPT_LOG_FILE";
				echo "Server stop script:              $STOP_SCRIPT";
				echo "Server stop script:              $STOP_SCRIPT" >> "$SCRIPT_LOG_FILE";
				echo "Server install script:           $INSTALL_SCRIPT";
				echo "Server install script:           $INSTALL_SCRIPT" >> "$SCRIPT_LOG_FILE";
				echo "Server start script:             $START_SCRIPT";
				echo "Server start script:             $START_SCRIPT" >> "$SCRIPT_LOG_FILE";
				echo "Capture & search of screen list: $SCREEN_LIST_CAPTURE";
				echo "Capture & search of screen list: $SCREEN_LIST_CAPTURE" >> "$SCRIPT_LOG_FILE";
				echo "Related screen already started?: $SCREEN_RUNNING_CHECK";
				echo "Related screen already started?: $SCREEN_RUNNING_CHECK" >> "$SCRIPT_LOG_FILE";
			fi;
			#
			#	ONLY if the related screen process is/was already running, ...
			#
			if [[ "$SCREEN_RUNNING_CHECK" = true ]]; then
					#
					#	Displaying an in-game text notification ...
					#
					echo "Displaying in-game notification,";
					echo "Displaying in-game notification," >> "$SCRIPT_LOG_FILE";
					screen -S $GAMESERVERID -p 0 -X stuff "$WARNUPDATETEXT";
	            	#
					#	Playing an in-game audible notification ...
					#
	 				echo "Playing an in-game audible alert ...";
					echo "Playing an in-game audible alert ..." >> "$SCRIPT_LOG_FILE";           
					screen -S $GAMESERVERID -p 0 -X stuff "$WARNUPDATEAUDIO";
					#
					#	Wait 60 seconds to allow the sound file
					#	to complete playing in-game ...
					#
					echo "Allowing 60-sec for alert to play ...";
					echo "Allowing 60-sec for alert to play ..." >> "$SCRIPT_LOG_FILE";
					sleep 60s;
					#
					#	Stop any existing instance of this game-server ...
					#
					echo "Stopping background instance of this game server ... ";
					echo "Stopping background instance of this game server ... " >> "$SCRIPT_LOG_FILE";
					$STOP_SCRIPT;
					echo "Stopped background instance of this game server. ";
					echo "Stopped background instance of this game server. " >> "$SCRIPT_LOG_FILE";
	            else
	 				echo "No background instance of this game server detected.";
					echo "No background instance of this game server detected." >> "$SCRIPT_LOG_FILE"; 
			fi;
			#
			#	Update content of this game-server ...
			#
			echo "Updating content of this game-server ... ";
			echo "Updating content of this game-server ... " >> "$SCRIPT_LOG_FILE";
			$INSTALL_SCRIPT;
			#
			#	ONLY if the related screen process is/was already running, ...
			#
			if [[ "$SCREEN_RUNNING_CHECK" = true ]]; then
				#
				#	Restart this game-server ...
				#
				echo "Restart this game-server ... ";
				echo "Restart this game-server ... " >> "$SCRIPT_LOG_FILE";
				$START_SCRIPT;
			fi; 
	fi;
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
