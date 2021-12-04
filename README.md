# Build and Run a Private Valheim Dedicated Linux Server
Everything needed to install and run a private Valheim dedicated server to a Linux virtual machine running inside of Windows on your local network.

## Instructions

### Prerequesites

* Download and install Vagrant for Windows [https://releases.hashicorp.com/vagrant/2.2.16/vagrant_2.2.16_x86_64.msi]
* Download and install VirtualBox for Windows [https://download.virtualbox.org/virtualbox/6.1.30/VirtualBox-6.1.30-148432-Win.exe]

### Get Started

* Use `git clone https://github.com/chuckthomasincontact/private-valheim-dedicated-server.git` to clone this repo, then cd into the cloned folder from a Windows command prompt.
* Edit the `Vagrantfile` in the root directory and change line 55 (`vb.memory = "8192"`) to whatever value (in MB) you care to give to the virtual machine (at least 2048?).
* Edit `scripts\bootstrap.sh`
  * Edit line 28 to change the Valheim server name `To The Pain` to whatever server name you would like to use.
  * Edit line 29 to change the Valheim world name `MomsWorld` to whatever world name you would like to use.
  * Edit line 30 to change the Valheim password `password` to whatever you would like to use.
* From a command prompt, in the cloned root folder, type `vagrant up`, and follow any instructions. This will create the Linux server in VirtualBox, and will power it up as a virtual machine on your private local network. This will also install updates, etc., and scripts you will use to install, start, stop and update your Valheim server.
* When that completes, type the command `vagrant ssh` to log in to your Valheim server. **NOTE:** if this fails, you can open VirtualBox, then select your Valheim Server instance (which should be running by now), then click the big green `Show` arrow at the top, which will launch a window for you to log in to. Log in as `vagrant`, using the password `vagrant`. Either way should take you to your Valheim Linux home folder (`/home/vagrant`).
* From there, type `./install_steam`. This will install all remaining things needed to create your Valheim server (under `/home/vagrant/valheim`), and will start the server automatically.
* From your Valheim server home directory (`/home/vagrant`), you can use the following commands at any time:
  * `./stop_valheim_server` to stop the Valheim server.
  * `./start_valheim_server` to start the Valheim server (if it stopped for any reason).
  * `./update_valheim_server` to update your Valheim server software (this command is set to run automatically, however, every day at 6 am).
  * `sudo systemctl status valheim` to see if the Valheim server is currently running or not.
  * `./power_off` to shutdown the virtual Linux machine and power it off (use VirtualBox to restart it by right clicking on the virtual machine and clicking `Start`, then `Headless Start`, which will automatically restart your Valheim server as well).
* If you ever need to wipe out the virtual machine and start over, from a Windows command prompt (and from the root of the cloned directory), simply type the command `vagrant destroy --force`. You can always rebuild the server quickly using `vagrant up` again.
* Lastly, your worlds are automatically backed up every minute the virtual machine is running (to `/home/vagrant/.conf/unity3d/IronGate/Valheim/worlds-backup`). You can restore your worlds any time by typing the command `rsync -a /home/vagrant/.conf/unity3d/IronGate/Valheim/worlds-backup/ /home/vagrant/.conf/unity3d/IronGate/Valheim/worlds` from your vagrant home directory.