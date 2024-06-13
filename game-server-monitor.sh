#!/bin/bash
#
#	----------------------------------------------------------------------------
#	Monitor game-server(s) screen session(s) for various fatal conditions
#	============================================================================
#	Created:	   2024-04-06, by Weasel.SteamID.155@gMail.com		
#	Last modified: 2024-06-13, by Weasel.SteamID.155@gMail.com
#	----------------------------------------------------------------------------
#	
#	Purpose:
#	
#		Check the screen logs for a game-server process for fatal conditions,
#		and restart the server automatically - only if needed.
#		Accepts multiple gameserverids in the same command-line.
#
#	Usage / command-line parameters:
#		
#		gameserverid
#	
#			The game-server identifier(s) for the game-server(s) to monitor.
#		
#			Example:
#		
#				./game-server-monitor.sh gameserverid1 gameserverid2 gameserveridN;
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
	SCRIPT_LOG_FILE="$LOGS_FOLDER/$GAMESERVERID-monitor.log";
	ACTION_LOG_FILE="$LOGS_FOLDER/$GAMESERVERID-monitor-action.log";
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
	#	Validate that SERVERTHRESHOLD is true or false (or blank = true) ...
	#
	if ! [[ $SERVERSTALE ]]; then
			#
			#	If no value was passed, assume false ...
			#
			SERVERSTALE=false; 
		else
			#
		    #	If a valude was passed, evanualte it for validity ...
		    #
			case $SERVERSTALE in
				true | True | TRUE)
	            	SERVERSTALE=true; 
	            	;;
				false | False | FALSE)
	           		SERVERSTALE=false; 
	            	;;            
	            *)
					MESSAGE="${ANSI_REDLT}$(figlet "Error:")${ANSI_OFF}\n";
					MESSAGE+="${ANSI_WHITE}Only 'true' or 'false' (or blank) may be used for parameter: ${ANSI_REDLT}monitor-for-stale?${ANSI_OFF}";
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
			esac        
	fi;
	#
	#	Define some additional variables ...
	#
	STOP_SCRIPT="$SCRIPTS_FOLDER/game-server-stop.sh $GAMESERVERID";    # script to stop existing game-server instance.
	START_SCRIPT="$SCRIPTS_FOLDER/game-server-start.sh $GAMESERVERID";  # script to restart game-server instance.
	SCREEN_LOG_FILE="$LOGS_FOLDER/$GAMESERVERID-screen.log";            # screen output log file to examine for fatal conditions.
	TAIL_COMMAND="tail -n 1 $SCREEN_LOG_FILE";                          # tail command to retreive last line(s) of screen log file.
	if [ ! -f $SCREEN_LOG_FILE ]; then
			DATESERIAL_LOG=0;                                           # if no 'screen' log file exists, use zero (0).
		else
	    	DATESERIAL_LOG=$(date +%s -r $SCREEN_LOG_FILE);             # the date/time (in "seconds since epoch" format) of last log file change.
	fi;
	DATESERIAL_CURRENT=$(date +%s);                                     # the current date/time (in "seconds since epoch" format).
	DATESERIAL_SECONDS=$(( $DATESERIAL_CURRENT - $DATESERIAL_LOG ));    # difference (in seconds) between now and last log file change.
	DATESERIAL_MINUTES=$(( $DATESERIAL_SECONDS / 60 ));                 # difference (in minutes) between now and last log file change.
	#
	#	Display what server is being monitored for fatal conditions ...
	#
	echo "Game-server selected: [ID=$GAMESERVERID] $SERVERDESC";
	echo "Game-server selected: [ID=$GAMESERVERID] $SERVERDESC" >> "$SCRIPT_LOG_FILE";
	#
	#	If debug is on, display and log various information ...
	#
	if [ "$SCRIPTS_VERBOSE" = true ]; then
	    echo "Verbose mode:                           $SCRIPTS_VERBOSE$";  
	    echo "Monitor for stale 'screen' logging?:    $SERVERSTALE";
		echo "Stop script to use:                     $STOP_SCRIPT";
		echo "Start script to use:                    $START_SCRIPT";
		echo "Screen log-file to examine:             $SCREEN_LOG_FILE";
		echo "Tail command to use:                    $TAIL_COMMAND";
	   	echo "Date/Time serial (current):             $DATESERIAL_CURRENT";
		echo "Date/Time serial (screen log file):     $DATESERIAL_LOG";
		echo "Date/Time serial difference (seconds):  $DATESERIAL_SECONDS";
		echo "Date/Time serial difference (minutes):  $DATESERIAL_MINUTES";
		echo "Date/Time serial threshold (seconds):   $SERVERTHRESHOLD";
	fi;
	#
	#	Use 'tail' utility to check the last line(s) of the screen log file for fatal conditions ...
	#
	TAIL_OUTPUT=$($TAIL_COMMAND 2>/dev/null);
	TAIL_OUTPUT_SEG_FAULT_CHECK=$(echo $TAIL_OUTPUT | grep "^Segmentation fault");
	TAIL_OUTPUT_FATAL_ERROR_CHECK=$(echo $TAIL_OUTPUT | grep "^FATAL ERROR");
	if [[ $DATESERIAL_SECONDS -gt $SERVERTHRESHOLD ]]; then
		STALE_LOG_CONDITION=true;
	fi;
	#
	#	If verbose mode is on, display and log that last line for troubleshooting purposes ...
	#
	if [ "$SCRIPTS_VERBOSE" = true ]; then
		echo "";
		echo "Output of Tail utility to get last line(s) of screen log file ...";
		echo "Tail Output:";
		echo "$TAIL_OUTPUT";
		echo "Tail Output (Seg-Fault Check):";
		echo "$TAIL_OUTPUT_SEG_FAULT_CHECK";
		echo "Tail Output (Fatal-Error Check):";
		echo "$TAIL_OUTPUT_FATAL_ERROR_CHECK";
	    echo "";
	fi;
	#
	#	Check if related screen process is even running ...
	#
	SCREEN_LIST_CAPTURE=$(screen -ls | grep $GAMESERVERID);
	if [[ $SCREEN_LIST_CAPTURE == *"$GAMESERVERID"* ]]; then
		SCREEN_RUNNING_CHECK=true;
	else
		SCREEN_RUNNING_CHECK=false;
	fi;
	echo "Is related screen process running?:     $SCREEN_RUNNING_CHECK";
	echo "Is related screen process running?:     $SCREEN_RUNNING_CHECK" >> "$SCRIPT_LOG_FILE";
    echo "Monitor for stale 'screen' logging?:    $SERVERSTALE";
    echo "Monitor for stale 'screen' logging?:    $SERVERSTALE" >> "$SCRIPT_LOG_FILE";
	echo "Most recent 'screen' log actvity:       $DATESERIAL_SECONDS seconds ago.";
	echo "Most recent 'screen' log actvity:       $DATESERIAL_SECONDS seconds ago." >> "$SCRIPT_LOG_FILE";
	#
	#	If verbose mode is on, display and log some extra stuff ...
	#
	if [ "$SCRIPTS_VERBOSE" = true ]; then
		echo "";
		echo "Screen session list capture:";
		echo "Screen session list capture:" >> "$SCRIPT_LOG_FILE";
		echo "$SCREEN_LIST_CAPTURE";
		echo "$SCREEN_LIST_CAPTURE" >> "$SCRIPT_LOG_FILE";
		echo "";
	fi;
	#
	#	ONLY if the related screen process is running, check for various fatal conditions ...
	#
	if [[ "$SCREEN_RUNNING_CHECK" = true ]]; then
		#
		#	...	if a seg-fault it detected ...
		#
		if [[ $TAIL_OUTPUT_SEG_FAULT_CHECK ]]; then
		    #
			#	Display start of ACTION ...
			#
			source $SCRIPTS_FOLDER/include/include-actionbegin.inc;
			#
			#	Display and log a warning ...
			#
			MESSAGE="${ANSI_YELLOW}$(figlet "Warning:")${ANSI_OFF}\n";
			MESSAGE+="${ANSI_WHITE}Segmention Fault${ANSI_OFF} (Seg-Fault) detected!";
			echo -e "$MESSAGE";
			if [[ $SCRIPT_LOG_FILE ]]; then
				echo -e "$MESSAGE" | ansi2txt >> "$SCRIPT_LOG_FILE";
				echo -e "$MESSAGE" | ansi2txt >> "$ACTION_LOG_FILE";
			fi;
			#
			#	Restart this game-server ...
			#
			echo "Restarting this game server ... ";
			echo "Restarting this game server ... " >> "$SCRIPT_LOG_FILE";
			echo "Restarting this game server ... " >> "$ACTION_LOG_FILE";
			$START_SCRIPT;
			#
			#	Display end of ACTION ...
			#
			source $SCRIPTS_FOLDER/include/include-actionend.inc;
			#
			#	Display end of stuff ...
			#
			source $SCRIPTS_FOLDER/include/include-outputend.inc;
	        exit;
	 	fi;
		#
		#	...	if a fatal-error is detected ...
		#
		if [[ $TAIL_OUTPUT_FATAL_ERROR_CHECK ]]; then
			#
			#	Display and log a warning ...
			#
			MESSAGE="${ANSI_YELLOW}$(figlet "Warning:")${ANSI_OFF}\n";
			MESSAGE+="${ANSI_WHITE}Fatal Error${ANSI_OFF} detected!";
			echo -e "$MESSAGE";
			if [[ $SCRIPT_LOG_FILE ]]; then
				echo -e "$MESSAGE" | ansi2txt >> "$SCRIPT_LOG_FILE";
			fi;
			#
			#	Restart this game-server ...
			#
			echo "Restarting this game server ... ";
			echo "Restarting this game server ... " >> "$SCRIPT_LOG_FILE";
			$START_SCRIPT;
			#
			#	Display end of stuff ...
			#
			source $SCRIPTS_FOLDER/include/include-outputend.inc;
	        exit;
		fi;
		#
	    #		Only check for stale logging, if SERVERSTALE is requested ...
	    #
	    if [[ $SERVERSTALE == true ]]; then
	    	#
			#	... then check to see if there is recent GNU 'screen' log-file output ...
			#
			if [[ $STALE_LOG_CONDITION == true ]]; then
				#
				#	Display and log a warning ...
				#
				MESSAGE="${ANSI_YELLOW}$(figlet "Warning:")${ANSI_OFF}\n";
				MESSAGE+="${ANSI_WHITE}Stale 'screen' log-file${ANSI_OFF} detected!";
				echo -e "$MESSAGE";
				if [[ $SCRIPT_LOG_FILE ]]; then
					echo -e "$MESSAGE" | ansi2txt >> "$SCRIPT_LOG_FILE";
				fi;
				#
				#	Restart this game-server ...
				#
				echo "Restarting this game server ... ";
				echo "Restarting this game server ... " >> "$SCRIPT_LOG_FILE";
				$START_SCRIPT;
				#
				#	Display end of stuff ...
				#
				source $SCRIPTS_FOLDER/include/include-outputend.inc;
	        	exit;
			fi;
	    fi;
	fi;
	#
	#	Display end of stuff ...
	#
	source $SCRIPTS_FOLDER/include/include-outputend.inc;
	#
	#	Use 'shift' to move to next parameter passed ...
	#
	shift;
	echo "";
	echo "" >> "$SCRIPT_LOG_FILE";
done;
#
#	... thats all folks!
#
