#!/bin/bash
#
#	----------------------------------------------------------------------------
#	Games-related scheduled maintenance: DAILY
#	============================================================================
#	Created:       2024-03-06, by Weasel.SteamID.155@gMail.com        
#	Last modified: 2024-06-04 by Weasel.SteamID.155@gMail.com
#	----------------------------------------------------------------------------
#	
#	Purpose:
#	
#		A script intended to be invoked from a scheduled "cron" job, to perform
#		various maintenace tasks on a DAILY basis.
#		
#		This typically would include script backups, and (if desirably) preemptive
#		DAILY restarts of the game-servers to avoid crashes during busy hours,
#		and perhaps some additional log clean-up.
#
#	NOTE: Be certain to ensure this script runs as the correct Linux user -
#	      whatever account all the game-server instances are running under!
#	      
#	----------------------------------------------------------------------------
#
#	\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
#	 DAILY maintenance stuff starts after here ...
#	//////////////////////////////////////////
#
#		Backup scripts ...
#
$HOME/weaselsscripts/game-server-backup.sh weaselsscripts;
#
#		Backup just data seperatedly also (config.txt, data folder, backup-configs, etc.) ...
#
$HOME/weaselsscripts/game-server-backup.sh data;
#
#		Restart various game-servers ...
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
#	... DAILY maintenance stuff ends before here.
#	    \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
#
#	Display end of stuff ...
#
source $HOME/weaselsscripts/include/include-outputend.inc;
#
#	... thats all folks!
#
exit;