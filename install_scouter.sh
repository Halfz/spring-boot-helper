#/bin/bash
if [ ! -f scouter-all-1.7.1.tar.gz ]; then
  # if git is slow use google drive ...
  # wget https://github.com/scouter-project/scouter/releases/download/v1.7.1/scouter-all-1.7.1.tar.gz
  wget -O scouter-all-1.7.1.tar.gz  "https://drive.google.com/uc?export=download&id=0B5XgPksl3sfPbWJDSG9Vejh4ZTg"
  tar xvzf scouter-all-1.7.1.tar.gz
fi
mkdir -p $HOME/app-data
mkdir -p $HOME/app-data/scouterdb
cat <<EOF > scouter.conf
# Agent Control and Service Port(Default : TCP 6100)
net_tcp_listen_port=6100
# UDP Receive Port(Default : 6100)
net_udp_listen_port=6100
# DB directory(Default : ./database)
db_dir=$HOME/app-data/scouterdb
# Log directory(Default : ./logs)
log_dir=$HOME/logs
EOF
./run_scouter.sh
