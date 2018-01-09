FROM alpine:latest
ADD rgerhards@adiscon.com-5a54927f.rsa.pub /etc/apk/keys/rgerhards@adiscon.com-5a54927f.rsa.pub
#ADD rger-5a54d18f.rsa.pub /etc/apk/keys/rger-5a54d18f.rsa.pub 
RUN echo "http://build.rsyslog.com/alpine" >> /etc/apk/repositories \
  && apk update \
  && apk --no-cache add alpine-sdk coreutils cmake \
  && adduser -G abuild -g "Alpine Package Builder" -s /bin/ash -D builder \
  && echo "builder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
  && mkdir /packages \
  && chown builder:abuild /packages
COPY /abuilder /bin/
USER builder
ENTRYPOINT ["abuilder", "-r"]
WORKDIR /home/builder/package
ENV RSA_PRIVATE_KEY_NAME ssh.rsa
ENV PACKAGER_PRIVKEY /home/builder/${RSA_PRIVATE_KEY_NAME}
ENV REPODEST /packages
VOLUME ["/home/builder/package"]
