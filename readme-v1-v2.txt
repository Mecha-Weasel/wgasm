+----------------------------------------------------------------------+
| Weasel's Game-Administrator / Server-Manager (wGASM), for Linux - v2 |
|  __        __                  _ _        ____    _    ____  __  __  |
|  \ \      / /__  __ _ ___  ___| ( )___   / ___|  / \  / ___||  \/  | |
|   \ \ /\ / / _ \/ _` / __|/ _ \ |// __| | |  _  / _ \ \___ \| |\/| | |
|    \ V  V /  __/ (_| \__ \  __/ | \__ \ | |_| |/ ___ \ ___) | |  | | |
|     \_/\_/ \___|\__,_|___/\___|_| |___/  \____/_/   \_\____/|_|  |_| |
+----------------------------------------------------------------------+
| DGitHub Repo's https://github.com/Mecha-Weasel                       |
| DE-Mail        Weasel.SteamID.155@gMail.com                          |
| DDiscord       https://discordapp.com/users/weasel.steamid.155       |
| DSteam Profile https://steamcommunity.com/id/Weasel/                 |
| DSteam (perm)  https://steamcommunity.com/profiles/76561197960266039 |
+----------------------------------------------------------------------+


\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
| Changes from older (now-retroactively v1.x) scripts:                 |
///////////////////////////////////////////////////////////\////////////

A lot has changed between the 1st generation (v1.x) and 2nd generation (v2.x)
of these scripts.  This includes changes such as:

	* New default folder(s), and automatic folder detection.
	* New central configuration file for various options.
	* Re-usable portions of code moved to "source include" files.
	* Now driven by config file, and data "tables".
	* Now has a script available the "prepare" the OS for installation.
	* Now has a script that will perform the "install" (after OS prepared).

+----------------------------------------------------------------------+
| Related Guide on Steam Community:                                    |
+----------------------------------------------------------------------+

Weasel's Dedicated-Server Management System, v2 (for Linux)
https://steamcommunity.com/sharedfiles/filedetails/?id=3259278773

+----------------------------------------------------------------------+
| Purpose of each (one-time-use) script:                               |
+----------------------------------------------------------------------+

Several scripts are provided strictly for initial setup purposes, and to not
perform any direct action on the game-servers themselves.  These include:

* prepare-debian.sh          Run as "root", prepares OS for installation.
* install-wgasm.sh  Run as "game-servers", installs the system.
* install-steamcmd.sh        Run as "game-servers", installs SteamCMD.
* install-stencils.sh        Run as "game-servers", installs Stencils.

The "Prepare" script (prepare-debian.sh):

	The "Prepare" script is the only script that *MUST* be run logged-into
	Linux as either literally the "root" user, or as another user with
	equivalent admin privileges using the "sudo" function. * NONE* of the
	other scripts should ever be run under "root" or a "sudo" user!

	This script may be invoked with an optional command-line parameter
	to assuming "yes" to all interactive prompts.  This feature is known
	as "Nike Mode" or "Just Do It!".  The parameter is used like this:

		./prepare-debian.sh --nike;

	The "Prepare" script will perform several functions automating as much
	of the process as possible.  These functions include:

	* Ensure you are running a supported Linux OS (i.e. Debian family).
	* Enabling 32-bit architecture/library support.
	* Installing various "packages" for commands/utilities required.
	* Testing that all required commands/utilities actually work.
	* If Webmin is not already installed, offer to install it.
	* If the "game-servers" Linux user does not exist, offer to create it.
	* Offer to pre-download the "Install" folder into "game-servers".
	* Offer to setup the "game-servers" Linux user as a Webmin user.

The main "Install" script (install-wgasm.sh):

	The "Install" script should be run under a completely unprivileged
	Linux user - that does NOT have any admin privileges using "sudo" or
	any other administrative capability.  Presumably, this Linux user is
	named "game-servers".

	This script may be invoked with an optional command-line parameter
	to assuming "yes" to all interactive prompts.  This feature is known
	as "Nike Mode" or "Just Do It!".  The parameter is used like this:

		./install-wgasm.sh --nike;

	The "Install" script will perform several functions automating as much
	of the process as possible.  These functions include:

	* Testing that all required commands/utilities actually work.
	* Downloading the system from GitHub.
	* Installing the components into their default locations.
	* Offer to install SteamCMD (using that script).
	* Offer to install Stencils (using that script)

The "SteamCMD" install script (install-steamcmd.sh):

	The "SteamCMD" install script should also be run under a completely
	unprivileged Linux user - that does NOT have any admin privileges using
	"sudo" or any other administrative capability.  Presumably, this Linux
	user is named "game-servers".

	The "SteamCMD" install script will perform several functions automating
	as much of the process as possible.  These functions include:

	* Downloading the latest Linux version of the SteamCMD utility.
	* Installing SteamCMD into the default (steamcmd) folder.
	* Log into SteamCMD once to ensure it updates.

The "Stencils" install script (install-stencils.sh):

	The "Stencils" install script should also be run under a completely
	unprivileged Linux user - that does NOT have any admin privileges using
	"sudo" or any other administrative capability.  Presumably, this Linux
	user is named "game-servers".

	The "Stencils" install script will perform several functions automating
	as much of the process as possible.  These functions include:

	* Downloading the latest Linux version of the example "Stencils",
	* Installing the example Stencils into the default (stencils) folder.

+----------------------------------------------------------------------+
| New default scripts location:                                        |
+----------------------------------------------------------------------+

Changed the default installation folder is "$HOME\wgasm" folder.  This
should avoid conflicting with any other scripting projects that the author (or
the user) might be working-with.

Although *NOT* RECOMMENDED, the scripts may now be installed in any alternative
location - as long as that location may be still be accessed by the user in a
READ+WRITE+EXECUTE basis.  When a script is run, it will determine at runtime
where it is located, and then use that as the basis for:

	* Finding the central configuration file.
	* Importing code from variuos "source include" files.
	* Running other scripts that are part of this project.

+----------------------------------------------------------------------+
| The central configuration file:                                      |
+----------------------------------------------------------------------+

Many items formerly hard-coded into the scripts, have been moved into the
central configuration file.  This file should be in the same folder as the
scripts. The configuration file is named "config.txt", and MUST be located
in the same folder as the main scripts themselves.

The config file is a plain-text file, and as such should be edtiable via any
preferred text editor ("nano", "vim", or any GUI text editor, etc.).

The options in the configuration file (config.txt) include:

	Option:                 Explanation:
	------                  -----------
	display_banner          Enable/disable banner display.
	scripts_verbose         Enable/disable verbose output.
	moron_detection         Prevent running things under root/sudo that should NOT be.
	purge_temp_installs     Purge "exclude" installs.
	autobackup_by_check     Automatically backup before "check" forces an update.
	autoexclude_by_check    Automatically update "exclude" when "check" updates.
	servers_install_folder  Default folder to branch game-server installs from.
	logs_folder             Folder where scripts and 'GNU screen' will store logs.
	temp_folder             Folder where that 7-zip will use as a working area.
	tempinstall_folder      Folder where "exclude" process will put temp installs.
	backup_folder           Folder where "backup" scripts will store the backups.
	stencils_folder         Folder where "stencils" (pre-configs) are stored.
	steamcmd_folder         Folder where SteamCMD utility is installed.
	backup_configs_folder   Folder where "include" and "exclude" files are stored.
	data_folder             Folder where data files / tables will be stored.
	game_types_file         The name of the game-types tab-separated-value file, relative to the "data" folder.
	game_servers_file       The name of the game-servers tab-separated-value file, relative to the "data" folder.
	game_stencils_file      The name of the game-stencils tab-separated-value file, relative to the "data" folder.
	banner_file             The name file with the banner content to display, relative to the "data" folder.
	steam_login             Default Steam credentials to use, enclose in quotes if NOT anonymous.

The default values included in the configuration file (config.txt) are:

	display_banner=true
	scripts_verbose=false
	moron_detection=true
	purge_temp_installs=true
	autobackup_by_check=true
	autoexclude_by_check=true
	servers_install_folder=$HOME
	logs_folder=$HOME/logs
	temp_folder=$HOME/temp
	tempinstall_folder=$HOME/temp/temp-install
	backup_folder=$HOME/backups
	stencils_folder=$HOME/stencils
	steamcmd_folder=$HOME/steamcmd
	backup_configs_folder=$SCRIPTS_FOLDER/backup-configs
	data_folder=$SCRIPTS_FOLDER/data
	game_types_file=game-types.tsv
	game_servers_file=game-servers.tsv
	game_stencils_file=game-stencils.tsv
	banner_file=banner.txt
	steam_login="anonymous"

+----------------------------------------------------------------------+
| Consequences of changing the default SCRIPTS location (~/wgasm):     |
+----------------------------------------------------------------------+

The default location for the scripts would be the "wgasm" folder
directly inside the Linux user-users "home-directory".  This is typically
described equally as either "$HOME/wgasm/" or "~/wgasm/" -
depending on the format required.

If you want to place the scripts in some other location, there are several
possible consequences you need to keep in mind:

* If you are using the related Webmin "Custom Commands" config they will BREAK!

* The "config.txt" file MUST be located in the same folder the scripts are in!
* The sub-folder for the "include" files MUST also exist, branched from there.
* The sub-folder for the "data" files should also be branched from there.
* If you want to put the "data" files somewhere else, update the config file.
* All the "data" files must go together in the same location.
* That would include the TSV files and the "banner.tsv" file.
* Similar issues with the "backup-configs" sub-folder.
* Be sure to update the config file if yuou want "back-configs" elsewhere.
* Similar issues with the "stencils" sub-folder.
* Be sure to update the config file if you want "stencils" elsewhere.

+----------------------------------------------------------------------+
| Consequences of changing the default GAME-SERVERS base location (~/) |
+----------------------------------------------------------------------+

The default location for game-server installations is branched directly inside
the Linux users "home-directory".  This is typically described equally as
either "$HOME/" or "~/" - depending on the format required.

If you want to branch the game-server installations form some other location,
there are several possible consequences you need to keep in mind:

* Of course, be sure to update the configuration file option that specifies the
  location to branch all the game-server installations from.

* The "backup" scripts, will only work for items that are INSIDE of that same
  location.  So, if you move the default game-server installation to someplace
  other than the home-directory, it may not be able to backup other things that
  perhaps are still located directly inside the Linux users home-directory -
  such as the default "weaseslsscripts" folder.  This will prevent backing-up
  the "weaseslsscripts" folder itself with that function.

* Similar issues for the "restore" function.  That function will only work for
  items that are INSIDE of that same location.

+----------------------------------------------------------------------+
| Purpose of each (regular) script:                                    |
+----------------------------------------------------------------------+

Several scripts are provided strictly for diagnostic purposes, and to not
perform any direct action on the game-servers themselves.  These include:

* list-running.sh          Displays running GNU 'screen' game-servers, etc.
* list-network.sh          Displays utilization of the network interface.
* list-ports.sh            Lists what ports are in use, on the computer.
* list-ports-game.sh       Lists what ports are in use, by all game-servers.
* list-ports-hlds.sh       Lists what ports are in use, by GoldSrc-engine games.
* list-ports-source.sh     Lists what ports are in use by Source-engine games.
* game-types-list.sh       Lists what game-types are defined.
* game-types-detail.sh     Displays details for a specific GameTypeID.
* game-stencils-list-sh    Lists what stencils are defined.
* game-stencils-detail.sh  Displays details for a specific GameStencilID.
* game-server-list         Lists what game-servers are defined.
* game-server-detail.sh    Displays details for a specific GameServerID.
* game-stencils-package.sh Rebuilds stencil zip files based on source files.

The scripts that actually perform functions for game-servers include:

* game-server-install.sh   Installs a game-server, based on a GameServerID.
* game-server-exclude.sh   Builds backup exclusions, based on a GameServerID.
* game-server-backup.sh    Backs-up a game-server, based on a GameServerID.
* game-server-paint.sh     Paints a specific GameServerID with a GameStencilID.
* game-server-run.sh       Runs a specific GameServerID interactively.
* game-server-start.sh     Starts a GameServerID disconnected in background.
* game-server-stop.sh      Stops a GameServerID if it is already started.
* game-server-update.sh    Updates a GameServerID, restarting if needed.
* game-server-check.sh     Gracefully apply any new updates for a GameServerID.
* game-server-monitor.sh   Monitors a GameServerID, restarting if needed.
* game-server-command.sh   Sends a command to a GameServerID's console.

+----------------------------------------------------------------------+
| Now driven by data "tables":                                         |
+----------------------------------------------------------------------+

Parameters that vary by game-type, game-server or game-stencil, have been
migrated from being hard-coded in the scripts themselves - into text-based
"tables".  These tables are in tab-seperated-value (TSV) format.

There are two such "tables":

	game-types    A list of per-game-TYPE data, in various columns.
	              The default filename is "game-types.tsv", and is
	              located in the "data_folder" specified in the central
	              configuration file.

	game-servers  A list of per-game-SERVER data, in various columns.
	              The default filename is "game-servers.tsv", and is
	              located in the "data_folder" specified in the central
	              configuration file.

	game-stencils  A list of canned-configurations that may be applied to
	               ("painted-onto") a game-server to overlay its config
	               additional content.  Stencils are game-type specific.

The TSV format allows each table to act somewhat like a database, but yet
also be easily editable using any desired plain-text-editor.

However, care must be exercised to ensure all fields are seperated by the
"TAB" charater (ASCII character number 8).  Obviously, no fields may have
a TAB character embedded inside of them, as this is used as the seperator
between columns.

Using TSV instead of the more common comma-seperated-value (CSV) format,
allows for commas and some other characters to be more eaily accomodated
in select fields - such as "Description" and "Comment" fields, which tend
to contain content that is less format-restricted.

For all fields, the data expected are strings of characters.  For some of
the fields, it is more restrictive - such as numeric, or all alpha-numeric,
or even all lower-case alpha-numeric, etc.

+----------------------------------------------------------------------+
| The "game-types" table (wgasm/data/game-types.tsv):                  |
+----------------------------------------------------------------------+

The game-types table, contains information about each game-type that the
scripts are expected to work-with.  As the name implies, each game-type is
associated with a different type of game, such as (but not limited to):

	* Half-Life (Hl1)
	* Team Fortress Classic (TFC)
	* Team Fortress 2 (TF2)
	* Counter-Strike 1.6 (CS1)
	* Counter-Strike:Source (CSS)
	* Counter-Strike 2 (CS2)

Some individual fields may be left blank.  But the correct number of TABs in
the row must be preserved. Also the ORDER of the fields must be prevered,
or the scripts will not function properly.

The order and description of each field is provided below:

Field	Field-Name       Description
------  ---------------  -----------
1       gametypeid       ID for game-type (hl1, tfc, cs1, css, cs2, etc.)
2       gameengine       Game engine type (goldsrc, source, src2cs2, etc.)
3       steamlogin       If not "anonymous", then "username password".
4       appidinstall     Steam AppID to use for installation.
5       appidcheck       Steam AppID to use for checking for updates.
6       steamcmdmod      Steam "mod" value to use for install (if any).
7       teamcmdpts       Extra install options for SteamCMD.
8       modsubfolder     Mod sub-folder, relative to install folder
9       warnstoptext     Command to warn players (in text) about a restart.
10      warnstopaudio    Command to warn players (in audio) about a restart.
11      warnupdatetext   Command to warn players (in text) about an update.
12      warnupdateaudio  Command to warn players (in audio) about an update.
13      description      Plain-text game-type description.
14      comment	         Notes about this game-type (if any).

Noted below are which fields are required/mandatory or optional:

Field	Field-Name       Required?
------  ---------------  ---------
1       gametypeid       MANDATORY: *ALWAYS* required, and must be UNIQUE!
2       gameengine       MANDATORY: either "goldsrc", "source" or "src2cs2".
3       steamlogin       Optional: If blank info in conf file will be used.
4       appidinstall     MANDATORY: check Steam Store for game to find.
5       appidcheck       MANDATORY: varies by game.
6       steamcmdmod      MANDATORY, but only for "goldsrc" engine games.
7       teamcmdpts       Optional: Uusually stuff like "validate".
8       modsubfolder     MANDATORY: Mod sub-folder, relative to install folder.
9       warnstoptext     Optional: Comamnd warning (in text) about a restart.
10      warnstopaudio    Optional: Comamnd warning (in audio) about a restart.
11      warnupdatetext   Optional: Comamnd warning (in text) about an update.
12      warnupdateaudio  Optional: Comamnd warning (in audio) about an update.
13      description      MANDATORY: Plain-text game-type description.
14      comment	         Optional: Larger description/notes.

Noted below are the format requirements / restrictions for each field:

Field	Field-Name       Format/Restrictions
------  ---------------  -------------------
1       gametypeid       ONLY: lower-case A-Z, numerals 0-9, and hypen ("-").
2       gameengine       ONLY: lower-case A-Z, numerals 0-9, and hypen ("-").
3       steamlogin       Plain text.
4       appidinstall     ONLY: numbers (numerals 0-9), generally 10-99999.
5       appidcheck       ONLY: numbers (numerals 0-9), generally 10-99999.
6       steamcmdmod      ONLY: lower-case A-Z, numerals 0-9, and hypen ("-").
7       teamcmdpts       Plain text.
8       modsubfolder     Plain text.
9       warnstoptext     Plain text, typically an amx_say, or sm_say.
10      warnstopaudio    Plain text, typically an amx_play, or sm_play.
11      warnupdatetext   Plain text, typically an amx_say, or sm_say.
12      warnupdateaudio  Plain text, typically an amx_play, or sm_play.
13      description      Plain text, a short user-friendly name.
14      comment	         Plain text, possibly HTML.

+----------------------------------------------------------------------+
| Updated pre-tabled "game-types":                                     |
+----------------------------------------------------------------------+

The game-types table now includes a LARGE selection of games that (in theory)
may be installed and managed via these scripts.  The updated game-types table
now includes:

	* 42 games that LIKELY can be installed and managed with these scripts.
    * 10 of which have actually been installed and TESTED with these scripts.
    * 13 additional games listed, but that are identified as being UNUSABLE.
    * 11 are unsuable, because no Linux version of their server is available.
    * 2 are unusable, because they are simply not relased (yet).

The "comment" field of each game-type has been populated with notes about
which game-types are tested, untested, unusable, etc.

The information used to create this updated game-types table was collected
from the https://steamdb.info/ web-site, filtering for which games had a
seperate "Dedicated Server" app available for them, AND also had either
"Engine.Source" or "Engine.GoldSource" specified in their list of included
technologies.

Also included is Counter-Strike 2 (CS2) which includes the newer
"Engine.Source2" technology.  It is NOT clear at this stage if later games
built around the Source2 game-engine will follow similar conventions with
regard to the games executable name, launch paratermers / requirements, etc.
Consequently, the game-engine defined for CS2 in the game-type table is
named as "src2cs2" due to how it is currently implmented - which MIGHT be
unique to CS2 (time will tell, as outher Source2-based games are relased).

In some rare cases, there are a few games that can not be installed using the
default "anonymous" Steam login with SteamCMD.  In those cases, the game must
be installed using the credential of a Steam account that "owns" the game in
Steam (has it in their Steam "Library").  In these cases, in the game-types
table the "steamlogin" field has been populated with a generic placeholder
entry of "username password" - to be replaced with a real Steam login BEFORE
you try to setup and manage a server with that specific game.  This will
override the default Steam login credentials (from the central config file),
for just that specific type of game - when trying to install or update it.

The list 39 game-types which are either already tested, or appear LIKELY
to be usabled with these scripts, currently includes:

	* Counter-Strike 1.6 (CS1) - Tested!
	* Deathmatch Classic (DMC) - Tested!
	* Day of Defeat (DoD) - Tested!
	* Half-Life (HL1) - Tested!
	* Team Fortress Classic (TFC) - Tested!
	* Half-Life: Blue Shift (Bshift) - Untested.
	* Half-Life: Opposing Force (Op4) - Untested.
	* Counter-Strike:Source (CSS) - Tested!
	* Day of Defeat:Source (DoDS) - Tested!
	* Team Fortress 2 (TF2) - Tested!
	* Half-Life 2 Deathmatch (HL2DM) - Untested.
	* Half-Life Deathmatch:Source (HLDMS) - Untested.
	* Left for Dead (L4D) - Untested.
	* Left for Dead 2 (L4D2) - Untested.
	* Counter-Strike 2 (CS2) - Tested, but no SourceMod available.
	* Sven Co-op (Sven) - Untested.
	* Fistful of Frags (FoF) - Tested!
	* Age of Chivalry (AoC) - Untested.
	* Brain Bread 2 (BB2) - Untested.
	* Black Mesa (BMS) - Untested.
	* Blade Symphony (BS) - Untested.
	* Codename CURE (Cure) - Untested.
	* Double Action:Boogaloo (DAB) - Untested.
	* Day of Infamy (DoI) - Untested.
	* Dystopia (Dys) - Untested.
	* Gary's Mod (GMod) - Untested.
	* Insurgency (INS) - Untested.
	* INSURGENCY: Modern Infantry Combat (InsMIC) - Untested.
	* Jabroni Brawl:Episode 3 (JBEp3) - Untested.
	* JBMod (JB) - Untested.
	* Military Conflict:Vietnam (MCV) - Untested.
	* Nuclear Dawn (ND) - Untested.
    * Natural Selection 2 (NS2) - Untested.
	* Pirates, Vikings, & Knights II (PVK2) - Untested.
	* The Ship (Ship) - Untested.
	* Zombie Panic:Source (ZPS) - Untested.
    * Action Half-Life:Source (AH2S) - Untested, also requires Steam login.
	* Infestus (Inf) - Untested, also requires Steam login.
	* IOSoccer (IOS) - Untested, also requires Steam login.
	* Half-Life Dedicated Server (HLDS) - Untested. Template for installing various "mods" on top of.
	* SDK Base 2007 - Untested. Template for installing various "mods" on top of.
	* SDK Base 2013 - Untested. Template for installing various "mods" on top of.

+----------------------------------------------------------------------+
| The "game-servers" table (wgasm/data/game-servers.tsv):              |
+----------------------------------------------------------------------+

The game-servers table, contains information about each game-server that will
exist - for the scripts to perform various functions on, such as:

	* Install the game-server.
	* Run the game-server interactively at the command-prompt.
	* Start the server as a disconnected background GNU 'screen' process.
	* Stop a server already running under GNU 'screen' in the background.
	* Check a game-server for available updates.
	* Monitor a game-server for fatal error conditions and restart.
	* Backup a game-server.
	* Build a "backup exclude" file for the game-server - for efficiency.
    * Restore a game-server from backups.

Some individual fields may be left BLANK.  But the correct NUMBER of TABs in
the row must be preserved. Also the ORDER of the fields must be prevered,
otherwise the scripts will not function properly.

The order and description of each field is provided below:

Field	Field-Name    Description
------  ------------  -----------
1       gameserverid  ID for game-server.
2       gametypeid    ID for game-type for this game-server.
3       portnumber    Network port number for game-server.
4       verbose       Enable/disable verbose script ouptput.
5       stale         Enable/disable monitoring for 'stale' logging.
6       threshold     Threshold for stale-log monitoring (in seconds).
7       description   Plain-text game-server description.
8       comment	      Notes about this server (if any).

Noted below are which fields are required/mandatory or optional:

Field	Field-Name    Required?
------  ------------  ---------
1       gameserverid  MANDATORY: *ALWAYS* required, must be UNIQUE!
2       gametypeid1   MANDATORY: *ALWAYS* required.
3       portnumber    MANDATORY: Usually a number in 27000-27999 range.
4       verbose       MANDATORY: must be exactly "true" or "false".
5       stale         MANDATORY: must be exactly "true" or "false".
6       threshold     MANDATORY, but only if STALE is set to "true".
7       description   MANDATORY: Plain-text game-serve desription.
8       comment	      Optional: Larger description/notes.

Noted below are the format requirements / restrictions for each field:

Field	Field-Name    Format/Restrictions
------  ------------  -------------------
1       gameserverid  ONLY: lower-case A-Z, numerals 0-9, and hypen ("-").
2       gametypeid    ONLY: lower-case A-Z, numerals 0-9, and hypen ("-").
3       portnumber    ONLY: numbers (numerals 0-9), generally 27000-27999.
4       verbose       ONLY: "true" or "false" (all lower-case).
5       stale         ONLY: "true" or "false" (all lower-case).
6       threshold     ONLY: numbers (numerals 0-9), generally 0-900.
7       description   Plain text, a short user-friendly name for the server.
8       comment       Plain text, possibly HTML.

+----------------------------------------------------------------------+
| The "game-stencils" table (wgasm/data/game-stencils.tsv):            |
+----------------------------------------------------------------------+

The game-stencils table, contains information about each game-stencil that is
available to be applied-to (aka "painted-onto") an existing game-server install.

Each game-stencil is specific to ONE game-type.  Typically, stencils are used
to standardize configurations or apply server-side modifications.  Effectively,
game-stencils are a bunch of content zipped-up in a manner that facilitates its
being unzipped directly into the appropriate game-server's mod-sub-folder.

It is important to keep in mind that, when "painting" a stencil onto an
existing game-server, any conflicting files will be overwritten by the content
in the stencil.

For this reason, stencils are usually applied when building an NEW game-server,
to setup a standard configuration, add some standard server-side mods.  This
provides an easier starting-point for getting a new game-server customized
and ready for play.

A few individual fields may be left BLANK.  But the correct NUMBER of TABs in
the row must be preserved. Also the ORDER of the fields must be prevered,
otherwise the scripts will not function properly.

The order and description of each field is provided below:

Field	Field-Name       Type        Description
------  ---------------  ----------  -----------
1       gamestencilid    string      ID for game-stencil
2       gametypeid       string      ID for game-type (HL1, TFC, CS1, CSS, CS2, etc.)
3       stencilfilename  string      Filename of the game-stencils zip file.
4       description      string      Plain-text game-stencil description.
5       comment	         string      Notes about this stencil (if any).

Noted below are which fields are required/mandatory or optional:

Field	Field-Name       Required?
------  ---------------  ---------
1       gamestencilid    MANDATORY: *ALWAYS* required, must be UNIQUE!
2       gametypeid       MANDATORY: *ALWAYS* required.
3       stencilfilename  MANDATORY: *ALWAYS* required.
4       description      MANDATORY: Plain-text game-serve desription.
5       comment	         Optional: Larger description/notes.

Noted below are the format requirements / restrictions for each field:

Field	Field-Name       Format/Restrictions
------  ---------------  -------------------
1       gamestencilid    ONLY: lower-case A-Z, numerals 0-9, and hypen ("-").
2       gametypeid       ONLY: lower-case A-Z, numerals 0-9, and hypen ("-").
3       stencilfilename  Linux-filename restrictions (lower-case recommended).
4       description      Plain text, a short user-friendly name for the server.
5       comment	         Plain text, possibly HTML.

+----------------------------------------------------------------------+
| Revised: 2024-06-10-Rev-E                       ... Thats all folks! |
+----------------------------------------------------------------------+

