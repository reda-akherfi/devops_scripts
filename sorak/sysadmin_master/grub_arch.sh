#!/bin/bash


############################################################
### basic setup for the env itself
############################################################
# setting up the font inside the live env
read -p "Is the text small for your taste Mr Redaa? [Y/n] " text_small
if [ $text_small = "n" ]
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
############################################################
# choosing the drive
disk_is_selected=0
until [ $disk_is_selected -eq 1 ]
do
    echo -e "choosing the drive\n"
    sleep 3
    lsblk
    read -p "enter the name of the drive , beware of typos !!!  " disk_name
    sleep 3
    echo -e "the disk you selected is $disk_name \n"
    read -p "Is this selection the right one ? [yes/No]" user_selected_disk
    if [ $user_selected_disk = "yes" ]
    then
        disk_is_selected=1
        echo -e "\nyou chose yes\n"
        sleep 3
        clear
    else 
        echo -e "you chose to repeat the selection \n"
        sleep 3
        clear
    fi
done

# $ parted [options] [device [command [options...]...]]
# partitionning the disk
partitionning_successful=0
until [ $partitionning_successful -eq 1 ]
do
    echo -e "partitionning the disk\n"
    sleep 3
    # use parted
    echo -e "use parted\n"
    # creating the gpt label
    echo -e "creating the gpt label\n"
    parted --fix --script $disk_name mklabel "gpt"
    sleep 3
    # making the efi partition
    echo -e "making the efi partition\n"
    sleep 3
    parted --fix --script $disk_name mkpart  "EFIREDA" "fat32" 1MiB 301MiB
    # setting the bootable flag for the efi partition
    echo -e "setting the bootable flag for the efi partition\n"
    sleep 3
    parted --fix --script $disk_name set 1 esp on
    # making the root partition as the rest of the disk
    echo -e "making the root partition as the rest of the disk\n"
    sleep 3
    parted --fix --script $disk_name mkpart  "ROOTREDA" "ext4" 301MiB 100%
    clear
    partitionning_successful=1
    parted --script ${disk_name} print
###    read -p "is this partioning scheme acceptable? [yes/No] " user_partitioning_answer
###    if [ $user_partitioning_answer = "yes" ]
###    then
###        echo -e "you have selected the cuurent partitionning scheme\n"
###        partitionning_successful=1
###        sleep 3
###        clear
###    else
###        echo -e "something went wrong with the partitionning \n going at it again but you might want to rewrite the script\n"
###        sleep 2
###        clear
###    fi
    sleep 5
done

# making the file system -- formatting
echo -e "making the file system -- formatting\n"
sleep 3
# formatting the efi partition
echo -e "formatting the efi partition in vfat 32\n"
sleep 3
mkfs.vfat -F32 -n "EFISYSTEM" "${disk_name}1"
# formatting the root partition 
echo -e "formatting the root partition in ext4\n"
sleep 3
mkfs.ext4 -F -F -L "ROOT" "${disk_name}2"
clear

# mounting the partitions
echo -e "mounting the partitions\n"
sleep 3
# mouting the root parttion into /mnt
echo -e "mouting the root parttion into /mnt\n"
sleep 3
mount -t ext4 ${disk_name}2 /mnt
# mounting the efi part to /mnt/boot
echo -e "mounting the efi part to /mnt/boot\n"
sleep 3
mkdir /mnt/boot
mount -t vfat  ${disk_name}1 /mnt/boot
sleep 3
clear


############################################################
### installing software
############################################################
# chrooting to the live env
echo -e "installing software"
pacstrap -K /mnt base linux linux-firmware intel-ucode networkmanager sudo grub efibootmgr
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
