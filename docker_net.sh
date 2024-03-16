sudo yum install iptables-services
sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo systemctl enable iptables
sudo systemctl start iptables
sudo iptables -I DOCKER-USER -p tcp --dport 8080 -s 192.168.1.0/24 -j ACCEPT
sudo iptables -I DOCKER-USER -p tcp --dport 8080 -s 10.10.10.10 -j ACCEPT
sudo iptables -A DOCKER-USER -p tcp --dport 8080 -j DROP
sudo service iptables save
