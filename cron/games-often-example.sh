#!/bin/bash
#
#	----------------------------------------------------------------------------
#	Games-related scheduled maintenance: OFTEN (about every 10-20 minutes)
#	============================================================================
#	Created:       2024-04-06, by Weasel.SteamID.155@gMail.com        
#	Last modified: 2024-06-04, by Weasel.SteamID.155@gMail.com
#	----------------------------------------------------------------------------
#
#	Purpose:
#	
#		A script intended to be invoked from a scheduled "cron" job, to perform
#		various maintenace tasks on a FREQUENT basis (every 10, 15 or 20 minutes).
#	
#		This would typically be to run "monitor" scripts that will look to see if
#		any of the servers has encountered "fatal error" or "segmentation fault"
#		conditions, and if so, restart those servers.
#
#	NOTE: Be certain to ensure this script runs as the correct Linux user -
#	      whatever account all the game-server instances are running under!
#	      
#	----------------------------------------------------------------------------
#
#	\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
#	 OFTEN maintenance stuff starts after here ...
#	///////////////////////////////////////////
#
#		Monitor game-servers for fatal conditions ...
#
#$HOME/wgasm/game-server-monitor.sh server0hl1;  # Uncomment the BEGINNING of this line to enable monitoring of this server.
#$HOME/wgasm/game-server-monitor.sh server1dmc;  # Uncomment the BEGINNING of this line to enable monitoring of this server.
#$HOME/wgasm/game-server-monitor.sh server2tfc;  # Uncomment the BEGINNING of this line to enable monitoring of this server.
#$HOME/wgasm/game-server-monitor.sh server3tf2;  # Uncomment the BEGINNING of this line to enable monitoring of this server.
#$HOME/wgasm/game-server-monitor.sh server4cs1;  # Uncomment the BEGINNING of this line to enable monitoring of this server.
#$HOME/wgasm/game-server-monitor.sh server5css;  # Uncomment the BEGINNING of this line to enable monitoring of this server.
#$HOME/wgasm/game-server-monitor.sh server6cs2;  # Uncomment the BEGINNING of this line to enable monitoring of this server.
#$HOME/wgasm/game-server-monitor.sh server7dod;  # Uncomment the BEGINNING of this line to enable monitoring of this server.
#$HOME/wgasm/game-server-monitor.sh server8dods; # Uncomment the BEGINNING of this line to enable monitoring of this server.
#$HOME/wgasm/game-server-monitor.sh server9fof;  # Uncomment the BEGINNING of this line to enable monitoring of this server.
#
#		Log running game-server processes ...
#
$HOME/wgasm/list-running.sh;
$HOME/wgasm/list-running.sh; >> "$SCRIPT_LOG_FILE";
#
#	    //////////////////////////////////////////
#	... OFTEN maintenance stuff ends before here.
#	    \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
#
#	... thats all folks!
#
exit;
