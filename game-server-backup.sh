#!/bin/bash
#
#	----------------------------------------------------------------------------
#	7-zip backup(s), using pre-configured include and exclude files ... 
#	============================================================================
#	Created:       2024-03-06, by Weasel.SteamID.155@gMail.com        
#	Last modified: 2024-06-13, by Weasel.SteamID.155@gMail.com
#	----------------------------------------------------------------------------
#
#	Accepts multiple server/backup identifier(s) in the same command-line.
#	
#	Usage / command-line parameters:
#	
#		gameserverid
#	
#			The game-server/backup-config identifier(s) to backup.
#		
#			Example:
#		
#				./game-server-stop.sh backupconfigid1 backupconfigid2 backupconfigidN;
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
	SCRIPT_LOG_FILE="$LOGS_FOLDER/$GAMESERVERID-backup.log";
    #
	#	Display start of stuff ...
	#
	source $SCRIPTS_FOLDER/include/include-outputbegin.inc;
	#	
	#	Process/validate parameter GAMESERVERID ...
	#	(or similar backup configuration named similarly)
	#
	source $SCRIPTS_FOLDER/include/include-gameserverid.inc;
	#
	#	Define some variables ...
	#
	WORKING_DIRECTORY="$SERVERS_INSTALL_FOLDER";
	INCLUDE_FILE="$BACKUP_CONFIGS_FOLDER/$GAMESERVERID-include.txt";
	EXCLUDE_FILE="$BACKUP_CONFIGS_FOLDER/$GAMESERVERID-exclude.txt";
	OUTPUT_FILE="$BACKUP_FOLDER/$GAMESERVERID-backup.zip";
	BACKUP_COMMAND="nice -n 19 7za a -tzip -mmt=off -snl -w$TEMP_FOLDER $OUTPUT_FILE @$INCLUDE_FILE -xr@$EXCLUDE_FILE";
	#
	#	Dispaly what server or backu config is being worked-on ..
	#
	echo "Game-server (or backup config) to backup: $SERVERDESC [ID=$GAMESERVERID]";
	echo "Game-server (or backup config) to backup: $SERVERDESC [ID=$GAMESERVERID]" >> "$SCRIPT_LOG_FILE";
	#
	#	Validate some stuff ...
	#	
	#		Validate that required backup "include" file exists ...
	#
	if [ ! -f $INCLUDE_FILE ]; then
		MESSAGE="${ANSI_REDLT}$(figlet "Error:")${ANSI_OFF}\n";
		MESSAGE+="${ANSI_WHITE}Required include-list file NOT found at: ${ANSI_REDLT}$INCLUDE_FILE${ANSI_OFF}";
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
	#		Validate that required backup "exclude" file exists ...
	#
	if [ ! -f $EXCLUDE_FILE ]; then
		MESSAGE="${ANSI_REDLT}$(figlet "Error:")${ANSI_OFF}\n";
		MESSAGE+="${ANSI_WHITE}Required exclude-list file NOT found at: ${ANSI_REDLT}$EXCLUDE_FILE${ANSI_OFF}";
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
	#	If in verbose mode, display and log some extra stuff ...
	#
	if [ "$SCRIPTS_VERBOSE" == true ]; then
		echo "Details for this backup process ... ";
		echo "Tempory folder (for zipping process): $TEMP_FOLDER";
		echo "Include File: $INCLUDE_FILE";
		echo "Exclude File: $EXCLUDE_FILE";
		echo "Output File: $OUTPUT_FILE";
		echo "Backup Command:";
		echo "$BACKUP_COMMAND";
	fi;
	#
	#	Display and log any existing backups ...
	#
	echo "Listing any previous backups ...";
	echo "Listing any previous backups ..." >> "$SCRIPT_LOG_FILE";
	ls -golh $OUTPUT_FILE 2>/dev/null;
	ls -golh $OUTPUT_FILE 2>/dev/null >> "$SCRIPT_LOG_FILE";
	#
	#	Delete any previous backup ...
	#
	echo "Deleting any previous backup ...";
	echo "Deleting any previous backup ..." >> "$SCRIPT_LOG_FILE";
	rm -f $OUTPUT_FILE 2>/dev/null;
	#
	#	Change to the working directory ...
	#
	cd $WORKING_DIRECTORY 2>/dev/null;
	#
	#	Create the new backup ...
	#
	echo "Creating a new backup ...";
	echo "Creating a new backup ..." >> "$SCRIPT_LOG_FILE";
	echo "Backup command being used:";
	echo "Backup command being used:" >> "$SCRIPT_LOG_FILE";
	echo "$BACKUP_COMMAND";
	echo "$BACKUP_COMMAND" >> "$SCRIPT_LOG_FILE";
	$BACKUP_COMMAND >> "$SCRIPT_LOG_FILE";
	#
	#	List the newly created backup file ...
	#
	echo " ... should be done. Listing backups ... ";
	echo " ... should be done. Listing backups ... " >> "$SCRIPT_LOG_FILE";
	ls -golh $OUTPUT_FILE 2>/dev/null;
	ls -golh $OUTPUT_FILE 2>/dev/null >> "$SCRIPT_LOG_FILE";
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
