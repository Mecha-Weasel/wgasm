#bin/bash
#
#	----------------------------------------------------------------------------
#	Dispaly standard output ending message ...
#	============================================================================
#	Created:       2024-05-21, by Weasel.SteamID.155@gMail.com        
#	Last modified: 2024-05-29, by Weasel.SteamID.155@gMail.com
#	----------------------------------------------------------------------------
#
#	Capture the time the scipt ended in date-serial form ...
#	
SCRIPT_DATESERIAL_END=$(date +%s);
#
#	Calculate how-long the script was running ...
#	
if [[ $SCRIPT_DATESERIAL_START ]]; then
		SCRIPT_DATESERIAL_DURATION=$(( $SCRIPT_DATESERIAL_END - $SCRIPT_DATESERIAL_START )); 
    else
    	SCRIPT_DATESERIAL_DURATION="";
fi;
#
#	If verbose is on, display progress notification ...
#
if [ "$SCRIPTS_VERBOSE" == true ]; then
	MESSAGE="[Processing include file: ${ANSI_CYANLT}include-outputend.inc${ANSI_OFF} (via ${ANSI_WHITE}${0##*/}${ANSI_OFF})${ANSI_OFF}]";
	if [ -t 1 ]; then
			echo -e "$MESSAGE";
            	else
			echo -e "$MESSAGE" | ansi2txt;
    fi;
fi;
#
#	Dispaly standard output ending message ...
#
if [[ $SCRIPT_DATESERIAL_DURATION ]]; then
		OUPUTCONTENT="End: ${ANSI_CYANLT}${0##*/}${ANSI_OFF}, at ${ANSI_WHITE}$(date) ($SCRIPT_DATESERIAL_DURATION secs)${ANSI_OFF}";
	else
		OUPUTCONTENT="End: ${ANSI_CYANLT}${0##*/}${ANSI_OFF}, at ${ANSI_WHITE}$(date)${ANSI_OFF}";
fi;
DIVIDERLINE="+-----------------------------------------------------------------------------+";
DIVIDERLINE_LENGTH=${#DIVIDERLINE};
OUPUTCONTENT_NOANSI=$(echo -e "$OUPUTCONTENT" | ansi2txt);
OUPUTCONTENT_LENGTH=${#OUPUTCONTENT_NOANSI};
PAD_LENGTH=$(( $DIVIDERLINE_LENGTH - $(( $OUPUTCONTENT_LENGTH + 4 )) ));
OUTPUTPAD=$(printf '%*s' $PAD_LENGTH);
PADDED_OUTPUT="| $OUPUTCONTENT$OUTPUTPAD |";
PADDED_OUTPUT_NOANSI="| $OUPUTCONTENT_NOANSI$OUTPUTPAD |";
if [ -t 1 ]; then
    	echo -e "$DIVIDERLINE\n$PADDED_OUTPUT\n$DIVIDERLINE";
	else
		echo -e "$DIVIDERLINE\n$PADDED_OUTPUT_NOANSI\n$DIVIDERLINE"; 
fi;
if [[ $SCRIPT_LOG_FILE ]]; then
    echo -e "$DIVIDERLINE\n$PADDED_OUTPUT_NOANSI\n$DIVIDERLINE" >> "$SCRIPT_LOG_FILE";
fi;
#
#	If verbose is on, display progress notification ...
#
if [ "$SCRIPTS_VERBOSE" == true ]; then
    MESSAGE="[Finished include file: ${ANSI_CYANLT}include-outputend.inc${ANSI_OFF} (via ${ANSI_WHITE}${0##*/}${ANSI_OFF})${ANSI_OFF}]";
	if [ -t 1 ]; then
			echo -e "$MESSAGE";
            	else
			echo -e "$MESSAGE" | ansi2txt;
    fi;
fi;
#
#	... thats all folks!
#
