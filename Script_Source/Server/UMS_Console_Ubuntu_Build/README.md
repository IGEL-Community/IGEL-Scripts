# Linux Scripts

***
## Build Ubuntu Desktop that can be used to run IGEL UMS Console(s)

| Name | Description |
|------|-------------|
[ums-console-ubuntu-desktop-build.sh](ums-console-ubuntu-desktop-build.sh) | Setup Ubuntu desktop to be used to install / run UMS Console(s) <br /><br />The script will update and configure a FRESHLY installed version of Ubuntu Server 18.04 / 20.04.<br/><br/> Items installed / configured include:<br/> - Prepped for IGEL UMS console(s) install<br /> - Time service (chrony) <br /> - OpenSSH |

## Linux UMS and X11 forwarding to IGEL OS endpoint

| Item | Description |
|------|-------------|
| Summary of steps to run UMS console and UMS administrator on IGEL OS endpoint | -	Setup SSH server on Linux UMS server (if not already running) <br /> -	Update SSH server to allow X11 forwarding <br /> -	Setup IGEL OS endpoint SSH key pairs and copy public key to the UMS server <br /> -	SSH X11 forwarding from IGEL OS endpoint to UMS Server <br /> -	Start UMS Console or UMS Administrator |
| Setup SSH server on Linux UMS server | - On UMS server, install, start and enable SSH (if not already running) <br /> *** sudo apt install openssh-server -y <br /> *** sudo systemctl start sshd.service <br /> *** sudo systemctl enable sshd.service <br /> - Ref: [SSH Setup](https://tinyurl.com/ssh-setup) |
| Update SSH server to allow X11 forwarding | -	On UMS server, edit /etc/ssh/ssh_config file (uncomment / remove “#”): <br /> ***	ForwardX11 yes <br /> ***	Forward11Trusted yes <br /> -	Restart SSH <br /> ***	sudo systemctl restart sshd.service <br /> -	Ref - [X11 Forwarding](https://tinyurl.com/x11-forwarding) |
| IGEL OS endpoint SSH setup | -	On IGEL OS endpoint, open a terminal window as user <br /> -	Generate key pairs (~/.ssh folder) <br /> ***	ssh-keygen  <br /> -	Copy public key to Linux UMS server <br /> ***	ssh-copy-id username@ums_server <br /> -	Test connection <br /> ***	ssh -l username ums_server |
| SSH X11 forwarding from IGEL OS endpoint to UMS server | -	On IGEL OS endpoint, open a terminal window and start SSH connection to the UMS server <br /> ***	ssh -X username@ums_server <br /> -	**Note**: For slow connections, add -C (compression) to the ssh command |
| Install UMS console | - During the install of the UMS Console, add version number to the path: /opt/IGEL/RemoteManager-606100 |
| Start UMS console | -	On IGEL OS endpoint, in the SSH terminal window, start UMS Console <br /> ***	/opt/IGEL/RemoteManager-606100/RemoteManager.sh & |
