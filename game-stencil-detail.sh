#!/bin/bash
#
#	----------------------------------------------------------------------------
#	Display information about a game-stencil (long/detailed version)
#	============================================================================
#	Created:       2024-05-26, by Weasel.SteamID.155@gMail.com        
#	Last modified: 2024-05-27, by Weasel.SteamID.155@gMail.com
#	----------------------------------------------------------------------------
#
#	Purpose:
#	
#		Displays all information associated for specific game-stencil.
#		Displays all information about the game-stencils specific game-type.
#
#	Usage / command-line parameters:
#	
#		gamestencilid
#	
#			The game-stencil identifier for the game-stencil information to display.
#		
#			Example:
#		
#				./game-stencil-detail.sh gamestencilid;
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
#	NO script log file ...
#
SCRIPT_LOG_FILE="";
#
#	Display start of stuff ...
#
source $SCRIPTS_FOLDER/include/include-outputbegin.inc;
#
#	Grab command-line parameter (which should be a GAMESERVERID) ...
#	
GAMESTENCILID=$1;
#	
#	Process/validate parameter GAMESERVERID ...
#
source $SCRIPTS_FOLDER/include/include-gamestencilid.inc;
#
#	Retrive data from game-types table for specific GAMESERVERID ...
#	
source $SCRIPTS_FOLDER/include/include-gamestencilfields.inc;
#
#	Display the information gathered ...
#
echo -e "Game-Stencil Information:";
echo -e "========================";
echo -e "ID for stencil-type:           $GAMESTENCILID";
echo -e "ID for game-type:              $GAMETYPEID";
echo -e "Stencil file-name:             $STENCILFILE";
echo -e "Description (for game-type):   $STENCILDESC";
echo -e "Comments (for game-type):      $STENCILCOMMENT";
#	
#	Process/validate parameter GAMETYPEID ...
#
source $SCRIPTS_FOLDER/include/include-gametypeid.inc;
#
#	Retrive data from game-types table for specific GAMETYPEID ...
#	
source $SCRIPTS_FOLDER/include/include-gametypefields.inc;
#
#	Display the information gathered ...
#
echo -e "";
echo -e "Game-Type Information:";
echo -e "=====================";
echo -e "ID for game-type:              $GAMETYPEID";
echo -e "Game-Engine:                   $GAMEENGINE";
echo -e "Steam login (default):         $STEAM_LOGIN_DEFAULT_SHOW";
echo -e "Steam login (this game-type):  $STEAM_LOGIN_SERVER_SHOW"; 
echo -e "Steam login (to use):          $STEAM_LOGIN_USE_SHOW"; 
echo -e "AppID (for installation):      $APPIDINSTALL";
echo -e "AppID (for update check):      $APPIDCHECK";
echo -e "SteamCMD mod-type (if any):    $STEAMCMDMOD";
echo -e "SteamCMD (extra) options:      $STEAMCMDOPTS";
echo -e "Mod Sub-Folder:                $MODSUBFOLDER";
echo -e "Restart warning (text):        $WARNSTOPTEXT";
echo -e "Restart warning (audio):       $WARNSTOPAUDIO";
echo -e "Update warning (text):         $WARNUPDATETEXT";
echo -e "Update warning (audio):        $WARNUPDATEAUDIO";
echo -e "Description (for game-type):   $TYPEDESC";
echo -e "Comments (for game-type):      $TYPECOMMENT";
#
#	Display end of stuff ...
#
source $SCRIPTS_FOLDER/include/include-outputend.inc;
#
#	... thats all folks!
#
