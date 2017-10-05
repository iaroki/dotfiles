#!/bin/bash

BKPDIR=/home/adminuser/backup
BKPNAME=proxy-server-backup-`date +%F-%H-%M`.tar.bz2

cd $BKPDIR
tar cvpjf $BKPNAME --exclude=/proc \
		   --exclude=/lost+found \
                   --exclude=$BKPNAME \
                   --exclude=/mnt \
                   --exclude=/sys \
					--exclude=$BKPDIR /
