#!/bin/bash
#
#	----------------------------------------------------------------------------
#	Re-package standard game-stencils from source into compressed (zip) files
#	============================================================================
#	Created:       2024-05-27, by Weasel.SteamID.155@gMail.com
#	Last modified: 2024-05-27, by Weasel.SteamID.155@gMail.com
#	----------------------------------------------------------------------------
#
#	Figure-out where the scripts folder is located ...
#
SCRIPTS_FOLDER="$( dirname -- "$( readlink -f -- "$0"; )"; )";
#
#	Innclude the base script dependancies ...
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
#	Determine which folders to use ...
#
SOURCE_FOLDER="$STENCILS_FOLDER/source";
OUTPUT_FOLDER="$STENCILS_FOLDER";
#
#	Change to the folder with all then
#	different configuration sub-folders
#	stored inside it ..
#
cd $SOURCE_FOLDER;
#
#	Loop through source folders,
#	compressing the content of each
#	and putting the output zip file
#	in the proper place ...
#
for CONFIGURATION in *; do
	#
	#	Check its really a folder (not a file) ...
	#
    if [ -d "$CONFIGURATION" ]; then
        #
		#	Build the compression command to use ..
		#
		COMPRESS_COMMAND="7za a -tzip -mmt=off -snl $OUTPUT_FOLDER/$CONFIGURATION.zip ./*";
		#
		#	Diplay compression command that will be used ...
		#
		echo "-----------------------";
		echo "Input to be compressed: $CONFIGURATION"
		echo "Compression command being used:"
		echo "$COMPRESS_COMMAND";
		cd $SOURCE_FOLDER/$CONFIGURATION;
		$COMPRESS_COMMAND;
		cd $SOURCE_FOLDER;
		echo "";
    fi;
done;
#
#	... thats all folks!
#
