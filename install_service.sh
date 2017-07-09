#/bin/bash
if [ "$#" -eq 1 ]
then
   echo "register service: $1.jar"
else
   echo "Usage: ./install_service.sh <appname>"
   exit 1
fi
uname=$(id -u -n)
gname=$(id -g -n)
sudo ln -s $1.jar /etc/init.d/$1
chown $uname:$gname $1.jar
chmod 500 $1.jar
mkdir -p $HOME/pids
mkdir -p $HOME/logs
cat <<EOF > $1.conf
PID_FOLDER=$HOME/pids
LOG_FOLDER=$HOME/logs
RUN_ARGS=$2
JAVA_OPTS=
JAVA_OPTS=" ${JAVA_OPTS} -javaagent:$(pwd)/scouter/agent.java/scouter.agent.jar"
JAVA_OPTS=" ${JAVA_OPTS} -Dobj_name=$1"
EOF
sudo service $1 start
