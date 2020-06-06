FROM alpine:3.11

LABEL author="biju.nair@ltts.com"
LABEL maintainer="L&T Technology Services"

RUN apk upgrade --update && apk add --no-cache nodejs npm openjdk8-jre curl gnupg git && rm -rf /var/apk/*

# Installing Jetty
ENV JAVA_HOME /usr/lib/jvm/default-jvm
ENV JETTY_VERSION 9.4.27.v20200227
ENV JETTY_HOME /usr/local/jetty
ENV JETTY_BASE /var/lib/jetty
ENV TMPDIR /tmp/jetty
ENV LOGDIR /var/log
ENV PATH $JAVA_HOME/bin:$JETTY_HOME/bin:$JAVA_HOME/db/bin:$PATH
ENV JETTY_TGZ_URL https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-home/$JETTY_VERSION/jetty-home-$JETTY_VERSION.tar.gz

ENV J2SDKDIR $JAVA_HOME
ENV J2REDIR $JAVA_HOME
ENV DERBY_HOME $JAVA_HOME/db


#	export J2SDKDIR=/usr/lib/jvm/ jdk-1.8.0
#	export J2REDIR=/usr/lib/jvm/ jdk-1.8.0
#	export PATH=$PATH:/usr/lib/jvm/java-jdk-1.8.0/bin:/usr/lib/jvm/java-jdk-1.8.0/db/bin
#	export JAVA_HOME=/usr/lib/jvm/java-jdk-1.8.0
#	export DERBY_HOME=/usr/lib/jvm/java-jdk-1.8.0/db


ENV JAVA_OPTIONS "-DappConfig=$XCONF_PROPS -DserviceName=xconfAngularUIService \
-Xms2048m -Xmx2048m -XX:NewSize=512m -XX:MaxNewSize=512m \
-XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:+HeapDumpOnOutOfMemoryError \
-XX:HeapDumpPath=$LOGDIR/xconfAngularUIService.heapDump -XX:OnOutOfMemoryError=$LOGDIR/oom/OOM.rb \
-Djetty.logs=$LOGDIR/jetty -Djava.io.tmpdir=$TMPDIR -DENABLE_OBIEE_SCP_URL_PROP=false \
-Dtheplatform.log.dir=$LOGDIR/platform -Djava.library.path=$JAVA_HOME/jre/lib/ext \
-DSTOP.PORT=9082 -Djetty.port=9092"

# GPG Keys are personal keys of Jetty committers (see https://github.com/eclipse/jetty.project/blob/0607c0e66e44b9c12a62b85551da3a0edce0281e/KEYS.txt)
ENV JETTY_GPG_KEYS \
	# Jan Bartel      <janb@mortbay.com>
	AED5EE6C45D0FE8D5D1B164F27DED4BF6216DB8F \
	# Jesse McConnell <jesse.mcconnell@gmail.com>
	2A684B57436A81FA8706B53C61C3351A438A3B7D \
	# Joakim Erdfelt  <joakim.erdfelt@gmail.com>
	5989BAF76217B843D66BE55B2D0E1FB8FE4B68B4 \
	# Joakim Erdfelt  <joakim@apache.org>
	B59B67FD7904984367F931800818D9D68FB67BAC \
	# Joakim Erdfelt  <joakim@erdfelt.com>
	BFBB21C246D7776836287A48A04E0C74ABB35FEA \
	# Simone Bordet   <simone.bordet@gmail.com>
	8B096546B1A8F02656B15D3B1677D141BCF3584D \
	# Greg Wilkins    <gregw@webtide.com>
	FBA2B18D238AB852DF95745C76157BDF03D0DCD6 \
	# Greg Wilkins    <gregw@webtide.com>
	5C9579B3DB2E506429319AAEF33B071B29559E1E

RUN set -xe ; \
	# fetch GPG keys
        export GNUPGHOME=/jetty-keys ; \
    mkdir -p "$GNUPGHOME" ; \
        for key in $JETTY_GPG_KEYS; do \
                for server in \
                        ha.pool.sks-keyservers.net \
                        p80.pool.sks-keyservers.net:80 \
                        ipv4.pool.sks-keyservers.net \
                        pgp.mit.edu ; \
                do \
                        if gpg --batch --keyserver "$server" --recv-keys "$key"; then \
                                break; \
                        fi; \
                done; \
        done ; \
	#
	echo Fetch jetty release into JETTY_HOME at $JETTY_HOME ; \   
	mkdir -p "$JETTY_HOME" ; \
	cd $JETTY_HOME ; \
	curl -SL "$JETTY_TGZ_URL" -o jetty.tar.gz ; \
	curl -SL "$JETTY_TGZ_URL.asc" -o jetty.tar.gz.asc ; \
	#
	echo Verify GPG signatures; \
	#gpg --batch --verify jetty.tar.gz.asc jetty.tar.gz ; \
	#
	echo Unpack jetty; \
	tar -xvf jetty.tar.gz --strip-components=1 ; \
	sed -i '/jetty-logging/d' etc/jetty.conf ; \
	#
	echo Create and configure the JETTY_BASE directory; \
	mkdir -p "$JETTY_BASE" ; \
	cd $JETTY_BASE ; \
	java -jar "$JETTY_HOME/start.jar" --create-startd \
		--add-to-start="server,http,deploy,jsp,jstl,ext,resources,websocket" ; \
	mkdir -p "$TMPDIR" ; \
    #addgroup -S jetty && adduser -S -g jetty jetty ; \
	#chown -R jetty:jetty "$JETTY_HOME" "$JETTY_BASE" "$TMPDIR" "$LOGDIR"; \
	#
	echo Cleanup; \
	rm -rf /tmp/hsperfdata_root ; \
	rm -fr $JETTY_HOME/jetty.tar.gz* ; \
	rm -fr /jetty-keys $GNUPGHOME ; \
	rm -rf /tmp/hsperfdata_root ; \
	#
	echo Basic smoke test; \
	java -jar "$JETTY_HOME/start.jar" --list-config ;


COPY ./webapp $JETTY_BASE/webapps/admin

RUN cd $JETTY_BASE/webapps/admin; \
    npm install -g bower; \
    npm install -g grunt-cli; \
    npm install; \
    npm install grunt-contrib-copy --save-den; \
	bower --allow-root install; \
	grunt install; \
    cd $JETTY_BASE/webapps/admin/WEB-INF/classes; \
    mv sample.service.properties service.properties; \
    echo -e "\nautoGenerateSchema=true\n\
connectionPools.SharedConnectionPool.maxConnsPerHost=15\n\
connectionPools.SharedConnectionPool.seeds=cassandra\n" >> $JETTY_BASE/webapps/admin/WEB-INF/service.properties;

#connectionPools.SharedConnectionPool.nodeDiscoveryType=RING_DESCRIBE\n \
#connectionPools.SharedConnectionPool.readConsistencyLevel=CL_LOCAL_QUORUM\n \
#connectionPools.SharedConnectionPool.useConnectionPoolMonitor=true\n \
#connectionPools.SharedConnectionPool.writeConsistencyLevel=CL_LOCAL_QUORUM\n \
#connectionPools.SharedConnectionPool.autoDiscoverHosts=true\n" 

WORKDIR $JETTY_BASE
COPY docker-entrypoint.sh generate-jetty-start.sh /
RUN chmod +x /docker-entrypoint.sh; \
	addgroup -S jetty && adduser -S -g jetty jetty; \
	chown -R jetty:jetty "$JETTY_HOME" "$JETTY_BASE" "$TMPDIR" "$LOGDIR";
USER jetty
EXPOSE 9093

ENV XCONF_PROPS $JETTY_BASE/webapps/admin/WEB-INF/service.properties
ENV JAVA_OPTIONS "-DappConfig=$XCONF_PROPS -DserviceName=xconfUIService \
-Xms2048m -Xmx2048m -XX:NewSize=512m -XX:MaxNewSize=512m \
-XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:+HeapDumpOnOutOfMemoryError \
-XX:HeapDumpPath=$LOGDIR/xconfUIService.heapDump -XX:OnOutOfMemoryError=$LOGDIR/oom/OOM.rb \
-Djetty.logs=$LOGDIR/jetty -Djava.io.tmpdir=$TMPDIR -DENABLE_OBIEE_SCP_URL_PROP=false \
-Dtheplatform.log.dir=$LOGDIR/platform -Djava.library.path=$JAVA_HOME/jre/lib/ext \
-DSTOP.PORT=9083 -Djetty.port=9093"

ENTRYPOINT ["/docker-entrypoint.sh"]
