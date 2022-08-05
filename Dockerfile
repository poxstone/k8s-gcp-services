#FROM danielhwang/ubuntu20-jdk8:latest
FROM ucalgary/glassfish:latest

#ENV DOMAIN_NAME=domain1
#ENV ADMIN_PASSWORD=gf
#ENV PASSWORD_FILE=/opt/glassfish4/glassfish/passwordFile
#ENV GLASSFISH_DIR=/opt/glassfish4/glassfish
#EXPOSE 4848 8080 8181
ENV AS_ADMIN_PASSWORD=abcd1234
ENV AS_ADMIN_ENABLE_SECURE=1
ENV GLASSFISH_HOME=/opt/glassfish4

#WORKDIR /home/administrador
#COPY docker-entrypoint.sh $GLASSFISH_HOME/

#ENTRYPOINT ["/usr/local/glassfish3/docker-entrypoint.sh"]
#CMD ["/opt/glassfish4/glassfish/bin/asadmin", "start-domain", "--verbose"]
#ENTRYPOINT sh -c ${GLASSFISH_DIR}/bin/asadmin start-domain ${DOMAIN_NAME} --verbose
#ENTRYPOINT sh -c ${GLASSFISH_DIR}/bin/asadmin start-domain ${DOMAIN_NAME};bash
#ENTRYPOINT /opt/jdk/jdk1.8.0_144/bin/java -cp /opt/glassfish4/glassfish/modules/glassfish.jar -XX:+UnlockDiagnosticVMOptions -XX:NewRati