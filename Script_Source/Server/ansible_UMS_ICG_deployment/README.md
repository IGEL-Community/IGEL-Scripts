# Linux Scripts

## Ansible UMS + ICG Deployment

- create basic installation for ICG and UMS server (tested with Ubuntu 18.04)
  - set IP addresses and add/edit them to /inventories/IGEL/hosts.yml
  - setup basic user with password with su privilege and add it to inventories/ICG/group_vars/all.yml
- create secrets file ~/.vault_pass.txt
- edit settings in
  - /inventories/IGEL/group_vars/all.yml
  - /inventories/IGEL/host_vars/icg.yml
  - /inventories/IGEL/host_vars/ums.yml
- encrypt vars in /inventories/IGEL/group_vars/all.yml
- replace files/keystore.icg with the exported keystore.icg from the UMS

install required roles from ansible galaxy:

```bash
ansible-galaxy install -r roles/requirements.yml -p ./roles/ --force
```

execute UMS playbook:

```bash
ansible-playbook prepare_igel_ums.yml -i inventories/ICG/hosts.yml --vault-password-file ~/.vault_pass.txt
```

proceed with the manual UMS installation:

1. Connect to the host as root (alternative: sudo -s)
2. cd /tmp
3. ./setup*.bin
4. Follow wizard
5. rm ./setup*.bin
6. UMS Administrator -> Backup -> Restore latest backup (optional)
7. UMS Console -> Global Configuration -> Certificate Management -> Cloud Gateway -> Export certificate chain to IGEL Cloud Gateway keystore format
8. copy keystore.icg to ../ansible_UMS_ICG_deployment/files

execute ICG playbook:

```bash
ansible-playbook prepare_igel_icg.yml -i inventories/ICG/hosts.yml --vault-password-file ~/.vault_pass.txt
```

proceed with the manual ICG installation:

1. Connect to the host as root (alternative: sudo -s)
2. cd /tmp
3. ./installer*.bin keystore.icg
4. Follow wizard
5. rm installer*.bin keystore.icg
6. UMS Console -> UMS Administration -> IGEL Cloud Gateway -> Add existing Gateway to database

Filetransfer:

The ICG server is configured to have a vsftpd server installed, which uses explicit passive FTPS. There is a cron job configured on the UMS Server to sync the file_transfer files to the FTP user home. That way devices can use Firmwareupdates via a profile. Corporate Design files don't work atm with that FTP implementation, a ticket with IGEL is open (2020-12-03).