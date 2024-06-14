#!/bin/bash
#
#	----------------------------------------------------------------------------
#	Script for wrapping scripts called by cron, but with collision avoidance
#	============================================================================
#	Created:       2024-06-14, by Weasel.SteamID.155@gMail.com        
#	Last modified: 2024-06-14, by Weasel.SteamID.155@gMail.com
#	----------------------------------------------------------------------------
#
#	This script will be used to "wrap" other scripts,
#	to allow them to be safely invoked from the Linux
#	"cron" scheduler.  This wrapper will ensure that
#	scripts for two different schedules do not attempt
#	to run simultaneously, creating problems.
#
#	One example might be the HOURLY or OFTEN scripts
#	attempting to run, while the WEEKLY script (which
#	may run for a long time) is still running.
#
#		Figure-out where the scripts folder is located ...
#
SCRIPTS_FOLDER="$( dirname -- "$( readlink -f -- "$0"; )"; )";
#
#	Include the ANSI escape code definitions ...
#	
source $SCRIPTS_FOLDER/include/include-ansi.inc;
#
#	Innclude the base script dependancies ...
#	
source $SCRIPTS_FOLDER/include/include-base.inc;
#
#	Display start of stuff ...
#
source $SCRIPTS_FOLDER/include/include-outputbegin.inc;
#
#	Determine path to CRON scripts folder ...
#
CRON_SCRIPTS_FOLDER="$SCRIPTS_FOLDER/cron";
#
#	Grab command-line parameter (which should be a cron script (without the path) ...
#
CRON_SCRIPT=$1;
#
#	Determine the cron check file that will be used to avoid collisions ...
#
CRON_CHECK_FILE="$CRON_SCRIPTS_FOLDER/cron-in-progress.txt";
#
#	Display and log some stuff ...
#
echo -e "Option:                       Value:";
echo -e "Option:                       Value:" >> "$SCRIPT_LOG_FILE";
echo -e "----------------------------  -----";
echo -e "----------------------------  -----" >> "$SCRIPT_LOG_FILE";
echo -e "Scripts folder:               $SCRIPTS_FOLDER";
echo -e "Scripts folder:               $SCRIPTS_FOLDER" >> "$SCRIPT_LOG_FILE";
echo -e "Cron Scripts folder:          $CRON_SCRIPTS_FOLDER";
echo -e "Cron Scripts folder:          $CRON_SCRIPTS_FOLDER" >> "$SCRIPT_LOG_FILE";
echo -e "Cron Script Requested:        $CRON_SCRIPT";
echo -e "Cron Script Requested:        $CRON_SCRIPT" >> "$SCRIPT_LOG_FILE";
echo -e "Cron Check-File:              $CRON_CHECK_FILE";
echo -e "Cron Check-File:              $CRON_CHECK_FILE" >> "$SCRIPT_LOG_FILE";
#
#	Check if the check control file already exists ...
#
ls -lah $CRON_SCRIPTS_FOLDER;
if [ -e "$CRON_CHECK_FILE" ]; then
		#
		#	Display a notification that there
		#	is already an update in progress ...
		#
		MESSAGE="${ANSI_REDLT}$(figlet "WARNING:")${ANSI_OFF}\n";
		MESSAGE+="${ANSI_WHITE}Another scheduled cron job is already in progress!${ANSI_OFF}  ${ANSI_WHITE}Aborting this script.${ANSI_OFF}";
		echo -e "$MESSAGE";
		if [[ $SCRIPT_LOG_FILE ]]; then
			echo -e "$MESSAGE" | ansi2txt >> "$SCRIPT_LOG_FILE";
		fi;
	else
		#
		#	If the coron check file does not exist,
		#	then, its all-clear to proceed ...
		#
		echo -e "Created at:  $(date)" > $CRON_CHECK_FILE;
		echo -e "Created by:  $CRON_SCRIPT" >> $CRON_CHECK_FILE;
		ls -lah $CRON_SCRIPTS_FOLDER;
		#
		#	Go ahead and run the requested script ...
		#
		echo -e "Running this script as requested";
		echo -e "Running this script as requested" >> "$SCRIPT_LOG_FILE";
		echo -e "$CRON_SCRIPTS_FOLDER/$CRON_SCRIPT";
		echo -e "$CRON_SCRIPTS_FOLDER/$CRON_SCRIPT" >> "$SCRIPT_LOG_FILE";
		cd $CRON_SCRIPTS_FOLDER;
		#$CRON_SCRIPTS_FOLDER/$CRON_SCRIPT;
		#
		#	Delete the cron check file, since we are done ...
		#
		rm -f $CRON_SCRIPT;
fi;
ls -lah $CRON_SCRIPTS_FOLDER;
#
#	Display end of stuff ...
#
source $SCRIPTS_FOLDER/include/include-outputend.inc;
#
#	... thats all folks!
#
