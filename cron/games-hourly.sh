#!/bin/bash
#
#	----------------------------------------------------------------------------
#	Games-related scheduled maintenance: HOURLY
#	============================================================================
#	Created:       2024-03-08, by Weasel.SteamID.155@gMail.com        
#	Last modified: 2024-06-04, by Weasel.SteamID.155@gMail.com
#	----------------------------------------------------------------------------
#
#	Purpose:
#	
#		A script intended to be invoked from a scheduled "cron" job, to perform
#		various maintenace tasks on a HOURLY basis.
#		
#		This typically would include checking for any applicable updates to the
#		game servers, and if so, automatically stop the servers, apply the updates,
#		and restart the game-servers.
#
#	NOTE: Be certain to ensure this script runs as the correct Linux user -
#	      whatever account all the game-server instances are running under!
#	      
#	----------------------------------------------------------------------------
#
#	\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
#	 HOURLY maintenance stuff starts after here ...
#	///////////////////////////////////////////
#
#		Check game-servers for unapplied updates ....
#
#$HOME/weaselsscripts/game-server-check.sh server0hl1;  # Uncomment the BEGINNING of this line to enable check of this server.
#$HOME/weaselsscripts/game-server-check.sh server1dmc;  # Uncomment the BEGINNING of this line to enable check of this server.
#$HOME/weaselsscripts/game-server-check.sh server2tfc;  # Uncomment the BEGINNING of this line to enable check of this server.
#$HOME/weaselsscripts/game-server-check.sh server3tf2;  # Uncomment the BEGINNING of this line to enable check of this server.
#$HOME/weaselsscripts/game-server-check.sh server4cs1;  # Uncomment the BEGINNING of this line to enable check of this server.
#$HOME/weaselsscripts/game-server-check.sh server5css;  # Uncomment the BEGINNING of this line to enable check of this server.
#$HOME/weaselsscripts/game-server-check.sh server6cs2;  # Uncomment the BEGINNING of this line to enable check of this server.
#$HOME/weaselsscripts/game-server-check.sh server7dod;  # Uncomment the BEGINNING of this line to enable check of this server.
#$HOME/weaselsscripts/game-server-check.sh server8dods; # Uncomment the BEGINNING of this line to enable check of this server.
#$HOME/weaselsscripts/game-server-check.sh server9fof;  # Uncomment the BEGINNING of this line to enable check of this server.
#
#		Log running game-server processes ...
#
$HOME/weaselsscripts/list-running.sh;
$HOME/weaselsscripts/list-running.sh; >> "$SCRIPT_LOG_FILE";
#
#	    //////////////////////////////////////////
#	... HOURLY maintenance stuff ends before here.
#	    \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
#
#	... thats all folks!
#
exit;
