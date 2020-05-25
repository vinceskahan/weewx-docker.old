
FROM centos:8
MAINTAINER Vince Skahan "vinceskahan@gmail.com"

# copy supervisor config file into place
COPY supervisord.conf /etc/supervisord.conf

# centos is odd - you need to add tzdata or locale goes whacko
RUN yum update -y  \
    && yum install -y wget tzdata rsyslog unzip \
           python3-pip python3-configobj python3-pillow python3-pyserial python3-pyusb \
           epel-release procps

# from epel
RUN yum update -y \
    && yum install -y python3-cheetah supervisor

# (note: adding pyephem above makes the size much bigger and the build much slower)

# extract it out
RUN wget http://weewx.com/downloads/weewx-4.1.0.tar.gz -O /tmp/weewx.tgz && \
      cd /tmp && \
      tar zxvf /tmp/weewx.tgz

# need rsyslog
COPY rsyslog.conf /etc/rsyslog.conf


#### note the call to rsyslogd at the end of the next RUN section
#### so that it starts ok before weewx when the container runs

# use this line to get master latest in zip format
#### RUN wget https://github.com/weewx/weewx/archive/master.zip -O /tmp/weewx.zip && cd /tmp && \ unzip /tmp/weewx.zip && \

# or use this line to use a specific version
RUN wget http://www.weewx.com/downloads/released_versions/weewx-4.1.0.tar.gz -O /tmp/weewx.tgz && cd /tmp && tar zxvf /tmp/weewx*.tgz && \
      cd weewx-* ; python3 ./setup.py build && python3 ./setup.py install --no-prompt && \
      cp /home/weewx/util/init.d/weewx.debian /etc/init.d/weewx && \
      mkdir -p /home/weewx/archive /home/weewx/public_html && \
      sed -i -e s:My\ Little\ Town,\ Oregon:Centos8\ setup.py\ test\ system: /home/weewx/weewx.conf && \
      rsyslogd

#--- uncomment to set weewx debug=1 
# RUN sed -i -e s:debug\ =\ 0:debug\ =\ 1: /home/weewx/weewx.conf

#---- uncomment to set your timezone to other than UTC
RUN TIMEZONE="US/Pacific" && rm -f /etc/localtime && ln -s /usr/share/zoneinfo/${TIMEZONE} /etc/localtime

# call supervisord as our container process to run
CMD ["/usr/bin/supervisord"]

##### vds
