#bin/bash
#
#	----------------------------------------------------------------------------
#	display the "Weasels Scripts" ACSI-text banner (if enabled)
#	============================================================================
#	Created:       2024-05-21, by Weasel.SteamID.155@gMail.com        
#	Last modified: 2024-05-27, by Weasel.SteamID.155@gMail.com
#	----------------------------------------------------------------------------
#
#	USAGE NOTES:
#
#		Includes optional display banner, controlled by option in config file.
#
#	----------------------------------------------------------------------------
#
#	Include the ANSI escape code definitions ...
#	
source $SCRIPTS_FOLDER/include/include-ansi.inc;
#
#	If banner display is enabled, display it ...
#
if [ "$DISPLAY_BANNER" == true ]; then
	if [ -t 1 ]; then
    		echo -e "$(cat -v $BANNER_FILE)";
		else
			echo -e "$(cat -v $BANNER_FILE)" | ansi2txt;
	fi;
fi;
#
#	... thats all folks!
#
