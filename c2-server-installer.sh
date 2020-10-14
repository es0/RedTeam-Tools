#!/usr/bin/env bash

#script header
printHeader(){
  echo "##################################"
  echo "#  Red Team C2 Server Installer  #"
  echo "#  ver. 1.2.20          by:e.s0  #"
  echo "##################################"
  echo
  echo

}

# main menu
listFrameworks(){
    clear
    echo
    echo "Available C2 Frameworks"
    echo "-------------------------------------------------"
    echo "[0]   FactionC2       - A modern, flexible C2 framework (currently very beta)"
    echo "[1]   Covenant        - Collaborative .NET C2 framework for red teamers "
    echo "[2]   Koadic          - COM Command & Control, is a Windows post-exploitation rootkit"
    echo "[3]   SILENTTRINITY   - Post-exploitation agent powered by Python, IronPython, C#/.NET."
    echo "[4]   Empire          - Empire is a PowerShell and Python post-exploitation agent."
    echo "[5]   Sliver          - Cross-platform implant framework that supports C2 over Mutual-TLS, HTTP(S), and DNS."
    echo "[6]   Caldera         - Automated Adversary Emulation system build on MITRE ATT&CK"
    echo "[7]   Mythic          - A cross-platform, post-exploit, red teaming framework"
    echo "[99]  QUIT!           - EXIT INSTALLER!"
    echo
}


#fun load bar
loadbar(){
  BAR='######################################## PWN!'   # this is full bar, e.g. 20 chars
  echo "Loading"
  for i in {1..45}; do
      echo -ne "\r${BAR:0:$i}" # print $i chars of $BAR from 0 position
      sleep .1                 # wait 100ms between "frames"
  done
}



# Installer functions
install_factionc2(){
  echo "[*] Downloading FactionC2"
  sleep 3
  sudo git clone https://github.com/FactionC2/Faction/ /opt/FactionC2/
  sleep 1
  echo "[*] Installing FactionC2"
  cd /opt/FactionC2/
  sudo bash ./install.sh
  sleep 1
  echo
  echo "[*] Installing Marauder Agent for FactionC2"
  sudo git clone https://maraudershell/Marauder.git /opt/Marauder
  echo "[!] Installing Dependencies"
  wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O /tmp/packages-microsoft-prod.deb
  sudo dpkg -i /tmp/packages-microsoft-prod.deb
  echo "[!] Installing DotNet Core Runtime"
  sudo add-apt-repository universe
  sudo apt-get update -y
  sudo apt-get install apt-transport-https -y
  sudo apt-get update -y
  sudo apt-get install dotnet-sdk-2.2 -y
  cd /opt/Marauder
  dotnet build
}

install_covenant(){
  echo "[*] Downloading Covenant"
  sudo git clone --recurse-submodules https://github.com/cobbr/Covenant /opt/Covenant
  sleep 1
  echo "[*] Installing Dependencies"
  wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O /tmp/packages-microsoft-prod.deb
  sudo dpkg -i /tmp/packages-microsoft-prod.deb
  echo "[!] Installing DotNet Core Runtime"
  sudo add-apt-repository universe
  sudo apt-get update -y
  sudo apt-get install apt-transport-https -y
  sudo apt-get update -y
  sudo apt-get install dotnet-sdk-2.2 -y
  echo "[*] Installing Covenant"
  cd /opt/Covenant/Covenant
  dotnet build

}

install_koadic(){
  echo "[*] Downloading Koadic"
  sudo git clone https://github.com/zerosum0x0/koadic.git /opt/koadic/
  cd /opt/koadic
  echo "[!] Installing Dependencies"
  sudo apt install python2.7 python3 python2.7-pip python3-pip -y
  echo "[*] Installing Koadic"
  pip install -r requirements.txt
  echo

}

install_SILENTTRINITY(){
  echo "[*] Downloading SILENTTRINITY"
  sudo git clone https://github.com/byt3bl33d3r/SILENTTRINITY /opt/SILENTTRINITY/
  echo "[!] Installing Dependencies"
  sudo apt install python3 python3-pip -y
  echo "[*] Installing SILENTTRINITY"
  pip3 install --user pipenv && pipenv install && pipenv shell
  cd /opt/SILENTTRINITY
  pip3 install -r requirments.txt

}

install_sliver(){
  echo "[*] Downloading Sliver"
  echo "TO BE IMPLEMENTED SOON!"
}

install_empire(){
  echo "[*] Downloading Empire"
  sudo git clone https://github.com/BC-SECURITY/Empire.git /opt/Empire
  echo "[!] Installing Dependencies"
  sudo apt install python2.7 python3 python2.7-pip python3-pip -y
  echo
  echo "[*] Installing Empire"
  cd /opt/Empire
  sudo ./setup/install.sh
  echo

}

install_caldera(){
  echo "[*] Downloading Caldera"
  sudo git clone https://github.com/mitre/caldera.git --recursive --branch 2.4.0 /opt/caldera
  cd /opt/caldera
  echo "[*] Installing Dependencies"
  sudo bash auto-installer.sh
  echo 
}

install_mythic(){
  echo "[*] Downloading Mythic"
  sudo git clone https://github.com/its-a-feature/Mythic /opt/mythic
  cd /opt/mythic
  echo "[*] Installing Dependencies"
  sudo bash install_docker_ubuntu.sh
  echo
  echo "[!] MODIFY CONFIG [/mythic-docker/config.json] BEFORE USE!!"
  echo "    Then run start_mythic.sh [Recomend starting without Documentation container] "
  echo 
}

#Get c2 option helper function
get_choice(){
  local opt
  read -p "Choose c2 framework to install: " opt
  case $opt in
    0) clear;
        echo "Installing FactionC2";
        install_factionc2;
    ;;
    1) clear;
        echo "Installing Covenant C2";
        install_covenant;
    ;;
    2) clear;
        echo "Installing Koadic";
        install_koadic;
    ;;
    3) clear;
        echo "Installing SILENTTRINITY";
        install_SILENTTRINITY;
    ;;
    4) clear;
        echo "Installing Empire";
        install_empire;
    ;;
    5) clear;
        echo "Installing Sliver";
        install_sliver;
    ;;
    6) clear;
        echo "Installing Caldera";
        install_caldera;
    ;;
    7) clear;
        echo "Installing Mythic"
        install_mythic;
    ;;    
    99)exit;
    ;;
    *)clear;
        echo "INVALID OPTION!";
        listFrameworks;
  esac

}

printHeader
loadbar
sleep 3

trap '' SIGINT SIGQUIT SIGTSTP

notinstalled=true
while $notinstalled
    do
      listFrameworks
      get_choice
      notinstalled=false
      echo
      echo
      loadbar
      echo
      echo "[*] DONE INSTALLING"
      echo "[+] Have a nice day :)"
done
