
sudo parted /dev/sda -- mklabel msdos
sudo parted /dev/sda -- mkpart primary 1MiB 100%
sudo mkfs.ext4 -L nixos /dev/sda1
sudo mount /dev/disk/by-label/nixos /mnt
sudo nixos-generate-config --root /mnt
