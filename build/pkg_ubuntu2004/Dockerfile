#-------------------------------------------------------
#
# Dockerfile for building a simulator driver weewx system
#
# build via 'docker build -t weebian'
#
# run via 'docker -p 22 -p 80 run -t weebian' 
#     and optionally add -d to run detached in the backgroud
#     or optionally add -t -i to monitor it in the foreground
#
# or 'docker run -i -t weebian /bin/bash'
#     and in the shell 'service start' nginx and weewx
#
# last modified:
#     2019-0515 - update to 4.1.0
#-------------------------------------------------------

FROM ubuntu:20.04
MAINTAINER Vince Skahan "vinceskahan@gmail.com"

# copy supervisor config file into place
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN apt-get update \
    && apt-get install -y sqlite3 wget \
           python3-distutils rsyslog  \
           python3-configobj python3-cheetah python3-pil \
           python3-usb python3-serial \
           supervisor tzdata procps vim \
    && apt-get clean autoclean \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/{apt,dpkg,cache,log}

# add the trailing \ above and uncomment these to add in 
# unnecessary things that you might want to add to the image
#
#           python-serial python-usb \
#           curl procps \

# add the trailing \ above and uncomment these to add in
# pyephem, which makes the size much bigger and the build much slower
#
#           python-dev \
#           python-pip \
#   && pip install pyephem

RUN wget http://www.weewx.com/downloads/released_versions/python3-weewx_4.1.0-1_all.deb && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y ./python3-weewx_4.1.0-1_all.deb

# let'em know who we are
RUN sed -i -e s:Santa\'s\ Workshop,\ North\ Pole:Ubuntu20.04\ dpkg\ test\ system: /etc/weewx/weewx.conf

#---- uncomment to set your timezone to other than UTC
# (to do: this doesn't work any more on ubuntu)
#####RUN TIMEZONE="US/Pacific" && rm /etc/timezone && rm /etc/localtime && echo $TIMEZONE > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

# call supervisord as our container process to run
CMD ["supervisord"]
