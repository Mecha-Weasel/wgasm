#!/bin/bash
#
#	----------------------------------------------------------------------------
#	Interactively run a game-server, using information from the data-files.
#	============================================================================
#	Created:       2024-05-18, by Weasel.SteamID.155@gMail.com	
#	Last modified: 2024-05-31, by Weasel.SteamID.155@gMail.com
#	----------------------------------------------------------------------------
#
#	Purpose:
#	
#		Interactively run a dedicated game-server instance.
#		Does NOT check if the instance may already be latest version.
#		Does NOT stop any instance already running in the background.
#		Does NOT start this instance running in the background.
#
#	Usage / command-line parameters:
#	
#	gameserverid
#	
#		The game-server name/ID that will be used run a dedicated
#		game-server interactively.
#		
#		Various options from the scrips.conf file will be used,
#		such as default install location, where to find the data-files, etc.
#		
#		Example:
#		
#			./game-server-run.sh gameserverid;
#
#	----------------------------------------------------------------------------
#	
#	Set special option to enable/disable the "-norestart" option on older games
#	running the GoldSrc engine.  Sometimes goldSrc/HLDS games end abnormally but
#	do not close.
#	
#	The "monitor" scipts can detect this situation and restart the server - but
#	ONLY if the affected game-server stays in that condition long enough for it
#	to be detected.  A side effect, is that since the game-server process will
#	be terminated by the "monitor" script, logging by the server will be cut-off
#	preventing the completion of the "-run.log" file.
#	
#	Adding the "-norestart" option to the command-line for launching HLDS would
#	allow the game-server process to close normally after an abnormal ending,
#	and subsequently allow the related "-run.log" file to be updated normally.
#	However, doing so prevents the "monitor" scripts from detecting the failure
#	condition.
#	
#	The option to include the "-norestart" option at game-server start will be
#	controlled by the $ALLOW_CLOSE_AT_ABEND option below, which might be useful
#	for troubleshooting. The default behavior will be for "-norestart" to not be
#	enabled - to allow successful "monitor" script functions.
#	
#ALLOW_CLOSE_AT_ABEND=true
ALLOW_CLOSE_AT_ABEND=false
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
#	Grab command-line parameter (which should be a GAMESERVERID) ...
#	
GAMESERVERID=$1;
#
#	Determine script log file ...
#
SCRIPT_LOG_FILE="$LOGS_FOLDER/$GAMESERVERID-run.log";
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
#	Process/validate parameter SERVERPORTNUMBER ...
#
source $SCRIPTS_FOLDER/include/include-portnumber.inc;
#
#	Define some variables ...
#
INSTALL_FOLDER="$SERVERS_INSTALL_FOLDER/$GAMESERVERID";
BASE_FOLDER="$INSTALL_FOLDER/$MODSUBFOLDER";	
#
#	Display what server is being run ...
#	
echo "Game-server selected: [ID=$GAMESERVERID] $SERVERDESC";
echo "Game-server selected: [ID=$GAMESERVERID] $SERVERDESC" >> "$SCRIPT_LOG_FILE";
#
#	If in verbose mode, display and log some extra stuff ...
#
if [ "$SCRIPTS_VERBOSE" == true ]; then
	MESSAGE="${ANSI_WHITE}Validating the game-engine is supported ...${ANSI_OFF}";
	echo -e "$MESSAGE";
	if [[ $SCRIPT_LOG_FILE ]]; then
		echo -e "$MESSAGE" | ansi2txt >> "$SCRIPT_LOG_FILE";
	fi;
fi;
#
#	Validate game-engine is supported ...
#
source $SCRIPTS_FOLDER/include/include-gameengineid.inc;
#
#	If in verbose mode, display and log some extra stuff ...
#
if [ "$SCRIPTS_VERBOSE" == true ]; then
	MESSAGE="${ANSI_CYANLT}Progress: ${ANSI_WHITE}Generating the command to run the game-server ...${ANSI_OFF}";
	echo -e "$MESSAGE";
	if [[ $SCRIPT_LOG_FILE ]]; then
		echo -e "$MESSAGE" | ansi2txt >> "$SCRIPT_LOG_FILE";
	fi;
fi;
#
#	Generate command to run the game-server ...
#
case $GAMEENGINE in
	"goldsrc")
		if [[ $SERVER_LOCAL_IP_ADDRESS ]]; then
        		if [[ $ALLOW_CLOSE_AT_ABEND == true ]]; then
						GAME_START_COMMAND="nice -n 10 ./hlds_run -game $MODSUBFOLDER -secure -norestart -port $SERVERPORTNUMBER +ip $SERVER_LOCAL_IP_ADDRESS";
					else
	                    GAME_START_COMMAND="nice -n 10 ./hlds_run -game $MODSUBFOLDER -secure -port $SERVERPORTNUMBER +ip $SERVER_LOCAL_IP_ADDRESS";
				fi;
			else
        		if [[ $ALLOW_CLOSE_AT_ABEND == true ]]; then
						GAME_START_COMMAND="nice -n 10 ./hlds_run -game $MODSUBFOLDER -secure -norestart -port $SERVERPORTNUMBER";
					else
	                    GAME_START_COMMAND="nice -n 10 ./hlds_run -game $MODSUBFOLDER -secure -port $SERVERPORTNUMBER";
				fi;
		fi;
		;;
	"source")
		if [[ $SERVER_LOCAL_IP_ADDRESS ]]; then
				GAME_START_COMMAND="nice -n 10 ./srcds_run -game $MODSUBFOLDER -secure -port $SERVERPORTNUMBER +ip $SERVER_LOCAL_IP_ADDRESS";
			else
				GAME_START_COMMAND="nice -n 10 ./srcds_run -game $MODSUBFOLDER -secure -port $SERVERPORTNUMBER";
		fi;
		;;
	"src2cs2")
		if [[ $SERVER_LOCAL_IP_ADDRESS ]]; then
				GAME_START_COMMAND="nice -n 9 ./game/bin/linuxsteamrt64/cs2 -dedicated -secure -port $SERVERPORTNUMBER +ip $SERVER_LOCAL_IP_ADDRESS -usercon -nodefaultmap -maxplayers 64 +exec autoexec.cfg";
			else
				GAME_START_COMMAND="nice -n 9 ./game/bin/linuxsteamrt64/cs2 -dedicated -secure -port $SERVERPORTNUMBER -usercon -nodefaultmap -maxplayers 64 +exec autoexec.cfg";
		fi;
		;;
	*)
		MESSAGE="${ANSI_REDLT}$(figlet "Error:")${ANSI_OFF}\n";
		MESSAGE+="${ANSI_YELLOW}Unsupported or unspecified game-engine: ${ANSI_WHITE}$GAMEENGINE${ANSI_OFF}";
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
#	Display and log some extra stuff ...
#
echo "Start-up command-line:";
echo "Start-up command-line:" >> "$SCRIPT_LOG_FILE";
echo "$GAME_START_COMMAND";
echo "$GAME_START_COMMAND" >> "$SCRIPT_LOG_FILE";
#
#	Change to the folder where game is installed ...
#
cd $INSTALL_FOLDER;
#
#	If in verbose mode, display and log some extra stuff ...
#
if [ "$SCRIPTS_VERBOSE" == true ]; then
	MESSAGE="${ANSI_CYANLT}Progress: ${ANSI_WHITE}Starting the game-server ...${ANSI_OFF}";
	echo -e "$MESSAGE";
	if [[ $SCRIPT_LOG_FILE ]]; then
		echo -e "$MESSAGE" | ansi2txt >> "$SCRIPT_LOG_FILE";
	fi;
fi;
#
#	Start the game-server ...
#
echo "Starting game server ...";
echo "Starting game server ..." >> "$SCRIPT_LOG_FILE";
echo $GAME_START_COMMAND;
$GAME_START_COMMAND;
#
#	Display end of stuff ...
#
source $SCRIPTS_FOLDER/include/include-outputend.inc;
#
#	... thats all folks!
#
