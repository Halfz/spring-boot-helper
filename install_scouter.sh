#/bin/bash
ver=${1:-1.7.1}
#wget https://github.com/scouter-project/scouter/releases/download/v$(1)/scouter-all-$(1).tar.gz
#tar xvzf scouter-all-$(1).tar.gz
mkdir -p $HOME/data/scouterdb
cat <<EOF > scouter/server/conf/scouter.conf
# Agent Control and Service Port(Default : TCP 6100)
net_tcp_listen_port=6100
# UDP Receive Port(Default : 6100)
net_udp_listen_port=6100
# DB directory(Default : ./database)
db_dir=$HOME/data/scouterdb
# Log directory(Default : ./logs)
log_dir=$HOME/logs
EOF
sudo ln -s ./scouter/server/startup.sh /etc/init.d/scouter
sudo service scouter start
sudo ln -s ./scouter/agent.host/host.sh /etc/init.d/scouter-host
sudo service scouter-host start
