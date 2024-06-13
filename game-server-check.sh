#!/bin/bash
#
#	----------------------------------------------------------------------------
#	Chedk for and automatically apply any available update to server(s).
#	============================================================================
#	Created:       2024-03-08, by Weasel.SteamID.155@gMail.com        
#	Last modified: 2024-06-13, by Weasel.SteamID.155@gMail.com
#	----------------------------------------------------------------------------
#
#	Purpose:
#	
#		Check if an update is available for the game-type of the game-server.
#		If an update is available, stop any related GNU 'screen' instance.
#		If an update is available, apply the latest update.
#		If the game-server was running before, start it gain.
#		If the game-server was NOT running before, does NOT start it gain.
#		Accepts multiple gameserverids in the same command-line.
#
#	Usage / command-line parameters:
#	
#		gameserverid
#	
#			The game-server identifier(s)for the game-server(s) to check.
#		
#			Example:
#		
#				./game-server-check.sh gameserverid1 gameserverid2 gameserveridN;
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
	SCRIPT_LOG_FILE="$LOGS_FOLDER/$GAMESERVERID-check.log";
	ACTION_LOG_FILE="$LOGS_FOLDER/$GAMESERVERID-check-action.log";
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
	BACKUP_SCRIPT="$SCRIPTS_FOLDER/game-server-backup.sh $GAMESERVERID";    # script to backup game-server instance.
	EXCLUDE_SCRIPT="$SCRIPTS_FOLDER/game-server-exclude.sh $GAMESERVERID";  # script to exclude game-server instance.
	UPDATE_SCRIPT="$SCRIPTS_FOLDER/game-server-update.sh $GAMESERVERID";    # script to update game-server instance.
	CHECK_CONTROL_FILE="$BASE_FOLDER/update-in-progress.txt";               # file used to avoid conflicting update/install processes.
	STEAM_INF_FILE="$BASE_FOLDER/steam.inf";                                # full path to Steam.inf file.
	#
	#	Display what server is being updated ...
	#
	echo "Game-server selected: [ID=$GAMESERVERID] $SERVERDESC";
	echo "Game-server selected: [ID=$GAMESERVERID] $SERVERDESC" >> "$SCRIPT_LOG_FILE";
	#
	#	Validate game-engine is supported ...
	#
	source $SCRIPTS_FOLDER/include/include-gameengineid.inc;
	#
	#	Parse the currently-installed version from the steam.inf file ...
	#
	SERVER_CURRENT_VERSION=$(grep PatchVersion $STEAM_INF_FILE | sed 's/PatchVersion=//');
	SERVER_CURRENT_VERSION=$(echo -n $SERVER_CURRENT_VERSION |tr -d '\n\r\t');
	#
	#	Build the SteamAPI URL to use for checking if the
	#	currently-installed version is up-to-date ...
	#
	UPDATE_CHECK_URL="http://api.steampowered.com/ISteamApps/UpToDateCheck/v1?appid=$APPIDCHECK&version=$SERVER_CURRENT_VERSION&format=xml";
	#
	#	If in verbose mode, display and log some extra stuff ...
	#
	if [ "$SCRIPTS_VERBOSE" == true ]; then
		echo "Information used for this update-check includes: ...";
		echo "Information used for this update-check includes: ..." >> "$SCRIPT_LOG_FILE";
		echo "Location of steam.inf file: $STEAM_INF_FOLDER";
		echo "Location of steam.inf file: $STEAM_INF_FOLDER" >> "$SCRIPT_LOG_FILE";
		echo "AppID (for installation): $APPIDINSTALL";
		echo "AppID (for installation): $APPIDINSTALL" >> "$SCRIPT_LOG_FILE";
		echo "AppID (for checking): $APPIDCHECK";
		echo "AppID (for checking): $APPIDCHECK" >> "$SCRIPT_LOG_FILE";
		echo "Current version (from steam.inf): $SERVER_CURRENT_VERSION";
		echo "Current version (from steam.inf): $SERVER_CURRENT_VERSION" >> "$SCRIPT_LOG_FILE";
	fi;
	#
	#	Display and log various information ...
	#
	echo "URL to use for update-check:";
	echo "URL to use for update-check:" >> "$SCRIPT_LOG_FILE";
	echo "$UPDATE_CHECK_URL";
	echo "$UPDATE_CHECK_URL" >> "$SCRIPT_LOG_FILE";
	echo "Checking the current version against the update-check URL now ...";
	echo "Checking the current version against the update-check URL now ..." >> "$SCRIPT_LOG_FILE";
	#
	#	If in verbose mode, display and log some extra stuff ...
	#
	if [ "$SCRIPTS_VERBOSE" == true ]; then
		echo "Output of SteamAPI UpToDateCheck URL ...";
		echo "Output of SteamAPI UpToDateCheck URL ..." >> "$SCRIPT_LOG_FILE";
	fi;
	#
	#	Use 'curl' utility to check the SteamAPI URL to check if
	#	the currently-installed version is up-to-date ...
	#
	UPDATE_CHECK_SUCCESS=$(curl -s "$UPDATE_CHECK_URL" | grep '</success>' | sed -e 's/^[ \t]*//');
	UPDATE_CHECK_UPTODATE=$(curl -s "$UPDATE_CHECK_URL" | grep '</up_to_date>' | sed -e 's/^[ \t]*//') >> "$SCRIPT_LOG_FILE";
	echo "";
	echo "" >> "$SCRIPT_LOG_FILE";
	#
	#	If in verbose mode, display and log some extra stuff ...
	#
	if [ "$SCRIPTS_VERBOSE" == true ]; then
		echo -e "The strings returned by the update-check were:";
		echo -e "The strings returned by the update-check were:" >> "$SCRIPT_LOG_FILE";
		echo -e "Information                        Value";
		echo -e "Information                        Value" >> "$SCRIPT_LOG_FILE";
		echo -e "---------------------------------  -----";
	    echo -e "---------------------------------  -----" >> "$SCRIPT_LOG_FILE";
		echo -e "String returned by success-check:  $UPDATE_CHECK_SUCCESS";
		echo -e "String returned by success-check:  $UPDATE_CHECK_SUCCESS" >> "$SCRIPT_LOG_FILE";
		echo -e "String returned by update-check:   $UPDATE_CHECK_UPTODATE";
		echo -e "String returned by update-check:   $UPDATE_CHECK_UPTODATE" >> "$SCRIPT_LOG_FILE";
		echo -e "---------------------------------  -----";
	    echo -e "---------------------------------  -----" >> "$SCRIPT_LOG_FILE";
	fi;
	#
	#	Display and log various information ...
	#
	echo "Evaluating the SteamAPI update check output ...";
	echo "Evaluating the SteamAPI update check output ..." >> "$SCRIPT_LOG_FILE";
	#
	#	Evaluate the string returned form the update
	#	URL to determine if an update is required ...
	#
	if [ "$UPDATE_CHECK_SUCCESS" == "<success>true</success>" ]; then
			#
			#	Display and log a notification that the
			#	update-check process was successful ...
			#
			echo "[X] SteamAPI update check was successful.";
			echo "[X] SteamAPI update check was successful." >> "$SCRIPT_LOG_FILE";
			#
			#	Determine if there is an update available ...
			#
			if [ "$UPDATE_CHECK_UPTODATE" == "<up_to_date>false</up_to_date>" ]; then
			    #
				#	Display start of ACTION ...
				#
				source $SCRIPTS_FOLDER/include/include-actionbegin.inc;
				#
				#	Display and log that an update is needed ...
				#
				MESSAGE="${ANSI_YELLOW}$(figlet "WARNING:")${ANSI_OFF}";
				echo -e "$MESSAGE";
				if [[ $SCRIPT_LOG_FILE ]]; then
					echo -e "$MESSAGE" | ansi2txt >> "$SCRIPT_LOG_FILE";
				fi;
				echo "[_] Server installation is NOT up-to-date!";
				echo "[_] Server installation is NOT up-to-date!" >> "$SCRIPT_LOG_FILE";
				echo "[_] Server installation is NOT up-to-date!" >> "$ACTION_LOG_FILE";
                #
				#	Conditionally, invote the backup script before updating the game-server ...
				#
                if [ "$AUTOBACKUP_BY_CHECK" == true ]; then
                	echo "Invoking backup script BEFORE updating ...";
					echo "Invoking backup script BEFORE updating ..." >> "$SCRIPT_LOG_FILE";
					echo "Invoking backup script BEFORE updating ..." >> "$ACTION_LOG_FILE";
					$BACKUP_SCRIPT;
                fi;
				#
				#	Wait 1 minute(s) to allow for SteamPipe content to
				#	catch-up to SteamAPI indicators ...
				#
            	echo "Waiting 1 minute(s) for SteamPipe content availability ...";
				echo "Waiting 1 minute(s) for SteamPipe content availability ..." >> "$SCRIPT_LOG_FILE";
				echo "Waiting 1 minute(s) for SteamPipe content availability ..." >> "$ACTION_LOG_FILE";
				sleep 1m;
				echo "Invoking update script ...";
				echo "Invoking update script ..." >> "$SCRIPT_LOG_FILE";
				echo "Invoking update script ..." >> "$ACTION_LOG_FILE";
				#
				#	Invote script(s) that update all relevant games ...
				#
				$UPDATE_SCRIPT;
                #
				#	Conditionally, invote the exclude script after updating the game-server ...
				#
                if [ "$AUTOEXCLUDE_BY_CHECK" == true ]; then
                	echo "Invoking exclude script AFTER updating ...";
					echo "Invoking exclude script AFTER updating ..." >> "$SCRIPT_LOG_FILE";
					echo "Invoking exclude script AFTER updating ..." >> "$ACTION_LOG_FILE";
					$EXCLUDE_SCRIPT;
                fi;
				#
				#	Display end of ACTION ...
				#
				source $SCRIPTS_FOLDER/include/include-actionend.inc;
			else
				#
				#	Display and log that an update is needed ...
				#
				echo "[X] Server installation is already up-to-date.";
            	echo "[X] Server installation is already up-to-date." >> "$SCRIPT_LOG_FILE";
				echo "Server already up-to-date, NOT attempting update.";
            	echo "Server already up-to-date, NOT attempting update." >> "$SCRIPT_LOG_FILE";
			fi;
		else
			#
			#	Display and log a notification that the
			#	update check process could not determine
			#	if an update is (or is not) required ...
			#
			MESSAGE="${ANSI_REDLT}$(figlet "ERROR:")${ANSI_OFF}";
			echo -e "$MESSAGE";
			if [[ $SCRIPT_LOG_FILE ]]; then
				echo -e "$MESSAGE" | ansi2txt >> "$SCRIPT_LOG_FILE";
			fi;
			echo "[_] SteamAPI update check was NOT successful!";
	        echo "[_] SteamAPI update check was NOT successful!" >> "$SCRIPT_LOG_FILE";
			echo "[_] Server installation readiness is INDETERMINATE!";
	        echo "[_] Server installation readiness is INDETERMINATE!" >> "$SCRIPT_LOG_FILE";
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
