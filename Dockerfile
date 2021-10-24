#Step 0: Choose base
FROM ubuntu:latest
#Step 1 : Install the pre-requisite
RUN apt-get -y update
# Install basic software support
RUN apt install -y wget
RUN apt install -y curl
RUN apt install -y unzip
RUN apt install -y tar
RUN apt install -y emacs




RUN apt-get update && \
    apt-get install --yes software-properties-common

#Step 1.1: setup java
RUN echo "deb https://debian.opennms.org/ stable main" >>  /etc/apt/sources.list

RUN wget -O - http://debian.opennms.org/OPENNMS-GPG-KEY | apt-key add -

RUN apt-get -y update

# Add the JDK 8 and accept licenses (mandatory)
RUN apt install --yes  openjdk-8-jdk openjdk-8-jre

#RUN apt-get --no-install-recommends  --yes install oracle-java8-installer

RUN echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> ~/.bashrc

#Version numbers
ARG FIREFOX_VERSION=93.0b2
ARG CHROME_VERSION=95.0.4638.54
#ARG CHROMDRIVER_VERSION=83.0.4103.39
#ARG FIREFOXDRIVER_VERSION=0.26.0
ARG CHROMDRIVER_VERSION=95.0.4638.17
ARG FIREFOXDRIVER_VERSION=0.30.0

#Step 2: Install Chrome
RUN curl http://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_$CHROME_VERSION-1_amd64.deb -o /chrome.deb
RUN RUN dpkg -i /chrome.deb; apt-get install -f -y
RUN rm /chrome.deb
#Step 3: Install chromedriver for Selenium
RUN mkdir -p /app/bin
RUN curl https://chromedriver.storage.googleapis.com/$CHROMDRIVER_VERSION/chromedriver_linux64.zip -o /tmp/chromedriver.zip \
    && unzip /tmp/chromedriver.zip -d /app/bin/ \
    && rm /tmp/chromedriver.zip
RUN chmod +x /app/bin/chromedriver
#Step 4 : Install firefox
RUN wget --no-verbose -O /tmp/firefox.tar.bz2 https://download-installer.cdn.mozilla.net/pub/firefox/releases/$FIREFOX_VERSION/linux-x86_64/en-US/firefox-$FIREFOX_VERSION.tar.bz2 \
  && bunzip2 /tmp/firefox.tar.bz2 \
  && tar xvf /tmp/firefox.tar \
  && mv /firefox /opt/firefox-$FIREFOX_VERSION \
  && ln -s /opt/firefox-$FIREFOX_VERSION/firefox /usr/bin/firefox
  #Step 5: Install Geckodriver
RUN wget https://github.com/mozilla/geckodriver/releases/download/v$FIREFOXDRIVER_VERSION/geckodriver-v$FIREFOXDRIVER_VERSION-linux64.tar.gz \
    && tar -xf geckodriver-v0.30.0-linux64.tar.gz \
    && cp geckodriver /app/bin/geckodriver
RUN chmod +x /app/bin/geckodriver
#Step 6: Install Maven
# 1- Define Maven version
ARG MAVEN_VERSION=3.8.3
# 2- Define a constant with the working directory
ARG USER_HOME_DIR="/root"

# 3- Define the SHA key to validate the maven download
#ARG SHA=c35a1803a6e70a126e80b2b3ae33eed961f83ed74d18fcd16909b2d44d7dada3203f1ffe726c17ef8dcca2dcaa9fca676987befeadc9b9f759967a8cb77181c0
ARG SHA=1c12a5df43421795054874fd54bb8b37d242949133b5bf6052a063a13a93f13a20e6e9dae2b3d85b9c7034ec977bbc2b6e7f66832182b9c863711d78bfe60faa

# 4- Define the URL where maven can be downloaded from
#ARG BASE_URL=http://apachemirror.wuchna.com/maven/maven-3/${MAVEN_VERSION}/binaries
ARG BASE_URL=https://downloads.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries

# 5- Create the directories, download maven, validate the download, install it, remove downloaded file and set links
RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && echo "Downlaoding maven" \
  && curl -kfsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
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

# 6- Define environmental variables required by Maven, like Maven_Home directory and where the maven repo is located
ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"
#Step 7: Copy our project
COPY . /app
#Making our working directory as /app
WORKDIR /app