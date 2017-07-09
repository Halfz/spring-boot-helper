#/bin/bash
pkill -f 'scouter-server-boot.jar'
pkill -f 'scouter.host.jar'
nohup java -Xmx512m -classpath ./scouter/server/scouter-server-boot.jar scouter.boot.Boot ./scouter/server/lib > $HOME/logs/scouter.out &
nohup java  -classpath ./scouter/agent.host/scouter.host.jar scouter.boot.Boot ./scouter/agent.host/lib > $HOME/logs/scouter-host.out &
sleep 1
tail -100 $HOME/logs/scouter.out
tail -100 $HOME/logs/scouter-host.out
