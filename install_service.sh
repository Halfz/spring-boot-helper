#/bin/bash
uname=$(id -u -n)
gname=$(id -g -n)
sudo ln -s $1.jar /etc/init.d/$1
sudo service $1 start
chown $uname:$gname $1.jar
chmod 500 $1.jar
mkdir -p $HOME/pids
mkdir -p $HOME/logs
cat <<EOF >> $1.conf
PID_FOLDER=$HOME/pids
LOG_FOLDER=$HOME/logs
RUN_ARGS=$2
JAVA_OPTS=
EOF
