#!/usr/bin/env bash

# Update, upgrade and install misc.
sudo apt-get update
sudo apt-get upgrade -y
sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install net-tools curl wget file tar bzip2 gzip unzip bsdmainutils python util-linux ca-certificates binutils bc jq tmux netcat lib32gcc1 lib32stdc++6 libsdl2-2.0-0:i386 -y
sudo apt-get update

# Create shutdown script
cat << EOF > /home/vagrant/power_off
#!/bin/bash

sudo shutdown -h now
EOF

sudo chmod 700 /home/vagrant/power_off
sudo chown vagrant power_off
sudo chown :vagrant power_off

# Create the install_steam script
cat << EOF > /home/vagrant/install_steam
#!/bin/bash

sudo apt-get install steamcmd -y
steamcmd +force_install_dir /home/vagrant/valheim +login anonymous +app_update 896660 validate +exit
sed -i 's/-name \"My server\"/-name \"To The Pain\"/g' ./valheim/start_server.sh
sed -i 's/-world \"Dedicated\"/-world \"MomsWorld\"/g' ./valheim/start_server.sh
sed -i 's/-password \"secret\"/-password \"password\"/g' ./valheim/start_server.sh
crontab /var/spool/cron/vagrant
rm /home/vagrant/install_steam
./start_valheim_server
EOF

sudo chmod 700 /home/vagrant/install_steam
sudo chown vagrant install_steam
sudo chown :vagrant install_steam

# Create the start_valheim_server script
cat << EOF > /home/vagrant/start_valheim_server
#!/bin/bash

echo "Starting the Valheim server..."
sudo systemctl start valheim
sudo systemctl status valheim
EOF

sudo chmod 700 /home/vagrant/start_valheim_server
sudo chown vagrant start_valheim_server
sudo chown :vagrant start_valheim_server

# Create the stop_valheim_server script
cat << EOF > /home/vagrant/stop_valheim_server
#!/bin/bash

echo "Stopping the Valheim server..."
sudo systemctl stop valheim
sudo systemctl status valheim
EOF

sudo chmod 700 /home/vagrant/stop_valheim_server
sudo chown vagrant stop_valheim_server
sudo chown :vagrant stop_valheim_server

# Create the update_valheim_server script
cat << EOF > /home/vagrant/update_valheim_server
#!/bin/bash

echo "Stopping Valheim server..."
sudo systemctl stop valheim
echo "Backing up Valheim worlds..."
rsync -a /home/vagrant/.config/unity3d/IronGate/Valheim/worlds_local/ /home/vagrant/.config/unity3d/IronGate/Valheim/worlds_local-backup
echo "Backing up Valheim server start script..."
cp /home/vagrant/valheim/start_server.sh /home/vagrant/start_server.sh.bak
steamcmd +force_install_dir /home/vagrant/valheim +login anonymous +app_update 896660 validate +exit
echo "Restoring Valheim start script..."
cp /home/vagrant/start_server.sh.bak /home/vagrant/valheim/start_server.sh
echo "Restoring Valheim worlds..."
rsync -a /home/vagrant/.config/unity3d/IronGate/Valheim/worlds_local-backup/ /home/vagrant/.config/unity3d/IronGate/Valheim/worlds_local
/home/vagrant/start_valheim_server
EOF

sudo chmod 700 /home/vagrant/update_valheim_server
sudo chown vagrant update_valheim_server
sudo chown :vagrant update_valheim_server

# Create Valheim service
cat << EOF > /etc/systemd/system/valheim.service
[Unit]
Description=Valheim Server
Wants=network.target
After=network-online.target

[Service]
Type=simple
User=vagrant
WorkingDirectory=/home/vagrant/valheim
ExecStart=/bin/bash /home/vagrant/valheim/start_server.sh
StandardOutput=journal+console
StandardError=journal+console

[Install]
WantedBy=multi-user.target
EOF

sudo chmod +x /etc/systemd/system/valheim.service
sudo systemctl enable /etc/systemd/system/valheim.service
sudo systemctl daemon-reload

# Grant crontab permissions
cat << EOF > /etc/cron.allow
root
vagrant
EOF

# Create vagrant crontab
cat << EOF > /var/spool/cron/vagrant
*/1 * * * * rsync -a /home/vagrant/.config/unity3d/IronGate/Valheim/worlds/ /home/vagrant/.config/unity3d/IronGate/Valheim/worlds-backup

0 13 * * * /home/vagrant/update_valheim_server
EOF

echo ""
echo "Please log into your Valheim server and run the following command to complete this installation:"
echo "  ./install_steam"
echo ""
echo "To start the Valheim server, type:"
echo "  ./start_valheim_server"
echo ""
echo "To stop the Valheim server, type:"
echo "  ./stop_valheim_server"
echo ""
echo "To update the Valheim server, type:"
echo "  ./update_valheim_server"
