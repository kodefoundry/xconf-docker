# xconf-docker
A repository build and containerise RDK Xconf Server then deploy locally using docker-compose

Take a look at the xconf_build.sh if you want to customise path to maven (m2) and other paths
Run 'xconf_build.sh' first, on sucessful completion of the script, two containers as below


|REPOSITORY           |TAG                 |IMAGE ID            |CREATED             |SIZE         |
|---|---|---|---|---|
|xconf/dataservice    |latest              |xxxxxxxxxxxx        |5 minutes ago       |156MB        |
|                     |                    |                    |                    |             |
|xconf/adminservice   |latest              |xxxxxxxxxxxx        |5 minutes ago       |257MB        |




Run 'docker-compose up' to deploy the the services which on sucessful deployment will look as below



           Name                          Command                  State                        Ports
----------------------------------------------------------------------------------------------------------------------

cassandra                     docker-entrypoint.sh cassa ...   Up (healthy)   7000/tcp, 7001/tcp, 7199/tcp,
                                                                              0.0.0.0:9042->9042/tcp, 9160/tcp
                                                                              
cassandra-load-keyspace       docker-entrypoint.sh /bin/ ...   Exit 0

xconf-docker_adminservice_1   /docker-entrypoint.sh            Up             0.0.0.0:9093->9093/tcp

xconf-docker_dataservice_1    /docker-entrypoint.sh            Up             0.0.0.0:9092->9092/tcp


Run 'docker-compose down' to stop all the containers.

This is a work in progress. As of now the services are getting deployed but the application are not running. The application is not able to connect to the Cassandra DB. 
I am investigating and will commit changes as and when I find a fix.
