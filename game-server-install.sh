#!/bin/bash
#
#	----------------------------------------------------------------------------
#	Install game-server(s), using information from the data-files.
#	============================================================================
#	Created:       2024-05-18, by Weasel.SteamID.155@gMail.com	
#	Last modified: 2024-05-28, by Weasel.SteamID.155@gMail.com
#	----------------------------------------------------------------------------
#
#	Purpose:
#	
#		Install a dedicated game-server instance.
#		Does NOT check if the existing instance may already be latest version.
#		Does NOT stop any instance already running.
#		Does NOT restart any instance after completion.
#		Accepts multiple gameserverids in the same command-line.
#
#	Usage / command-line parameters:
#	
#		gameserverid
#	
#			The game-server identifier(s) for the game-server(s) to install.
#		
#			Example:
#		
#				./game-server-install.sh gameserverid1 gameserverid2 gameserveridN;
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
	SCRIPT_LOG_FILE="$LOGS_FOLDER/$GAMESERVERID-install.log";
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
	INSTALL_FOLDER="$SERVERS_INSTALL_FOLDER/$GAMESERVERID";     # folder where game-server will be installed.
	BASE_FOLDER="$INSTALL_FOLDER/$MODSUBFOLDER";                # folder where target mod will be located.
	CHECK_CONTROL_FILE="$BASE_FOLDER/install-in-progress.txt";  # file used to prevent update/install conflicts.
	#
	#	Display what server is being installed/updated ...
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
			STEAMCMD_COMMAND_LINE_SIMULATION="$STEAMCMD_FOLDER/steamcmd.sh +force_install_dir $INSTALL_FOLDER +login $STEAM_LOGIN_USE_SHOW +app_set_config $APPIDINSTALL mod $MODSUBFOLDER +app_update $APPIDINSTALL $STEAMCMDOPTS +quit";
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
			#
			#	Display a notification that there
			#	is already an update in progress ...
			#
			MESSAGE="${ANSI_REDLT}$(figlet "Error:")${ANSI_OFF}\n";
			MESSAGE+="${ANSI_WHITE}Game install or update already in progress!${ANSI_OFF}\n${ANSI_WHITE}Aborting this update attempt.${ANSI_OFF}";
			echo -e "$MESSAGE";
			if [[ $SCRIPT_LOG_FILE ]]; then
				echo -e "$MESSAGE" | ansi2txt >> "$SCRIPT_LOG_FILE";
			fi;
		else
			#
			#	Build a temporary text file
			#	(update-in-progress.txt) used
			#	for update-check control ...
			#
			echo "Update attempt initiated on $GAMESERVERID at $(date)" > "$CHECK_CONTROL_FILE";
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
	        fi;
            #
            #	Display size of intalled game ..
            #
            echo -e "Size of game-server installation (including any mods):\n$(du -h -s $INSTALL_FOLDER/)";
            echo -e "Size of game-server installation (including any mods):\n$(du -h -s $INSTALL_FOLDER/)" >> "$SCRIPT_LOG_FILE";
            #
	        #
			#	Fix any permissions that SteamCMD may have messed-up ...
			#
			case $GAMEENGINE in
				"goldsrc")
					chmod -R 744 $INSTALL_FOLDER > /dev/null 2>&1;
					chmod +x $INSTALL_FOLDER/hlds_* > /dev/null 2>&1;
					chmod +x $INSTALL_FOLDER/bin/vpk_linux32 > /dev/null 2>&1;
	                #
	                #	Just in case MetaMod and AMX-Mod-X are installed ...
	                #
					chmod +x $BASE_FOLDER/addons/amxmodx/scripting/amxxpc > /dev/null 2>&1;
					chmod +x $BASE_FOLDER/addons/amxmodx/scripting/compile.sh > /dev/null 2>&1;
					;;
				"source")
					chmod -R 744 $INSTALL_FOLDER > /dev/null 2>&1;
					chmod +x $INSTALL_FOLDER/srcds_* > /dev/null 2>&1;
	                #
	                #	Just in case MetaMod:Source and SourceMod are installed ...
	                #
					chmod +x $BASE_FOLDER/addons/sourcemod/scripting/spcomp > /dev/null 2>&1;
					chmod +x $BASE_FOLDER/addons/sourcemod/scripting/spcomp64 > /dev/null 2>&1;
					chmod +x $BASE_FOLDER/addons/sourcemod/scripting/compile.sh > /dev/null 2>&1;
					;;
				"src2cs2")
	            	#chmod -R 744 $INSTALL_FOLDER > /dev/null 2>&1;
					#chmod -R +x $INSTALL_FOLDER/*.sh > /dev/null 2>&1;
	                #chmod +x $INSTALL_FOLDER/game/bin/linuxsteamrt64/cs2 > /dev/null 2>&1;
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
			#	Reset various configuration files that
			#	may have been over-written by the update ...
			#
			#	If the CUSTOMIZATION folder (all upper-case) exists,
			#	copy any customized files staged there back into the
			#	folder above - overwriting anything problematic ...
			#
			case $GAMEENGINE in
				"goldsrc")
					cp -fR $BASE_FOLDER/CUSTOMIZATION/* $BASE_FOLDER/ > /dev/null 2>&1;
					;;
				"source")
					cp -fR $BASE_FOLDER/CUSTOMIZATION/* $BASE_FOLDER/ > /dev/null 2>&1;
					cp -fR $BASE_FOLDER/cfg/CUSTOMIZATION/* $BASE_FOLDER/cfg/ > /dev/null 2>&1;
					;;
				"src2cs2")
					cp -fR $BASE_FOLDER/CUSTOMIZATION/* $BASE_FOLDER/ > /dev/null 2>&1;
					cp -fR $BASE_FOLDER/cfg/CUSTOMIZATION/* $BASE_FOLDER/cfg/ > /dev/null 2>&1;
					;;
				*)
					;;
			esac;	  
			echo "";
			#
			#	Remove the temporary text file
			#	used for update-check control ...
			#
			rm $CHECK_CONTROL_FILE 1>/dev/null 2>&1;
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
