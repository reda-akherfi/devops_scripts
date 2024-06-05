#!/bin/bash


source ./bash_colors_source_me_everywhere.sh

function transition_echo() {
    clear;
    echo -e "$1\n";
    sleep 3;
}

function targeting_disk() {
    # choosing the drive
    disk_is_selected=0
    until [ $disk_is_selected -eq 1 ]
    do
        transition_echo "${GREEN}choosing the drive${WHITE}"
        lsblk
        read -p "${GREEN}enter the name of the drive , beware of typos !!! e.g ${RED}/dev/bla${WHITE} " disk_name
        transition_echo "${GREEN}the disk you selected is${RED} $disk_name ${WHITE}\n"
        read -p "${YELLOW}Is this selection the right one ? [yes/No]${WHITE}" user_selected_disk
        if [ $user_selected_disk = "yes" ]
        then
            disk_is_selected=1
            transition_echo "${GREEN}you chose yes${WHITE}"
        else 
            transition_echo "${GREEN}you chose to repeat the selection${WHITE}"
        fi
    done
}

function partition_lvm() {
    # $ parted [options] [device [command [options...]...]]
    # partitionning the disk
    partitionning_successful=0
    until [ $partitionning_successful -eq 1 ]
    do
        transition_echo "partitioning using parted"
        # creating the gpt label
        transition_echo "creating the gpt label"
        parted --fix --script $disk_name mklabel "gpt"
        # making the efi partition
        transition_echo "making the efi partition"
        parted --fix --script $disk_name mkpart  "EFIREDA" "fat32" 1MiB 301MiB
        # setting the bootable flag for the efi partition
        transition_echo "setting the bootable flag for the efi partition"
        parted --fix --script $disk_name set 1 esp on
        # making the root partition as the rest of the disk
        transition_echo "making the one LVM partition"
        parted --fix --script $disk_name mkpart  "ROOTREDA" "ext4" 301MiB 100%
        transition_echo "creating the ${GREEN}physical volume${WHITE}"
        pvcreate "${disk_name}"2
        transition_echo "creating the ${GREEN} volume group${WHITE}"
        vgcreate REDALVM "${disk_name}2"
        transition_echo "creating the ${GREEN} logical volume${WHITE}"
        lvcreate -L 6G -n ROOTREDALVM REDALVM
        partitionning_successful=1
        parted --script ${disk_name} print
        sleep 5
    done
}

function making_filesystems() {
    # making the file system -- formatting
    transition_echo "making the file system -- formatting"
    # formatting the efi partition
    transition_echo "formatting the efi partition in vfat 32"
    mkfs.vfat -F32 -n "EFISYSTEM" "${disk_name}1"
    # formatting the root partition 
    transition_echo "formatting the root partition in ext4"
    mkfs.ext4 -F -F -L "ROOT" "/dev/REDALVM/ROOTREDALVM"
    clear
}

function mounting_stuff() {
    # mounting the partitions
    transition_echo "${GREEN}mounting the partitions${WHITE}"
    # mouting the root parttion into /mnt
    transition_echo "mouting the root parttion into /mnt"
    mount -t ext4 /dev/REDALVM/ROOTREDALVM /mnt
    # mounting the efi part to /mnt/boot
    transition_echo "mounting the efi part to /mnt/boot"
    mkdir /mnt/boot
    mount -t vfat  ${disk_name}1 /mnt/boot
    sleep 3
    clear
}

############################################################
### basic setup for the env itself
############################################################
# setting up the font inside the live env
read -p "Is the text small for your taste Mr Redaa? [Y/n] " text_small
if [ $text_small = "no" ]
then
    echo -e "Ok, we will continue using this font size Mr Reda\n"
    sleep 3
    clear
else 
    # making the font get bigger
    echo -e "making the font get bigger\n"
    echo -e "this is the font before:"
    sleep 3
    setfont ter-132b
    echo -e "this is the font after"
    sleep 3
    clear
fi

# set up the time
echo -e "configuring the time has begun\n"
sleep 3
timedatectl
# setting the ntp protocol true
echo -e "setting the ntp protocol true\n"
timedatectl set-ntp true
# setting up the time zone
echo -e "setting up the time zone\n"
timedatectl set-timezone Africa/Casablanca
echo -e "setting up the time has finished"
sleep 3
clear

# updating keyrings
echo -e "updating the keyrings \n"
sleep 3
pacman -Sy --needed --noconfirm archlinux-keyring
echo -e "just updated the keyring for arch \nwhatever that means!\n"
sleep 3
clear



############################################################
### partitionning the drives
#
targeting_disk
partition_lvm
making_filesystems
mounting_stuff


############################################################
### installing software
############################################################
# chrooting to the live env
echo -e "installing software"
pacstrap -K /mnt base linux linux-firmware intel-ucode networkmanager sudo grub efibootmgr \
    linux-headers linux-lts linux-lts-headers lvm2
echo -e "all software has been installed successfully !\n"
sleep 3

############################################################
### before chrooting
############################################################
# generating the fstab file
echo -e "generating the fstab file "
sleep 2
genfstab -U /mnt >> /mnt/etc/fstab
echo -e "fstab has been generated\n"
sleep 3
clear




############################################################
### the inside chroot script setup
### and copying it to it
############################################################
cat <<ENDE > /mnt/inside_script.sh

#!/bin/bash

############################################################
### Setting up users
############################################################
# setting the password for the root user
echo -e "setting the password for the root user\n"
echo -e root:Tzbg5340 | chpasswd
sleep 3
# adding a new user
echo -e "adding a new user\n"
useradd -m reda --shell /bin/bash
sleep 3
# setting up the password for reda
echo -e "setting up the password for reda\n"
echo -e reda:1966 | chpasswd
sleep 3
# adding reda to certain groups
echo -e "adding reda to certain groups\n"
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
usermod -a -G wheel,storage,power,audio reda
sleep 3

############################################################
### Performing menial tasks 
############################################################
# setting up the timezone
echo -e "setting up the timezone"
ln -sf /usr/share/zoneinfo/Africa/Casablanca /etc/localtime
sleep 3
# syncing the system to hardware clock
echo -e "syncing the system to hardware clock"
hwclock --systohc
sleep 3
# setting up the locale
echo -e "setting up the locale"
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sleep 3
locale-gen
sleep 3
# setting up the language
echo -e "setting up the language"
echo -e "LANG=en_US.UTF-8" > /etc/locale.conf
sleep 3
# host name stuff
echo -e "host name stuff"
sleep 3
#setting up the host name
echo -e "setting up the host name\n"
echo -e homeworld16 > /etc/hostname
sleep 2
# setting  up the /etc/hosts file
echo -e "setting  up the /etc/hosts file\n"
cat <<EOF > /etc/hosts
127.0.0.1 localhost
::1       localhost
127.0.1.1 archmc.localdomain archmc
EOF
pacman -S --needed --noconfirm vim git terminus-font openssh
systemctl enable --now sshd
git clone https://github.com/reda-akherfi/dottas.git
git clone https://github.com/reda-akherfi/devops_scripts.git
clear
echo -e "configuring mkinitcpio\n"
sleep 2
sed -i 's/^HOOKS.*/HOOKS=(base udev autodetect modconf block lvm2 filesystems keyboard fsck)/' /etc/mkinitcpio.conf
mkinitcpio -P

echo -e "installing grub : the boot loader\n"
grub-install --target=x86_64-efi   --efi-directory=/boot   --bootloader-id=REDABOOT
echo -e "just install grub"
sleep 2
echo -e "making the config for grub\n"
grub-mkconfig -o /boot/grub/grub.cfg
sleep 2


############################################################
### misc
############################################################
# enabling the NetworkManager service
echo -e "enabling the NetworkManager service\n"
systemctl enable NetworkManager.service
ENDE
arch-chroot /mnt sh ./inside_script.sh

echo -e "\n\n the installation has finished you can reboot now"
