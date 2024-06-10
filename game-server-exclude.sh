#!/bin/bash
#
#	----------------------------------------------------------------------------
#	Build backup exclusion list(s) for a specified game-server(s)
#	============================================================================
#	Created:       2024-03-06, by Weasel.SteamID.155@gMail.com        
#	Last modified: 2024-05-28, by Weasel.SteamID.155@gMail.com
#	----------------------------------------------------------------------------
#
#	Purpose:
#	
#		Built a backup exclusion list for Half-Life (HL1) game server content.
#		Accepts multiple gameserverids in the same command-line.
#
#	Usage / command-line parameters:
#	
#		gameserverid
#	
#			The game-server identifier(s) for the game-server(s) to exclude.
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
	MESSAGE="${ANSI_WHITE}$(figlet "Error:")${ANSI_OFF}\n";
	MESSAGE+="${ANSI_YELLOW}At least one (1) gameserverid must be specified!${ANSI_OFF}";
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
	SCRIPT_LOG_FILE="$LOGS_FOLDER/$GAMESERVERID-exclude.log";
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
	#	Define some more options ...
	#	
	INSTALL_FOLDER="$TEMPINSTALL_FOLDER/stock-$GAMETYPEID";        # folder where game-server will be installed.
	BASE_FOLDER="$INSTALL_FOLDER/$MODSUBFOLDER";                # folder where target mod will be located.
	CHECK_CONTROL_FILE="$BASE_FOLDER/install-in-progress.txt";  # file used to prevent update/install conflicts.
	EXCLUDE_LIST_FILE="$BACKUP_CONFIGS_FOLDER/$GAMESERVERID-exclude.txt";	# backup exclusions list file, to put list of stock content into.
	#
	#	Display what server is being installed/updated (excluded generated for) ...
	#
	echo "Game-server selected: [ID=$GAMESERVERID] $SERVERDESC";
	echo "Game-server selected: [ID=$GAMESERVERID] $SERVERDESC" >> "$SCRIPT_LOG_FILE";
	#
	#	Validate game-engine is supported ...
	#
	source $SCRIPTS_FOLDER/include/include-gameengineid.inc;
	#
	#	Build SteamCMd command-line to use to perform the installation/update ...
	#
	case $GAMEENGINE in
		"goldsrc")
			STEAMCMD_COMMAND_LINE="$STEAMCMD_FOLDER/steamcmd.sh +force_install_dir $INSTALL_FOLDER +login $STEAM_LOGIN_USE +app_set_config $APPIDINSTALL mod $MODSUBFOLDER +app_update $APPIDINSTALL $STEAMCMDOPTS +quit";
			STEAMCMD_COMMAND_LINE_SIMULATION="$STEAMCMD_FOLDER/steamcmd.sh +force_install_dir $INSTALL_FOLDER +login $STEAM_LOGIN_USE_SHOW +app_config $APPIDINSTALL mod $MODSUBFOLDER +app_update $APPIDINSTALL $STEAMCMDOPTS +quit";
			;;
		"source")
			STEAMCMD_COMMAND_LINE="$STEAMCMD_FOLDER/steamcmd.sh +force_install_dir $INSTALL_FOLDER +login $STEAM_LOGIN_USE +app_update $APPIDINSTALL $STEAMCMDOPTS +quit";
			STEAMCMD_COMMAND_LINE_SIMULATION="$STEAMCMD_FOLDER/steamcmd.sh +force_install_dir $INSTALL_FOLDER +login $STEAM_LOGIN_USE_SHOW +app_update $APPIDINSTALL $STEAMCMDOPTS +quit";
			;;
		"src2cs2")
			STEAMCMD_COMMAND_LINE="$STEAMCMD_FOLDER/steamcmd.sh +force_install_dir $INSTALL_FOLDER +login $STEAM_LOGIN_USE +app_update $APPIDINSTALL $STEAMCMDOPTS +quit";
			STEAMCMD_COMMAND_LINE_SIMULATION="$STEAMCMD_FOLDER/steamcmd.sh +force_install_dir $INSTALL_FOLDER +login $STEAM_LOGIN_USE_SHOW +app_update $APPIDINSTALL $STEAMCMDOPTS +quit";
			;;
		*)     
			MESSAGE="${ANSI_REDLT}$(figlet "Error:")${ANSI_OFF}\n";
			MESSAGE+="${ANSI_WHITE}Unsupported or unspecified game-engine: ${ANSI_REDLT}$GAMEENGINE${ANSI_OFF}";
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
	#	Check to see if an update is
	#	already in progress ...
	#
	if [ -e "$CHECK_CONTROL_FILE" ]; then
		MESSAGE="${ANSI_REDLT}$(figlet "Error:")${ANSI_OFF}\n";
		MESSAGE+="${ANSI_WHITE}Game install or update already in progress!${ANSI_OFF}\n${ANSI_WHITE}Aborting this update attempt.${ANSI_OFF}";
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
	#	Build a temporary text file
	#	(update-in-progress.txt) used
	#	for update-check control ...
	#
	echo "Exclude attept initiated for $GAMESERVERID at $(date)" 2>/dev/null 1> "$CHECK_CONTROL_FILE";
	#
	#	If in verbose mode, display and log some extra stuff ...
	#
	if [ "$SCRIPTS_VERBOSE" == true ]; then
		echo -e "Information being used to attempt this install/update ... ";
		echo -e "Information being used to attempt this install/update ... " >> "$SCRIPT_LOG_FILE";
		echo -e "";
		echo -e "" >> "$SCRIPT_LOG_FILE";
		echo -e "Information:                   Value:";
		echo -e "Information:                   Value:" >> "$SCRIPT_LOG_FILE";
		echo -e "-----------                    -----";
		echo -e "-----------                    -----" >> "$SCRIPT_LOG_FILE";
		echo -e "Game-server this is for:       $GAMESERVERID";
		echo -e "Game-server this is for:       $GAMESERVERID" >> "$SCRIPT_LOG_FILE";
		echo -e "Sub-folder where game is:      $MODSUBFOLDER";
		echo -e "Sub-folder where game is:      $MODSUBFOLDER" >> "$CHECK_CONTROL_FILE";
		echo -e "Game AppID to install:         $APPIDINSTALL";
		echo -e "Game AppID to install:         $APPIDINSTALL" >> "$SCRIPT_LOG_FILE";
		echo -e "Game-server description:       $SERVERDESC";
		echo -e "Game-server description:       $SERVERDESC" >> "$SCRIPT_LOG_FILE";
		echo -e "Folder where SteamCMD is:      $STEAMCMD_FOLDER";
		echo -e "Folder where SteamCMD is:      $STEAMCMD_FOLDER" >> "$SCRIPT_LOG_FILE";
		echo -e "Folder where scripts are:      $SCRIPTS_FOLDER";
		echo -e "Folder where scripts are:      $SCRIPTS_FOLDER" >> "$SCRIPT_LOG_FILE";
		echo -e "Base folder where game is:     $BASE_FOLDER";
		echo -e "Base folder where game is:     $BASE_FOLDER" >> "$SCRIPT_LOG_FILE";
		echo -e "Log file for this update:      $SCRIPT_LOG_FILE";
		echo -e "Log file for this update:      $SCRIPT_LOG_FILE" >> "$SCRIPT_LOG_FILE";
		echo -e "Update check-control file:     $CHECK_CONTROL_FILE";
		echo -e "Update check-control file:     $CHECK_CONTROL_FILE" >> "$SCRIPT_LOG_FILE";
		echo -e "SteamCMD command and options:  $STEAMCMD_COMMAND_OPTIONS";
		echo -e "SteamCMD command and options:  $STEAMCMD_COMMAND_OPTIONS" >> "$SCRIPT_LOG_FILE";
		echo -e "Contents of steam.inf file, BEFORE intalling/updating ...";
		echo -e "Contents of steam.inf file, BEFORE intalling/updating ..." >> "$SCRIPT_LOG_FILE";	
		cat $BASE_FOLDER/steam.inf;
		cat $BASE_FOLDER/steam.inf >> "$SCRIPT_LOG_FILE";
		echo -e "";
		echo -e "" >> "$SCRIPT_LOG_FILE";
	fi;
	#
	#	Display the full SteamCMD command-line that will be used ...
	#
	echo -e "Full command-line to send to SteamCMD:";
	echo -e "Full command-line to send to SteamCMD:" >> "$SCRIPT_LOG_FILE";
	echo -e "$STEAMCMD_COMMAND_LINE_SIMULATION";
	echo -e "$STEAMCMD_COMMAND_LINE_SIMULATION" >> "$SCRIPT_LOG_FILE";
	#
	#	Install / update the game-server to the latest version ...
	#
	cd $STEAMCMD_FOLDER 1>/dev/null 2>&1;
	nice -n 19 $STEAMCMD_COMMAND_LINE;
	#
	#	If in verbose mode, display and log some extra stuff ...
	#
	if [ "$SCRIPTS_VERBOSE" == true ]; then
		echo "Contents of steam.inf file, AFTER intalling/updating ...";
		echo "Contents of steam.inf file, AFTER intalling/updating ..." >> "$SCRIPT_LOG_FILE";
		cat $BASE_FOLDER/steam.inf;
		cat $BASE_FOLDER/steam.inf >> "$SCRIPT_LOG_FILE";
		echo -e "";
		echo -e "" >> "$SCRIPT_LOG_FILE";
	fi;
	#
	#	Remove the temporary text file
	#	used for update-check control ...
	#
	rm $CHECK_CONTROL_FILE 1>/dev/null 2>&1;
	#
	#	Display size of intalled game ..
	#
	echo -e "Size of temporary installation:\n$(du -h -s $INSTALL_FOLDER/)";
	echo -e "Size of temporary installation:\n$(du -h -s $INSTALL_FOLDER/)" >> "$SCRIPT_LOG_FILE";
	#
	#	Generate the exclude file based on the content of this new "stock" game-server installation ...
	#
	echo "Generating an updated exclude file ...";
	echo "Generating an updated exclude file ..." >> "$SCRIPT_LOG_FILE";
	cd $BASE_FOLDER/; 
	tree -f --noreport -i -n | sed "s,\.\/,$GAMESERVERID\/$MODSUBFOLDER\/," | grep "\." | sed '1d' | grep -Ev '.cfg|.txt|.ini' > $EXCLUDE_LIST_FILE;
	cat $BACKUP_CONFIGS_FOLDER/global-exclude.txt >> $EXCLUDE_LIST_FILE;
	#
	#	Conditionally, purge the temp installation ...
	#
	if [ "$PURGE_TEMP_INSTALLS" == true ]; then
			echo "Purging the temporary game installation ...";
			echo "Purging the temporary game installation ..." >> "$SCRIPT_LOG_FILE";
			rm -Rf $INSTALL_FOLDER >/dev/null 2>&1;
			echo -e "";
			echo -e "" >> "$SCRIPT_LOG_FILE";
		else
 			echo "NOT purging the temporary game installation.";
			echo "NOT purging the temporary game installation." >> "$SCRIPT_LOG_FILE";       
	fi;
	#
	#	If in verbose mode, display and log some extra stuff ...
	#
	if [ "$SCRIPTS_VERBOSE" == true ]; then
		cat $EXCLUDE_LIST_FILE | more;
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
