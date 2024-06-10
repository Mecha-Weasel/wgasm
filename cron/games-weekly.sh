#!/bin/bash
#
#	----------------------------------------------------------------------------
#	Games-related scheduled maintenance: WEEKLY
#	============================================================================
#	Created:       2024-03-06, by Weasel.SteamID.155@gMail.com        
#	Last modified: 2024-06-04, by Weasel.SteamID.155@gMail.com
#	----------------------------------------------------------------------------
#
#	Purpose:
#	
#		A script intended to be invoked from a scheduled "cron" job, to perform
#		various maintenace tasks on a WEEKLY basis.
#		
#		This typically would include full server backups, and some log clean-up.
#		
#	NOTE: Be certain to ensure this script runs as the correct Linux user -
#	      whatever account all the game-server instances are running under!
#	      
#	----------------------------------------------------------------------------
#
#	\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
#	 WEEKLY maintenance stuff starts after here ...
#	///////////////////////////////////////////
#	
#		Stop all game-servers, sequencially ...
#
$HOME/weaselsscripts/game-server-stop.sh server0hl1;  # Uncomment the BEGINNING of this line to enable stop of this server.
$HOME/weaselsscripts/game-server-stop.sh server1dmc;  # Uncomment the BEGINNING of this line to enable stop of this server.
$HOME/weaselsscripts/game-server-stop.sh server2tfc;  # Uncomment the BEGINNING of this line to enable stop of this server.
$HOME/weaselsscripts/game-server-stop.sh server3tf2;  # Uncomment the BEGINNING of this line to enable stop of this server.
$HOME/weaselsscripts/game-server-stop.sh server4cs1;  # Uncomment the BEGINNING of this line to enable stop of this server.
$HOME/weaselsscripts/game-server-stop.sh server5css;  # Uncomment the BEGINNING of this line to enable stop of this server.
$HOME/weaselsscripts/game-server-stop.sh server6cs2;  # Uncomment the BEGINNING of this line to enable stop of this server.
$HOME/weaselsscripts/game-server-stop.sh server7dod;  # Uncomment the BEGINNING of this line to enable stop of this server.
$HOME/weaselsscripts/game-server-stop.sh server8dods; # Uncomment the BEGINNING of this line to enable stop of this server.
$HOME/weaselsscripts/game-server-stop.sh server9fof;  # Uncomment the BEGINNING of this line to enable stop of this server.
#
#		Purge some old logs ...
#
echo Purging old some old logs ...
rm -f $HOME/logs/*.log
#
#		Backup scripts ...
#
$HOME/weaselsscripts/game-server-backup.sh weaselsscripts;
#
#		Backup just data seperatedly also (config.txt, data folder, backup-configs, etc.) ...
#
$HOME/weaselsscripts/game-server-backup.sh data;
#
#		Backup game-servers ...
#
#$HOME/weaselsscripts/game-server-backup.sh server0hl1;  # Uncomment the BEGINNING of this line to enable backup of this server.
#$HOME/weaselsscripts/game-server-backup.sh server1dmc;  # Uncomment the BEGINNING of this line to enable backup of this server.
#$HOME/weaselsscripts/game-server-backup.sh server2tfc;  # Uncomment the BEGINNING of this line to enable backup of this server.
#$HOME/weaselsscripts/game-server-backup.sh server3tf2;  # Uncomment the BEGINNING of this line to enable backup of this server.
#$HOME/weaselsscripts/game-server-backup.sh server4cs1;  # Uncomment the BEGINNING of this line to enable backup of this server.
#$HOME/weaselsscripts/game-server-backup.sh server5css;  # Uncomment the BEGINNING of this line to enable backup of this server.
#$HOME/weaselsscripts/game-server-backup.sh server6cs2;  # Uncomment the BEGINNING of this line to enable backup of this server.
#$HOME/weaselsscripts/game-server-backup.sh server7dod;  # Uncomment the BEGINNING of this line to enable backup of this server.
#$HOME/weaselsscripts/game-server-backup.sh server8dods; # Uncomment the BEGINNING of this line to enable backup of this server.
#$HOME/weaselsscripts/game-server-backup.sh server9fof;  # Uncomment the BEGINNING of this line to enable backup of this server.
#
#		Start (or restart) all game-servers, sequencially ...
#
#$HOME/weaselsscripts/game-server-start.sh server0hl1;  # Uncomment the BEGINNING of this line to enable restart of this server.
#$HOME/weaselsscripts/game-server-start.sh server1dmc;  # Uncomment the BEGINNING of this line to enable restart of this server.
#$HOME/weaselsscripts/game-server-start.sh server2tfc;  # Uncomment the BEGINNING of this line to enable restart of this server.
#$HOME/weaselsscripts/game-server-start.sh server3tf2;  # Uncomment the BEGINNING of this line to enable restart of this server.
#$HOME/weaselsscripts/game-server-start.sh server4cs1;  # Uncomment the BEGINNING of this line to enable restart of this server.
#$HOME/weaselsscripts/game-server-start.sh server5css;  # Uncomment the BEGINNING of this line to enable restart of this server.
#$HOME/weaselsscripts/game-server-start.sh server6cs2;  # Uncomment the BEGINNING of this line to enable restart of this server.
#$HOME/weaselsscripts/game-server-start.sh server7dod;  # Uncomment the BEGINNING of this line to enable restart of this server.
#$HOME/weaselsscripts/game-server-start.sh server8dods; # Uncomment the BEGINNING of this line to enable restart of this server.
#$HOME/weaselsscripts/game-server-start.sh server9fof;  # Uncomment the BEGINNING of this line to enable restart of this server.
#
#		Log running game-server processes ...
#
$HOME/weaselsscripts/list-running.sh;
$HOME/weaselsscripts/list-running.sh; >> "$SCRIPT_LOG_FILE";
#
#	    //////////////////////////////////////////
#	... WEEKLY maintenance stuff ends before here.
#	    \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
#
#	... thats all folks!
#
exit;
