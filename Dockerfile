FROM debian:latest

ARG UNIFI_VERSION
ARG DEBIAN_FRONTEND="noninteractive"

RUN apt-get update -qq \
  && apt-get install -yqq curl gnupg2 libcap2

RUN echo "deb http://archive.raspbian.org/raspbian stretch main contrib non-free rpi" > /etc/apt/sources.list.d/raspbian-stretch.list \
  && curl -fsSL http://archive.raspbian.org/raspbian.public.key | gpg --dearmor > /etc/apt/trusted.gpg.d/raspbian-stretch.gpg \
  && apt-get update -qq \
  && apt-get install -yqq mongodb-server openjdk-8-jre-headless

RUN curl -fsSLO https://dl.ui.com/unifi/${UNIFI_VERSION}/unifi_sysvinit_all.deb

RUN dpkg -i --ignore-depends=java8-runtime-headless --ignore-depends=logrotate --ignore-depends=jsvc --ignore-depends=binutils unifi_sysvinit_all.deb \
  && rm unifi_sysvinit_all.deb

CMD ["java",  "-jar", "/usr/lib/unifi/lib/ace.jar", "start"]
