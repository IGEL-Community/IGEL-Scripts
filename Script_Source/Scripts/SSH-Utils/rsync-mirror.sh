#!/bin/sh
# uncomment set and trap to trace execution
#set -x
#trap read debug

# rsync mirror from server to PC
#  --delete for mirror
#  --exclude to exclude folders
rsync \
--delete \
--exclude 'VirtualBox*VMs' \
-Pave \
ssh \
alias1-home:~/ \
~/Server-Backups/FULL
