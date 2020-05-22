
FROM ubuntu:20.04
MAINTAINER Vince Skahan "vinceskahan@gmail.com"

# copy supervisor config file into place
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# cleanup of apt remnants courtesy of:
#  https://gist.github.com/marvell/7c812736565928e602c4

RUN apt-get update \
    && apt-get install -y python3-configobj \
            python3-cheetah \
            python3-pil \
            python3-serial \
            python3-usb \
            python3-pip \
            wget supervisor procps vim sqlite3 rsyslog unzip \
    && apt-get clean autoclean \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/{apt,dpkg,cache,log}
# optional: add python3-pyephem to the list above

# copy rsyslogd config file into place
COPY rsyslog.conf /etc/rsyslog.conf

# os notes:
#    debian:10 docker base image does not have python3-distutils installed
#              and seems to default to python2, so we call python3 explictly below
#              if this Dockerfile uses setup.py

RUN wget https://github.com/weewx/weewx/archive/master.zip -O /tmp/weewx.zip && \
      cd /tmp && \
      unzip /tmp/weewx.zip && \
      cd weewx-* ; python3 ./setup.py build && python3 ./setup.py install --no-prompt && \
      cp /home/weewx/util/init.d/weewx.debian /etc/init.d/weewx && \
      mkdir -p /home/weewx/archive /home/weewx/public_html && \
      sed -i -e s:My\ Little\ Town,\ Oregon:Ubuntu-20.04\ setup.py\ test\ system: /home/weewx/weewx.conf

#---- uncomment to set your timezone to other than UTC
# doesn't work on ubuntu
# RUN TIMEZONE="US/Pacific" && rm /etc/timezone && rm /etc/localtime && echo $TIMEZONE > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

#--- uncomment to set weewx debug=1 
RUN sed -i -e s:debug\ =\ 0:debug\ =\ 1: /home/weewx/weewx.conf

# call supervisord as our container process to run
CMD ["supervisord"]

