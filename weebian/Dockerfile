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
#     2018-0816 - update to 3.8.2
#     2018-0430 - switch to python-pil, set timezone to US-Pacific
#     2017-1122 - update to 3.8.0
#     2017-1007 - update to 3.7.1
#     2016-1021 - refactor for docker-compose
#     2016-1008 - update to 3.6.0, use vanila debian image
#     2016-0505 - update to 3.5.0
#     2015-1211 - install pyephem, refactor to reduce layers
#     2015-1206 - update to 3.3.1
#     2015-0220 vinceskahan@gmail.com - original
#
#-------------------------------------------------------

FROM debian
MAINTAINER Vince Skahan "vinceskahan@gmail.com"

# copy supervisor config file into place
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# install misc packages, webserver, weewx prerequisites, pip, supervisord/sshd
# then install pyephem via pip
# then install weewx via the setup.py method
#  - the 'cd' below expects Tom to stick with the weewx-VERSION naming in his .tgz
#
# this should be reasonably stable
RUN apt-get update \
    && apt-get install -y sqlite3 wget \
           python-configobj python-cheetah python-pil \
           supervisor tzdata

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

# install weewx, making sure to mkdir the directories we will use as external volumes
RUN wget http://weewx.com/downloads/weewx-3.8.2.tar.gz -O /tmp/weewx.tgz && \
      cd /tmp && \
      tar zxvf /tmp/weewx.tgz && \
      cd weewx-* ; ./setup.py build ; ./setup.py install --no-prompt && \
      cp /home/weewx/util/init.d/weewx.debian /etc/init.d/weewx && \
      mkdir -p /home/weewx/archive /home/weewx/public_html

# set the location to something indicating this os
RUN sed -i -e s:Hood\ River,\ Oregon:Debian\ setup.py\ test\ system: /home/weewx/weewx.conf

#---- uncomment to set your timezone to other than UTC
# (to do: this doesn't work any more)
RUN TIMEZONE="US/Pacific" && rm /etc/timezone && rm /etc/localtime && echo $TIMEZONE > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

# call supervisord as our container process to run
CMD ["/usr/bin/supervisord"]

# or use bash instead (and manually run supervisord) for debugging
# CMD ["/bin/bash"]
