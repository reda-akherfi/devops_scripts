


sudo dnf install samba samba-client

sudo firewall-cmd --permanent --zone=public --add-service=samba
sudo firewall-cmd --reload

# add the curr user as an smbb user [Setting up Windows-style password hashes]
sudo smbpasswd -a <jkirk>

# or opt for  the group way instead
sudo useradd <captains>
sudo usermod -aG captains jkirk
sudo chown root:captains /mnt/path/tp/share
sudo chmod u=rwx,g=rwxs,o= /mnt/path/tp/share


