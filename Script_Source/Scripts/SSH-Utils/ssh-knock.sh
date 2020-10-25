#!/bin/bash
#set -x

#
# Script to knock on server to allow ssh connection and then
# to knock on server to close down SSH
#
SRV_NAME=SERVER-NAME
USR_Name=USER-Account
KNOCK01=7000
KNOCK02=8000
KNOCK03=9000
SSH_PORT=60022

knock -v $SRV_NAME $KNOCK01 $KNOCK02 $KNOCK03
ssh  -p $SSH_PORT $USR_Name@$SRV_NAME
knock -v $SRV_NAME $KNOCK03 $KNOCK02 $KNOCK01
