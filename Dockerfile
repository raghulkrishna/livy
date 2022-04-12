FROM debian:buster

RUN apt-get update \
 && apt-get install -y locales \
 && dpkg-reconfigure -f noninteractive locales \
 && locale-gen C.UTF-8 \
 && /usr/sbin/update-locale LANG=C.UTF-8 \
 && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
 && locale-gen \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Users with other locales should set this in their derivative image
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get update \
 && apt-get install -y curl unzip \
    python3 python3-setuptools python3-pip wget \
 && ln -s /usr/bin/python3 /usr/bin/python \
 && pip3 install py4j \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# http://blog.stuart.axelbrooke.com/python-3-on-spark-return-of-the-pythonhashseed
ENV PYTHONHASHSEED 0
ENV PYTHONIOENCODING UTF-8
ENV PIP_DISABLE_PIP_VERSION_CHECK 1

ARG JAVA_MAJOR_VERSION=8
ARG JAVA_UPDATE_VERSION=321
ARG JAVA_BUILD_NUMBER=10
ENV JAVA_ALL_VERSION=jdk1.8.0_202.jdk
ENV JAVA_HOME /usr/jdk1.${JAVA_MAJOR_VERSION}.0_${JAVA_UPDATE_VERSION}

ENV PATH $PATH:$JAVA_HOME/bin
COPY jdk-8u321-linux-x64.tar.gz server-jre-8u321-linux-x64.tar.gz
# RUN wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie"  \
#     http://download.oracle.com/otn-pub/java/jdk/${JAVA_MAJOR_VERSION}u${JAVA_UPDATE_VERSION}-b${JAVA_BUILD_NUMBER}/d7fc238d0cbf4b0dac67be84580cfb4b/server-jre-${JAVA_MAJOR_VERSION}u${JAVA_UPDATE_VERSION}-linux-x64.tar.gz

RUN tar xvfz $(pwd)/server-jre-${JAVA_MAJOR_VERSION}u${JAVA_UPDATE_VERSION}-linux-x64.tar.gz -C /usr/ \
  && ln -s $JAVA_HOME /usr/java \
  && rm -rf $JAVA_HOME/man \
  && rm $(pwd)/server-jre-${JAVA_MAJOR_VERSION}u${JAVA_UPDATE_VERSION}-linux-x64.tar.gz

# ARG JAVA_MAJOR_VERSION=8
# ARG JAVA_UPDATE_VERSION=291
# ARG JAVA_BUILD_NUMBER=10
# ENV JAVA_HOME /usr/jdk1.${JAVA_MAJOR_VERSION}.0_${JAVA_UPDATE_VERSION}

# ENV PATH $PATH:$JAVA_HOME/bin
# RUN wget -c --header "Cookie: oraclelicense=accept-securebackup-cookie"  \
#     http://download.oracle.com/otn-pub/java/jdk/${JAVA_MAJOR_VERSION}u${JAVA_UPDATE_VERSION}-b${JAVA_BUILD_NUMBER}/d7fc238d0cbf4b0dac67be84580cfb4b/server-jre-${JAVA_MAJOR_VERSION}u${JAVA_UPDATE_VERSION}-linux-x64.tar.gz

# RUN tar xvfz $(pwd)/server-jre-${JAVA_MAJOR_VERSION}u${JAVA_UPDATE_VERSION}-linux-x64.tar.gz -C /usr/ \
#   && ln -s $JAVA_HOME /usr/java \
#   && rm -rf $JAVA_HOME/man \
#   && rm $(pwd)/server-jre-${JAVA_MAJOR_VERSION}u${JAVA_UPDATE_VERSION}-linux-x64.tar.gz

RUN wget https://archive.apache.org/dist/spark/spark-3.1.1/spark-3.1.1-bin-hadoop3.2.tgz
RUN tar -zxvf spark-3.1.1-bin-hadoop3.2.tgz