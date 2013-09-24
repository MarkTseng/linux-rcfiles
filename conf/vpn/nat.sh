/sbin/iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -o eth0 -j MASQUERADE
/sbin/iptables -I FORWARD -p tcp --syn -i ppp+ -j TCPMSS --set-mss 1356
