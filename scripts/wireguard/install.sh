sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install wireguard

echo net.ipv4.ip_forward=1 | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

cd /etc/wireguard
umask 077

wg genkey | tee privatekey | wg pubkey > publickey

sudo cp wg0.conf /etc/wireguard/wg0.conf

sudo cat /etc/wireguard/publickey
sudo cat /etc/wireguard/privatekey

wg-quick up wg0
wg show

systemctl enable wg-quick@wg0

