zk:
  image: mesos
  command: /usr/share/zookeeper/bin/zkServer.sh start-foreground
  name: zk

master:
  image: mesos-master
  ports:
    - "5050:5050"
    - "8080:8080"
  links:
    - "zk:zookeeper"
  hostname: $HOSTNAME
  name: mesos-master

slave:
  privileged: true
  image: mesos-slave
  links:
    - "zk:zookeeper"
  volumes:
    - "/var/run/docker.sock:/var/run/docker.sock"
    - "/var/lib/docker:/var/lib/docker"
    - "/usr/local/bin/docker:/usr/local/bin/docker"
    - "/sys:/sys"
    - "/tmp/mesos:/tmp/mesos"
  ports:
    - "5051:5051"
  hostname: $HOSTNAME
  name: mesos-slave

consul:
  environment:
    MASTER_IP: $IP
    MASTER_HOST: $HOSTNAME
    DC: $DC
    CONSUL_BOOTSTRAP: \"$BOOTSTRAP\"
    CONSUL_MODE: \"$MODE\"
  image: consul
  ports:
    - "8300:8300"
    - "8301:8301"
    - "8301:8301/udp"
    - "8302:8302"
    - "8302:8302/udp"
    - "8400:8400"
    - "8500:8500"
    - "8600:8600"
    - "8600:8600/udp"
  hostname: $HOSTNAME
  name: consul
