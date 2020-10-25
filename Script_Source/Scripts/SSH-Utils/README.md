# SSH Utils: Script Name and Description
OpenSSH Notes:
```{openssh}
- Generate key pairs in .ssh directory --> ssh-keygen
- Copy public key to remote server --> ssh-copy-id username@remote_host
- Test connection --> ssh -l username hostname
- Forward X11 --> ssh -X -l username hostname
- Forward X11 compressed --> ssh -X -C -l username hostname
- Tunnel VNC --> ssh -l username -f -N -L 5900:localhost:5900 remote_host
    VNC connection
  ```
Ref: https://tinyurl.com/ssh-setup
| Name | Description |
|------|-------------|
|[config](config)|Sample configuration file for SSH.|
|[ssh-home.sh](ssh-home.sh)|SSH to an alias (home) in config|
|[ssh-away.sh](ssh-away.sh)|SSH to an alias (away) in config|
|[ssh-knock.sh](ssh-knock.sh)|Script to knock on server to allow SSH connection and then to knock on server to close down SSH |
|[vnc-home.sh](vnc-home.sh)|VNC tunnel connection on home network|
|[vnc-away.sh](vnc-away.sh)|VNC tunnel connection on internet network|
|[rsync-vb.sh](rsync-vb.sh)|RSYNC via SSH connection|
|[rsync-mirror.sh](rsync-mirror.sh)|RSYNC via SSH connection to mirror server folder to PC|

**Note:** If you encounter timeout issues with rsync, add the following setting to each SSH server and restart SSH service:

```
IPQoS 0x00
to the file
/etc/ssh/sshd_config
  ```
