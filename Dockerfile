FROM openshift3/jenkins-1-rhel7:latest

EXPOSE 50000/tcp
EXPOSE 8080/tcp
VOLUME /var/lib/jenkins
ENV JENKINS_VERSION=1.625 \
    HOME=/var/lib/jenkins \
    JENKINS_HOME=/var/lib/jenkins \
    MAVEN_HOME=/usr/share/maven \
    JAVA_HOME=/etc/alternatives/jre \
    JAVA_OPTS=-Duser.home=$HOME

USER root

COPY apache-maven-3.3.9-bin.tar.gz /tmp/
COPY plugins.tar /tmp/
ADD configuration /opt/openshift/configuration/

RUN  ls -al /tmp && mkdir -p /usr/share/maven \
  && tar -zxvf /tmp/apache-maven-3.3.9-bin.tar.gz -C /usr/share/maven \
  && tar -xvf /tmp/plugins.tar -C /opt/openshift \
  && ln -sf /usr/share/zoneinfo/Europe/Budapest /etc/localtime \
  && yum --enablerepo=rhel-7-server-thirdparty-oracle-java-rpms -y install \
     java-1.8.0-oracle \
     java-1.8.0-oracle-devel \
     java-1.7.0-oracle \
     java-1.7.0-oracle-devel \
     which \
  && yum clean all \
  && rm -rf /var/cache/yum \
  && alternatives --set java /usr/lib/jvm/java-1.8.0-oracle-1.8.0.71-1jpp.1.el7.x86_64/jre/bin/java \
  && alternatives --set javac /usr/lib/jvm/java-1.8.0-oracle-1.8.0.71-1jpp.1.el7.x86_64/bin/javac \
  && ln -s /usr/share/maven/apache-maven-3.3.9/bin/mvn /usr/bin/mvn \
  && git config --system http.sslverify false \
  && git config --system user.email "jenkins-build-job@ulx.hu" \
  && git config --system user.name "Jenkins Build Job" \
  && chmod -R g+rw /opt/openshift \
  && chown -R 185:root /opt/openshift/plugins \
  && chown -R 185:185 ${JENKINS_HOME} \
  && rm -f /opt/openshift/plugins/openshift-pipeline.jpi \
  && rm -rf "/opt/openshift/configuration/jobs/OpenShift Sample" \
  && rm -rf /tmp/*

USER 185

CMD ["/usr/libexec/s2i/run"]

