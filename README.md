
The documentation takes the form of this Steam Community "Guide":

https://steamcommunity.com/sharedfiles/filedetails/?id=3259278773

Quick-Quick Start:
-----------------

1.  FIRST: Login as "root" or some "sudo" privledged user.

2.  SECOND: Download and run the "prepare-debian.sh" script:

2a.    wget -O prepare-debian.sh https://github.com/Mecha-Weasel/wgasm/raw/main/prepare-debian.sh;wait;
  
2b.    chmod +x prepare-debian.sh;
  
2c.    sudo ./prepare-debian.sh;

3.  THIRD: Login as the "game-servers" unprivledged user.

4.  FOURTH: Run the "install-wgasm.sh" script:

4a.    wget -O install-wgasm.sh https://github.com/Mecha-Weasel/wgasm/raw/main/install-wgasm.sh;wait;
  
4b.    chmod +x install-wgasm.sh;
  
4c.    ./install-wgasm.sh;
