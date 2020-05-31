FROM maven:3.5-jdk-8-alpine
ENV MAVEN_PROXY -DproxySet=true -Dhttp.proxyHost=$MAVEN_PROXY_HOST -Dhttp.proxyPort=$MAVEN_PROXY_PORT -Dhttps.proxyHost=$MAVEN_PROXY_HOST -Dhttps.proxyPort=$MAVEN_PROXY_PORT -Dhttp.nonProxyHosts=mvnrepository.com
ENV MAVEN_CLI_OPTS -Dmaven.test.skip=true
RUN apk update && apk add git
VOLUME [ "/artifacts", "/root/.m2" ]
ENTRYPOINT  git clone "https://code.rdkcentral.com/r/rdk/components/generic/xconfserver" \
&& cd xconfserver \
&& mvn $MAVEN_CLI_OPTS clean package \
&& cp ./xconf-angular-admin/src/main/webapp/*.json ./xconf-angular-admin/target/xconfAdminService2 \
&& cp ./xconf-angular-admin/src/main/webapp/Gruntfile.js ./xconf-angular-admin/target/xconfAdminService2 \
&& cp -r ./xconf-angular-admin/target/xconfAdminService2 /artifacts/adminservice \
&& cp -r ./xconf-dataservice/target/xconf-dataservice /artifacts/dataservice \
#&& /bin/sh