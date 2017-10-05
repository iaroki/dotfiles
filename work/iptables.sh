#!/bin/bash

echo 1 > /proc/sys/net/ipv4/ip_forward
sysctl -w net.ipv4.ip_forward=1

iptables -A FORWARD -i eth0 -o eth1 -j ACCEPT
iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

iptables -A INPUT -i eth+ -m pkttype --pkt-type broadcast -j ACCEPT
iptables -A INPUT -i eth+ -p tcp -m tcp -m multiport --dports 139,445 -j ACCEPT
iptables -A INPUT -i eth+ -p udp -m udp -m multiport --dports 137,138 -j ACCEPT

iptables -A FORWARD -i eth+ -m pkttype --pkt-type broadcast -j ACCEPT
iptables -A FORWARD -i eth+ -p tcp -m tcp -m multiport --dports 139,445 -j ACCEPT
iptables -A FORWARD -i eth+ -p udp -m udp -m multiport --dports 137,138 -j ACCEPT
