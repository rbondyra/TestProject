#Base
FROM ubuntu:latest
#Install the pre-requisite
RUN apt-get -y update
RUN apt install -y wget
RUN apt install -y curl
RUN apt install -y unzip
RUN apt install -y tar
RUN apt install -y unzip xvfb libxi6 libgconf-2-4
RUN apt-get install -y vim
RUN apt-get install --yes software-properties-common

#Setup java
RUN echo "deb https://debian.opennms.org/ stable main" >>  /etc/apt/sources.list

RUN wget -O - http://debian.opennms.org/OPENNMS-GPG-KEY | apt-key add -

RUN apt-get -y update
RUN apt install --yes  openjdk-8-jdk openjdk-8-jre
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> ~/.bashrc


ARG FIREFOX_VERSION=93.0b2
#ARG CHROME_VERSION=latest
ARG CHROMDRIVER_VERSION=95.0.4638.17
ARG FIREFOXDRIVER_VERSION=0.30.0


RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt install --yes ./google-chrome-stable_current_amd64.deb

#Install chromedriver for Selenium
RUN mkdir -p /app/bin
RUN curl https://chromedriver.storage.googleapis.com/$CHROMDRIVER_VERSION/chromedriver_linux64.zip -o /tmp/chromedriver.zip \
    && unzip /tmp/chromedriver.zip -d /app/bin/ \
    && rm /tmp/chromedriver.zip
RUN chmod +x /app/bin/chromedriver

#Install firefox
RUN wget --no-verbose -O /tmp/firefox.tar.bz2 https://download-installer.cdn.mozilla.net/pub/firefox/releases/$FIREFOX_VERSION/linux-x86_64/en-US/firefox-$FIREFOX_VERSION.tar.bz2 \
  && bunzip2 /tmp/firefox.tar.bz2 \
  && tar xvf /tmp/firefox.tar \
  && mv /firefox /opt/firefox-$FIREFOX_VERSION \
  && ln -s /opt/firefox-$FIREFOX_VERSION/firefox /usr/bin/firefox

#Install Geckodriver
RUN wget https://github.com/mozilla/geckodriver/releases/download/v$FIREFOXDRIVER_VERSION/geckodriver-v$FIREFOXDRIVER_VERSION-linux64.tar.gz \
    && tar -xf geckodriver-v0.30.0-linux64.tar.gz \
    && cp geckodriver /app/bin/geckodriver
RUN chmod +x /app/bin/geckodriver

#Install Maven
ARG USER_HOME_DIR="/root"
#SHA key to validate the maven download
ARG SHA=1c12a5df43421795054874fd54bb8b37d242949133b5bf6052a063a13a93f13a20e6e9dae2b3d85b9c7034ec977bbc2b6e7f66832182b9c863711d78bfe60faa

ARG BASE_URL=https://downloads.apache.org/maven/maven-3/3.8.3/binaries

RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && echo "Downlaoding maven" \
  && curl -kfsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-3.8.3-bin.tar.gz \
  \
  && echo "Checking download hash" \
  && echo "${SHA}  /tmp/apache-maven.tar.gz" | sha512sum -c - \
  \
  && echo "Unziping maven" \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  \
  && echo "Cleaning and setting links" \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

#Define environmental variables required by Maven, like Maven_Home directory and where the maven repo is located
ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "/root/.m2"
#Copy our project
COPY . /app
#Making our working directory as /app
WORKDIR /app