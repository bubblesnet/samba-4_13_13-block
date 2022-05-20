/usr/sbin/useradd -m -p pi -s /bin/bash pi; (echo pi; echo pi) | /usr/bin/smbpasswd -a -s pi
/usr/sbin/smbd restart
bash
