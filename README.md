
The documentation takes the form of this Steam Community "Guide":

https://steamcommunity.com/sharedfiles/filedetails/?id=3259278773

Quick-Quick Start:
-----------------

FIRST: Login as "root" or some "sudo" privledged user.

SECOND: Download and run the "prepare-debian.sh" script:

wget -O prepare-debian.sh https://github.com/Mecha-Weasel/wgasm/raw/main/prepare-debian.sh;wait;
  
chmod +x prepare-debian.sh;
  
sudo ./prepare-debian.sh;



THIRD: Login as the "game-servers" unprivledged user.

FOURTH: Run the "install-wgasm.sh" script:

wget -O install-wgasm.sh https://github.com/Mecha-Weasel/wgasm/raw/main/install-wgasm.sh;wait;
  
chmod +x install-wgasm.sh;
  
./install-wgasm.sh;
