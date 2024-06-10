#bin/bash
#
#	----------------------------------------------------------------------------
#	Dispaly standard action beginning message ...
#	============================================================================
#	Created:       2024-06-09, by Weasel.SteamID.155@gMail.com        
#	Last modified: 2024-06-09, by Weasel.SteamID.155@gMail.com
#	----------------------------------------------------------------------------
#
#	Capture the time the scipt started in date-serial form ...
#	
SCRIPT_DATESERIAL_START=$(date +%s);
#
#	If verbose is on, display progress notification ...
#
if [ "$SCRIPTS_VERBOSE" == true ]; then
	MESSAGE="[Processing include file: ${ANSI_CYANLT}include-actionbegin.inc${ANSI_OFF} (via ${ANSI_WHITE}${0##*/}${ANSI_OFF})${ANSI_OFF}]";
	if [ -t 1 ]; then
			echo -e "$MESSAGE";
            	else
			echo -e "$MESSAGE" | ansi2txt;
    fi;
fi;
#
#	Dispaly standard output beginning message ...
#
DIVIDERLINE="+-----------------------------------------------------------------------------+";
OUPUTCONTENT="Begin: ${ANSI_CYANLT}${0##*/}${ANSI_OFF}, at ${ANSI_WHITE}$(date)${ANSI_OFF}";
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
if [[ $ACTION_LOG_FILE ]]; then
    echo -e "$DIVIDERLINE\n$PADDED_OUTPUT_NOANSI\n$DIVIDERLINE" >> "$ACTION_LOG_FILE";
fi;
#
#	If verbose is on, display progress notification ...
#
if [ "$SCRIPTS_VERBOSE" == true ]; then
	MESSAGE="[Finished include file: ${ANSI_CYANLT}include-actionbegin.inc${ANSI_OFF} (via ${ANSI_WHITE}${0##*/}${ANSI_OFF})${ANSI_OFF}]";
	if [ -t 1 ]; then
			echo -e "$MESSAGE";
            	else
			echo -e "$MESSAGE" | ansi2txt;
    fi;
fi;
#
#	... thats all folks!
#
