
FROM debian:10
MAINTAINER Vince Skahan "vinceskahan@gmail.com"

# cleanup of apt remnants courtesy of:
#  https://gist.github.com/marvell/7c812736565928e602c4

RUN apt-get update \
    && apt-get install -y python-configobj \
            python-cheetah \
            python-pil \
            python-serial \
            python-usb \
            python-ephem \
            wget supervisor procps sqlite3 rsyslog unzip tar \
    && rm -rf /usr/share/man \
    && apt-get clean autoclean \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/{apt,dpkg,cache,log}

# optional: add python3-pip to the list above (makes the image 400 MB bigger!!!!)

# copy supervisor config file into place
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# copy rsyslogd config file into place
COPY rsyslog.conf /etc/rsyslog.conf

# use this line to get master latest in zip format
#### RUN wget https://github.com/weewx/weewx/archive/master.zip -O /tmp/weewx.zip && cd /tmp && \ unzip /tmp/weewx.zip && \

# or use this line to use a specific version
RUN wget http://www.weewx.com/downloads/released_versions/weewx-4.6.0.tar.gz -O /tmp/weewx.tgz && cd /tmp && tar zxvf /tmp/weewx*.tgz && \
      cd weewx-* ; python ./setup.py build && python ./setup.py install --no-prompt && \
      cp /home/weewx/util/init.d/weewx.debian /etc/init.d/weewx && \
      mkdir -p /home/weewx/archive /home/weewx/public_html && \
      sed -i -e s:My\ Little\ Town,\ Oregon:Debian10\ setup.py\ test\ system\ \(python2\): /home/weewx/weewx.conf

#---- uncomment to set your timezone to other than UTC
RUN TIMEZONE="US/Pacific" && rm /etc/timezone && rm /etc/localtime && echo $TIMEZONE > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

# call supervisord as our container process to run
CMD ["supervisord"]
