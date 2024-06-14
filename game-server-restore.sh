#!/bin/bash
#
#	----------------------------------------------------------------------------
#	Restore 7-zip backups(s) created by the game-server-backup.sh script
#	============================================================================
#	Created:       2024-05-24, by Weasel.SteamID.155@gMail.com        
#	Last modified: 2024-06-13, by Weasel.SteamID.155@gMail.com
#	----------------------------------------------------------------------------
#	
#	Purpose:
#	
#		The game-server name/ID (or other backup config/ID)
#		will determine the name of the folder to restore.
#		Accepts multiple backupconfigids in the same command-line.
#
#	Usage / command-line parameters:
#	
#		gameserverid
#	
#			The game-server identifier(s) for the game-server(s) to restore.
#		
#			Example:
#		
#				./game-server-restore.sh backupconfigid1 backupconfigid2 backupconfigidN;
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
	SCRIPT_LOG_FILE="$LOGS_FOLDER/$GAMESERVERID-restore.log";
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
	INPUT_FILE="$BACKUP_FOLDER/$GAMESERVERID-backup.zip";
	RESTORE_FOLDER="$SERVERS_INSTALL_FOLDER/$GAMESERVERID";
	RESTORE_COMMAND="nice -n 19 7za x -mmt=off -aoa -o$WORKING_DIRECTORY -w$TEMP_FOLDER $INPUT_FILE"
	#
	#	Dispaly that is being restored ..
	#
	echo "Game-server (or backup config) to restore: [ID=$GAMESERVERID]";
	echo "Game-server (or backup config) to restore: [ID=$GAMESERVERID]" >> "$SCRIPT_LOG_FILE";
	#
	#	If in verbose mode, display and log some extra stuff ...
	#
	if [ "$SCRIPTS_VERBOSE" == true ]; then
		echo "Details for this restore process ... ";
		echo "Tempory folder (for zipping process): $TEMP_FOLDER";
		echo "Input File:                           $INPUT_FILE";
	    echo "Restore Folder:                       $RESTORE_FOLDER"
		echo "Restore Command:";
		echo "$RESTORE_COMMAND";
	fi;
	#
	#	Display and log any existing backups ...
	#
	echo "List any matching backups available ...";
	echo "List any matching backups available ..." >> "$SCRIPT_LOG_FILE";
	ls -golh $INPUT_FILE 2>/dev/null;
	ls -golh $INPUT_FILE 2>/dev/null >> "$SCRIPT_LOG_FILE";
	#
	#	Change to the working directory ...
	#
	cd $WORKING_DIRECTORY 2>/dev/null;
	#
	#	Create the new backup ...
	#
	echo "Restoring the backup ...";
	echo "Restoring the backup ..." >> "$SCRIPT_LOG_FILE";
	echo "Restore command being used:";
	echo "Restore command being used:" >> "$SCRIPT_LOG_FILE";
	echo "$RESTORE_COMMAND";
	echo "$RESTORE_COMMAND" >> "$SCRIPT_LOG_FILE";
	$RESTORE_COMMAND >> "$SCRIPT_LOG_FILE";
	#
	#	Display (some) of the restore result ...
	#
	if [ "$SCRIPTS_VERBOSE" == true ]; then
			#
	        #	If in verbose mode, display full directory listing ..
	        #
	        echo " Listing restored folder ... ";
			echo " Listing restored folder ... " >> "$SCRIPT_LOG_FILE";
			tree --dirsfirst $RESTORE_FOLDER 2>/dev/null;
			tree --dirsfirst $RESTORE_FOLDER 2>/dev/null >> "$SCRIPT_LOG_FILE";
		else
	    	#
	        #	If NOT in verbose mode, limit directory listing to 2 levels ...
	        #	(but still send full listing to log file)
	        #
	        echo " Listing restored folder (listing limited to 2 levels deep) ... ";
			echo " Listing restored folder ... " >> "$SCRIPT_LOG_FILE";
	 		tree --dirsfirst -L 2 $RESTORE_FOLDER 2>/dev/null;
			tree --dirsfirst $RESTORE_FOLDER 2>/dev/null >> "$SCRIPT_LOG_FILE";
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
