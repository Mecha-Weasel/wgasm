#!/bin/bash
#
#	----------------------------------------------------------------------------
#	Paint a specified game-server, with a specified game-stencil
#	============================================================================
#	Created:       2024-05-26, by Weasel.SteamID.155@gMail.com        
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
#			The game-server to "paint" a game-stencil onto.
#			
#		gamestencilid
#	
#			The game-stencil identifier to be "painted" on the game-server.
#		
#		Example:
#		
#				./game-server-paint.sh gameserverid gamestencilid;
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
#	Grab command-line parameter GAMESTENCILID...
#
GAMESERVERID=$1;
#
#	Determine script log file ...
#
SCRIPT_LOG_FILE="$LOGS_FOLDER/$GAMESERVERID-paint.log";
#
#	Display start of stuff ...
#
source $SCRIPTS_FOLDER/include/include-outputbegin.inc;
#	
#	Process/validate parameter GAMESERVERID ...
#
source $SCRIPTS_FOLDER/include/include-gameserverid.inc;
#
#	Retrive data from game-servers table for specific GAMESERVERID ...
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
#	Store a copy of GAMETYPEID from the matching game-servers record ..
#
SERVER_GAMETYPEID=$GAMETYPEID;
#
#	Grab command-line parameter GAMESTENCILID...
#	
GAMESTENCILID=$2;
#	
#		Process/validate parameter GAMESTENCILID ...
#
source $SCRIPTS_FOLDER/include/include-gamestencilid.inc;
#
#		Retrive data from game-stencils table for specific GAMESTENCILID ...
#	
source $SCRIPTS_FOLDER/include/include-gamestencilfields.inc;
#
#	Store a copy of GAMETYPEID from the matching game-stencils record ..
#
STENCIL_GAMETYPEID=$GAMETYPEID;
#
#	Define some variables ...
#
INPUT_FILE="$STENCILS_FOLDER/$STENCILFILE";
PAINT_FOLDER="$SERVERS_INSTALL_FOLDER/$GAMESERVERID/$MODSUBFOLDER";
PAINT_COMMAND="nice -n 19 7za x -mmt=off -aoa -o$PAINT_FOLDER -w$TEMP_FOLDER $INPUT_FILE"
#
#		Validate that game-stencil is valid for this game-type ...
#
if [ "$SERVER_GAMETYPEID" != "$STENCIL_GAMETYPEID" ]; then
	MESSAGE="${ANSI_REDLT}$(figlet "Error:")${ANSI_OFF}\n";
	MESSAGE+="${ANSI_WHITE}Mis-match between server game-type (${ANSI_REDLT}$SERVER_GAMETYPEID${ANSI_OFF})${ANSI_WHITE} and stensil game-type (${ANSI_REDLT}$STENCIL_GAMETYPEID${ANSI_OFF})!";
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
#	Display that is painted onto where ...
#
echo -e "Game-server to 'paint' the stencil on: [ID=$GAMESERVERID]";
echo -e "Game-server to 'paint' the stencil on: [ID=$GAMESERVERID]" >> "$SCRIPT_LOG_FILE";
echo -e "Game-stencil to 'paint' with:          [ID=$GAMESTENCILID]";
echo -e "Game-stencil to 'paint' with:          [ID=$GAMESTENCILID]" >> "$SCRIPT_LOG_FILE";
echo -e "Temp folder (for zipping process):     $TEMP_FOLDER";
echo -e "Temp folder (for zipping process):     $TEMP_FOLDER" >> "$SCRIPT_LOG_FILE";
echo -e "Input File:                            $INPUT_FILE";
echo -e "Input File:                            $INPUT_FILE" >> "$SCRIPT_LOG_FILE";
echo -e "Paint Folder:                          $PAINT_FOLDER";
echo -e "Paint Folder:                          $PAINT_FOLDER" >> "$SCRIPT_LOG_FILE";
echo -e "";
echo -e "" >> "$SCRIPT_LOG_FILE";
#
#	Display BEFORE infomation ...
#
echo -e "Stats/Details BEFORE painting:";
echo -e "Stats/Details BEFORE painting:" >> "$SCRIPT_LOG_FILE";
echo -e "Size of server install:                $(du -h -s $SERVERS_INSTALL_FOLDER/$GAMESERVERID)";
echo -e "Size of server install:                $(du -h -s $SERVERS_INSTALL_FOLDER/$GAMESERVERID)" >> "$SCRIPT_LOG_FILE";
echo -e "Size of server game/mod folder:        $(du -h -s $PAINT_FOLDER)";
echo -e "Size of server game/mod folder:        $(du -h -s $PAINT_FOLDER)" >> "$SCRIPT_LOG_FILE";
echo -e "Stats for server install:              $(tree $SERVERS_INSTALL_FOLDER/$GAMESERVERID | tail -n 1)";
echo -e "Stats for server install:              $(tree $SERVERS_INSTALL_FOLDER/$GAMESERVERID | tail -n 1)" >> "$SCRIPT_LOG_FILE";
echo -e "Stats for server game/mod folder:      $(tree $PAINT_FOLDER | tail -n 1)";
echo -e "Stats for server game/mod folder:      $(tree $PAINT_FOLDER | tail -n 1)" >> "$SCRIPT_LOG_FILE";
#
#	If in verbose mode, display and log some extra stuff ...
#
if [ "$SCRIPTS_VERBOSE" == true ]; then
	echo -e "Details for this paint process ... ";
	echo -e "Tempory folder (for zipping process): $TEMP_FOLDER";
	echo -e "Input File:                           $INPUT_FILE";
    echo -e "Paint Folder:                         $PAINT_FOLDER"
fi;
#
#	Change to the working directory ...
#
cd $PAINT_FOLDER 2>/dev/null;
#
#	Paint the server with the stencil ...
#
echo -e "";
echo -e "" >> "$SCRIPT_LOG_FILE";
echo -e "Paint command being used:";
echo -e "Paint command being used:" >> "$SCRIPT_LOG_FILE";
echo -e "$PAINT_COMMAND";
echo -e "$PAINT_COMMAND" >> "$SCRIPT_LOG_FILE";
echo -e "";
echo -e "" >> "$SCRIPT_LOG_FILE";
echo -e "Painting the server with stencil ...";
echo -e "Painting the server with stencil ..." >> "$SCRIPT_LOG_FILE";
$PAINT_COMMAND >> "$SCRIPT_LOG_FILE";
echo -e "";
echo -e "" >> "$SCRIPT_LOG_FILE";
#
#	Display (some) of the restore result ...
#
if [ "$SCRIPTS_VERBOSE" == true ]; then
		#
        #	If in verbose mode, display full directory listing ..
        #
        echo -e " Listing painted folder ... ";
		echo -e " Listing painted folder ... " >> "$SCRIPT_LOG_FILE";
		tree --dirsfirst $PAINT_FOLDER 2>/dev/null;
		tree --dirsfirst $PAINT_FOLDER 2>/dev/null >> "$SCRIPT_LOG_FILE";
	else
    	#
        #	If NOT in verbose mode, only send directory tree to log file ..
        #
        echo -e " Listing painted folder ... " >> "$SCRIPT_LOG_FILE";
		tree --dirsfirst $PAINT_FOLDER 2>/dev/null >> "$SCRIPT_LOG_FILE";
fi;
#
#	Display AFTER infomation ...
#
echo -e "Stats/Details AFTER painting:";
echo -e "Stats/Details AFTER painting:" >> "$SCRIPT_LOG_FILE";
echo -e "Size of server install:                $(du -h -s $SERVERS_INSTALL_FOLDER/$GAMESERVERID)";
echo -e "Size of server install:                $(du -h -s $SERVERS_INSTALL_FOLDER/$GAMESERVERID)" >> "$SCRIPT_LOG_FILE";
echo -e "Size of server game/mod folder:        $(du -h -s $PAINT_FOLDER)";
echo -e "Size of server game/mod folder:        $(du -h -s $PAINT_FOLDER)" >> "$SCRIPT_LOG_FILE";
echo -e "Stats for server install:              $(tree $SERVERS_INSTALL_FOLDER/$GAMESERVERID | tail -n 1)";
echo -e "Stats for server install:              $(tree $SERVERS_INSTALL_FOLDER/$GAMESERVERID | tail -n 1)" >> "$SCRIPT_LOG_FILE";
echo -e "Stats for server game/mod folder:      $(tree $PAINT_FOLDER | tail -n 1)";
echo -e "Stats for server game/mod folder:      $(tree $PAINT_FOLDER | tail -n 1)" >> "$SCRIPT_LOG_FILE";
#
#	Display end of stuff ...
#
source $SCRIPTS_FOLDER/include/include-outputend.inc;
#
#	... thats all folks!
#
