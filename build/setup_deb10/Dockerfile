
FROM debian:10
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
            wget supervisor procps vim sqlite3 rsyslog \
    && apt-get clean autoclean \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/{apt,dpkg,cache,log}
# optional: add python3-pyephem to the list above

# os notes:
#    debian:10 docker base image does not have python3-distutils installed
#              and seems to default to python2, so we call python3 explictly below
#              if this Dockerfile uses setup.py

##### 4.0.0 needs a patch to restore --no-prompt
####    so lets keep the old syntax here for when it's merged back in
####
#### this replaces the build/install line below...
####    cd weewx-* ; python3 ./setup.py build ; python3 ./setup.py install --no-prompt && \


RUN wget http://weewx.com/downloads/weewx-4.0.0.tar.gz -O /tmp/weewx.tgz && \
      cd /tmp && \
      tar zxvf /tmp/weewx.tgz && \
      cd weewx-* ; python3 ./setup.py build && echo "mylocation\n700,foot\n0.00\n0.00\nn\nus\n3\n" | python3 ./setup.py install && \
      cp /home/weewx/util/init.d/weewx.debian /etc/init.d/weewx && \
      mkdir -p /home/weewx/archive /home/weewx/public_html

# let'em know who we are
# - when weewx is patched for --no-prompt this sed will need to change
RUN sed -i -e s:mylocation:Debian10\ setup.py\ test\ system: /home/weewx/weewx.conf

#---- uncomment to set your timezone to other than UTC
RUN TIMEZONE="US/Pacific" && rm /etc/timezone && rm /etc/localtime && echo $TIMEZONE > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

# call supervisord as our container process to run
CMD ["supervisord"]

