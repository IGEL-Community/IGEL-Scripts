# Linux Scripts

***
## Build Ubuntu IGEL ICG

| Name | Description |
|------|-------------|
|[build-ubuntu-igel-icg.sh](build/build-ubuntu-igel-icg.sh)|Setup a hardened ICG server. The script will update and configure a FRESHLY installed version of Ubuntu Server 18.04 / 20.04..<br/><br/> Items installed / configured include:<br/> - Prepped for a IGEL ICG install <br /> - Time service (chrony) <br /> - OpenSSH <br /> - UFW Firewall <br /> - Fail2ban Automatic Banning <br /> - Rootkit Hunter (Rkhunter) <br /> - Port Knocking (Knockd) -- Note: install knock client on PC |
|[ssh-knock.sh](ssh/ssh-knock.sh)|Script to knock on server to allow SSH connection and then to knock on server to close down SSH |
