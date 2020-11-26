# Linux Scripts

***
## Ansible ICG Deployment

- create basic installation for ICG server (tested with Ubuntu 18.04)
  -  set IP address and add it to /inventories/ICG/group_vars/all.yml
  -  setup basic user with password with su privilege and add it to inventories/ICG/hosts.yml
  -  edit settings in /inventories/ICG/group_vars/all.yml and/or prepare_igel_icg.yml

- create secrets file ~/.vault_pass.txt

- encrypt vars in /inventories/ICG/group_vars/all.yml

```
ansible-galaxy install -r roles/requirements.yml -p ./roles/ --force
ansible-playbook prepare_igel_icg.yml -i inventories/ICG/hosts.yml --vault-password-file ~/.vault_pass.txt
```