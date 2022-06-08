#!/bin/bash
cp /samba_shared/*.conf /etc/samba
if [ ! -f "/etc/samba/smb.conf" ]
then
  echo "There was no smb.conf in /samba_shared so we're using the sample!"
  cp smb_sample.conf /etc/samba/smb.conf
else
  echo "There was a smb.conf in /samba_shared so we're using it."
fi

/usr/sbin/useradd -m -p $SAMBA_PASSWORD -s /bin/bash $SAMBA_USER; (echo $SAMBA_PASSWORD; echo $SAMBA_PASSWORD) | /usr/bin/smbpasswd -a -s $SAMBA_USER
/usr/sbin/smbd restart
tail -F /samba_shared/var/log/samba/smbd.log
