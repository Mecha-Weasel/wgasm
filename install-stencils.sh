#!/bin/bash
#
#	----------------------------------------------------------------------------
#	Install example stencils (using folder specified in the config file)
#	============================================================================
#	Created:       2024-06-04, by Weasel.SteamID.155@gMail.com
#	Last modified: 2024-06-13, by Weasel.SteamID.155@gMail.com
#	----------------------------------------------------------------------------
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
#	NO script log file ...
#
SCRIPT_LOG_FILE="";
#
#	Display start of stuff ...
#
source $SCRIPTS_FOLDER/include/include-outputbegin.inc;
#
#	Dsplay some stuff ...
#
echo -e "Important configuration options:";
echo -e "";
echo -e "Option:                       Value:";
echo -e "----------------------------  -----";
echo -e "Config file:                  $CONFIG_FILE";
echo -e "Stencils folder:              $STENCILS_FOLDER";
#
#	Download and install example Stencils ...
#
STENCILS_FILE="stencils-latest.tar.gz";
#STENCILS_DOWNLOAD="https://www.dropbox.com/scl/fi/xoju4edvpawf53795v7mq/stencils-latest.tar.gz?rlkey=ff0cmv21spjffpxss0smr4zve&st=zjmcm2tc&&dl=1";
STENCILS_DOWNLOAD="$(cat ./stencils-dropbox.url)";
cd $STENCILS_FOLDER 2> /dev/null > /dev/null;
echo -e "";
echo -e "Downloading $STENCILS_FILE from DropBox (this may take a long time) ...";
wget --no-check-certificate -o /dev/null -O $STENCILS_FILE $STENCILS_DOWNLOAD;wait;
if [[ "$?" -gt 0 ]]; then
	TEST_ERROR_CHECK=true;
fi;
if [[ "$?" == 0 ]]; then
		echo -e "Download: ${ANSI_GREENLT}Successful.${ANSI_OFF}"
	else
		{ echo -e "Download: ${ANSI_REDLT}FAILED!${ANSI_OFF}"; TEST_ERROR_CHECK=true; };
fi;
echo -e "Size of stencils archive:           $(du -h -s $STENCILS_FOLDER/$STENCILS_FILE;)";
echo -e "Extracting the contents of $STENCILS_FILE to default folder ($STENCILS_FOLDER) ...";
tar -xzf $STENCILS_FILE;
if [[ "$?" -gt 0 ]]; then
	TEST_ERROR_CHECK=true;
fi;
if [[ "$?" == 0 ]]; then
		echo -e "Extraction: ${ANSI_GREENLT}Successful.${ANSI_OFF}"
else
		{ echo -e "Extraction: ${ANSI_REDLT}FAILED!${ANSI_OFF}"; TEST_ERROR_CHECK=true; };
fi;
echo -e "Size of 'stencils' folder:          $(du -h -s $STENCILS_FOLDER;)";
echo -e "Stats for 'stencils' folder:        $(tree $STENCILS_FOLDER | tail -n 1)";
echo -e "Deleting cached archive file ($STENCILS_FILE) ...";
rm -f $STENCILS_FILE 2> /dev/null > /dev/null;
#
#	If any of checks failed, display an error messsage ...
#
if [[ $TEST_ERROR_CHECK == true ]]; then
		MESSAGE="${ANSI_REDLT}ERROR:${ANSI_OFF}\n";
		MESSAGE+="${ANSI_WHITE}Something went wrong!${ANSI_OFF}";
		echo -e "\n$MESSAGE\n";
		exit 1;
	else
		MESSAGE="${ANSI_GREENLT}PASSED:${ANSI_OFF}\n";
		MESSAGE+="${ANSI_WHITE}Everything looks good (so far)!${ANSI_OFF}";
		echo -e "\n$MESSAGE\n";
fi;
#
#	Display end of stuff ...
#
source $SCRIPTS_FOLDER/include/include-outputend.inc;
#
#	... thats all folks!
#

