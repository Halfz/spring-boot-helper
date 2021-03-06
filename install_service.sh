#/bin/bash
if [ "$#" -eq 2 ]
then
   echo "register service: $1.jar port: $2"
else
   echo "Usage: ./install_service.sh <appname> <port>"
   exit 1
fi
uname=$(id -u -n)
gname=$(id -g -n)
sudo ln -s $(pwd)/$1.jar /etc/init.d/$1
chown $uname:$gname $1.jar
chmod 500 $1.jar
chmod 500 /etc/init.d/$1
mkdir -p $HOME/pids
mkdir -p $HOME/logs
cat <<EOF > $1.conf
PID_FOLDER=$HOME/pids
LOG_FOLDER=$HOME/logs
RUN_ARGS=$2
JAVA_OPTS=" \${JAVA_OPTS} -javaagent:$(pwd)/scouter/agent.java/scouter.agent.jar"
JAVA_OPTS=" \${JAVA_OPTS} -Dobj_name=$1"
EOF
